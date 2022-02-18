//-----------------------------------------------------------
// InventoryTrigger
//-----------------------------------------------------------
class ActorNearbyTrigger extends ManualTrigger;

#exec texture Import File=Textures\ActorIcons\ActorNearbyTrigger.bmp Name=ActorNearbyTrigger Mips=Off Flags=2
var(Logging) bool bLogToGameLogfile;

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

        if(bLogToGameLogfile){
            Log("ActorNearbyTrigger - Actor within range:"$a.Name);
        }

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

defaultproperties
{
      bLogToGameLogfile=False
      ActorsNeeded(0)=(ActorClass=Class'Engine.Mover',ActorTag="TriggerMover1",NumberNeeded=1,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(1)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(2)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(3)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(4)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(5)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(6)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(7)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(8)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(9)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(10)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(11)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(12)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(13)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(14)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(15)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(16)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(17)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(18)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(19)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(20)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(21)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(22)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(23)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(24)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(25)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(26)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(27)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(28)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(29)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(30)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      ActorsNeeded(31)=(ActorClass=None,ActorTag="None",NumberNeeded=0,QuantityComparison=ANT_EQUALS)
      Message="You have triggered this due to nearby actors."
      Texture=Texture'HeadHunter.ActorNearbyTrigger'
}
