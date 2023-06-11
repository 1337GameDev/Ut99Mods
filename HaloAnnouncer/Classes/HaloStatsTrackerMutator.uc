//=============================================================================
// HaloStatsTrackerMutator
//
// This is a mutator used to track kills and how they are performed, as to announce different halo announcer sayings - EG: Shotgun spree, sword spree, etc
//=============================================================================

class HaloStatsTrackerMutator extends Mutator nousercreate;

var float MaxTimeBetweenSpreeKills;

var Sound GlobalSoundsToPlay[255];
var int CurrentFreeSoundIndex;

var int CurrentSoundToPlayIndex;

static function HaloStatsTrackerMutator RegisterMutator(Actor context) {
	local Mutator mut;
	
	mut = class'LGDUtilities.MutatorHelper'.static.GetGameMutatorByClass(context, class'HaloAnnouncer.HaloStatsTrackerMutator');
	if(mut == None) {
        mut = context.Spawn(class'HaloAnnouncer.HaloStatsTrackerMutator');
        context.Level.Game.BaseMutator.AddMutator(mut);
	}
	
    return HaloStatsTrackerMutator(mut);
}

function bool PreventDeath(Pawn Victim, Pawn Killer, name damageType, vector HitLocation) {
	local HaloStatsSingleton haloStats;
	local HaloStatsPlayerReplicationInfo killerStats, victimStats;
	local string killerWeaponName;
	local Enforcer killerWeaponEnforcer;
	
	local TournamentPlayer killerTP, victimTP;
	local float CurrentLevelTime;
	local bool OnlyInvolvedPlayers;//used to check if only "players" (Bots/Pawns involved in the game and scoring -- excludes spectators or other pawns)
	local bool IsSuicide; 
	local bool IsBetrayal;
	
	local int CurrentKillCount;
	
    local bool DeathPrevented;
	DeathPrevented = Super.PreventDeath(Victim, Killer, damageType, HitLocation);
	
	if(!DeathPrevented) {
		OnlyInvolvedPlayers = (Victim.bIsPlayer && ((Killer == None) || (Killer.bIsPlayer)) );
		IsSuicide = (Killer == Victim) || (damageType == 'Suicided') || (Killer == None);
		IsBetrayal = Level.Game.bTeamGame && (Killer != None) && (Killer.PlayerReplicationInfo != None) && (Victim != None) && (Victim.PlayerReplicationInfo != None) && (Victim.PlayerReplicationInfo.Team == Killer.PlayerReplicationInfo.Team);
		
		killerTP = TournamentPlayer(Killer);
		victimTP = TournamentPlayer(Victim);
		
		Log("HaloStatsTrackerMutator - PreventDeath");
		
		if(OnlyInvolvedPlayers) {
			if(Killer.Weapon != None) {
				killerWeaponEnforcer = Enforcer(Killer.Weapon);
				
				if((killerWeaponEnforcer != None) && (killerWeaponEnforcer.SlaveEnforcer != None)) {
					killerWeaponName = "Botpack.DoubleEnforcer";
				} else {
					killerWeaponName = string(Killer.Weapon.Class);
				}
			} else {
				killerWeaponName = "NONE";
			}
			
			//pawn was killed, track stats for killer and victim
			CurrentLevelTime = Level.TimeSeconds;
			
			//prevent DeathMatchPlus.Killed -> GameInfo.Killed / DeathMatchPlus.NotifySpree from sending spree messages
			//prevents invocation / use of Botpack.KillingSpreeMessage
			Killer.Spree = 0;
			
			//now prevent first blood message - WE want control of this
			Victim.Level.Game.SetPropertyText("bFirstBlood", "true");
			
			Log("HaloStatsTrackerMutator - Set player spree to 0.");
			Log("HaloStatsTrackerMutator - killerWeaponName: "$killerWeaponName);
						
			if(Victim.PlayerReplicationInfo != None) {
				//get the class that caches and holds the replication info objects for each player
				haloStats = class'HaloAnnouncer.HaloStatsSingleton'.static.GetRef(self);
				
				if(haloStats != None) {
					killerStats = haloStats.GetHaloStatsPlayerReplicationInfo(Killer);
					victimStats = haloStats.GetHaloStatsPlayerReplicationInfo(Victim);
					
					//log the kill, based on weapon / team / etc
					//not a suicide AND killer had halo stats and player replication info
					if(!IsSuicide && (killerStats != None)) {
						CurrentLevelTime = Level.TimeSeconds;
						killerStats.CurrentSpreeSinceDeath++;
						
						//if the killer has never gotten a "last kill" (just spawned or game started) or we are within the spree time
						if((killerTP.LastKillTime == 0) || ((CurrentLevelTime - killerTP.LastKillTime) <= MaxTimeBetweenSpreeKills)) {
							//killer is within the kill time to continue their spree
							//killer didn't commit suicide, and if this is a team game, the killer and victim aren't on the same team (no betrayals)
							if (!IsBetrayal) {
								killerStats.CurrentSpreeCount++;
								killerTP.LastKillTime = CurrentLevelTime;
								
								if(Killer.Weapon != None) {
									if(Killer.Weapon.Class == killerStats.CurrentSpreeWeapon) {
										//increase spree
										killerStats.CurrentSpreeCountWithWeapon++;
										
										Log("HaloStatsTrackerMutator - Continuing weapon spree for this kill for weapon:"$killerWeaponName);
									} else {
										killerStats.CurrentSpreeCountWithWeapon = 1;
										killerStats.CurrentSpreeWeapon = Killer.Weapon.Class;
										
										Log("HaloStatsTrackerMutator - RESET weapon spree for kill");
									}
								} else {
									killerStats.CurrentSpreeCountWithWeapon = 0;
									killerStats.CurrentSpreeWeapon = None;
									
									Log("HaloStatsTrackerMutator - ENDED weapon kill spree");
								}
								
							} else {
								Log("HaloStatsTrackerMutator - Player was killed, and within spree time, but didn't pass player check (spree count not tracked)....");
							}
						} else {
							Log("HaloStatsTrackerMutator - Not within spree time to increment spree counter");
						}
						
						//track kills with this weapon
						CurrentKillCount = killerStats.AddToKillCount(killerWeaponName, 1);
																		
						Log("HaloStatsTrackerMutator - Killer kill counts:");
						killerStats.KillCounts.InOrderLog();
						Log("HaloStatsTrackerMutator - Killer killed by counts:");
						killerStats.KilledByCounts.InOrderLog();
						
					}//not suicide and killer had stats object
					
					//before resetting any, call any custom trackers
					ExecuteCustomTrackerCallbacks(killerStats, victimStats);
					Log("HaloStatsTrackerMutator - Called ExecuteCustomTrackerCallbacks");
					
					//get stats tracking for victim
					
					//reset counts for player who was killed
					if(victimStats != None) {
						victimStats.ResetSpree();
						CurrentKillCount = victimStats.AddToKilledByCount(killerWeaponName, 1);
						
						Log("HaloStatsTrackerMutator - Victim kill counts:");
						victimStats.KillCounts.InOrderLog();
						Log("HaloStatsTrackerMutator - Victim killed By counts:");
						victimStats.KilledByCounts.InOrderLog();
						
						if(IsSuicide) {
							victimStats.SuicideCount++;
						}
						
						if(IsBetrayal) {
							victimStats.BetrayalCount++;
						}
					}//victim stats not empty
					
					//trigger any announcers based on new stats being updated
					self.TriggerAnnouncementsFromStats(victimStats, killerStats, OnlyInvolvedPlayers, IsSuicide, IsBetrayal, damageType);
				}
			}//victim have replication info isn't empty
		}//only involves players -- we don't track info on non-players / spectators
	}//death not prevented
	
    return DeathPrevented;
}

