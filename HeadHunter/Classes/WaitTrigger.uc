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
            m = class'HUDHelper'.static.PlayerHasHUDMutator(p, 'WaitTriggerHUDMutator');
            if(m == None) {
               hud = class'WaitTriggerHUDMutator'.static.SpawnAndRegister(self);
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
            m = class'HUDHelper'.static.PlayerHasHUDMutator(p, 'WaitTriggerHUDMutator');
            hud = WaitTriggerHUDMutator(m);

            if(hud != None){
                //register this trigger to the hudmutator, but only if it's closer than the current trigger -- if there is one
                hud.RemoveTriggerIfSet(self);
            }
        }
    }
}

defaultproperties {
     ShowWaitMessage=True,
     Texture=Texture'WaitTrigger',
     Message="Activated!",
     WaitMessage="Wait To Activate",
     //the message to show based on the Trigger's RetriggerDelay
     RetriggerCooldownMessage="Wait To Reactivate...",

     TimeToTrigger=2.0,

     //Whether to show the time elapsed when looking at the trigger
     ShowTimeWaitedAt=True,
     //whether to show the time remaining, when showing the time looked at
     ShowTimeRemaining=True,
     //whether to show the time remaining to trigger, if showing the time looked at
     ShowTimeCountingDown=True,

     //whether to show a message when waiting for the RetriggerDelay
     ShowMessagesAfterActivated=True,
     //whether to show text stating the player has to wait to retrigger
     ShowRetriggerCooldownMessage=True,
     //whether to show the time for the RetriggerDelay - counting up
     ShowCooldownTime=True,
     //whether to show the time for the RetriggerDelay - counting down
     ShowCooldownTimeRemaining=True
}

