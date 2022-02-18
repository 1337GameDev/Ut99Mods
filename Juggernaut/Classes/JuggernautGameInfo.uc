//=============================================================================
// JuggernautGameInfo.
//=============================================================================
class JuggernautGameInfo extends DeathMatchPlus
	config;

#exec AUDIO IMPORT FILE="Sounds\JuggernautIntro.wav" NAME="JuggernautIntro" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\NewJuggernaut.wav" NAME="NewJuggernaut" GROUP="Announcer"

var Sound IntroSound;
var Sound NewJuggernautSound;

//cached cast from GameReplicationInfo class
var JuggernautGameInfoReplicationInfo JugRepInfo;

//the time needed to elapse between juggernaut changing -- to eliminate odd scenarios with multiple people dying and the juggernaut going back and forth
var float TimeDeltaToChangeJuggernauts;

var bool bHasPlayedIntro;

var bool bHasInitAnyHUDMutators;

var config bool ShowJuggernautIndicator;
var config bool OnlyJuggernautScores;

var config int RegenSeconds;
var config int ShieldRegenRate;
var config int HealthRegenRate;
var config float JugJumpModifier;
var config float JugMovementMultiplier;

var IndicatorHudGlobalTargets GlobalIndicatorTargets;

function PreCacheReferences() {
	//never called - here to force precaching of meshes
	spawn(class'TMale1');
	spawn(class'TMale2');
	spawn(class'TFemale1');
	spawn(class'TFemale2');
	spawn(class'ImpactHammer');
	spawn(class'Translocator');
	spawn(class'Enforcer');
	spawn(class'UT_Biorifle');
	spawn(class'ShockRifle');
	spawn(class'PulseGun');
	spawn(class'Ripper');
	spawn(class'Minigun2');
	spawn(class'UT_FlakCannon');
	spawn(class'UT_Eightball');
	spawn(class'SniperRifle');
	spawn(class'WarheadLauncher');

	spawn(class'Juggernaut.JuggernautBelt');
}

function PreBeginPlay() {
    local PlayerSpawnNotifyForJuggernautCallback playerSpawnCallback;
	Super.PreBeginPlay();

    GlobalIndicatorTargets = class'IndicatorHudGlobalTargets'.static.GetRef(self);
	playerSpawnCallback = new class'PlayerSpawnNotifyForJuggernautCallback';

	class'PlayerSpawnMutator'.static.RegisterToPlayerSpawn(self, playerSpawnCallback);
}

function CheckReady() {
	if (TimeLimit == 0) {
		TimeLimit = 20;
		RemainingTime = 60 * TimeLimit;
	}
}

//called at end of DeathMatchPlus.PreBeginPlay
function InitGameReplicationInfo() {
	Super.InitGameReplicationInfo();

    JugRepInfo = JuggernautGameInfoReplicationInfo(GameReplicationInfo);

    JugRepInfo.ShowJuggernautIndicator = ShowJuggernautIndicator;
	JugRepInfo.OnlyJuggernautScores = OnlyJuggernautScores;

	JugRepInfo.RegenSeconds = RegenSeconds;
	JugRepInfo.ShieldRegenRate = ShieldRegenRate;
	JugRepInfo.HealthRegenRate = HealthRegenRate;
	JugRepInfo.JugJumpModifier = JugJumpModifier;
	JugRepInfo.JugMovementMultiplier = JugMovementMultiplier;

    JugRepInfo.bHasInitAnyHUDMutators = bHasInitAnyHUDMutators;


	JugRepInfo.bHasPlayedIntro = bHasPlayedIntro;
	JugRepInfo.CurrentJuggernautPlayerID = -1;
}

