//-----------------------------------------------------------
// InventoryTrigger
//-----------------------------------------------------------
class RandomTrigger extends ManualTrigger;

#exec texture Import File=Textures\ActorIcons\RandomTrigger.bmp Name=RandomTrigger Mips=Off Flags=2

var(Trigger) bool ActivateOnTimer;
var(Odds) int Successes;
var(Odds) int OutOfTotal;

var float Probability;

simulated function PostBeginPlay() {
    Probability = 1.0 - (float(Successes) / float(OutOfTotal));
    Probability = FClamp(Probability, 0.0, 1.0);

    if(ActivateOnTimer) {
	    SetTimer(RepeatTriggerTime, false);
	}
}

function Touch(Actor Other) {}
function Timer() {
   ActivateRandomly(self);

   if(ActivateOnTimer) {
	    SetTimer(RepeatTriggerTime, false);
   }
}

function Trigger(Actor Other, Pawn EventInstigator) {
    if(CanBeTriggeredExternally){
        ActivateRandomly(Other);
    }
}

function ActivateRandomly(Actor Other){
    if(FRand() >= Probability){
        ActivateTrigger(Other);
    }
}

DefaultProperties {
   PlayActivationSound=false,
   RepeatTriggerTime=1.0,
   ActivateOnTimer=True,
   Successes=10,
   OutOfTotal=100,
   Texture=Texture'RandomTrigger',
   Message="Random Event"
}
