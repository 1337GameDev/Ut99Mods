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
            m = class'LGDUtilities.HUDHelper'.static.PlayerHasHUDMutator(p, 'LookTriggerHUDMutator');
            if(m == None) {
               hud = class'LGDUtilities.LookTriggerHUDMutator'.static.SpawnAndRegister(self);
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
            m = class'LGDUtilities.HUDHelper'.static.PlayerHasHUDMutator(p, 'LookTriggerHUDMutator');
            hud = LookTriggerHUDMutator(m);

            if(hud != None){
                //register this trigger to the hudmutator, but only if it's closer than the current trigger -- if there is one
                hud.RemoveTriggerIfSet(self);
            }
        }
    }
}

defaultproperties {
      ScaleIndicatorSizeToTarget=True
      StaticIndicatorPercentOfMinScreenDimension=10.000000
      UseHudColorForIndicator=False
      ShowIndicatorWhenObscured=True
      IndicatorOffsetFromTriggerActor=(X=0.000000,Y=0.000000,Z=0.000000)
      IndicatorColor=(R=255,G=186,B=3,A=0)
      ShowLookMessage=True
      LookMessage="Look At To Activate"
      ShowTargetLookCircle=True
      ShowTimeLookedAt=True
      ShowTimeRemaining=True
      ShowTimeCountingDown=True
      ShowMessagesAfterActivated=True
      ShowRetriggerCooldownMessage=True
      ShowCooldownTime=True
      ShowCooldownTimeRemaining=True
      LookTimeToTrigger=2.000000
      TargetLookCircleWidth=60.000000
      BaseAlphaValue=1.000000
      RetriggerCooldownMessage="Wait To Reactivate..."
      Message="Activated!"
      Texture=Texture'LGDUtilities.LookTrigger'
}