function ScoreKill(Pawn Killer, Pawn Other) {
    Super.ScoreKill(Killer, Other);
	
	//scorekill chain executed, so now process any score change events
	//note currerent player rankings
	
}

function ExecuteCustomTrackerCallbacks(HaloStatsPlayerReplicationInfo killerStats, HaloStatsPlayerReplicationInfo victimStats) {
	local HaloAnnouncerCustomMessagesSingleton singleton;
	local ListElement le;
	local HaloStatsTrackerCallbackFn callback;
	
	singleton = class'HaloAnnouncer.HaloAnnouncerCustomMessagesSingleton'.static.GetRef(self);
	
	if((singleton != None) && (singleton.CustomStatTrackers != None)) {
		le = singleton.CustomStatTrackers.Head;
		
		while(le != None) {
			callback = HaloStatsTrackerCallbackFn(le.Value);
			
			if(callback != None) {
				callback.TrackerCallbackFunc(killerStats, victimStats);
			}
			
			le = le.Next;
		}
	}
}

function bool HandleRestartGame() {
	// reset all counts
	Log("HaloStatsTrackerMutator - HandleRestartGame");
	ResetAllPawnHaloStats();
	
	return Super.HandleRestartGame();
}

function bool HandleEndGame() {
	// reset all counts
	Log("HaloStatsTrackerMutator - HandleEndGame");
	ResetAllPawnHaloStats();
	
	return Super.HandleEndGame();
}