//
// Initialize the game.
//warning: this is called before actors' PreBeginPlay (so game replication info is not initialized yet).
//
event InitGame(string Options, out string Error) {
    local string InOpt;
	Super.InitGame(Options, Error);

	RegenSeconds = GetIntOption(Options, "RegenSeconds", RegenSeconds);
    ShieldRegenRate = GetIntOption(Options, "ShieldRegenRate", ShieldRegenRate);
    HealthRegenRate = GetIntOption(Options, "HealthRegenRate", HealthRegenRate);
	JugJumpModifier = GetIntOption(Options, "JugJumpModifier", JugJumpModifier);
	JugMovementMultiplier = GetIntOption(Options, "JugMovementMultiplier", JugMovementMultiplier);

	//handle bool values
    InOpt = ParseOption(Options, "ShowJuggernautIndicator");
    if(InOpt != ""){
        ShowJuggernautIndicator = bool(InOpt);
    }

    InOpt = ParseOption(Options, "OnlyJuggernautScores");
    if(InOpt != ""){
        OnlyJuggernautScores = bool(InOpt);
    }
}

//
// Restart a player.
//
function bool RestartPlayer(Pawn aPlayer) {
    local bool foundStart;
    foundStart = Super.RestartPlayer(aPlayer);
    if(foundStart){
        //modify any indicator lists of IndicatorHud
    }

    return foundStart;
}

function StartMatch() {
     Super.StartMatch();

     //pick new juggernaut
	 PickNewJuggernaut();
}

function ScoreKill(Pawn Killer, Pawn Other) {
    //Copied from Engine.GameInfo.ScoreKill
	if(Other != None){
        Other.DieCount++;
    }

	if((Killer == Other) || (Killer == None)) {
		Other.PlayerReplicationInfo.Score -= 1;
	} else if ((Killer != None) && (Killer.PlayerReplicationInfo != None)) {
	    if(!JugRepInfo.OnlyJuggernautScores || (Killer.PlayerReplicationInfo.PlayerID == JugRepInfo.CurrentJuggernautPlayerID)) {
		    Killer.killCount++;
		    Killer.PlayerReplicationInfo.Score += 1;
		}
	}

	BaseMutator.ScoreKill(Killer, Other);
}

