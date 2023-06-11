class IterativeSoundPlayer extends Actor nousercreate;

var SoundQueue SoundQueueActors[32];

var private IterativeSoundPlayer Ref;

function PostBeginPlay() {
	Enable('Timer');
	SetTimer(1.0, True);
}

final static function IterativeSoundPlayer GetRef(Actor referenceToUseForSpawn) {
    local IterativeSoundPlayer singleton;

    if(default.Ref == None) {
        singleton = referenceToUseForSpawn.Spawn(class'LGDUtilities.IterativeSoundPlayer');
        default.Ref = singleton;
    }

    return default.Ref;
}

function SoundQueue GetSoundQueueForPlayerPawn(PlayerPawn p) {
	local SoundQueue q;
	local int idx;
	//iterate through each queue actor and find a Queue based on its PlayerPawnOwner
	
	for(idx=0;idx<32;idx++) {
		if((SoundQueueActors[idx] != None) && (SoundQueueActors[idx].PlayerPawnOwner == p)) {
			q = SoundQueueActors[idx];
		}
	}
	
	if(q == None) {
		//sound queue not found, so create one
		q = class'LGDUtilities.SoundQueue'.static.GetInstance(p);
		
		//find an index to place it
		for(idx=0;idx<32;idx++) {
			if(SoundQueueActors[idx] == None) {
				SoundQueueActors[idx] = q;
			}
		}
	}
	
	return q;
}

function Timer() {
	local int idx;
	//iterate through each queue actor and remove it if its PlayerPawnOwner is invalid
	
	for(idx=0;idx<32;idx++) {
		if((SoundQueueActors[idx] != None) && (SoundQueueActors[idx].PlayerPawnOwner == None)) {
			SoundQueueActors[idx].Destroy();
			SoundQueueActors[idx] = None;
		}
	}
}

defaultproperties {
      Ref=None
}
