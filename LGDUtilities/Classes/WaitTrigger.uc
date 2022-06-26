//=============================================================================
// Trigger: senses things happening in its proximity and generates
// sends Trigger/UnTrigger to actors whose names match 'EventName'.
//=============================================================================
class WaitTrigger extends ManualTrigger;

#exec texture Import File=Textures\ActorIcons\WaitTrigger.bmp Name=WaitTrigger Mips=Off Flags=2

//-----------------------------------------------------------------------------
// WaitTrigger variables.
//=============================================================================
var(TriggerVisuals) bool ShowWaitMessage;
var(TriggerVisuals) string WaitMessage;

var(TriggerVisuals) bool ShowTimeWaitedAt;
var(TriggerVisuals) bool ShowTimeRemaining;
var(TriggerVisuals) bool ShowTimeCountingDown;

var(Trigger) float TimeToTrigger;

var(TriggerVisuals) bool ShowMessagesAfterActivated;
var(TriggerVisuals) bool ShowRetriggerCooldownMessage;
var(TriggerVisuals) bool ShowCooldownTime;
var(TriggerVisuals) bool ShowCooldownTimeRemaining;

function PostBeginPlay() {
    Super.PostBeginPlay();
}

function Actor SpecialHandling(Pawn Other) {
    return None;
}

//=============================================================================
// Trigger logic.
//
// Called when something touches the trigger.
// Unlike a normal trigger, this just ensures the player
//  has the proper hud mutator, and registers itself with it,
//  if the player is closest to this trigger, vs the current hud mutator's trigger target.
//
function Touch(Actor Other) {
    local Mutator m;
    local WaitTriggerHUDMutator hud;
    local PlayerPawn p;

    if(IsRelevant(Other)) {
        p = PlayerPawn(Other);

        if(p != None){
            m = class'LGDUtilities.HUDHelper'.static.PlayerHasHUDMutator(p, 'WaitTriggerHUDMutator');
            if(m == None) {
               hud = class'LGDUtilities.WaitTriggerHUDMutator'.static.SpawnAndRegister(self);
            } else {
               hud = WaitTriggerHUDMutator(m);
            }

            //register this trigger to the hudmutator, but only if it's closer than the current trigger -- if there is one
            if(hud.SetTriggerActorIfClosest(self, p)){
               //set settings for this trigger
               ShowWaitMessage = true;
            }
        }
    }
}

//
// When something untouches the trigger.
//
function UnTouch(Actor Other) {
    local Mutator m;
    local WaitTriggerHUDMutator hud;
    local PlayerPawn p;

    if(IsRelevant(Other)) {
        p = PlayerPawn(Other);

        if(p != None){
            m = class'LGDUtilities.HUDHelper'.static.PlayerHasHUDMutator(p, 'WaitTriggerHUDMutator');
            hud = WaitTriggerHUDMutator(m);

            if(hud != None){
                //register this trigger to the hudmutator, but only if it's closer than the current trigger -- if there is one
                hud.RemoveTriggerIfSet(self);
            }
        }
    }
}

defaultproperties {
      ShowWaitMessage=True
      WaitMessage="Wait To Activate"
      ShowTimeWaitedAt=True
      ShowTimeRemaining=True
      ShowTimeCountingDown=True
      TimeToTrigger=2.000000
      ShowMessagesAfterActivated=True
      ShowRetriggerCooldownMessage=True
      ShowCooldownTime=True
      ShowCooldownTimeRemaining=True
      RetriggerCooldownMessage="Wait To Reactivate..."
      Message="Activated!"
      Texture=Texture'LGDUtilities.WaitTrigger'
}