// Monitor killed messages for fraglimit
function Killed(Pawn killer, Pawn Other, name damageType) {
    local String Message, KillerWeapon, OtherWeapon;
	local bool bSpecialDamage, bEndOverTime;
    local Pawn P, Best;

	local int NextTaunt, i;
	local bool bAutoTaunt;

    if(Other == None){
		return;
    }

	//if there's a killer, and the killer is NOT the pawn that was killed (suicide)
    //if the killer killed the current juggernaut, then transfer the juggernaut to them
    if(Other.PlayerReplicationInfo.PlayerID == JugRepInfo.CurrentJuggernautPlayerID) {
       if((killer != None) && (killer != other)) {
           TransferJuggernaut(killer);
        } else {//killer is NONE, or killer==other
	        //suicide, so pick a random new juggernaut
		    PickNewJuggernaut(true, Other.PlayerReplicationInfo.PlayerID);
	    }
    }

	if ( (damageType == 'Decapitated') && (Killer != None) && (Killer != Other) ) {
		if (Level.Game.LocalLog != None)
			Level.Game.LocalLog.LogSpecialEvent("headshot", Killer.PlayerReplicationInfo.PlayerID, Other.PlayerReplicationInfo.PlayerID);
		if (Level.Game.WorldLog != None)
			Level.Game.WorldLog.LogSpecialEvent("headshot", Killer.PlayerReplicationInfo.PlayerID, Other.PlayerReplicationInfo.PlayerID);
		Killer.ReceiveLocalizedMessage(class'DecapitationMessage');
	}

	// ---------------------------------------------------------------------- Copied from GameInfo.Killed ---------------------------------------------------------------------- //

	if(Other.bIsPlayer) {
	    if(Killer != None) {
			if(!Killer.bIsPlayer) {
				Message = Killer.KillMessage(damageType, Other);
				BroadcastMessage( Message, false, 'DeathMessage');

				if (LocalLog != None){
					LocalLog.LogSuicide(Other, DamageType, None);
				}

				if (WorldLog != None){
					WorldLog.LogSuicide(Other, DamageType, None);
				}

				return;
			}

			if( (DamageType == 'SpecialDamage') && (SpecialDamageString != "") ){
				BroadcastMessage( ParseKillMessage(
						Killer.PlayerReplicationInfo.PlayerName,
						Other.PlayerReplicationInfo.PlayerName,
						Killer.Weapon.ItemName,
						SpecialDamageString
						),
					false, 'DeathMessage');
				bSpecialDamage = True;
			}
		}

		Other.PlayerReplicationInfo.Deaths += 1;

        if ((Killer == None) || (Killer == Other)) {
			// Suicide
			if (damageType == '') {
				if (LocalLog != None){
					LocalLog.LogSuicide(Other, 'Unknown', Killer);
				}

                if (WorldLog != None){
					WorldLog.LogSuicide(Other, 'Unknown', Killer);
				}
			} else {
				if (LocalLog != None){
					LocalLog.LogSuicide(Other, damageType, Killer);
				}

				if (WorldLog != None){
					WorldLog.LogSuicide(Other, damageType, Killer);
				}
			}

			if (!bSpecialDamage) {
				if ( damageType == 'Fell' )
					BroadcastLocalizedMessage(DeathMessageClass, 2, Other.PlayerReplicationInfo, None);
				else if ( damageType == 'Eradicated' )
					BroadcastLocalizedMessage(DeathMessageClass, 3, Other.PlayerReplicationInfo, None);
				else if ( damageType == 'Drowned' )
					BroadcastLocalizedMessage(DeathMessageClass, 4, Other.PlayerReplicationInfo, None);
				else if ( damageType == 'Burned' )
					BroadcastLocalizedMessage(DeathMessageClass, 5, Other.PlayerReplicationInfo, None);
				else if ( damageType == 'Corroded' )
					BroadcastLocalizedMessage(DeathMessageClass, 6, Other.PlayerReplicationInfo, None);
				else if ( damageType == 'Mortared' )
					BroadcastLocalizedMessage(DeathMessageClass, 7, Other.PlayerReplicationInfo, None);
				else
					BroadcastLocalizedMessage(DeathMessageClass, 1, Other.PlayerReplicationInfo, None);
			}
		} else {
			if (Killer.bIsPlayer) {
				KillerWeapon = "None";

				if (Killer.Weapon != None){
					KillerWeapon = Killer.Weapon.ItemName;
				}

				OtherWeapon = "None";

				if (Other.Weapon != None) {
					OtherWeapon = Other.Weapon.ItemName;
				}

				if (Killer.PlayerReplicationInfo.Team == Other.PlayerReplicationInfo.Team) {
					if (LocalLog != None) {
						LocalLog.LogTeamKill(
							Killer.PlayerReplicationInfo.PlayerID,
							Other.PlayerReplicationInfo.PlayerID,
							KillerWeapon,
							OtherWeapon,
							damageType
						);
					}
					if (WorldLog != None){
						WorldLog.LogTeamKill(
							Killer.PlayerReplicationInfo.PlayerID,
							Other.PlayerReplicationInfo.PlayerID,
							KillerWeapon,
							OtherWeapon,
							damageType
						);
					}
				} else {
					if (LocalLog != None){
						LocalLog.LogKill(
							Killer.PlayerReplicationInfo.PlayerID,
							Other.PlayerReplicationInfo.PlayerID,
							KillerWeapon,
							OtherWeapon,
							damageType
						);
					}

					if(WorldLog != None) {
						WorldLog.LogKill(
							Killer.PlayerReplicationInfo.PlayerID,
							Other.PlayerReplicationInfo.PlayerID,
							KillerWeapon,
							OtherWeapon,
							damageType
						);
					}
				}

				if (!bSpecialDamage && (Other != None)) {
					BroadcastRegularDeathMessage(Killer, Other, damageType);
				}
			}
		}
	}
	ScoreKill(Killer, Other);

	// ---------------------------------------------------------------------- END of GameInfo.Killed ---------------------------------------------------------------------- //

	if (Other.Spree > 4) {
		EndSpree(Killer, Other);
	}

	Other.Spree = 0;

	if(bOverTime) {
		bEndOverTime = true;
		//check for clear winner now
		// find individual winner
		for(P=Level.PawnList; P!=None; P=P.nextPawn)
			if ( P.bIsPlayer && ((Best == None) || (P.PlayerReplicationInfo.Score > Best.PlayerReplicationInfo.Score)) )
				Best = P;

		// check for tie
		for (P=Level.PawnList; P!=None; P=P.nextPawn)
			if ( P.bIsPlayer && (Best != P) && (P.PlayerReplicationInfo.Score == Best.PlayerReplicationInfo.Score) )
				bEndOverTime = false;

		if (bEndOverTime) {
			if ((FragLimit > 0) && (Best.PlayerReplicationInfo.Score >= FragLimit)) {
				EndGame("fraglimit");
			} else {
				EndGame("timelimit");
			}
		}
	}
	else if ( (FragLimit > 0) && (killer != None) && (killer.PlayerReplicationInfo != None)
			&& (killer.PlayerReplicationInfo.Score >= FragLimit) )
		EndGame("fraglimit");

    //handle spree-based messages
	if (!bFirstBlood) {
		if ((Killer != None) || (Killer != Other) && Killer.bIsPlayer) {
			if (!Self.IsA('TrainingDM')) {
				bFirstBlood = True;
				BroadcastLocalizedMessage(class'FirstBloodMessage', 0, Killer.PlayerReplicationInfo);
			}
		}
	}

	if ( BotConfig.bAdjustSkill && (((Killer != None) && Killer.IsA('PlayerPawn')) || Other.IsA('PlayerPawn')) ) {
		if ( killer.IsA('Bot') ) {
			BotConfig.AdjustSkill(Bot(Killer),true);
		}

		if ( Other.IsA('Bot') ){
			BotConfig.AdjustSkill(Bot(Other),false);
		}
	}

	if ( Other.bIsPlayer && (Killer != None) && Killer.bIsPlayer && (Killer != Other)
		&& (!bTeamGame || (Other.PlayerReplicationInfo.Team != Killer.PlayerReplicationInfo.Team)) )
	{
		Killer.Spree++;
		if ( Killer.Spree > 4 )
			NotifySpree(Killer, Killer.Spree);
	}

	bAutoTaunt = (Killer != None) && ((TournamentPlayer(Killer) != None) && TournamentPlayer(Killer).bAutoTaunt);

	if ((Killer != None) && ((Bot(Killer) != None) || bAutoTaunt)
		&& (Killer != Other) && (DamageType != 'gibbed') && (Killer.Health > 0)
		&& (Level.TimeSeconds - LastTauntTime > 3) )
	{
		LastTauntTime = Level.TimeSeconds;
		NextTaunt = Rand(class<ChallengeVoicePack>(Killer.PlayerReplicationInfo.VoiceType).Default.NumTaunts);
		for ( i=0; i<4; i++ )
		{
			if ( NextTaunt == LastTaunt[i] )
				NextTaunt = Rand(class<ChallengeVoicePack>(Killer.PlayerReplicationInfo.VoiceType).Default.NumTaunts);
			if ( i > 0 )
				LastTaunt[i-1] = LastTaunt[i];
		}
		LastTaunt[3] = NextTaunt;
 		killer.SendGlobalMessage(None, 'AUTOTAUNT', NextTaunt, 5);
	}

	if (bRatedGame) {
		RateVs(Other, Killer);
	}
}

