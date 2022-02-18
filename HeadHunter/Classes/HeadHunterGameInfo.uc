//=============================================================================
// HeadHunterGameInfo.
//=============================================================================
class HeadHunterGameInfo extends DeathMatchPlus
	config;

#exec AUDIO IMPORT FILE="Sounds\HeadHunter\HeadHunter.wav" NAME="HeadHunterIntro" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HeadHunter\SkullsCollected.wav" NAME="SkullsCollected" GROUP="Announcer"

var Sound IntroSound;
var Sound SkullCollectedSound;

//cached cast from GameReplicationInfo class
var HeadHunterGameReplicationInfo HHRepInfo;

var bool bHasPlayedIntro;

var() config int SkullCollectGoal;
var() config int SkullCarryLimit;//the limit on number of skulls a person is allowed to carry
var() config int SkullCollectTimeInterval;//how often are skulls collected to be scored
var int SkullsCollectedCountdown;//countdown until skulls will be collected

var bool bHasInitAnyHUDMutators;
var config bool ShowDroppedSkullIndicators;
var config bool ShowPlayersWithSkullThreshold;
var config int SkullThresholdToShowPlayers;

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

	spawn(class'HeadHunter.SkullItem');
	spawn(class'HeadHunter.SkullItemProj');
	spawn(class'HeadHunter.FlameFollower');
}

function PreBeginPlay() {
	Super.PreBeginPlay();

    GlobalIndicatorTargets = class'IndicatorHudGlobalTargets'.static.GetRef(self);
}

function CheckReady() {
	if ((SkullCollectGoal == 0) && (TimeLimit == 0)){
		TimeLimit = 20;
		RemainingTime = 60 * TimeLimit;
		SkullsCollectedCountdown = SkullCollectTimeInterval;
	}
}

//called at end of DeathMatchPlus.PreBeginPlay
function InitGameReplicationInfo() {
	Super.InitGameReplicationInfo();

    HHRepInfo = HeadHunterGameReplicationInfo(GameReplicationInfo);

    HHRepInfo.SkullCollectGoal = SkullCollectGoal;
	HHRepInfo.SkullCarryLimit = SkullCarryLimit;
	HHRepInfo.SkullCollectTimeInterval = SkullCollectTimeInterval;

    HHRepInfo.bHasInitAnyHUDMutators = bHasInitAnyHUDMutators;
	HHRepInfo.ShowDroppedSkullIndicators = ShowDroppedSkullIndicators;
	HHRepInfo.ShowPlayersWithSkullThreshold = ShowPlayersWithSkullThreshold;
	HHRepInfo.SkullThresholdToShowPlayers = SkullThresholdToShowPlayers;

	HHRepInfo.bHasPlayedIntro = bHasPlayedIntro;
}

//
// Initialize the game.
//warning: this is called before actors' PreBeginPlay (so game replication info is not initialized yet).
//
event InitGame(string Options, out string Error) {
    local string InOpt;
	Super.InitGame(Options, Error);

    SkullCollectGoal = GetIntOption(Options, "SkullCollectGoal", SkullCollectGoal);
	SkullCarryLimit = GetIntOption(Options, "SkullCarryLimit", SkullCarryLimit);
	SkullCollectTimeInterval = GetIntOption(Options, "SkullCollectTimeInterval", SkullCollectTimeInterval);
    SkullThresholdToShowPlayers = GetIntOption(Options, "SkullThresholdToShowPlayers", SkullThresholdToShowPlayers);
	SkullsCollectedCountdown = SkullCollectTimeInterval;//set the countown to the initial value of the interval

	//handle bool values
    InOpt = ParseOption(Options, "ShowDroppedSkullIndicators");
    if(InOpt != ""){
        ShowDroppedSkullIndicators = bool(InOpt);
    }

    InOpt = ParseOption(Options, "ShowPlayersWithSkullThreshold");
    if(InOpt != ""){
        ShowPlayersWithSkullThreshold = bool(InOpt);
    }
}

//
// Restart a player.
//
function bool RestartPlayer(Pawn aPlayer) {
    local bool foundStart;
    foundStart = Super.RestartPlayer(aPlayer);
    if(foundStart){
        //modify any indictor lists of IndicatorHud

    }

    return foundStart;
}

function StartMatch() {
     Super.StartMatch();

     SkullsCollectedCountdown = SkullCollectTimeInterval;
     HHRepInfo.SkullsCollectedCountdown = SkullsCollectedCountdown;
}

function ScoreKill(pawn Killer, pawn Other) {
    if(Other != None){
        Other.DieCount++;
    }
    if(Killer != None){
        Killer.KillCount++;
    }

    //we don't score normally, so ignore this call
	//BaseMutator.ScoreKill(Killer, Other);
}

