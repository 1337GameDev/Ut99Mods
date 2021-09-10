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
            m = class'HUDHelper'.static.PlayerHasHUDMutator(p, 'UseTriggerHUDMutator');
            if(m == None) {
               hud = class'UseTriggerHUDMutator'.static.SpawnAndRegister(self);
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
            m = class'HUDHelper'.static.PlayerHasHUDMutator(p, 'UseTriggerHUDMutator');
            hud = UseTriggerHUDMutator(m);

            if(hud != None){
                //register this trigger to the hudmutator, but only if it's closer than the current trigger -- if there is one
                hud.RemoveTriggerIfSet(self);
            }
        }
    }
}

defaultproperties {
     ScaleIndicatorSizeToTarget=false,
     StaticIndicatorPercentOfMinScreenDimension=5.0,
     UseHudColorForIndicator=false,
     ShowIndicatorWhenObscured=True,
     IndicatorOffsetFromTriggerActor=Vect(0,0,0),
     IndicatorColor=(R=255,G=186,B=3),
     UseMessage="Interact to trigger",
     ShowUseMessage=True,
     ShowIndicator=True,//the indicator on the HUD to show where this is
     BaseAlphaValue=0.30,
     Texture=Texture'UseTrigger',
     Message="Activated the trigger!"
}

