//=============================================================================
// KillConfirmedGameInfo.
//=============================================================================
class KillConfirmedGameInfo extends DeathMatchPlus
	config;

#exec texture IMPORT NAME=DogTagIcon FILE=Textures\Indicators\DogTags.bmp FLAGS=2 MIPS=OFF
#exec AUDIO IMPORT FILE="Sounds\Announcer\KillConfirmed.wav" NAME="KillConfirmed" GROUP="Announcer"

var bool UseHaloAnnouncer;
var Sound IntroSound;

//cached cast from GameReplicationInfo class
var KillConfirmedGameReplicationInfo KCRepInfo;

var bool bHasPlayedIntro;

var bool bHasInitAnyHUDMutators;
var config bool ShowDogTagIndicators;
var config int TagCollectGoal;

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

	spawn(class'KillConfirmed.DogTagItem');
	spawn(class'KillConfirmed.DogTagItemVisuals');
}

function PreBeginPlay() {	
	Super.PreBeginPlay();
	
    GlobalIndicatorTargets = class'LGDUtilities.IndicatorHudGlobalTargets'.static.GetRef(self);
}

function CheckReady() {
	if ((TagCollectGoal == 0) && (TimeLimit == 0)){
		TimeLimit = 20;
		RemainingTime = 60 * TimeLimit;
	}
}

//called at end of DeathMatchPlus.PreBeginPlay
function InitGameReplicationInfo() {
	Super.InitGameReplicationInfo();

    KCRepInfo = KillConfirmedGameReplicationInfo(GameReplicationInfo);
	
	KCRepInfo.DogTagStats = new class'LGDUtilities.LinkedList';
	
    KCRepInfo.bHasInitAnyHUDMutators = bHasInitAnyHUDMutators;
	KCRepInfo.ShowDogTagIndicators = ShowDogTagIndicators;

	KCRepInfo.bHasPlayedIntro = bHasPlayedIntro;
	KCRepInfo.UseHaloAnnouncer = UseHaloAnnouncer;
}

//
// Initialize the game.
//warning: this is called before actors' PreBeginPlay (so game replication info is not initialized yet).
//
event InitGame(string Options, out string Error) {
    local string InOpt;
	Super.InitGame(Options, Error);

	//handle bool values
    InOpt = ParseOption(Options, "ShowDogTagIndicators");
    if(InOpt != ""){
        ShowDogTagIndicators = bool(InOpt);
    }
	
	InOpt = ParseOption(Options, "UseHaloAnnouncer");
    if(InOpt != ""){
        UseHaloAnnouncer = bool(InOpt);
    }
}

function DogTagItem CreateDogTagForPawn(Pawn p){
	local DogTagItem dogTag;
	local DogTagStatsObj statsObj;
	
	dogTag = Spawn(class'KillConfirmed.DogTagItem',,, p.Location);
	
	if(dogTag != None) {
		dogTag.DroppedByTeam = p.PlayerReplicationInfo.Team;
		dogTag.DroppedByPlayerID = p.PlayerReplicationInfo.PlayerID;
		dogTag.IsTeamGame = bTeamGame;
				
		dogTag.CreateVisuals();
		
		if(ShowDogTagIndicators) {
			AddDogTagItemIndicator(dogTag);
		}
		
		statsObj = GetDogTagStatsForPlayer(p.PlayerReplicationInfo.PlayerID, True);
		if(statsObj != None) {
			statsObj.TagsDropped++;
		}
	}
	
	return dogTag;
}

function AddDogTagStatsForPlayer(int PlayerID) {
	local DogTagStatsObj statsObj;
	
	if(GetDogTagStatsForPlayer(PlayerID) == None) {
		statsObj = new class'KillConfirmed.DogTagStatsObj';
		statsObj.PlayerID = PlayerID;
		
		KCRepInfo.DogTagStats.Push(statsObj);
	}
}

