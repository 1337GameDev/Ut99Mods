//=============================================================================
// KillConfirmedGameReplicationInfo.
//=============================================================================
class KillConfirmedGameReplicationInfo extends TournamentGameReplicationInfo;

var LinkedList DogTagStats;

var bool ShowDogTagIndicators;
var bool bHasInitAnyHUDMutators;
var bool bHasPlayedIntro;
var bool UseHaloAnnouncer;

replication {
	reliable if(Role == ROLE_Authority)
		DogTagStats, ShowDogTagIndicators, UseHaloAnnouncer, bHasInitAnyHUDMutators, bHasPlayedIntro;
}

defaultproperties {
      ShowDogTagIndicators=False
      bHasInitAnyHUDMutators=False
      bHasPlayedIntro=False,
	  UseHaloAnnouncer=false
}