// Monitor killed messages for fraglimit
function Killed(Pawn killer, Pawn Other, name damageType) {
    local String Message, KillerWeapon, OtherWeapon;
	local bool bSpecialDamage;

	local int NextTaunt, i, NumSkullsToDrop, NumSkullsSpawned;
	local bool bAutoTaunt;
	local SkullItem existingSkull;

    if(Other == None){
		return;
    }

    //spawn skulls from killed player
    NumSkullsToDrop = 1;
    existingSkull = SkullItem(Other.FindInventoryType(class'HeadHunter.SkullItem'));

    if(existingSkull != None){
        NumSkullsToDrop += existingSkull.NumCopies;
        existingSkull.Destroy();
    }

    NumSkullsSpawned = class'HeadHunter.SkullItem'.static.SpawnNumberFromPoint(Other, Other.Location, NumSkullsToDrop, Other.Velocity + (Vect(0,0,1) * 150));

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
            if(ShowDroppedSkullIndicators || ShowPlayersWithSkullThreshold){
                class'IndicatorHud'.static.SpawnAndRegister(self);

                For(P=Level.PawnList; P!=None; P=P.NextPawn) {
                    AddPlayerIndicator(P);
			    }
	        }

            bHasInitAnyHUDMutators = true;
            HHRepInfo.bHasInitAnyHUDMutators = bHasInitAnyHUDMutators;
        }

		if(!bHasPlayedIntro) {
			For (P=Level.PawnList; P!=None; P=P.NextPawn) {
				if(P.IsA('PlayerPawn')) {
					class'SoundHelper'.static.ClientPlaySound(PlayerPawn(P),IntroSound,, true, 100);
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

            AdvanceSkullCollectCountdown();

			if ( RemainingTime <= 0 )
				EndGame("timelimit");
		}
		else//overtime or time limit is zero or less
		{
			ElapsedTime++;
			GameReplicationInfo.ElapsedTime = ElapsedTime;
			AdvanceSkullCollectCountdown();
		}
	}
}

function Logout(pawn Exiting) {
    local int NumSkullsToDrop;
    local SkullItem existingSkull;

	Super.Logout(Exiting);

	if ((Exiting.IsA('PlayerPawn') && Exiting.IsA('Spectator')) || Exiting.IsA('Bot')) {
        //spawn skulls from killed player
        NumSkullsToDrop = 1;
        existingSkull = SkullItem(Exiting.FindInventoryType(class'HeadHunter.SkullItem'));

        if(existingSkull != None){
            NumSkullsToDrop += existingSkull.NumCopies;
            existingSkull.Destroy();
        }

        class'HeadHunter.SkullItem'.static.SpawnNumberFromPoint(Exiting, Exiting.Location, NumSkullsToDrop, Vect(0,0,1) * 150);
	}
}

function AdvanceSkullCollectCountdown() {
    local IntObj countObj;
	local Pawn pp;

    SkullsCollectedCountdown--;

	if((SkullsCollectedCountdown > 0) && (SkullsCollectedCountdown <= 6)) {
	    countObj = new class'IntObj';
		countObj.Value = SkullsCollectedCountdown;
	    BroadcastLocalizedMessage(class'HeadHunterMessage', 5,,, countObj);
	} else if(SkullsCollectedCountdown <= 0) {
	    //send message to collect all skulls
		BroadcastLocalizedMessage(class'HeadHunterMessage', 6);
		
		For (pp=Level.PawnList; pp!=None; pp=pp.NextPawn) {
			if(pp.IsA('PlayerPawn')) {
				class'SoundHelper'.static.ClientPlaySound(PlayerPawn(pp), SkullCollectedSound,, true, 32);
			}
		}

	    SkullsCollectedCountdown = SkullCollectTimeInterval;
		ScoreSkulls();
	}

	HHRepInfo.SkullsCollectedCountdown = SkullsCollectedCountdown;
}