function ResetAllPawnHaloStats() {
	local Pawn P;
	local HaloStatsSingleton haloStats;
	local HaloStatsPlayerReplicationInfo pawnStats;
	
	//reset all counts
	haloStats = class'HaloAnnouncer.HaloStatsSingleton'.static.GetRef(self);
	
	if(haloStats != None) {
		For(P=Level.PawnList; P!=None; P=P.NextPawn) {
			if(P.PlayerReplicationInfo != None) {
				pawnStats = haloStats.GetHaloStatsPlayerReplicationInfo(P);
				if(pawnStats != None) {
					pawnStats.ResetAllCounts();
				}
			}
		}
	}
}

function PlayGlobalAnnouncerSound(Sound SoundToPlay) {
	if(SoundToPlay != None) {
		GlobalSoundsToPlay[CurrentFreeSoundIndex] = SoundToPlay;
		CurrentFreeSoundIndex = (CurrentFreeSoundIndex++) % 255;
		
		Enable('Timer');
		SetTimer(0.0, False);
	}
}

function Timer() {
	local Pawn P;
	local Sound SoundToPlay;
	local float SoundLength;
	
	SoundToPlay = GlobalSoundsToPlay[CurrentSoundToPlayIndex];
	
	if(SoundToPlay != None)	{
		SoundLength = GetSoundDuration(SoundToPlay);
		
		For (P=Level.PawnList; P!=None; P=P.NextPawn) {
			if(P.IsA('PlayerPawn')) {
				//will this play too many copies of the sound?
				class'LGDUtilities.SoundHelper'.static.ClientPlaySound(PlayerPawn(P), SoundToPlay, true, true, 100);
			}
		}
		
		CurrentSoundToPlayIndex = (CurrentSoundToPlayIndex++) % 255;
		Enable('Timer');
		SetTimer(SoundLength, False);
	} else {
		Disable('Timer');
		CurrentSoundToPlayIndex = 0;
		CurrentFreeSoundIndex = 0;
	}
}

//invokes HaloAnnouncer.HaloKillingSpreeMessage
function NotifySpree(Pawn Other, int KillerSpreeNum) {
	local Sound SoundToPlay;
	local string SpreeNote;
	
	if(Other.IsA('PlayerPawn')) {
		Log("HaloStatsTrackerMutator - NotifySpree for: "$Other.PlayerReplicationInfo.PlayerName$" - KillerSpreeNum:"$KillerSpreeNum);
	
		//if spree was between 2 and 10, play normal announcer takes
		if((KillerSpreeNum > 1) ){
			SoundToPlay = class'HaloAnnouncer.HaloKillingSpreeMessage'.Default.SpreeSound[KillerSpreeNum];
			SpreeNote = class'HaloAnnouncer.HaloKillingSpreeMessage'.Default.spreenote[KillerSpreeNum];
			
			//PlayerPawn(Other).ClientPlaySound(SoundToPlay,, true);
			
		}
	}
} 

//this is called when somebody dies
function TriggerAnnouncementsFromStats(HaloStatsPlayerReplicationInfo victimStats, HaloStatsPlayerReplicationInfo killerStats, bool OnlyInvolvedPlayers, bool IsSuicide, bool IsBetrayal, Name damageType) {
	local HaloAnnouncerCustomMessagesSingleton singleton;
	local ListElement le;
	local HaloKillingSpreeMessageSender sender;
	
	singleton = class'HaloAnnouncer.HaloAnnouncerCustomMessagesSingleton'.static.GetRef(self);
	
	if((singleton != None) && (singleton.CustomKillingSpreeMessageSenders != None)) {
		le = singleton.CustomKillingSpreeMessageSenders.Head;
		
		while(le != None) {
			sender = HaloKillingSpreeMessageSender(le.Value);
			
			if(sender != None) {
				sender.TriggerSendingMessages(killerStats, victimStats, OnlyInvolvedPlayers, IsSuicide, IsBetrayal, damageType);
			}
			
			le = le.Next;
		}
	}
}

function Killed(pawn killer, pawn Other, name damageType) {
	Log("HaloStatsTrackerMutator - Killed");
}

function bool MutatorBroadcastLocalizedMessage(Actor Sender, Pawn Receiver, out class<LocalMessage> Message, out optional int Switch, out optional PlayerReplicationInfo RelatedPRI_1, out optional PlayerReplicationInfo RelatedPRI_2, out optional Object OptionalObject ) {
    Log("HaloStatsTrackerMutator - MutatorBroadcastLocalizedMessage - Message Class:"$Message.Class.Name);
	return Super.MutatorBroadcastLocalizedMessage(Sender, Receiver, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

function bool MutatorBroadcastMessage( Actor Sender, Pawn Receiver, out coerce string Msg, optional bool bBeep, out optional name Type ) {
	Log("HaloStatsTrackerMutator - MutatorBroadcastMessage - Message:"$Msg$" - Type:"$Type);
	return Super.MutatorBroadcastMessage(Sender, Receiver, Msg, bBeep, Type);
}

defaultproperties {
	MaxTimeBetweenSpreeKills=4.00
}