function Timer() {
	local Pawn P;
	local bool bReady;

    //Code from GameInfo.Timer
	SentText = 0;
	//END of code from GameInfo.Timer

	if ( bNetReady )
	{
		if ( NumPlayers > 0 )
			ElapsedTime++;
		else
			ElapsedTime = 0;
		if ( ElapsedTime > NetWait )
		{
			if ( (NumPlayers + NumBots < 4) && NeedPlayers() )
				AddBot();
			else if ( (NumPlayers + NumBots > 1) || ((NumPlayers > 0) && (ElapsedTime > 2 * NetWait)) )
				bNetReady = false;
		}

		if ( bNetReady )
		{
			for (P=Level.PawnList; P!=None; P=P.NextPawn )
				if ( P.IsA('PlayerPawn') )
					PlayerPawn(P).SetProgressTime(2);
			return;
		}
		else
		{
			while ( NeedPlayers() )
				AddBot();
			bRequireReady = false;
			StartMatch();
		}
	}

	if ( bRequireReady && (CountDown > 0) )
	{
	    //game has not begun, and CountDown has time remaining
		while ( (RemainingBots > 0) && AddBot() )
			RemainingBots--;
		for (P=Level.PawnList; P!=None; P=P.NextPawn )
			if ( P.IsA('PlayerPawn') )
				PlayerPawn(P).SetProgressTime(2);

		if ( ((NumPlayers == MaxPlayers) || (Level.NetMode == NM_Standalone))
				&& (RemainingBots <= 0) )
		{
			bReady = true;
			for (P=Level.PawnList; P!=None; P=P.NextPawn )
				if ( P.IsA('PlayerPawn') && !P.IsA('Spectator')
					&& !PlayerPawn(P).bReadyToPlay )
					bReady = false;

			if ( bReady )//all non-spectator players are READY, start the auto 30-seconds countdown
			{
				StartCount = 30;
				CountDown--;
				if ( CountDown <= 0 )//countdown has finished, start match
					StartMatch();
				else//play messages for each player denoting the current countdown
				{
					for ( P = Level.PawnList; P!=None; P=P.nextPawn )
						if ( P.IsA('PlayerPawn') )
						{
							PlayerPawn(P).ClearProgressMessages();
							if ( (CountDown < 11) && P.IsA('TournamentPlayer') )
								TournamentPlayer(P).TimeMessage(CountDown);
							else
								PlayerPawn(P).SetProgressMessage(CountDown$CountDownMessage, 0);
						}
				}
			}
			else if ( StartCount > 8 )//all players aren't ready
			{
				for ( P = Level.PawnList; P!=None; P=P.nextPawn )
					if ( P.IsA('PlayerPawn') )
					{
						PlayerPawn(P).ClearProgressMessages();
						PlayerPawn(P).SetProgressTime(2);
						PlayerPawn(P).SetProgressMessage(WaitingMessage1, 0);
						PlayerPawn(P).SetProgressMessage(WaitingMessage2, 1);
						if ( PlayerPawn(P).bReadyToPlay )
							PlayerPawn(P).SetProgressMessage(ReadyMessage, 2);
						else
							PlayerPawn(P).SetProgressMessage(NotReadyMessage, 2);
					}
			}
			else
			{
				StartCount++;
				if ( Level.NetMode != NM_Standalone )
					StartCount = 30;
			}
		}
		else
		{
			for ( P = Level.PawnList; P!=None; P=P.nextPawn )
				if ( P.IsA('PlayerPawn') )
					PlayStartupMessage(PlayerPawn(P));
		}
	}
	else
	{
	    if(!bHasInitAnyHUDMutators){
            //init IndicatorHud
            if(ShowJuggernautIndicator){
                class'IndicatorHud'.static.SpawnAndRegister(self);

                //ensure the juggernaut is visible
				For(P=Level.PawnList; P!=None; P=P.NextPawn) {
                    AddPlayerIndicator(P);
			    }
	        }

            bHasInitAnyHUDMutators = true;
            JugRepInfo.bHasInitAnyHUDMutators = bHasInitAnyHUDMutators;
        }

		if(!bHasPlayedIntro) {
			For (P=Level.PawnList; P!=None; P=P.NextPawn) {
				if(P.IsA('PlayerPawn')) {
				    class'SoundHelper'.static.ClientPlaySound(PlayerPawn(P), IntroSound, true, true, 100);
				}
			}

		    bHasPlayedIntro = true;
		}

	    //game has begun
		if ( bAlwaysForceRespawn || (bForceRespawn && (Level.NetMode != NM_Standalone)) )
			For ( P=Level.PawnList; P!=None; P=P.NextPawn )
			{
				if ( P.IsInState('Dying') && P.IsA('PlayerPawn') && P.bHidden )
					PlayerPawn(P).ServerReStartPlayer();
			}
		if ( Level.NetMode != NM_Standalone )
		{
			if ( NeedPlayers() )
				AddBot();
		}
		else
			while ( (RemainingBots > 0) && AddBot() )
				RemainingBots--;


		if ( bGameEnded )
		{
			if ( Level.TimeSeconds > EndTime + RestartWait )
				RestartGame();
		}
		else if ( !bOverTime && (TimeLimit > 0) )//if not overtime, and timelimit isn't zero (zero means infinite)
		{

			GameReplicationInfo.bStopCountDown = false;
			RemainingTime--;
			GameReplicationInfo.RemainingTime = RemainingTime;
			if ( RemainingTime % 60 == 0 )
				GameReplicationInfo.RemainingMinute = RemainingTime;

			if ( RemainingTime <= 0 )
				EndGame("timelimit");
		}
		else//overtime or time limit is zero or less
		{
			ElapsedTime++;
			GameReplicationInfo.ElapsedTime = ElapsedTime;
		}
	}
}

