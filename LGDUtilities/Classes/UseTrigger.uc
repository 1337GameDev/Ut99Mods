//=============================================================================
// Trigger: senses things happening in its proximity and generates
// sends Trigger/UnTrigger to actors whose names match 'EventName'.
//=============================================================================
class UseTrigger extends ManualTrigger;

#exec texture Import File=Textures\ActorIcons\UseTrigger.bmp Name=UseTrigger Mips=Off Flags=2

//-----------------------------------------------------------------------------
// UseTrigger variables.
//=============================================================================
var bool ScaleIndicatorSizeToTarget;
var float StaticIndicatorPercentOfMinScreenDimension;
var() bool UseHudColorForIndicator;

var bool ShowIndicatorWhenObscured;
var Vector IndicatorOffsetFromTriggerActor;
var() color IndicatorColor;
var() bool ShowUseMessage;
var() string UseMessage;
var() bool ShowIndicator;

var() float BaseAlphaValue;

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
//
function Touch(Actor Other) {
    local Mutator m;
    local UseTriggerHUDMutator hud;
    local PlayerPawn p;

    if(IsRelevant(Other)) {
        p = PlayerPawn(Other);

        if(p != None){
            m = class'LGDUtilities.HUDHelper'.static.PlayerHasHUDMutator(p, 'UseTriggerHUDMutator');

            if(m == None) {
               hud = class'LGDUtilities.UseTriggerHUDMutator'.static.SpawnAndRegister(self);
            } else {
               hud = UseTriggerHUDMutator(m);
            }

            hud.GiveOwnerHUDWeapon();

            //register this trigger to the hudmutator, but only if it's closer than the current trigger -- if there is one
            hud.SetTriggerActorIfClosest(self);
        }
    }
}

//
// When something untouches the trigger.
//
function UnTouch(Actor Other) {
    local Mutator m;
    local UseTriggerHUDMutator hud;
    local PlayerPawn p;

    if(IsRelevant(Other)) {
        p = PlayerPawn(Other);

        if(p != None){
            m = class'LGDUtilities.HUDHelper'.static.PlayerHasHUDMutator(p, 'UseTriggerHUDMutator');
            hud = UseTriggerHUDMutator(m);

            if(hud != None){
                //register this trigger to the hudmutator, but only if it's closer than the current trigger -- if there is one
                hud.RemoveTriggerIfSet(self);
            }
        }
    }
}

defaultproperties {
      ScaleIndicatorSizeToTarget=False
      StaticIndicatorPercentOfMinScreenDimension=5.000000
      UseHudColorForIndicator=False
      ShowIndicatorWhenObscured=True
      IndicatorOffsetFromTriggerActor=(X=0.000000,Y=0.000000,Z=0.000000)
      IndicatorColor=(R=255,G=186,B=3,A=0)
      ShowUseMessage=True
      UseMessage="Interact to trigger"
      ShowIndicator=True
      BaseAlphaValue=0.300000
      Message="Activated the trigger!"
      Texture=Texture'LGDUtilities.UseTrigger'
}
