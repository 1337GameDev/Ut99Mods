class ManualTrigger extends Trigger nousercreate;

var bool ActivatedOnceBefore;
var(Trigger) string RetriggerCooldownMessage;
var(Trigger) string CannotReactivateMessage;
var(Trigger) bool CanBeTriggeredExternally;

var(Sound) bool PlayActivationSound;
var(Sound) Sound ActivationNoise;
#exec AUDIO IMPORT FILE="Sounds\ManualTrigger\Activate.wav" NAME="ActivateTrigger" GROUP="ManualTrigger"

//=============================================================================
// Trigger logic
// See whether the other actor is relevant to this trigger.
//
function bool IsRelevant(Actor Other) {
    if(!bInitiallyActive) {
        return false;
    } else {
        return Pawn(Other)!=None && (Pawn(Other).bIsPlayer || Pawn(Other).Intelligence > BRAINS_None);
    }
}
//
// Called when something touches the trigger.
//
function Touch(Actor Other) {
    local PlayerPawn p;

    if(IsRelevant(Other)) {
        p = PlayerPawn(Other);

        if(p != None){

        }
    }
}

//
// When something untouches the trigger.
//
function UnTouch(Actor Other) {
    local PlayerPawn p;

    if(IsRelevant(Other)) {
        p = PlayerPawn(Other);

        if(p != None){

        }
    }
}

function Trigger(Actor Other, Pawn EventInstigator) {
    if(CanBeTriggeredExternally){
        ActivateTrigger(Other);
    }
}

function ActivateTrigger(Actor Other) {
    local Actor A;
    if(!CanActivateTrigger()){
        return;
    }

    TriggerTime = Level.TimeSeconds;
    ActivatedOnceBefore = true;

    if(PlayActivationSound) {
        PlaySound(ActivationNoise);
    }

    // Broadcast the Trigger message to all matching actors.
    if(Event != '') {
        foreach AllActors(class 'Actor', A, Event) {
            A.Trigger(Other, self.Instigator);
        }
    }

    if(Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self)) {
        Pawn(Other).SpecialGoal = None;
    }

    if(Message != "") {
        // Send a string message to the activator.
        if(Other.Instigator != None){
            Other.Instigator.ClientMessage(Message);
        } else {
            BroadcastMessage(Message);
        }
    }
}

function bool CanActivateTrigger() {
    if(ActivatedOnceBefore){
        if(bTriggerOnceOnly || ((ReTriggerDelay > 0) && ((Level.TimeSeconds-TriggerTime) < ReTriggerDelay)) ){
              return false;
        }
    }

    return true;
}

defaultproperties
{
      ActivatedOnceBefore=False
      RetriggerCooldownMessage="Trigger Cooldown"
      CannotReactivateMessage="Cannot reactivate"
      CanBeTriggeredExternally=True
      PlayActivationSound=True
      ActivationNoise=Sound'HeadHunter.ManualTrigger.ActivateTrigger'
      Message="Trigger activated."
}