function Logout(Pawn Exiting) {
	Super.Logout(Exiting);

	if ((Exiting.IsA('PlayerPawn') && Exiting.IsA('Spectator')) || Exiting.IsA('Bot')) {
        //if leaving player is juggernaut, choose another
		if(Exiting.PlayerReplicationInfo != None) {
		    if(Exiting.PlayerReplicationInfo.PlayerID == JugRepInfo.CurrentJuggernautPlayerID) {
			    PickNewJuggernaut(true, Exiting.PlayerReplicationInfo.PlayerID);
			}
		}
	}
}

//------------------------------------------------------------------------------
// Juggernaut Picking.

function PickNewJuggernaut(optional bool excludeAPlayer, optional int excludePlayerIDFromJugSelection) {
    local Pawn p;
	local JuggernautBelt jugBelt;
	local LinkedList excludePlayersFromJugSelection;

	//if there is a juggernaut selected, then remove the existing juggernaut belt
	if(JugRepInfo != None) {
	    if(JugRepInfo.CurrentJuggernautPlayerID != -1){
		    //ensure no pawns (aside from juggernaut) currently have the juggernaut belt
			For (P=Level.PawnList; P!=None; P=P.NextPawn) {
				if((p.PlayerReplicationInfo != None) && (p.PlayerReplicationInfo.PlayerID != JugRepInfo.CurrentJuggernautPlayerID)) {
					jugBelt = JuggernautBelt(p.FindInventoryType(class'Juggernaut.JuggernautBelt'));

					if(jugBelt != None){
						jugBelt.Destroy();
					}
				}
			}
		}

        excludePlayersFromJugSelection = new class'LinkedList';

		if(excludeAPlayer) {
            class'IntObj'.static.PushIntOntoLinkedList(excludePlayersFromJugSelection, excludePlayerIDFromJugSelection);
        }

		//now choose a random player to become the new juggernaut
		p = class'PawnHelper'.static.GetRandomPlayerPawnOrBot(self, excludePlayersFromJugSelection);

		if(p == None) {
		    Log("ERROR - JuggernautGameInfo - Unable to select new PlayerPawn / Bot for new juggernaut!");
			BroadcastLocalizedMessage(class'JuggernautMessage', 6);
		} else if(p.PlayerReplicationInfo != None) {
		    TransferJuggernaut(p);
		} else {
		    Log("ERROR - JuggernautGameInfo - Unable to select new PlayerPawn / Bot for new juggernaut due to missing PlayerReplicationInfo!");
			BroadcastLocalizedMessage(class'JuggernautMessage', 6);
		}
	}
}

