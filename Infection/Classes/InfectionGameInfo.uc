//=============================================================================
// InfectionGameInfo.
//=============================================================================
class InfectionGameInfo extends TeamGamePlus;

// Sounds
#exec OBJ LOAD FILE=..\Sounds\HaloAnnouncer.uax PACKAGE=HaloAnnouncer.Infection

var string ZombieStartUpMessage;
var string HumansStartUpMessage;

var bool bHasPlayedIntro;
var bool bHasInitAnyHUDMutators;

var IndicatorHudGlobalTargets GlobalIndicatorTargets;

//cached cast from GameReplicationInfo class
var InfectionGameReplicationInfo InfRepInfo;

//The minimum number of zombies to have in the game, such as round start / a zombie leaving the game
var int MinimumZombies;
var bool ShowZombieIndicators;
var bool ShowHumanIndicators;
var bool ShowSameTeamIndicators;
var float ZombieMovementModifier;
var float ZombieJumpModifier;

var float ZombieDamageMod;
var float HumanDamageMod;

var bool HumansPickupWeapons;
var bool ZombiesPickupWeapons;
var bool InfiniteAmmo;
var bool AnyDeathInfects;

//both based on TeamInfo.TeamIndex
//Based on enums provided in TeamGamePlus
//TEAM_Red=0
//TEAM_Blue=1
//TEAM_Green=2
//TEAM_Gold=3

var byte ZombieTeam;
var byte HumanTeam;
var byte NeutralTeam;

var bool GameStarted;

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

	//spawn(class'EnergySword.EnergySword');
	spawn(class'Infection.PrimaryShotOnlyFlakCannon');
	spawn(class'Infection.HeadShotEnforcer');
}

//called at end of DeathMatchPlus.PreBeginPlay
function InitGameReplicationInfo() {
	Super.InitGameReplicationInfo();

    InfRepInfo = InfectionGameReplicationInfo(GameReplicationInfo);

    InfRepInfo.MinimumZombies = MinimumZombies;
	InfRepInfo.ShowZombieIndicators = ShowZombieIndicators;
	InfRepInfo.ShowHumanIndicators = ShowHumanIndicators;
	InfRepInfo.ShowSameTeamIndicators = ShowSameTeamIndicators;

    InfRepInfo.bHasInitAnyHUDMutators = bHasInitAnyHUDMutators;
	InfRepInfo.ZombieMovementModifier = ZombieMovementModifier;
	InfRepInfo.ZombieJumpModifier = ZombieJumpModifier;
	InfRepInfo.ZombieTeam = ZombieTeam;
	InfRepInfo.HumanTeam = HumanTeam;
	InfRepInfo.NeutralTeam = NeutralTeam;

	InfRepInfo.HumansPickupWeapons = HumansPickupWeapons;
	InfRepInfo.ZombiesPickupWeapons = ZombiesPickupWeapons;
	InfRepInfo.InfiniteAmmo = InfiniteAmmo;
	InfRepInfo.AnyDeathInfects = AnyDeathInfects;

	InfRepInfo.ZombieDamageMod = ZombieDamageMod;
	InfRepInfo.HumanDamageMod = HumanDamageMod;

	InfRepInfo.bHasPlayedIntro = bHasPlayedIntro;
	InfRepInfo.GameStarted = GameStarted;

	InfRepInfo.ExtraPRIList = new class'LGDUtilities.LinkedList';
}

function PreBeginPlay() {
	Super.PreBeginPlay();

    GlobalIndicatorTargets = class'LGDUtilities.IndicatorHudGlobalTargets'.static.GetRef(self);
}

//
// Initialize the game.
//warning: this is called before actors' PreBeginPlay (so game replication info is not initialized yet).
//
event InitGame(string Options, out string Error) {
    local string InOpt;
	Super.InitGame(Options, Error);

	GoalTeamScore = Self.Default.GoalTeamScore;

	MinimumZombies = GetIntOption(Options, "MinimumZombies", MinimumZombies);

	InOpt = ParseOption(Options, "ZombieMovementModifier");
	if(InOpt != "") {
		ZombieMovementModifier = float(InOpt);
	}

	InOpt = ParseOption(Options, "ZombieJumpModifier");
	if(InOpt != "") {
		ZombieJumpModifier = float(InOpt);
	}

    ZombieTeam = Clamp(GetIntOption(Options, "ZombieTeam", ZombieTeam), 0, 3);
	HumanTeam = Clamp(GetIntOption(Options, "HumanTeam", HumanTeam), 0, 3);
	NeutralTeam = Clamp(GetIntOption(Options, "NeutralTeam", NeutralTeam), 0, 3);

	//now ensure none are equal, and if so, set defaults
	if((ZombieTeam == HumanTeam) || (ZombieTeam == NeutralTeam) || (NeutralTeam == HumanTeam) ){
		//set defaults
		ZombieTeam = self.default.ZombieTeam;
		HumanTeam = self.default.HumanTeam;
		NeutralTeam = self.default.NeutralTeam;
	}

	//handle bool values
    InOpt = ParseOption(Options, "ShowZombieIndicators");
    if(InOpt != ""){
        ShowZombieIndicators = bool(InOpt);
    }

    InOpt = ParseOption(Options, "ShowHumanIndicators");
    if(InOpt != ""){
        ShowHumanIndicators = bool(InOpt);
    }

	InOpt = ParseOption(Options, "ShowSameTeamIndicators");
    if(InOpt != ""){
        ShowSameTeamIndicators = bool(InOpt);
    }

	InOpt = ParseOption(Options, "HumansPickupWeapons");
    if(InOpt != ""){
        HumansPickupWeapons = bool(InOpt);
    }

	InOpt = ParseOption(Options, "ZombiesPickupWeapons");
    if(InOpt != ""){
        ZombiesPickupWeapons = bool(InOpt);
    }

	InOpt = ParseOption(Options, "InfiniteAmmo");
    if(InOpt != ""){
        InfiniteAmmo = bool(InOpt);
    }

	InOpt = ParseOption(Options, "AnyDeathInfects");
    if(InOpt != ""){
        AnyDeathInfects = bool(InOpt);
    }

	InOpt = ParseOption(Options, "ZombieDamageMod");
	if(InOpt != "") {
		ZombieDamageMod = float(InOpt);
	}

	InOpt = ParseOption(Options, "HumanDamageMod");
	if(InOpt != "") {
		HumanDamageMod = float(InOpt);
	}

	GameStarted = false;
}

