class HeadHunterCustomHaloAnnouncerCallbackFn extends HaloStatsTrackerCallbackFn;

function TrackerCallbackFunc(HaloStatsPlayerReplicationInfo killerStats, HaloStatsPlayerReplicationInfo victimStats) {
    
	Super.TrackerCallbackFunc(killerStats, victimStats);
	
	//killer could be None (or the player is None) - eg: suicide, killed by lava, fell to death, etc
	//access HaloStatsPlayerReplicationInfo.PawnOwner for owner reference
	//access HaloStatsPlayerReplicationInfo.PawnOwner.Weapon for current weapon
	
}