//gives the assigned juggernaut the items needed for the juggernaut role
function PrepareAssignedJuggernaut() {
    local Pawn p;
	local JuggernautBelt jugBelt;

    //if juggernaut wasn't selected prior
	if(JugRepInfo.CurrentJuggernautPlayerID == -1) {
	    PickNewJuggernaut();

		//failed to select a new juggernaut
		if(JugRepInfo.CurrentJuggernautPlayerID == -1) {
		    Log("ERROR - JuggernautGameInfo - PrepareAssignedJuggernaut - FAILED TO RESELECT A NEW JUGGERNAUT FROM ALL PLAYERS");
		    return;
		}
	}

	//ensure no pawns (aside from juggernaut) currently have the juggernaut belt
	For (P=Level.PawnList; P!=None; P=P.NextPawn) {
	    if((p.PlayerReplicationInfo != None) && (p.PlayerReplicationInfo.PlayerID != JugRepInfo.CurrentJuggernautPlayerID)) {
		    jugBelt = JuggernautBelt(p.FindInventoryType(class'Juggernaut.JuggernautBelt'));

		    if(jugBelt != None){
			    jugBelt.Destroy();
		    }
		}
	}

	//get current assigned juggernaut, and give them the neccessary items
	if(JugRepInfo != None) {
		p = class'PawnHelper'.static.GetPawnFromPlayerID(self, JugRepInfo.CurrentJuggernautPlayerID);
        jugBelt = JuggernautBelt(p.FindInventoryType(class'Juggernaut.JuggernautBelt'));

		if((p.PlayerReplicationInfo != None) && (jugBelt == None)) {
		    //give them a new JuggernautBelt
			jugBelt = Spawn(class'JuggernautBelt');

			if(jugBelt != None) {
			    jugBelt.JumpModifier = JugRepInfo.JugJumpModifier;
				jugBelt.NewAirControl = JugRepInfo.JugMovementMultiplier * p.AirControl;
				jugBelt.NewGroundSpeed = JugRepInfo.JugMovementMultiplier * p.GroundSpeed;
				jugBelt.NewAccelRate = JugRepInfo.JugMovementMultiplier * p.AccelRate;
				jugBelt.RegenSecs = JugRepInfo.RegenSeconds;
				jugBelt.RegenHealth = JugRepInfo.HealthRegenRate > 0;
				jugBelt.RegenShield = JugRepInfo.ShieldRegenRate > 0;
				jugBelt.HealthRegenAmount = JugRepInfo.HealthRegenRate;
				jugBelt.ShieldRegenAmount = JugRepInfo.ShieldRegenRate;
				jugBelt.GiveTo(p);
			} else {
			    Log("ERROR - JuggernautGameInfo - Unable to select new PlayerPawn / Bot for new juggernaut due to inability to spawn JuggernautBelt!");
				BroadcastLocalizedMessage(class'JuggernautMessage', 6);
			}
		} else {
		    Log("ERROR - JuggernautGameInfo - Unable to select new PlayerPawn / Bot for new juggernaut due to missing PlayerReplicationInfo!");
			BroadcastLocalizedMessage(class'JuggernautMessage', 6);
		}
	}
}