function StartMatch() {
	ChangeAllPlayersToHuman();

    //pick zombie, and balance required # of zombies
	ReBalance();

    Super.StartMatch();

	GameStarted = true;
}

function RestartGame() {
	GameStarted = false;

	Super.RestartGame();
}

//
// Add bot to game.
//
function bool AddBot() {
	local bot NewBot;
	local NavigationPoint StartSpot, OldStartSpot;

	NewBot = SpawnBot(StartSpot);

	if (NewBot == None) {
		log("Failed to spawn bot");
		return false;
	}

	if(!GameStarted) {
		ChangeToNeutralTeam(NewBot);
	} else {
		ChangeToHuman(NewBot);
	}

	if (bSpawnInTeamArea) {
		OldStartSpot = StartSpot;
		StartSpot = FindPlayerStart(NewBot, 255);

		if (StartSpot != None) {
			NewBot.SetLocation(StartSpot.Location);
			NewBot.SetRotation(StartSpot.Rotation);
			NewBot.ViewRotation = StartSpot.Rotation;
			NewBot.SetRotation(NewBot.Rotation);

			StartSpot.PlayTeleportEffect(NewBot, true);
		} else {
			StartSpot = OldStartSpot;
		}
	}

	StartSpot.PlayTeleportEffect(NewBot, true);

	SetBotOrders(NewBot);

	// Log it.
	if (LocalLog != None) {
		LocalLog.LogPlayerConnect(NewBot);
		LocalLog.FlushLog();
	}

	if (WorldLog != None) {
		WorldLog.LogPlayerConnect(NewBot);
		WorldLog.FlushLog();
	}

	if(GameStarted && !bGameEnded) {
		ReBalance();
	}

	if(bHasInitAnyHUDMutators) {
		AddPlayerIndicator(NewBot);
	}

	return true;
}

function playerpawn Login (
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
) {
	local PlayerPawn newPlayer;
	local NavigationPoint StartSpot;

	newPlayer = Super(DeathMatchPlus).Login(Portal, Options, Error, SpawnClass);
	if (newPlayer == None) {
		return None;
	}

	if (bSpawnInTeamArea) {
		StartSpot = FindPlayerStart(NewPlayer,255, Portal);

		if (StartSpot != None) {
			NewPlayer.SetLocation(StartSpot.Location);
			NewPlayer.SetRotation(StartSpot.Rotation);
			NewPlayer.ViewRotation = StartSpot.Rotation;
			NewPlayer.ClientSetRotation(NewPlayer.Rotation);
			StartSpot.PlayTeleportEffect( NewPlayer, true );
		}
	}
	PlayerTeamNum = NewPlayer.PlayerReplicationInfo.Team;

	return newPlayer;
}

//
// Called after a successful login. This is the first place
// it is safe to call replicated functions on the PlayerPawn.
//
event PostLogin(PlayerPawn NewPlayer) {
    Super(DeathMatchPlus).PostLogin(NewPlayer);

	CreateExtraPlayerPRI(NewPlayer.PlayerReplicationInfo.PlayerID);
	ChangeToNeutralTeam(NewPlayer);

	if (Level.NetMode != NM_Standalone) {
		NewPlayer.ClientChangeTeam(NewPlayer.PlayerReplicationInfo.Team);
	}
}

//
// Pawn exits.
//
function Logout(Pawn Exiting) {
	Super(DeathMatchPlus).Logout(Exiting);

	if (Exiting.IsA('Spectator') || Exiting.IsA('Commander')) {
		return;
    }

    Teams[Exiting.PlayerReplicationInfo.Team].Size--;
	ClearOrders(Exiting);

	RemoveExtraPlayerPRI(Exiting.PlayerReplicationInfo.PlayerID);

	if (!bGameEnded) {
		ReBalance();
	}
}

/* AcceptInventory()
Examine the passed player's inventory, and accept or discard each item
* AcceptInventory needs to gracefully handle the case of some inventory
being accepted but other inventory not being accepted (such as the default
weapon).  There are several things that can go wrong: A weapon's
AmmoType not being accepted but the weapon being accepted -- the weapon
should be killed off. Or the player's selected inventory item, active
weapon, etc. not being accepted, leaving the player weaponless or leaving
the HUD inventory rendering messed up (AcceptInventory should pick another
applicable weapon/item as current).
*/
function AcceptInventory(pawn PlayerPawn) {
	//deathmatch accepts no inventory
	local inventory Inv;
	for(Inv=PlayerPawn.Inventory; Inv!=None; Inv=Inv.Inventory) {
		Inv.Destroy();
	}

	PlayerPawn.Weapon = None;
	PlayerPawn.SelectedItem = None;

	AddDefaultInventory(PlayerPawn);
}

//
// Spawn any default inventory for the player.
//
function AddDefaultInventory(Pawn PawnWithInv) {
	local byte PawnTeam;
	local Weapon Sword;

	PawnWithInv.JumpZ = PawnWithInv.Default.JumpZ * PlayerJumpZScaling();

    if (PawnWithInv.IsA('Spectator') || (bRequireReady && (CountDown > 0)) ) {
        return;
	}

	PawnTeam = -1;

    // Spawn HeadShotEnforcer and PrimaryShotOnlyFlakCannon if human
	//give melee weapon only if zombie
	if(PawnWithInv.PlayerReplicationInfo != None) {
		if(PawnWithInv.PlayerReplicationInfo.Team == ZombieTeam) {
			Sword = Spawn(class'ChaosUT.Sword');
			Sword.AutoSwitchPriority = 9;

			if(Sword != None) {
				Sword.Instigator = PawnWithInv;
				Sword.BecomeItem();
				PawnWithInv.AddInventory(Sword);
				Sword.BringUp();
				Sword.GiveAmmo(PawnWithInv);
				Sword.SetSwitchPriority(PawnWithInv);
				Sword.WeaponSet(PawnWithInv);
			}

		} else if(PawnWithInv.PlayerReplicationInfo.Team == HumanTeam) {
			GiveWeapon(PawnWithInv, "Infection.HeadShotEnforcer");
			GiveWeapon(PawnWithInv, "Infection.PrimaryShotOnlyFlakCannon");
		}

		PawnWithInv.SwitchToBestWeapon();
	}

	bUseTranslocator = false; // never allow translocator in infection
	BaseMutator.ModifyPlayer(PawnWithInv);
}

