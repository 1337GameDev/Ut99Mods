class InfectionStatsTrackerCallbackFn extends HaloStatsTrackerCallbackFn;

function TrackerCallbackFunc(HaloStatsPlayerReplicationInfo killerStats, HaloStatsPlayerReplicationInfo victimStats) {
    local InfectionGameInfo infectionGame;
	Super.TrackerCallbackFunc(killerStats, victimStats);
	
	//killer could be None (or the player is None) - eg: suicide, killed by lava, fell to death, etc
	//access HaloStatsPlayerReplicationInfo.PawnOwner for owner reference
	//access HaloStatsPlayerReplicationInfo.PawnOwner.Weapon for current weapon
	
	if(victimStats != None) {
		infectionGame = InfectionGameInfo(victimStats.Level.Game);
		
		if((infectionGame != None) && (infectionGame.InfRepInfo != None)) {
			if(!IsSuicide) {//killerstats not empty then
				if((killerStats.PawnOwner.PlayerReplicationInfo != None) && (victimStats.PawnOwner.PlayerReplicationInfo != None)) {
					//if killer was a zombie, and victim was a human
					if((killerStats.PawnOwner.PlayerReplicationInfo.Team == infectionGame.InfRepInfo.ZombieTeam) && (victimStats.PawnOwner.PlayerReplicationInfo.Team == infectionGame.InfRepInfo.HumanTeam)) {
						killerStats.AddToKillCount("ZombieSpree", 1);
					} else {
						killerStats.ResetKillCount("ZombieSpree");
					}
					
					victimStats.ResetKillCount("ZombieSpree");
				}
			}
		}
	}
}