function TransferJuggernaut(Pawn NewPawn) {
    local Pawn p;

    if(NewPawn == None) {
	    return;
	} else {
	    if(NewPawn.PlayerReplicationInfo != None) {
		    JugRepInfo.PreviousJuggernautPlayerID = JugRepInfo.CurrentJuggernautPlayerID;
		    JugRepInfo.CurrentJuggernautPlayerID = NewPawn.PlayerReplicationInfo.PlayerID;
			JugRepInfo.LastJuggernautChangeTime = Level.TimeSeconds;

			BroadcastLocalizedMessage(class'JuggernautMessage', 5, NewPawn.PlayerReplicationInfo);

			//play the new juggernaut sound
			if(bHasPlayedIntro) {
				For (P=Level.PawnList; P!=None; P=P.NextPawn) {
					if(P.IsA('PlayerPawn')) {
						class'SoundHelper'.static.ClientPlaySound(PlayerPawn(P), NewJuggernautSound, true, true, 100);
					}
				}
			}

			if(!class'PawnHelper'.static.IsPawnDead(P)) {
			    PrepareAssignedJuggernaut();
			}
		}
	}
}

//adds an indicator to every player / bot that gets passed to this
function AddPlayerIndicator(Pawn player){
    local IndicatorHudTargetListElement le;
    local IndicatorSettings settings;
    local JuggernautPlayerIndicatorModifierFn indicatorMod;

    if((player == None) || !(player.IsA('Bot') || player.IsA('PlayerPawn')) ){
        return;
    }

    le = new class'IndicatorHudTargetListElement';
    indicatorMod = new class'JuggernautPlayerIndicatorModifierFn';
    indicatorMod.Player = player;
    indicatorMod.Context = Self;

    settings = new class'IndicatorSettings';
    settings.UseCustomColor = true;
    settings.IndicatorColor = class'ColorHelper'.default.RedColor;
    settings.ShowIndicatorAboveTarget = true;
    settings.ScaleIndicatorSizeToTarget = false;
    settings.ShowIndicatorLabel = false;

    //settings.TextureVariations = class'IndicatorHud'.static.GetTexturesForBuiltInOption(64);//HudIndicator_DownTriangle_Solid
    settings.TextureVariations = class'IndicatorHud'.static.GetTexturesForBuiltInOption(74);//HudIndicator_Crown
    settings.TextureVariations.BehindViewTex = None;
    settings.ShowTargetDistanceLabels = false;
    settings.MaxViewDistance = 0;
    settings.ShowIndicatorWhenOffScreen = true;

    le.IndicatorSettings = settings;
    le.IndicatorSettingsModifier = indicatorMod;
    le.Value = player;

    //should exist at this stage as we init the reference at the earlier stage of game execution
    GlobalIndicatorTargets.GlobalIndicatorTargets.Push(le);
}