// Monitor killed messages for fraglimit
function Killed(Pawn killer, Pawn Other, name damageType) {
	local Pawn P, Best;
	local int NextTaunt, i;
	local bool bAutoTaunt, bEndOverTime;

    if(Other == None) {
		return;
    }

	if ((damageType == 'Decapitated') && (Killer != None) && (Killer != Other) ) {
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

	if (bOverTime) {
		bEndOverTime = true;

		//check for clear winner now
		// find individual winner
		for (P=Level.PawnList; P!=None; P=P.nextPawn) {
			if (P.bIsPlayer && ((Best == None) || (P.PlayerReplicationInfo.Score > Best.PlayerReplicationInfo.Score)) && P.PlayerReplicationInfo.Team == InfRepInfo.HumanTeam) {
				Best = P;
			}
		}

		// check for tie
		for (P=Level.PawnList; P!=None; P=P.nextPawn) {
			if (P.bIsPlayer && (Best != P) && (P.PlayerReplicationInfo.Score == Best.PlayerReplicationInfo.Score) && P.PlayerReplicationInfo.Team == HumanTeam) {
				bEndOverTime = false;
			}
		}

		if (bEndOverTime) {
			if ((FragLimit > 0) && (Best.PlayerReplicationInfo.Score >= FragLimit) && (Best.PlayerReplicationInfo.Team == InfRepInfo.HumanTeam)) {
				EndGame("fraglimit");
			} else {
				EndGame("timelimit");
			}
		}
	} else if ((FragLimit > 0) && (killer != None) && (killer.PlayerReplicationInfo != None)
			&& (killer.PlayerReplicationInfo.Score >= FragLimit) && (killer.PlayerReplicationInfo.Team == InfRepInfo.HumanTeam)) {
		EndGame("fraglimit");
	}

	if ( (killer == None) || (Other == None) )
		return;

    //handle spree-based messages
	if (!bFirstBlood) {
		if ((Killer != None) || (Killer != Other) && Killer.bIsPlayer) {
			if (!Self.IsA('TrainingDM')) {
				bFirstBlood = True;
				BroadcastLocalizedMessage(class'FirstBloodMessage', 0, Killer.PlayerReplicationInfo);
			}
		}
	}

	if (BotConfig.bAdjustSkill && (((Killer != None) && Killer.IsA('PlayerPawn')) || Other.IsA('PlayerPawn')) ) {
		if (killer.IsA('Bot')) {
			BotConfig.AdjustSkill(Bot(Killer),true);
		}

		if (Other.IsA('Bot')) {
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
		for (i=0; i<4; i++) {
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
	local Inventory inv;
	local Weapon wep;

    //Code from GameInfo.Timer
	SentText = 0;
	//END of code from GameInfo.Timer

	if (bNetReady) {
		if (NumPlayers > 0) {
			ElapsedTime++;
		} else {
			ElapsedTime = 0;
		}

		if (ElapsedTime > NetWait) {
			if ((NumPlayers + NumBots < 4) && NeedPlayers()) {
				AddBot();
			} else if ( (NumPlayers + NumBots > 1) || ((NumPlayers > 0) && (ElapsedTime > 2 * NetWait)) ) {
				bNetReady = false;
			}
		}

		if (bNetReady) {
			for (P=Level.PawnList; P!=None; P=P.NextPawn) {
				if ( P.IsA('PlayerPawn'))  {
					PlayerPawn(P).SetProgressTime(2);
				}
			}

			return;
		} else {
			while (NeedPlayers()) {
				AddBot();
			}

			bRequireReady = false;
			StartMatch();
		}
	}

	if (bRequireReady && (CountDown > 0)) {
	    //game has not begun, and CountDown has time remaining
		while ( (RemainingBots > 0) && AddBot()) {
			RemainingBots--;
		}

		for (P=Level.PawnList; P!=None; P=P.NextPawn) {
			if (P.IsA('PlayerPawn')) {
				PlayerPawn(P).SetProgressTime(2);
			}
		}

		if ( ((NumPlayers == MaxPlayers) || (Level.NetMode == NM_Standalone))
				&& (RemainingBots <= 0) ) {
			bReady = true;
			for (P=Level.PawnList; P!=None; P=P.NextPawn) {
				if (P.IsA('PlayerPawn') && !P.IsA('Spectator')
					&& !PlayerPawn(P).bReadyToPlay) {
					bReady = false;
				}
			}

			if (bReady)//all non-spectator players are READY, start the auto 30-seconds countdown
			{
				StartCount = 30;
				CountDown--;
				if (CountDown <= 0) {//countdown has finished, start match
					StartMatch();
				} else {//play messages for each player denoting the current countdown
					for (P = Level.PawnList; P!=None; P=P.nextPawn) {
						if (P.IsA('PlayerPawn')) {
							PlayerPawn(P).ClearProgressMessages();

							if ((CountDown < 11) && P.IsA('TournamentPlayer')) {
								TournamentPlayer(P).TimeMessage(CountDown);
							} else {
								PlayerPawn(P).SetProgressMessage(CountDown$CountDownMessage, 0);
							}
						}
					}
				}
			} else if ( StartCount > 8 )//all players aren't ready
			{
				for (P = Level.PawnList; P!=None; P=P.nextPawn) {
					if ( P.IsA('PlayerPawn') )
					{
						PlayerPawn(P).ClearProgressMessages();
						PlayerPawn(P).SetProgressTime(2);
						PlayerPawn(P).SetProgressMessage(WaitingMessage1, 0);
						PlayerPawn(P).SetProgressMessage(WaitingMessage2, 1);
						if (PlayerPawn(P).bReadyToPlay) {
							PlayerPawn(P).SetProgressMessage(ReadyMessage, 2);
						} else {
							PlayerPawn(P).SetProgressMessage(NotReadyMessage, 2);
						}
					}
				}
			} else {
				StartCount++;
				if (Level.NetMode != NM_Standalone) {
					StartCount = 30;
				}
			}
		} else {
			for (P = Level.PawnList; P!=None; P=P.nextPawn) {
				if (P.IsA('PlayerPawn')) {
					PlayStartupMessage(PlayerPawn(P));
				}
			}
		}
	} else {
	    if(!bHasInitAnyHUDMutators) {
            //init IndicatorHud
            if(ShowZombieIndicators || ShowHumanIndicators) {
                class'LGDUtilities.IndicatorHud'.static.SpawnAndRegister(self);

                For(P=Level.PawnList; P!=None; P=P.NextPawn) {
					AddPlayerIndicator(P);
			    }
	        }

            bHasInitAnyHUDMutators = true;
            InfRepInfo.bHasInitAnyHUDMutators = bHasInitAnyHUDMutators;
        }

		if(!bHasPlayedIntro) {
			For (P=Level.PawnList; P!=None; P=P.NextPawn) {
				if(P.IsA('PlayerPawn')) {
					class'LGDUtilities.SoundHelper'.static.ClientPlaySound(PlayerPawn(P),Sound'HaloAnnouncer.Infection',, true, 100);
				}
			}

		    bHasPlayedIntro = true;
			InfRepInfo.bHasPlayedIntro = bHasPlayedIntro;
		}

	    //game has begun
		if (bAlwaysForceRespawn || (bForceRespawn && (Level.NetMode != NM_Standalone)) ) {
			For (P=Level.PawnList; P!=None; P=P.NextPawn) {
				if (P.IsInState('Dying') && P.IsA('PlayerPawn') && P.bHidden) {
					PlayerPawn(P).ServerReStartPlayer();
				}
			}
		}

		if (Level.NetMode != NM_Standalone) {
			if (NeedPlayers()) {
				AddBot();
			}
		} else {
			while ( (RemainingBots > 0) && AddBot()) {
				RemainingBots--;
			}
		}

		if (bGameEnded) {
			if (Level.TimeSeconds > EndTime + RestartWait) {
				RestartGame();
			}
		} else if (!bOverTime && (TimeLimit > 0) )//if not overtime, and timelimit isn't zero (zero means infinite)
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

			if(InfRepInfo.InfiniteAmmo) {
				For (P=Level.PawnList; P!=None; P=P.NextPawn) {
					inv = P.Inventory;

					while(inv != None) {
						wep = Weapon(inv);

						if(wep != None) {
							wep.PickupAmmoCount = 999;
							wep.GiveAmmo(P);
						}

						inv = inv.Inventory;
					}
				}
			}
		}
	}
}

//------------------------------------------------------------------------------
// Level death message functions.
function ScoreKill(pawn Killer, pawn Other) {
	local bool IsSuicide;
	IsSuicide = (Killer == Other) || (Killer == None);

	if (
        (Killer == None) ||
        (Killer == Other) ||
        !Other.bIsPlayer ||
        !Killer.bIsPlayer ||
        (Killer.PlayerReplicationInfo.Team != Other.PlayerReplicationInfo.Team)) {
            Super(DeathMatchPlus).ScoreKill(Killer, Other);
    }

	//change killed player (if they are human) to a zombie (if they are killed by a zombie or kill themself)
	if(Other.PlayerReplicationInfo.Team == InfRepInfo.HumanTeam) {//human being scrutinized
		if((IsSuicide && InfRepInfo.AnyDeathInfects) || (Killer.PlayerReplicationInfo.Team == InfRepInfo.ZombieTeam)) {//if they comitted suicide OR a zombie killed them
			ChangeToZombie(Other);
		} else if(Killer.PlayerReplicationInfo.Team == InfRepInfo.HumanTeam) {
			//should only happen if a human triggers a trap / friendly fire on another human -- ignore for now
		}
	}

	if (!bScoreTeamKills) {
		return;
	}

	if (Other.bIsPlayer && ((Killer == None) || Killer.bIsPlayer)) {
		if (IsSuicide) {
			Teams[Other.PlayerReplicationInfo.Team].Score -= 1;
		} else if (Killer.PlayerReplicationInfo.Team != Other.PlayerReplicationInfo.Team) {
			Teams[Killer.PlayerReplicationInfo.Team].Score += 1;
		} else if (FriendlyFireScale > 0) {
			Teams[Other.PlayerReplicationInfo.Team].Score -= 1;
			Killer.PlayerReplicationInfo.Score -= 1;
		}
	}

	if (bScoreTeamKills && (GoalTeamScore > 0)
	   && Killer.bIsPlayer
	   && (Teams[killer.PlayerReplicationInfo.Team].Score >= GoalTeamScore) &&
	   (killer.PlayerReplicationInfo.Team == InfRepInfo.HumanTeam)) {
			EndGame("teamscorelimit");
	}
	// stijn: 469 fix. Team games did not end when one of
	// the teams scored a frag in overtime
	else if (bOverTime && Killer.bIsPlayer) {
       EndGame("timelimit");
	}
}

//
// Default death message.
//
static function string KillMessage(name damageType, Pawn Other) {
	return Super.KillMessage(damageType, Other);
}

//
// Generate a player killled message.
//
static function string PlayerKillMessage(name damageType, PlayerReplicationInfo Other) {
	return Super.PlayerKillMessage(damageType, Other);

}

function InfectionPlayerReplicationInfo CreateExtraPlayerPRI(int PlayerID) {
    local InfectionPlayerReplicationInfo InfPRI;

	InfPRI = FetchExtraPlayerPRI(PlayerID);

	if(InfPRI == None) {
	    InfPRI = Spawn(class'Infection.InfectionPlayerReplicationInfo');
	    InfPRI.PlayerID = PlayerID;

	    InfRepInfo.ExtraPRIList.Push(InfPRI);
	}

	return InfPRI;
}
function InfectionPlayerReplicationInfo FetchExtraPlayerPRI(int PlayerID) {
    local ListElement le;
    local InfectionPlayerReplicationInfo InfPRI;
	local bool FoundPRI;

	le = InfRepInfo.ExtraPRIList.Head;

	while(le != None) {
	    InfPRI = InfectionPlayerReplicationInfo(le.Value);

		if(InfPRI != None) {
		    if(InfPRI.PlayerID == PlayerID) {
			    FoundPRI = true;
			    break;
			}
		}

		le = le.Next;
	}

	if(FoundPRI) {
	    return InfPRI;
	} else {
	    return None;
	}

}
function bool RemoveExtraPlayerPRI(int PlayerID) {
    local ListElement le;
    local InfectionPlayerReplicationInfo InfPRI;
	local bool FoundPRI;

	le = InfRepInfo.ExtraPRIList.Head;

	while(le != None) {
	    InfPRI = InfectionPlayerReplicationInfo(le.Value);

		if(InfPRI != None) {
		    if(InfPRI.PlayerID == PlayerID) {
			    FoundPRI = true;
			    break;
			}
		}

		le = le.Next;
	}

	if(FoundPRI) {
	    le.RemoveFromList();
	}

	return FoundPRI;
}

//------------------------------------------------------------------------------
//adds an indicator to every player / bot that gets passed to this
function AddPlayerIndicator(Pawn player){
	local IndicatorHudTargetListElement le;
    local IndicatorSettings settings;
	local IndicatorHud ih;

    if((player == None) || !(player.IsA('Bot') || player.IsA('PlayerPawn')) ){
        return;
    }

    le = new class'LGDUtilities.IndicatorHudTargetListElement';
	le.IndicatorSource = self;
	le.IndicatorSettingsModifier = new class'LGDUtilities.InfectionIndicatorHudTargetModifierFn';

    settings = new class'LGDUtilities.IndicatorSettings';
	settings.ReplaceExisting = true;
    settings.UseCustomColor = true;
    settings.IndicatorColor = class'LGDUtilities.ColorHelper'.default.RedColor;

	settings.ShowTargetDistanceLabels = false;
	settings.ScaleIndicatorSizeToTarget = true;
	settings.ShowIndicatorLabel = false;
	settings.TextureVariations = class'LGDUtilities.IndicatorHud'.static.GetTexturesForBuiltInOption(64);//HudIndicator_DownTriangle_Solid
	settings.TextureVariations.BehindViewTex = None;
	settings.MaxViewDistance = 0;
	settings.ShowIndicatorWhenOffScreen = false;
	settings.BlinkIndicator = false;
	settings.ShowIndicatorAboveTarget = true;

    le.IndicatorSettings = settings;
    le.Value = player;

	ih = class'LGDUtilities.IndicatorHud'.static.GetCurrentPlayerIndicatorHudInstance(self);
	ih.AddAdvancedTarget(le, true, true, true);
}

function RemovePlayerIndicator(Pawn player) {
	local IndicatorHud ih;

    if(player != None) {
		ih = class'LGDUtilities.IndicatorHud'.static.GetCurrentPlayerIndicatorHudInstance(self);
		ih.RemoveTargetFromAllLists(player, self);
    }
}

//------------------------------------------------------------------------------
// Game Querying.
function string GetRules() {
	local string ResultSet;
	ResultSet = Super(TournamentGameInfo).GetRules();

	ResultSet = ResultSet$"\\timelimit\\"$TimeLimit;
	ResultSet = ResultSet$"\\goalteamscore\\"$int(GoalTeamScore);
	Resultset = ResultSet$"\\minplayers\\"$MinPlayers;
	Resultset = ResultSet$"\\changelevels\\"$bChangeLevels;
	ResultSet = ResultSet$"\\maxteams\\"$MaxTeams;
	ResultSet = ResultSet$"\\balanceteams\\"$bBalanceTeams;
	ResultSet = ResultSet$"\\playersbalanceteams\\"$bPlayersBalanceTeams;
	ResultSet = ResultSet$"\\friendlyfire\\"$int(FriendlyFireScale*100)$"%";
	Resultset = ResultSet$"\\tournament\\"$bTournament;

	if(bMegaSpeed)
		Resultset = ResultSet$"\\gamestyle\\Turbo";
	else
	if(bHardcoreMode)
		Resultset = ResultSet$"\\gamestyle\\Hardcore";
	else
		Resultset = ResultSet$"\\gamestyle\\Classic";

	if(MinPlayers > 0)
		Resultset = ResultSet$"\\botskill\\"$class'ChallengeBotInfo'.default.Skills[Difficulty];

	//infection vars
	Resultset = ResultSet$"\\minimumzombies\\"$MinimumZombies;
	Resultset = ResultSet$"\\showzombieindicators\\"$ShowZombieIndicators;
	Resultset = ResultSet$"\\showhumanindicators\\"$ShowHumanIndicators;
	Resultset = ResultSet$"\\showsameteamindicators\\"$ShowSameTeamIndicators;
	Resultset = ResultSet$"\\zombiemovementmodifier\\"$ZombieMovementModifier;
	Resultset = ResultSet$"\\zombiejumpmodifier\\"$ZombieJumpModifier;
	Resultset = ResultSet$"\\zombiedamagemod\\"$ZombieDamageMod;
	Resultset = ResultSet$"\\humandamagemod\\"$HumanDamageMod;
	Resultset = ResultSet$"\\humanspickupweapons\\"$HumansPickupWeapons;
	Resultset = ResultSet$"\\zombiespickupweapons\\"$ZombiesPickupWeapons;
	Resultset = ResultSet$"\\infiniteammo\\"$InfiniteAmmo;

	return ResultSet;
}

function NotifySpree(Pawn Other, int num) {
	//if we have any custom objects to handle the spree, register them here, otherwise use the base DeathMatchGame.NotifySpree method
	Super.NotifySpree(Other, num);
}

function PlayStartUpMessage(PlayerPawn NewPlayer) {
	local int i;

	NewPlayer.ClearProgressMessages();

	// GameName
	NewPlayer.SetProgressColor(class'LGDUtilities.ColorHelper'.default.GreenColor, i);
	NewPlayer.SetProgressMessage(GameName, i++);
	NewPlayer.SetProgressColor(class'LGDUtilities.ColorHelper'.default.WhiteColor, i);

	if (bRequireReady && (Level.NetMode != NM_Standalone)) {
		NewPlayer.SetProgressMessage(TourneyMessage, i++);
	} else {
		NewPlayer.SetProgressMessage(StartUpMessage, i++);
	}

	NewPlayer.SetProgressColor(class'LGDUtilities.ColorHelper'.default.GreenColor, i);
	NewPlayer.SetProgressMessage("Zombies will try to infect all humans!", i++);
	NewPlayer.SetProgressColor(class'LGDUtilities.ColorHelper'.default.BlueColor, i);
	NewPlayer.SetProgressMessage(FragLimit@"zombie kills for any human wins the match!", i++);

	if (bScoreTeamKills && (GoalTeamScore > 0)) {
		NewPlayer.SetProgressColor(class'LGDUtilities.ColorHelper'.default.BlueColor, i);
		NewPlayer.SetProgressMessage(int(GoalTeamScore)@"zombie kills for the entire human team, wins the match!", i++);
	}

	if (NewPlayer.PlayerReplicationInfo.Team < 4) {
		if (!bRatedGame) {
			NewPlayer.SetProgressColor(class'LGDUtilities.ColorHelper'.default.WhiteColor, i);
			NewPlayer.SetProgressMessage(TeamChangeMessage, i++);
		}
	}

	if (Level.NetMode == NM_Standalone) {
		NewPlayer.SetProgressColor(class'LGDUtilities.ColorHelper'.default.WhiteColor, i);
		NewPlayer.SetProgressMessage(SingleWaitingMessage, i++);
	}
}

//----------------------- Team Changing Methods --------------------------------------------//
//chooses a random zombie, excluding all current zombies
function Pawn ChooseRandomZombie(optional bool SetTeamOfChosen) {
	local LinkedList excludePlayerIDsFromZombieSelection;
	local Pawn p;

	excludePlayerIDsFromZombieSelection = class'LGDUtilities.PawnHelper'.static.GetAllPlayeIDsOfTeam(self, Self.ZombieTeam);
	p = class'LGDUtilities.PawnHelper'.static.GetRandomPlayerPawnOrBot(self, excludePlayerIDsFromZombieSelection);

	if(SetTeamOfChosen) {
		ChangeToZombie(p, true);
	}

	return p;
}

function ChangeToZombie(Pawn pawnToChange, optional bool announceChange) {
	local Pawn P;
	local LinkedList ll;
	local int CurrentHumanCount;

	AddToTeam(Self.ZombieTeam, pawnToChange);

	if(announceChange) {
		For (P=Level.PawnList; P!=None; P=P.NextPawn) {
			if(P.IsA('PlayerPawn')) {
				class'LGDUtilities.SoundHelper'.static.ClientPlaySound(PlayerPawn(P), Sound'HaloAnnouncer.Infection.NewZombie', true, true, 100);
			}
		}
	}

	ll = class'LGDUtilities.PawnHelper'.static.GetAllPlayeIDsOfTeam(self, Self.HumanTeam);
	CurrentHumanCount = ll.Count;

	if(GameStarted && (CurrentHumanCount == 0)) {
		EndGame("everybodyinfected");
	}
}

function ChangeToHuman(Pawn p) {
	AddToTeam(Self.HumanTeam, p);
}

function ChangeToNeutralTeam(Pawn p) {
	AddToTeam(Self.NeutralTeam, p);
}

function AddToTeam(int num, Pawn Other) {
	local teaminfo aTeam;
	local Pawn P;
	local bool bSuccess;
	local string SkinName, FaceName;
	local InfectionGameMessageInfoObj messageInfoObj;

	if (Other == None) {
		return;
	}

	messageInfoObj = new class'Infection.InfectionGameMessageInfoObj';
	messageInfoObj.InfectionGame = Self;

	if((num < 0) || (num > 3)) {
		num = 3;//set to gold team -- unsorted -- not zombie or human
	}

	aTeam = Teams[num];

	aTeam.Size++;
	Other.PlayerReplicationInfo.Team = num;
	Other.PlayerReplicationInfo.TeamName = aTeam.TeamName;

	if (LocalLog != None) {
		LocalLog.LogTeamChange(Other);
	}

	if (WorldLog != None) {
		WorldLog.LogTeamChange(Other);
	}

	bSuccess = false;

	if (Other.IsA('PlayerPawn')) {
		Other.PlayerReplicationInfo.TeamID = 0;
		PlayerPawn(Other).ClientChangeTeam(Other.PlayerReplicationInfo.Team);
	} else {
		Other.PlayerReplicationInfo.TeamID = 1;
	}

	while (!bSuccess) {
		bSuccess = true;

		for (P=Level.PawnList; P!=None; P=P.nextPawn) {
            if (P.bIsPlayer && (P != Other)
				&& (P.PlayerReplicationInfo.Team == Other.PlayerReplicationInfo.Team)
				&& (P.PlayerReplicationInfo.TeamId == Other.PlayerReplicationInfo.TeamId)) {
					bSuccess = false;
			}
		}

		if (!bSuccess) {
			Other.PlayerReplicationInfo.TeamID++;
		}
	}

	messageInfoObj.TeamInfo = aTeam;
	BroadcastLocalizedMessage(DMMessageClass, 3, Other.PlayerReplicationInfo, None, messageInfoObj);

	Other.static.GetMultiSkin(Other, SkinName, FaceName);
	Other.static.SetMultiSkin(Other, SkinName, FaceName, num);

	if(GameStarted && !bGameEnded) {
		ReBalance();
	}
}

function ReBalance() {
	local LinkedList ll;
	local int NumNeededZombies, CurrentZombieCount;

	ll = class'LGDUtilities.PawnHelper'.static.GetAllPlayeIDsOfTeam(self, Self.ZombieTeam);
	CurrentZombieCount = ll.Count;

	if (bBalancing || ((ll != None) && (CurrentZombieCount >= Self.MinimumZombies)) ) {
		return;
	}

	bBalancing = true;
	NumNeededZombies = Self.MinimumZombies - ll.Count;

	While(CurrentZombieCount < NumNeededZombies) {
		ChooseRandomZombie(true);
		CurrentZombieCount++;
	}

	bBalancing = false;
}

function ChangeAllPlayersToHuman() {
	local Pawn P;

	if (bBalancing) {
		return;
	}

	bBalancing = true;

	For (P=Level.PawnList; P!=None; P=P.NextPawn) {
		if(P.PlayerReplicationInfo != None) {
			ChangeToHuman(P);
		}
	}

	bBalancing = false;
}

function ChangeAllPlayersToNeutral() {
	local Pawn P;

	if (bBalancing) {
		return;
	}

	bBalancing = true;

	For (P=Level.PawnList; P!=None; P=P.NextPawn) {
		if(P.PlayerReplicationInfo != None) {
			ChangeToNeutralTeam(P);
		}
	}

	bBalancing = false;
}

//----------------------- Spawn Location Methods --------------------------------------------//
function NavigationPoint FindPlayerStart(Pawn Player, optional byte InTeam, optional string incomingName) {
	local PlayerStart Dest, Candidate[64], InfectionPlayerStarts[64], Best;
	local InfectionPlayerStart infPlayerStart;

	local float Score[64], BestScore, NextDist;
	local Pawn OtherPlayer;
	local int i, num, NumberOfInfectionPlayerStarts;
	local Teleporter Tel;
	local NavigationPoint N;
	local byte Team;

	if (bStartMatch && (Player != None) && Player.IsA('TournamentPlayer')
		&& (Level.NetMode == NM_Standalone)
		&& (TournamentPlayer(Player).StartSpot != None) ) {
			return TournamentPlayer(Player).StartSpot;
	}

	if ((Player != None) && (Player.PlayerReplicationInfo != None)) {
		Team = Player.PlayerReplicationInfo.Team;
	} else {
		Team = InTeam;
	}

	if(incomingName != "") {
		foreach AllActors(class 'Teleporter', Tel) {
			if(string(Tel.Tag) ~= incomingName) {
				return Tel;
			}
		}
	}

	if (Team == 255) {
		Team = 0;
	}

	//look for infection player starts
	for (N=Level.NavigationPointList; N!=None; N=N.nextNavigationPoint) {
		infPlayerStart = InfectionPlayerStart(N);

		if ((infPlayerStart != None) && infPlayerStart.bEnabled
			&& (!bSpawnInTeamArea || (infPlayerStart.ZombieSpawn || infPlayerStart.HumanSpawn)) )
		{
			if(((Team == InfRepInfo.ZombieTeam) && infPlayerStart.ZombieSpawn) || ((Team == InfRepInfo.HumanTeam) && infPlayerStart.HumanSpawn)) {
				if (NumberOfInfectionPlayerStarts<64) {
					InfectionPlayerStarts[NumberOfInfectionPlayerStarts] = infPlayerStart;
				} else if (Rand(NumberOfInfectionPlayerStarts) < 64) {
					InfectionPlayerStarts[Rand(64)] = infPlayerStart;
				}

				NumberOfInfectionPlayerStarts++;
			}
		}
	}

	//choose candidates
	for (N=Level.NavigationPointList; N!=None; N=N.nextNavigationPoint) {
		Dest = PlayerStart(N);

		if ( (Dest != None) && Dest.bEnabled
			&& (!bSpawnInTeamArea || (Team == Dest.TeamNumber)) )
		{
			if (num<64) {
				Candidate[num] = Dest;
			} else if (Rand(num) < 64) {
				Candidate[Rand(64)] = Dest;
			}

			num++;
		}
	}

	if ((num == 0) && (NumberOfInfectionPlayerStarts == 0)) {
		foreach AllActors(class'PlayerStart', Dest) {
			if (num<64) {
				Candidate[num] = Dest;
			} else if (Rand(num) < 64) {
				Candidate[Rand(64)] = Dest;
			}

			num++;
		}

		if (num == 0) {
			return None;
		}
	} else if(NumberOfInfectionPlayerStarts > 0) {
		//only consider these then
		num = NumberOfInfectionPlayerStarts;

		for (i=0;i<num;i++) {
			if (i<64) {
				Candidate[i] = InfectionPlayerStarts[i];
			} else if (Rand(num) < 64) {
				Candidate[Rand(64)] = InfectionPlayerStarts[i];
			}
		}
	}

	num = FClamp(num, 0, 64);

	//assess candidates
	for (i=0;i<num;i++) {
		if (Candidate[i] == LastStartSpot) {
			Score[i] = -6000.0;
		} else {
			Score[i] = 4000 * FRand(); //randomize
		}
	}

	for (OtherPlayer=Level.PawnList; OtherPlayer!=None; OtherPlayer=OtherPlayer.NextPawn) {
		if (OtherPlayer.bIsPlayer && (OtherPlayer.Health > 0) && !OtherPlayer.IsA('Spectator')) {
			for (i=0; i<num; i++) {
				if (OtherPlayer.Region.Zone == Candidate[i].Region.Zone) {
					Score[i] -= 1500;
					NextDist = VSize(OtherPlayer.Location - Candidate[i].Location);

					if(NextDist < 2 * (CollisionRadius + CollisionHeight)) {
						Score[i] -= 1000000.0;
					} else if ((NextDist < 2000) && (OtherPlayer.PlayerReplicationInfo.Team != Team)
							&& FastTrace(Candidate[i].Location, OtherPlayer.Location)) {
						Score[i] -= (10000.0 - NextDist);
					}
				}
			}
		}
	}

	BestScore = Score[0];
	Best = Candidate[0];

	for (i=1; i<num; i++) {
		if(Score[i] > BestScore) {
			BestScore = Score[i];
			Best = Candidate[i];
		}
	}

	LastStartSpot = Best;

	return Best;
}

//----------------------- Damage Methods --------------------------------------------//
function int ReduceDamage(int Damage, name DamageType, Pawn injured, Pawn instigatedBy) {
	Damage = Super.ReduceDamage(Damage, DamageType, injured, instigatedBy);

	if(Damage > 0) {
		if((instigatedBy != injured) && (instigatedBy.PlayerReplicationInfo != None)) {
			if(instigatedBy.PlayerReplicationInfo.Team == InfRepInfo.ZombieTeam) {
				Damage *= InfRepInfo.ZombieDamageMod;
			} else if(instigatedBy.PlayerReplicationInfo.Team == InfRepInfo.HumanTeam) {
				Damage *= InfRepInfo.HumanDamageMod;
			}
		}
	}

	return Damage;
}

//----------------------- End Cams --------------------------------------------------//
function bool SetEndCams(string Reason) {
	local Pawn P, Best;
	local PlayerPawn player;
	local bool ZombieTeamWins;
	local TeamInfo WinningTeamInfo;

	if(Reason ~= "everybodyinfected") {
		//zombies win
		Best = class'LGDUtilities.PawnHelper'.static.GetBestScoringPawnOfTeam(self, ZombieTeam, true);
		ZombieTeamWins = true;
		WinningTeamInfo = Teams[ZombieTeam];
	} else if(Reason ~= "timelimit") {
		//humans survived the zombies
		Best = class'LGDUtilities.PawnHelper'.static.GetBestScoringPawnOfTeam(self, HumanTeam, true);
		WinningTeamInfo = Teams[HumanTeam];
	} else if(Reason ~= "fraglimit") {
		//a human reached the score limit
		Best = class'LGDUtilities.PawnHelper'.static.GetBestScoringPawnOfTeam(self, HumanTeam, true);
		WinningTeamInfo = Teams[HumanTeam];
	} else if(Reason ~= "teamscorelimit") {
		//a team reached the score limit -- not applicable for zombies, but handle this anyways
		Best = class'LGDUtilities.PawnHelper'.static.GetBestScoringPawnOfTeam(self, HumanTeam, true);
		WinningTeamInfo = Teams[HumanTeam];
	}

	// Message about the winner
	if(ZombieTeamWins) {
		GameReplicationInfo.GameEndedComments = "Zombies win!";
		if(Best != None) {
			GameReplicationInfo.GameEndedComments @= "Best zombie: \""$Best.PlayerReplicationInfo.PlayerName$"\" with a score of: "$int(Best.PlayerReplicationInfo.Score);
		}
	} else {
		GameReplicationInfo.GameEndedComments = "Humans win!";
		if(Best != None) {
			GameReplicationInfo.GameEndedComments @= "Best human: \""$Best.PlayerReplicationInfo.PlayerName$"\" with a score of: "$int(Best.PlayerReplicationInfo.Score);
		}
	}

	EndTime = Level.TimeSeconds + 3.0;
	for (P=Level.PawnList; P!=None; P=P.nextPawn) {
		player = PlayerPawn(P);

		if (Player != None) {
			if (!bTutorialGame) {
				PlayWinMessage(Player, (Player.PlayerReplicationInfo.Team == WinningTeamInfo.TeamIndex));
			}

			player.bBehindView = true;
			if (Player == Best) {
				Player.ViewTarget = None;
			} else {
				Player.ViewTarget = Best;
			}

			player.ClientGameEnded();
		}

		P.GotoState('GameEnded');
	}

	CalcEndStats();
	return true;
}

defaultproperties {
      ZombieStartUpMessage="Infect all humans!"
      HumansStartUpMessage="Survive against the zombies!"
	  	bSpawnInTeamArea=True
      bHasPlayedIntro=False
      bHasInitAnyHUDMutators=False
	  	GameStarted=False

      GlobalIndicatorTargets=None
      InfRepInfo=None
      MaxAllowedTeams=2
      TeamChangeMessage="No team changing is allowed!"
	  	StartUpTeamMessage="You are a "
      TeamChangeMessage=""

      StartUpMessage="A battle against the infected and survivors!"
      BeaconName="Inf"
      GameName="Infection"
      GameReplicationInfoClass=Class'Infection.InfectionGameReplicationInfo'
	  	MutatorClass=Class'Infection.InfectionGameTypeMutator'
	  	RulesMenuType="Infection.InfectionGameOptionsMenu"
	  	ScoreBoardType=Class'Infection.InfectionScoreBoard'
	  	HUDType=Class'Infection.InfectionGameHUD'

      DMMessageClass=Class'Infection.InfectionGameMessage'
	  	MinimumZombies=1
	  	ShowZombieIndicators=true
	  	ShowHumanIndicators=false
	  	ShowSameTeamIndicators=true
	  	ZombieMovementModifier=3.0
	  	ZombieJumpModifier=3.0

	  	ZombieDamageMod=3.0,
	  	HumanDamageMod=0.75,

	  	HumansPickupWeapons=false,
	  	ZombiesPickupWeapons=false,
	  	InfiniteAmmo=true,
	  	AnyDeathInfects=true,

	  	ZombieTeam=2//green
	  	HumanTeam=1//blue

	  	NeutralTeam=3//gold -- used for undecided team of a player / before game as begun
	  	GoalTeamScore=0,
	  	bScoreTeamKills=False
}
