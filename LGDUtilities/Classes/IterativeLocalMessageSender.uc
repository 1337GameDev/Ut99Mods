class IterativeLocalMessageSender extends Actor nousercreate;

var LocalMessageQueue LocalMessageQueueActors[32];

var private IterativeLocalMessageSender Ref;

function PostBeginPlay() {
	Enable('Timer');
	SetTimer(1.0, True);
}

final static function IterativeLocalMessageSender GetRef(Actor referenceToUseForSpawn) {
    local IterativeLocalMessageSender singleton;

    if(default.Ref == None) {
        singleton = referenceToUseForSpawn.Spawn(class'LGDUtilities.IterativeLocalMessageSender');
        default.Ref = singleton;
    }

    return default.Ref;
}

function LocalMessageQueue GetLocalMessageQueueForPlayerPawn(PlayerPawn p) {
	local LocalMessageQueue q;
	local int idx;
	
	if(p == None) {
		return None;
	}
	
	//iterate through each queue actor and find a Queue based on its PlayerPawnOwner
	
	for(idx=0;idx<32;idx++) {
		if((LocalMessageQueueActors[idx] != None) && (LocalMessageQueueActors[idx].PlayerPawnOwner == p)) {
			q = LocalMessageQueueActors[idx];
		}
	}
	
	if(q == None) {
		//sound queue not found, so create one
		q = class'LGDUtilities.LocalMessageQueue'.static.GetInstance(p);
		
		//find an index to place it
		for(idx=0;idx<32;idx++) {
			if(LocalMessageQueueActors[idx] == None) {
				LocalMessageQueueActors[idx] = q;
			}
		}
	}
	
	return q;
}

function Timer() {
	local int idx;
	//iterate through each queue actor and remove it if its PlayerPawnOwner is invalid
	
	for(idx=0;idx<32;idx++) {
		if((LocalMessageQueueActors[idx] != None) && (LocalMessageQueueActors[idx].PlayerPawnOwner == None)) {
			LocalMessageQueueActors[idx].Destroy();
			LocalMessageQueueActors[idx] = None;
		}
	}
}

defaultproperties {
      Ref=None
}
