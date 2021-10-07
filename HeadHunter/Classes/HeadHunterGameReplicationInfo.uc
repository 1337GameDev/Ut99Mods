//=============================================================================
// HeadHunterGameReplicationInfo.
//=============================================================================
class HeadHunterGameReplicationInfo extends TournamentGameReplicationInfo;

var int SkullCollectGoal;

var int SkullCarryLimit;//the limit on number of skulls a person is allowed to carry
var int SkullCollectTimeInterval;//how often are skulls collected to be scored
var int SkullsCollectedCountdown;//countdown until skulls will be collected

var bool ShowDroppedSkullIndicators;
var bool ShowPlayersWithSkullThreshold;
var int SkullThresholdToShowPlayers;

var bool bHasInitAnyHUDMutators;
var bool bHasPlayedIntro;

replication {
	reliable if(Role == ROLE_Authority)
		SkullCarryLimit, SkullCollectTimeInterval, SkullsCollectedCountdown, ShowDroppedSkullIndicators, ShowPlayersWithSkullThreshold, SkullThresholdToShowPlayers, SkullCollectGoal, bHasInitAnyHUDMutators, bHasPlayedIntro;
}

simulated function PostBeginPlay() {
	Super.PostBeginPlay();
    if(HeadHunterGameInfo(Level.Game) != None){

	}

}

defaultproperties {
     HumanString="*Human*"
     CommanderString="*Commander*"
     SupportString="supporting"
     DefendString="defending"
     AttackString="attacking"
     HoldString="holding"
     FreelanceString="freelancing"
     SkullCollectGoal=10
}
