//-----------------------------------------------------------
// InventoryTrigger
//-----------------------------------------------------------
class ActorNearbyTrigger extends ManualTrigger;

#exec texture Import File=Textures\ActorIcons\ActorNearbyTrigger.bmp Name=ActorNearbyTrigger Mips=Off Flags=2

enum ANT_COMPARISON {
	ANT_EQUALS,
	ANT_LESS_THAN,
	ANT_GREATER_THAN,
	ANT_LESS_THAN_OR_EQUALS,
	ANT_GREATER_THAN_OR_EQUALS
};

var(Trigger) struct ActorNeeded {
	var() class<Actor> ActorClass;
	var() name ActorTag;
	var() int NumberNeeded;
	var() ANT_COMPARISON QuantityComparison;//How should the quantity "NumberNeeded" be compared?
} ActorsNeeded[32];

simulated function PostBeginPlay() {
    SetTimer(1.0, true);
}

simulated function Timer() {
   CheckRequiredActors();
}

//
// Called when something touches the trigger.
//
function Touch(Actor Other) {}

function CheckRequiredActors(){
    local bool HasAllActors, ConsiderActor;//bool to indicate if all actors listed are met, and another bool to see if the current actor in range should be considered
    local Actor a;
    local float DistanceFromTrigger;

    local int i;
    local ActorNeeded actorNeeded;

    local int ActorCounts[32];
    HasAllActors = true;
    DistanceFromTrigger = FMax(self.CollisionHeight, self.CollisionRadius);

    foreach RadiusActors(class'Actor', a, DistanceFromTrigger, self.Location) {
        if(a == self){
            continue;
        }

        Log("ActorNearbyTrigger - Actor within range:"$a.Name);

        for(i=0; i<32; i++) {
            ConsiderActor = true;
            actorNeeded = ActorsNeeded[i];

            if((actorNeeded.ActorClass == None) && (actorNeeded.ActorTag == '')){
                continue;
            }

            if(actorNeeded.ActorClass != None){
                ConsiderActor = ConsiderActor && a.Class == actorNeeded.ActorClass;
            }

            if(actorNeeded.ActorTag != ''){
                ConsiderActor = ConsiderActor && a.Tag == actorNeeded.ActorTag;
            }

            if(ConsiderActor){
                ActorCounts[i]++;
            }
        }
    }

    for(i=0; i<32; i++) {
        actorNeeded = ActorsNeeded[i];

        if((actorNeeded.ActorClass == None) && (actorNeeded.ActorTag == '')){
            continue;
        }

        switch(actorNeeded.QuantityComparison) {
			case ANT_COMPARISON.ANT_EQUALS:
				HasAllActors = HasAllActors && (ActorCounts[i] == actorNeeded.NumberNeeded);
				break;
			case ANT_COMPARISON.ANT_GREATER_THAN_OR_EQUALS:
				HasAllActors = HasAllActors && (ActorCounts[i] >= actorNeeded.NumberNeeded);
				break;
			case ANT_COMPARISON.ANT_GREATER_THAN:
				HasAllActors = HasAllActors && (ActorCounts[i] > actorNeeded.NumberNeeded);
				break;
			case ANT_COMPARISON.ANT_LESS_THAN:
				HasAllActors = HasAllActors && (ActorCounts[i] < actorNeeded.NumberNeeded);
				break;
			case ANT_COMPARISON.ANT_LESS_THAN_OR_EQUALS:
				HasAllActors = HasAllActors && (ActorCounts[i] <= actorNeeded.NumberNeeded);
				break;
		}

		if(!HasAllActors){
		    break;
		}
    }

    if(HasAllActors){
         ActivateTrigger(self);
    }
}

DefaultProperties {
   ActorsNeeded(0)=(ActorClass=class'Engine.Mover',ActorTag="TriggerMover1",NumberNeeded=1,QuantityComparison=ANT_EQUALS),
   Texture=Texture'ActorNearbyTrigger',
   Message="You have triggered this due to nearby actors."
}