function DogTagStatsObj GetDogTagStatsForPlayer(int PlayerID, optional bool CreateIfNotExist) {
	local ListElement le;
	local DogTagStatsObj statsObj;
	
	if(KCRepInfo.DogTagStats == None) {
		KCRepInfo.DogTagStats = new class'LGDUtilities.LinkedList';
	} else {
		le = KCRepInfo.DogTagStats.Head;
		
		While(le != None) {
			statsObj = DogTagStatsObj(le.Value);
			
			if(statsObj != None) {
				if(statsObj.PlayerID == PlayerID) {
					return statsObj;
				}
			}
			
			le = le.Next;
		}
	}
	
	if(CreateIfNotExist) {
		statsObj = new class'KillConfirmed.DogTagStatsObj';
		statsObj.PlayerID = PlayerID;
		
		return statsObj;
	} else {
		return None;
	}
}
function RemoveDogTagStatsForPlayer(int PlayerID) {
	local ListElement le;
	local DogTagStatsObj statsObj;
	
	if(KCRepInfo.DogTagStats == None) {
		KCRepInfo.DogTagStats = new class'LGDUtilities.LinkedList';
	} else {
		le = KCRepInfo.DogTagStats.Head;
		
		While(le != None) {
			statsObj = DogTagStatsObj(le.Value);
			
			if(statsObj != None) {
				if(statsObj.PlayerID == PlayerID) {
					le.RemoveFromList();
				}
			}
			
			le = le.Next;
		}
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
	
	if(aPlayer.PlayerReplicationInfo != None) {
		AddDogTagStatsForPlayer(aPlayer.PlayerReplicationInfo.PlayerID);
	}
	
    return foundStart;
}

function StartMatch() {
     Super.StartMatch();
}

/*
//
// Called after a successful login. This is the first place
// it is safe to call replicated functions on the PlayerPawn.
//
event PostLogin(PlayerPawn NewPlayer) {
	Super.PostLogin(NewPlayer);
}
*/

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

//
// Called when pawn has a chance to pick Item up (i.e. when 
// the pawn touches a weapon pickup). Should return true if 
// he wants to pick it up, false if he does not want it.
//
function bool PickupQuery(Pawn Other, Inventory item) {
    local bool WillPickUp;
	local bool ScoreTagsCollected;
	local DogTagItem dogTags;
	local DogTagStatsObj statsObj;
	
	WillPickUp = Super.PickupQuery(Other, item);
	dogTags = DogTagItem(item);
	
	if(WillPickUp && (dogTags != None)) {
		if(ShowDogTagIndicators) {
			RemoveDogTagItemIndicator(dogTags);
		}
		
		if(Other.PlayerReplicationInfo != None) {
			if(bTeamGame) {
				ScoreTagsCollected = (Other.PlayerReplicationInfo.Team != dogTags.DroppedByTeam);
			} else {
				ScoreTagsCollected = (Other.PlayerReplicationInfo.PlayerID != dogTags.DroppedByPlayerID);
			}
			
			statsObj = GetDogTagStatsForPlayer(Other.PlayerReplicationInfo.PlayerID);
			
			//now notify the game that a player picked this up and adjust the score appropriately
			if(ScoreTagsCollected) {
				Other.PlayerReplicationInfo.Score += 1.0;
				statsObj.EnemyTagsCollected++;
				
				//play "Kill Confirmed" sound
				if(PlayerPawn(Other) != None) {
					class'LGDUtilities.SoundHelper'.static.ClientPlaySound(PlayerPawn(Other), Sound'KillConfirmed.Announcer.KillConfirmed', true, true, 255);
				}
				
				if((TagCollectGoal > 0) && (Other.PlayerReplicationInfo.Score >= TagCollectGoal)) {
					EndGame("fraglimit");
				} else {
					Other.ReceiveLocalizedMessage(class'KillConfirmed.CollectDogTagMessage', 1, Other.PlayerReplicationInfo, None, dogTags);
				}
			} else {
				//play "Kill Denied" sound
				if(PlayerPawn(Other) != None) {
					class'LGDUtilities.SoundHelper'.static.ClientPlaySound(PlayerPawn(Other), Sound'KillConfirmed.Announcer.KillDenied', true, true, 255);
				}
				
				Other.ReceiveLocalizedMessage(class'KillConfirmed.CollectDogTagMessage', 2, Other.PlayerReplicationInfo, None, dogTags);
				
				statsObj.FriendlyTagsCollected++;
			}
		}
	}
	
	return WillPickUp;
}

function NotifySpree(Pawn Other, int num) {
	Super.NotifySpree(Other, num);
}

// Monitor killed messages for fraglimit
function Killed(Pawn killer, Pawn Other, name damageType) {
	local int NextTaunt, i;
	local bool bAutoTaunt;
	local DogTagItem dogTag;

    if(Other == None){
		return;
    }

    //spawn tag from killed player
	dogTag = CreateDogTagForPawn(Other);
	
	if ( (damageType == 'Decapitated') && (Killer != None) && (Killer != Other) ) {
		if (Level.Game.LocalLog != None)
			Level.Game.LocalLog.LogSpecialEvent("headshot", Killer.PlayerReplicationInfo.PlayerID, Other.PlayerReplicationInfo.PlayerID);
		if (Level.Game.WorldLog != None)
			Level.Game.WorldLog.LogSpecialEvent("headshot", Killer.PlayerReplicationInfo.PlayerID, Other.PlayerReplicationInfo.PlayerID);
		Killer.ReceiveLocalizedMessage(class'DecapitationMessage');
	}

	Super(GameInfo).Killed(killer, Other, damageType);

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
		if (Killer.Spree > 4) {
			NotifySpree(Killer, Killer.Spree);
		}
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
	
	local IterativeSoundPlayer soundPlayer;
	local SoundQueue q;
	local SoundToPlaySettings soundSettings;

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
            if(ShowDogTagIndicators){
                class'LGDUtilities.IndicatorHud'.static.SpawnAndRegister(self);
	        }

            bHasInitAnyHUDMutators = true;
            KCRepInfo.bHasInitAnyHUDMutators = bHasInitAnyHUDMutators;
        }

		if(!bHasPlayedIntro) {
			For (P=Level.PawnList; P!=None; P=P.NextPawn) {
				if(P.IsA('PlayerPawn')) {					
					soundPlayer = class'LGDUtilities.IterativeSoundPlayer'.static.GetRef(self);
					q = soundPlayer.GetSoundQueueForPlayerPawn(PlayerPawn(P) );
					
					soundSettings = new class'SoundToPlaySettings';
					soundSettings.ASound = IntroSound;
					
					q.AddSoundToQueue(soundSettings);
				}
			}

		    bHasPlayedIntro = true;
		}

	    //game has begun
		if (bAlwaysForceRespawn || (bForceRespawn && (Level.NetMode != NM_Standalone)) ) {
			For(P=Level.PawnList; P!=None; P=P.NextPawn) {
				if(P.IsInState('Dying') && P.IsA('PlayerPawn') && P.bHidden) {
					PlayerPawn(P).ServerReStartPlayer();
				}
			}
		}
		
		if (Level.NetMode != NM_Standalone) {
			if (NeedPlayers()) {
				AddBot();
			}
		} else {
			while ((RemainingBots > 0) && AddBot()) {
				RemainingBots--;
			}
		}

		if (bGameEnded) {
			if (Level.TimeSeconds > EndTime + RestartWait) {
				RestartGame();
			}
		} else if ( !bOverTime && (TimeLimit > 0) )//if not overtime, and timelimit isn't zero (zero means infinite) 
		{

			GameReplicationInfo.bStopCountDown = false;
			RemainingTime--;
			GameReplicationInfo.RemainingTime = RemainingTime;
			
			if (RemainingTime % 60 == 0) {
				GameReplicationInfo.RemainingMinute = RemainingTime;
			}
			
			if (RemainingTime <= 0) {
				EndGame("timelimit");
			}
		} else//overtime or time limit is zero or less
		{
			ElapsedTime++;
			GameReplicationInfo.ElapsedTime = ElapsedTime;
		}
	}
}

