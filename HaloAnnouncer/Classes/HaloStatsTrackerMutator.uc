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

function ScoreKill(Pawn Killer, Pawn Victim) {
	local HaloStatsSingleton haloStats;
	local HaloStatsPlayerReplicationInfo killerStats, victimStats;
	
	//local InfectionGameInfo infectionGame;
	//local JuggernautGameInfo juggernautGame;
	
	
	local float CurrentLevelTime;
	
	Super.ScoreKill(Killer, Victim);
	
	//prevent DeathMatchPlus.Killed -> GameInfo.Killed / DeathMatchPlus.NotifySpree from sending spree messages
	Killer.Spree = 0;
	CurrentLevelTime = Level.TimeSeconds;
	
	if((Killer.PlayerReplicationInfo != None) && (Victim.PlayerReplicationInfo != None)) {
		haloStats = class'HaloAnnouncer.HaloStatsSingleton'.static.GetRef(self);
		
		if(haloStats != None) {
			killerStats = haloStats.GetHaloStatsPlayerReplicationInfo(Killer);
			victimStats = haloStats.GetHaloStatsPlayerReplicationInfo(Victim);
			
			//log the kill, based on weapon / team / juggernaut
			if(killerStats  != None) {
				if((CurrentLevelTime - killerStats.LastKillTime) <= MaxTimeBetweenSpreeKills){
					killerStats.SpreeCount++;
				}
				
				killerStats.LastKillTime = CurrentLevelTime;
				
				
				
				if(Killer.Weapon != None) {
					//shotgun check
					if(Killer.Weapon.IsA('PrimaryShotOnlyFlakCannon')) {
						killerStats.ShotgunKillSpreeCount++;
					} else if(Killer.Weapon.IsA('EnergySword')) {//sword check
						killerStats.SwordKillSpreeCount++;
					}
					
					//gametype checks
					/*
					infectionGame = InfectionGameInfo(Level.Game);
					if(infectionGame != None) {
						//if killer was a zombie, and killed a human
						if((Killer.PlayerReplicationInfo.Team == infectionGame.ZombieTeam) && (Victim.PlayerReplicationInfo.Team == infectionGame.HumanTeam)) {
							killerStats.HumanKillSpreeCount++;
						} else if((Killer.PlayerReplicationInfo.Team == infectionGame.HumanTeam) && (Victim.PlayerReplicationInfo.Team == infectionGame.ZombieTeam)) {//if killer was a human and killed a zombie
							killerStats.InfectedKillSpreeCount++;
						}
					}
					*/
					
					/*
					juggernautGame = JuggernautGameInfo(Level.Game);
					if(juggernautGame != None) {
						//if killer is the current juggernaut
						if((juggernautGame.JugRepInfo != None) && (juggernautGame.JugRepInfo.CurrentJuggernautPlayerID == Killer.PlayerReplicationInfo.PlayerID)){
							killerStats.JuggernautKillSpreeCount++;
						}
					}
					*/
				}
				
				self.NotifySpree(Killer, killerStats.SpreeCount);
			}
			
			//check for suicide? Killer == None?
			
			//reset counts for player who was killed
			if(victimStats != None) {
				victimStats.ResetAllCounts();
			}
		}
	}
}

function bool HandleRestartGame() {
	// reset all counts
	ResetAllPawnHaloStats();
	
	return Super.HandleRestartGame();
}

function bool HandleEndGame() {
	// reset all counts
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

function NotifySpree(Pawn Other, int SpreeNum) {
	local Sound SoundToPlay;
	local string SpreeNote;
	
	if(Other.IsA('PlayerPawn')) {
		//if spree was between 2 and 10, play normal announcer takes
		if((SpreeNum < 11) && (SpreeNum > 1) ){
			SoundToPlay = class'HaloAnnouncer.HaloKillingSpreeMessage'.Default.SpreeSound[SpreeNum];
			SpreeNote = class'HaloAnnouncer.HaloKillingSpreeMessage'.Default.spreenote[SpreeNum];
			
			PlayerPawn(Other).ClientPlaySound(SoundToPlay,, true);
			
		}
	}
} 

defaultproperties {
	MaxTimeBetweenSpreeKills=5.00
}