function RemovePlayerIndicator(Pawn player) {
    if(player != None){
        //should exist at this stage as we init the reference at the earlier stage of game execution
        GlobalIndicatorTargets.GlobalIndicatorTargets.RemoveElementByValue(player);
    }
}

//------------------------------------------------------------------------------
// Game Querying.

function string GetRules() {
	local string ResultSet;
	ResultSet = Super.GetRules();

	ResultSet = ResultSet$"\\timelimit\\"$TimeLimit;
	ResultSet = ResultSet$"\\fraglimit\\"$FragLimit;
	Resultset = ResultSet$"\\minplayers\\"$MinPlayers;
	Resultset = ResultSet$"\\changelevels\\"$bChangeLevels;
	Resultset = ResultSet$"\\tournament\\"$bTournament;

	Resultset = ResultSet$"\\showjuggernautindicator\\"$ShowJuggernautIndicator;
	Resultset = ResultSet$"\\onlyjuggernautscores\\"$OnlyJuggernautScores;

	Resultset = ResultSet$"\\regenseconds\\"$RegenSeconds;
	Resultset = ResultSet$"\\shieldregenrate\\"$ShieldRegenRate;
	Resultset = ResultSet$"\\healthregenrate\\"$HealthRegenRate;
	Resultset = ResultSet$"\\jugjumpmodifier\\"$JugJumpModifier;
	Resultset = ResultSet$"\\jugmovementmultiplier\\"$JugMovementMultiplier;

	if(bMegaSpeed)
		Resultset = ResultSet$"\\gamestyle\\Turbo";
	else
	if(bHardcoreMode)
		Resultset = ResultSet$"\\gamestyle\\Hardcore";
	else
		Resultset = ResultSet$"\\gamestyle\\Classic";

	if(MinPlayers > 0)
		Resultset = ResultSet$"\\botskill\\"$class'ChallengeBotInfo'.default.Skills[Difficulty];

	return ResultSet;
}

defaultproperties
{
      IntroSound=Sound'Juggernaut.Announcer.JuggernautIntro'
      NewJuggernautSound=Sound'Juggernaut.Announcer.NewJuggernaut'
      JugRepInfo=None
      TimeDeltaToChangeJuggernauts=0.000000
      bHasPlayedIntro=False
      bHasInitAnyHUDMutators=False
      ShowJuggernautIndicator=True
      OnlyJuggernautScores=True
      RegenSeconds=5
      ShieldRegenRate=10
      HealthRegenRate=10
      JugJumpModifier=3.000000
      JugMovementMultiplier=2.000000
      GlobalIndicatorTargets=None
      gamegoal="points wins the match."
      RulesMenuType="Juggernaut.JuggernautGameOptionsMenu"
      HUDType=Class'Juggernaut.JuggernautHUD'
      GameName="Juggernaut"
      DMMessageClass=Class'Juggernaut.JuggernautMessage'
      MutatorClass=Class'Juggernaut.JuggernautMutator'
      GameReplicationInfoClass=Class'Juggernaut.JuggernautGameInfoReplicationInfo'
}