function Logout(Pawn Exiting) {
    local DogTagItem dogTag;

	Super.Logout(Exiting);

	if ((Exiting.IsA('PlayerPawn') && Exiting.IsA('Spectator')) || Exiting.IsA('Bot')) {
        //spawn tag from killed player
        dogTag = CreateDogTagForPawn(Exiting);
		RemoveDogTagStatsForPlayer(Exiting.PlayerReplicationInfo.PlayerID);
	}
}

function AddDogTagItemIndicator(DogTagItem dogTag){
    local IndicatorHudTargetListElement le;
    local IndicatorSettings settings;
	local KillConfirmedDogTagIndicatorModifierFn indicatorMod;
	local IndicatorHud ih;
	
    if(dogTag == None){
        return;
    }

    le = new class'LGDUtilities.IndicatorHudTargetListElement';
	le.IndicatorSource = self;
	indicatorMod = new class'KillConfirmed.KillConfirmedDogTagIndicatorModifierFn';
    indicatorMod.Context = Self;
	
    settings = new class'LGDUtilities.IndicatorSettings';
    settings.UseCustomColor = true;
	
    settings.IndicatorColor = class'LGDUtilities.ColorHelper'.default.RedColor;
    settings.ShowIndicatorAboveTarget = true;
    settings.ShowTargetDistanceLabels = false;
    settings.ScaleIndicatorSizeToTarget = false;
    settings.MaxViewDistance = 0;
    settings.ShowIndicatorWhenOffScreen = true;
	settings.ShowIndicatorIfInventoryDropped = true;
	settings.ShowIndicatorIfInventoryNotHeld = true;

    settings.TextureVariations = class'LGDUtilities.IndicatorHud'.static.GetTexturesForBuiltInOption(64);//HudIndicator_DownTriangle_Solid
    settings.TextureVariations.BehindViewTex = None;

    settings.TextureVariations.InViewTex = Texture'DogTagIcon';

    le.IndicatorSettings = settings;
	le.IndicatorSettingsModifier = indicatorMod;
    le.Value = dogTag;
	
	ih = class'LGDUtilities.IndicatorHud'.static.GetCurrentPlayerIndicatorHudInstance(self);
	ih.AddAdvancedTarget(le, true, true, true);
}