function ScoreSkulls(){
    local Pawn P, Best;
    local SkullItem existingSkull;
	local bool bEndOverTime;
	local int PointsScored;

    //delete existing skulls that aren't picked up
    class'ProjectileHelper'.static.DeleteProjectilesOfClass(self, 'SkullItemProj');
    class'InventoryHelper'.static.DeleteInventoriesOnGround(self, 'SkullItem');

    for(P = Level.PawnList; P != None; P = P.nextPawn) {
        if(P.bIsPlayer && (P.PlayerReplicationInfo != None)) {
            existingSkull = SkullItem(P.FindInventoryType(class'HeadHunter.SkullItem'));

            if(existingSkull != None){
			    PointsScored += existingSkull.NumCopies;
                P.PlayerReplicationInfo.Score += existingSkull.NumCopies;
                P.ReceiveLocalizedMessage(class'HeadHunterScoredSkullsMessage',0,,, existingSkull);
				existingSkull.Destroy();
            }
        }
    }

    bEndOverTime = true;

	//check for clear winner now
	// find individual winner
	for(P=Level.PawnList; P!=None; P=P.NextPawn) {
		if(P.bIsPlayer && ((Best == None) || (P.PlayerReplicationInfo.Score > Best.PlayerReplicationInfo.Score))) {
			Best = P;
		}
	}

	// check for tie
	for(P=Level.PawnList; P!=None; P=P.NextPawn) {
		if(P.bIsPlayer && (Best != P) && (P.PlayerReplicationInfo.Score == Best.PlayerReplicationInfo.Score)) {
			bEndOverTime = false;
		}
	}

	//if the best (which is from collecting in overtime or not) has met the goal
	if ( (SkullCollectGoal > 0) && (Best != None) && (Best.PlayerReplicationInfo != None)
			&& (Best.PlayerReplicationInfo.Score >= SkullCollectGoal)) {
		EndGame("fraglimit");
	}

	if (bOverTime) {
		if (bEndOverTime) {//if points were scored by atleast one player, it would have been ended by code above
			EndGame("timelimit");
		}
	}
}

function AddAllPlayerIndicators(){
    local Pawn P;

    for(P = Level.PawnList; P != None; P = P.nextPawn) {
        if(P.IsA('Bot') || P.IsA('PlayerPawn') ){
            AddPlayerIndicator(P);
        }
    }
}
function RemoveAllPlayerIndicators(){
    local Pawn P;

    for(P = Level.PawnList; P != None; P = P.nextPawn) {
        if(P.IsA('Bot') || P.IsA('PlayerPawn') ){
            RemovePlayerIndicator(P);
        }
    }
}

