                    //=============================================================================
// Trigger: senses things happening in its proximity and generates
// sends Trigger/UnTrigger to actors whose names match 'EventName'.
//=============================================================================
class LookTrigger extends ManualTrigger;

#exec texture Import File=Textures\ActorIcons\LookTrigger.bmp Name=LookTrigger Mips=Off Flags=2

//-----------------------------------------------------------------------------
// LookTrigger variables.
//=============================================================================
var(TriggerVisuals) bool ScaleIndicatorSizeToTarget;
var(TriggerVisuals) float StaticIndicatorPercentOfMinScreenDimension;
var(TriggerVisuals) bool UseHudColorForIndicator;

var(TriggerVisuals) bool ShowIndicatorWhenObscured;
var(TriggerVisuals) Vector IndicatorOffsetFromTriggerActor;
var(TriggerVisuals) color IndicatorColor;
var(TriggerVisuals) bool ShowLookMessage;
var(TriggerVisuals) string LookMessage;

var(TriggerVisuals) bool ShowTargetLookCircle;
var(TriggerVisuals) bool ShowTimeLookedAt;
var(TriggerVisuals) bool ShowTimeRemaining;
var(TriggerVisuals) bool ShowTimeCountingDown;

var(TriggerVisuals) bool ShowMessagesAfterActivated;
var(TriggerVisuals) bool ShowRetriggerCooldownMessage;
var(TriggerVisuals) bool ShowCooldownTime;
var(TriggerVisuals) bool ShowCooldownTimeRemaining;

var(Trigger) float LookTimeToTrigger;
//Vars for the circle in the middle of the screen to center the target in, to be considered looking at the trigger
var(TriggerVisuals) float TargetLookCircleWidth;

var(TriggerVisuals) float BaseAlphaValue;

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
    local LookTriggerHUDMutator hud;
    local PlayerPawn p;

    if(IsRelevant(Other)) {
        p = PlayerPawn(Other);

        if(p != None){
            m = class'HUDHelper'.static.PlayerHasHUDMutator(p, 'LookTriggerHUDMutator');
            if(m == None) {
               hud = class'LookTriggerHUDMutator'.static.SpawnAndRegister(self);
            } else {
               hud = LookTriggerHUDMutator(m);
            }

            //register this trigger to the hudmutator, but only if it's closer than the current trigger -- if there is one
            if(hud.SetTriggerActorIfClosest(self, p)){
               //set settings for this trigger
               ShowLookMessage = true;
            }
        }
    }
}

//
// When something untouches the trigger.
//
function UnTouch(Actor Other) {
    local Mutator m;
    local LookTriggerHUDMutator hud;
    local PlayerPawn p;

    if(IsRelevant(Other)) {
        p = PlayerPawn(Other);

        if(p != None){
            m = class'HUDHelper'.static.PlayerHasHUDMutator(p, 'LookTriggerHUDMutator');
            hud = LookTriggerHUDMutator(m);

            if(hud != None){
                //register this trigger to the hudmutator, but only if it's closer than the current trigger -- if there is one
                hud.RemoveTriggerIfSet(self);
            }
        }
    }
}

defaultproperties {
     ScaleIndicatorSizeToTarget=True,
     StaticIndicatorPercentOfMinScreenDimension=10.0,
     UseHudColorForIndicator=False,
     ShowIndicatorWhenObscured=True,
     IndicatorOffsetFromTriggerActor=Vect(0,0,0),
     IndicatorColor=(R=255,G=186,B=3),
     ShowLookMessage=True,
     BaseAlphaValue=1.00,
     Texture=Texture'LookTrigger',
     Message="Activated!",
     LookMessage="Look At To Activate",
     //the message to show based on the Trigger's RetriggerDelay
     RetriggerCooldownMessage="Wait To Reactivate...",

     LookTimeToTrigger=2.0,
     TargetLookCircleWidth=60.0,
     ShowTargetLookCircle=True,
     //Whether to show the time elapsed when looking at the trigger
     ShowTimeLookedAt=True,
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