function AddAllDogTagItemIndicators(){
    local DogTagItem tags;

    ForEach AllActors(class'KillConfirmed.DogTagItem', tags) {
        if(!tags.bHeldItem && (tags.Owner == None) && !tags.bCarriedItem && !tags.bOnlyOwnerSee){
            AddDogTagItemIndicator(tags);
        }
    }
}
function RemoveAllDogTagItemIndicators(){
    local DogTagItem tags;
	
    ForEach AllActors(class'KillConfirmed.DogTagItem', tags) {
        RemoveDogTagItemIndicator(tags);
    }
}
function RemoveDogTagItemIndicator(DogTagItem tags){
	local IndicatorHud ih;
		
    if(tags != None){
		ih = class'LGDUtilities.IndicatorHud'.static.GetCurrentPlayerIndicatorHudInstance(self);
		ih.RemoveTargetFromAllLists(tags, self);
    }
}

//------------------------------------------------------------------------------
// Game Querying.

function string GetRules() {
	local string ResultSet;
	ResultSet = Super.GetRules();

	ResultSet = ResultSet$"\\timelimit\\"$TimeLimit;
	Resultset = ResultSet$"\\tagcollectgoal\\"$TagCollectGoal;
	Resultset = ResultSet$"\\minplayers\\"$MinPlayers;
	Resultset = ResultSet$"\\changelevels\\"$bChangeLevels;
	Resultset = ResultSet$"\\tournament\\"$bTournament;

	Resultset = ResultSet$"\\showdogtagindicators\\"$ShowDogTagIndicators;
	Resultset = ResultSet$"\\usehaloannouncer\\"$UseHaloAnnouncer;

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

defaultproperties {
      IntroSound=Sound'KillConfirmed.Announcer.KillConfirmed'
      KCRepInfo=None
      bHasPlayedIntro=False
      bHasInitAnyHUDMutators=False
      ShowDogTagIndicators=True
      GlobalIndicatorTargets=None
      gamegoal="collected tags wins the match."
      ScoreBoardType=Class'KillConfirmed.KCScoreBoard'
      RulesMenuType="KillConfirmed.KCGameOptionsMenu"
      GameName="KillConfirmed"
      GameReplicationInfoClass=Class'KillConfirmed.KillConfirmedGameReplicationInfo'
}