//adds an indictaor to every player / bot that gets passed to this
function AddPlayerIndicator(Pawn player){
    local IndicatorHudTargetListElement le;
    local IndicatorSettings settings;
    local HeadHunterPlayerIndicatorModifierFn indicatorMod;

    if((player == None) || !(player.IsA('Bot') || player.IsA('PlayerPawn')) ){
        return;
    }

    le = new class'IndicatorHudTargetListElement';
    indicatorMod = new class'HeadHunterPlayerIndicatorModifierFn';
    indicatorMod.Player = player;
    indicatorMod.Context = Self;

    settings = new class'IndicatorSettings';
    settings.UseCustomColor = true;
    settings.IndicatorColor = class'ColorHelper'.default.RedColor;
    settings.ShowIndicatorAboveTarget = true;
    settings.ScaleIndicatorSizeToTarget = false;

    settings.TextureVariations = class'IndicatorHud'.static.GetTexturesForBuiltInOption(64);//HudIndicator_DownTriangle_Solid
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

function AddSkullItemIndicator(SkullItem skull){
    local IndicatorHudTargetListElement le;
    local IndicatorSettings settings;
    local IndicatorTextureVariations texVars;

    if(skull == None){
        return;
    }

    le = new class'IndicatorHudTargetListElement';

    settings = new class'IndicatorSettings';
    settings.UseCustomColor = true;
    settings.IndicatorColor = class'ColorHelper'.default.RedColor;
    settings.ShowIndicatorAboveTarget = true;
    settings.ShowTargetDistanceLabels = false;
    settings.ScaleIndicatorSizeToTarget = false;
    //settings.BuiltinIndicatorTexture = 73;//HudIndicator_Skull
    settings.MaxViewDistance = 0;
    settings.ShowIndicatorWhenOffScreen = true;

    settings.TextureVariations = class'IndicatorHud'.static.GetTexturesForBuiltInOption(64);//HudIndicator_DownTriangle_Solid
    settings.TextureVariations.BehindViewTex = None;

    texVars = class'IndicatorHud'.static.GetTexturesForBuiltInOption(73);//HudIndicator_Skull
    settings.TextureVariations.InViewTex = texVars.InViewTex;

    le.IndicatorSettings = settings;
    le.Value = skull;

    //should exist at this stage as we init the reference at the earlier stage of game execution
    GlobalIndicatorTargets.GlobalIndicatorTargets.Push(le);
}
function RemoveSkullItemIndicator(SkullItem skull){
    if(skull != None){
        //should exist at this stage as we init the reference at the earlier stage of game execution
        GlobalIndicatorTargets.GlobalIndicatorTargets.RemoveElementByValue(skull);
    }
}
function AddSkullItemProjIndicator(SkullItemProj skullProj){
    local IndicatorHudTargetListElement le;
    local IndicatorSettings settings;
    local IndicatorTextureVariations texVars;

    if(skullProj == None){
        return;
    }

    le = new class'IndicatorHudTargetListElement';
    settings = new class'IndicatorSettings';
    settings.UseCustomColor = true;
    settings.IndicatorColor = class'ColorHelper'.default.RedColor;
    settings.ShowIndicatorAboveTarget = true;
    settings.ShowTargetDistanceLabels = false;
    settings.ScaleIndicatorSizeToTarget = false;
    //settings.BuiltinIndicatorTexture = 73;//HudIndicator_Skull
    settings.MaxViewDistance = 0;
    settings.ShowIndicatorWhenOffScreen = true;

    settings.TextureVariations = class'IndicatorHud'.static.GetTexturesForBuiltInOption(64);//HudIndicator_DownTriangle_Solid
    settings.TextureVariations.BehindViewTex = None;

    texVars = class'IndicatorHud'.static.GetTexturesForBuiltInOption(73);//HudIndicator_Skull
    settings.TextureVariations.InViewTex = texVars.InViewTex;

    le.IndicatorSettings = settings;
    le.Value = skullProj;

    //should exist at this stage as we init the reference at the earlier stage of game execution
    GlobalIndicatorTargets.GlobalIndicatorTargets.Push(le);
}
function RemoveSkullItemProjIndicator(SkullItemProj skullProj){
    if(skullProj != None){
        //should exist at this stage as we init the reference at the earlier stage of game execution
        GlobalIndicatorTargets.GlobalIndicatorTargets.RemoveElementByValue(skullProj);
    }
}

function AddAllSkullIndicators(){
    local SkullItem skull;
    local SkullItemProj skullProj;

    ForEach AllActors(class'SkullItem', skull) {
        if(!skull.bHeldItem && (skull.Owner == None) && !skull.bCarriedItem && !skull.bOnlyOwnerSee){
            AddSkullItemIndicator(skull);
        }
    }

    ForEach AllActors(class'SkullItemProj', skullProj) {
        AddSkullItemProjIndicator(skullProj);
    }
}
function RemoveAllSkullIndicators(){
    local SkullItem skull;
    local SkullItemProj skullProj;

    ForEach AllActors(class'SkullItem', skull) {
        RemoveSkullItemIndicator(skull);
    }

    ForEach AllActors(class'SkullItemProj', skullProj) {
        RemoveSkullItemProjIndicator(skullProj);
    }
}

//------------------------------------------------------------------------------
// Game Querying.

function string GetRules() {
	local string ResultSet;
	ResultSet = Super.GetRules();

	ResultSet = ResultSet$"\\timelimit\\"$TimeLimit;
	//ResultSet = ResultSet$"\\fraglimit\\"$FragLimit;//NOT APPLICABLE
	Resultset = ResultSet$"\\minplayers\\"$MinPlayers;
	Resultset = ResultSet$"\\changelevels\\"$bChangeLevels;
	Resultset = ResultSet$"\\tournament\\"$bTournament;

	Resultset = ResultSet$"\\skullcarrylimit\\"$SkullCarryLimit;
	Resultset = ResultSet$"\\skullcollecttimeinterval\\"$SkullCollectTimeInterval;
	Resultset = ResultSet$"\\skullcollectgoal\\"$SkullCollectGoal;
	Resultset = ResultSet$"\\showdroppedskullindicators\\"$ShowDroppedSkullIndicators;
	Resultset = ResultSet$"\\showplayerswithskullthreshold\\"$ShowPlayersWithSkullThreshold;
	Resultset = ResultSet$"\\skullthresholdtoshowplayers\\"$SkullThresholdToShowPlayers;

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
      IntroSound=Sound'HeadHunter.Announcer.HeadHunterIntro'
      SkullCollectedSound=Sound'HeadHunter.Announcer.SkullsCollected'
      HHRepInfo=None
      bHasPlayedIntro=False
      SkullCollectGoal=4
      SkullCarryLimit=10
      SkullCollectTimeInterval=900
      SkullsCollectedCountdown=0
      bHasInitAnyHUDMutators=False
      ShowDroppedSkullIndicators=True
      ShowPlayersWithSkullThreshold=True
      SkullThresholdToShowPlayers=0
      GlobalIndicatorTargets=None
      gamegoal="skulls wins the match."
      ScoreBoardType=Class'HeadHunter.HHScoreBoard'
      RulesMenuType="HeadHunter.HHGameOptionsMenu"
      HUDType=Class'HeadHunter.HeadHunterHUD'
      GameName="HeadHunter"
      DMMessageClass=Class'HeadHunter.HeadHunterMessage'
      MutatorClass=Class'HeadHunter.HHMutator'
      GameReplicationInfoClass=Class'HeadHunter.HeadHunterGameReplicationInfo'
}
