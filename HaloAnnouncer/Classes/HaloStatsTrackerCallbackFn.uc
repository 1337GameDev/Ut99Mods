class HaloStatsTrackerCallbackFn extends Object;

var bool OnlyInvolvedPlayers;
var bool IsSuicide;
var bool IsBetrayal;
var Name DamageType;

function TrackerCallbackFunc(HaloStatsPlayerReplicationInfo killerStats, HaloStatsPlayerReplicationInfo victimStats) {
	local Pawn Killer, Victim;
	
	if(killerStats != None) {
		Killer = killerStats.PawnOwner;
	}
	
	if(victimStats != None) {
		Victim = victimStats.PawnOwner;
	}
	
    OnlyInvolvedPlayers = (Victim.bIsPlayer && ((Killer == None) || (Killer.bIsPlayer)) );
	IsSuicide = (Killer == Victim) || (DamageType == 'Suicided') || (Killer == None);
	IsBetrayal = Victim.Level.Game.bTeamGame && (Killer != None) && (Killer.PlayerReplicationInfo != None) && (Victim != None) && (Victim.PlayerReplicationInfo != None) && (Victim.PlayerReplicationInfo.Team == Killer.PlayerReplicationInfo.Team);
		
	
	//killer could be None (or the player is None) - eg: suicide, killed by lava, fell to death, etc
	//access HaloStatsPlayerReplicationInfo.PawnOwner for owner reference
	//access HaloStatsPlayerReplicationInfo.PawnOwner.Weapon for current weapon
	
}
