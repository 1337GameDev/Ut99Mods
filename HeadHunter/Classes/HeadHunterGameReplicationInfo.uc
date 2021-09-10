//=============================================================================
// HeadHunterGameReplicationInfo.
//=============================================================================
class HeadHunterGameReplicationInfo extends TournamentGameReplicationInfo;

var int SkullCarryLimit;//the limit on number of skulls a person is allowed to carry
var float SkullCollectTimeInterval;//how often are skulls collected to be scored

replication {
	reliable if(Role == ROLE_Authority)
		SkullCarryLimit, SkullCollectTimeInterval;
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
}
