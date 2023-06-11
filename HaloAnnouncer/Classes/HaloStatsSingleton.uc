//=============================================================================
// HaloStatsSingleton.
//
// A singleton class used to centralize any "global" lists of HaloStatsPlayerReplicationInfo
//=============================================================================
class HaloStatsSingleton extends Actor nousercreate;

var private HaloStatsSingleton Ref;

var LinkedList PlayerHaloStats;

replication {
	reliable if(Role == ROLE_Authority)
		Ref, PlayerHaloStats;
}

final static function HaloStatsSingleton GetRef(Actor referenceToUseForSpawn) {
    local HaloStatsSingleton singleton;

    if(default.Ref == None) {
        singleton = referenceToUseForSpawn.Spawn(class'HaloAnnouncer.HaloStatsSingleton');
        default.Ref = singleton;
    }

    return default.Ref;
}

function HaloStatsPlayerReplicationInfo GetHaloStatsPlayerReplicationInfo(Pawn PawnOwner) {
	local ListElement le;
	local HaloStatsPlayerReplicationInfo stats;
	local bool foundInfo;
	local int PlayerID;
	
	if(PlayerHaloStats == None) {
	    PlayerHaloStats = new class'LGDUtilities.LinkedList';
	}
	
	if((PawnOwner != None) && (PawnOwner.PlayerReplicationInfo != None)) {
		PlayerID = PawnOwner.PlayerReplicationInfo.PlayerID;
				
		le = PlayerHaloStats.Head;
		while(le != None) {
			stats = HaloStatsPlayerReplicationInfo(le.Value);
			
			if((stats != None) && (stats.PlayerID == PlayerID)) {
				foundInfo = true;
				break;
			}
			
			le = le.Next;
		}

		if(!foundInfo) {
			stats = Spawn(class'HaloAnnouncer.HaloStatsPlayerReplicationInfo');
			stats.PlayerID = PlayerID;
			stats.PawnOwner = PawnOwner;
			stats.Init();
			
			PlayerHaloStats.Push(stats);
		}
	}
	
	return stats;
}

defaultproperties {
      Ref=None
}
