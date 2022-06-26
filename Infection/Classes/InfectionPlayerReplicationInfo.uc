//=============================================================================
// InfectionPlayerReplicationInfo.
//=============================================================================
class InfectionPlayerReplicationInfo extends ReplicationInfo;

var int PlayerID;

replication {
	//reliable if (Role == ROLE_Authority)
	//	Teams, FragLimit, TimeLimit, GoalTeamScore;
	
	//replicated on first update -- vars that don't change after initial replication	
	reliable if ((Role == ROLE_Authority) && bNetInitial)
		PlayerID;
}

defaultproperties {
}
