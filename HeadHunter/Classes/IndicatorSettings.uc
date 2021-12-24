//-----------------------------------------------------------
// Settings to use for the indicator hud for a target.
// Meant to make settings more "portable"
//-----------------------------------------------------------
class IndicatorSettings extends Object;

//variations used and cached for the different edges of the screen (to simulate rotations)
var IndicatorTextureVariations TextureVariations;

//set this var to one defined in IndicatorHud.uc, and it'll set any variations (rotations)
//in the "IndicatorTextureVariations" field above (eg: for edge of screen textures for direction indicators)
// ONLY sets built-in (a texture+texture variations that's already defined and included in the IndicatorHUD mutator) if the above TextureVariations field is NONE, otherwise it'll skip. ALSO skips if the built in is set to 0 (IndicatorHUD.HUDIndicator_Texture_BuiltIn.Empty)
var byte BuiltinIndicatorTexture;//IndicatorHud.HUDIndicator_Texture_BuiltIn

//whether to disable the icon/labels of this indicator
var bool DisableIndicator;
//the max distance (in unreal units) the target has an indictor from the owner of this indictor hud
var float MaxViewDistance;
//the offset in 3d coordinates to position the indicator over
var Vector IndicatorOffsetFromTarget;

//if both below are false, the indicator color is the default: IndicatorHud.default.IndicatorColor
//whether to use the player's current hud color for this indicator
var bool UseHUDColorForIndicator;

//whether to use a custom color for this indicator
var bool UseCustomColor;

//whether if UseCustomColor is true, the below color is used for the indicator
var Color IndicatorColor;

//show labels that indicate meters to the target
var bool ShowTargetDistanceLabels;

//the TEXT label of the indicator
var string IndicatorLabel;

//whether to show the indicator label
var bool ShowIndicatorLabel;

//whether to use the NAME of the target actor as the label (overrides the text specified above in "IndicatorLabel")
var bool UseTargetNameForLabel;

//whether to scale the indicator size based on the "size" of the actor on screen.
var bool ScaleIndicatorSizeToTarget;

//if ScaleIndicatorSizeToTarget isn't set, then this is taken into account for indicator size
var float StaticIndicatorPercentOfMinScreenDimension;

//if this is > 0, this sets a lower bound for icon size when the TARGET is off-screen, such as for screen edge arrows showing target direction
var float StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen;

//whether we should show the indicator when the TARGET is off screen
var bool ShowIndicatorWhenOffScreen;

//show indicator if the target is hidden
var bool ShowIndicatorIfTargetHidden;

//if target of indicator is an INVENTORY class/subclass, if this is FALSE, indicator is HIDDEN if inventory is considered HELD
var bool ShowIndicatorIfInventoryHeld;

//if target of indicator is an INVENTORY class/subclass, if this is FALSE, indicator is HIDDEN if inventory is considered NOT HELD
var bool ShowIndicatorIfInventoryNotHeld;

//if target of indicator is an INVENTORY class/subclass, if this is FALSE, indicator is HIDDEN if inventory is considered DROPPED (HELD by an actor, and then dropped on the ground -- uses the Mutator "DroppedInventoryMarkerMutator" to tag items dropped by actors)
var bool ShowIndicatorIfInventoryDropped;

//show indicator if the target is behind something else (eg: wall or another actor)
var bool ShowIndicatorsThatAreObscured;

//whether to blink the indicator or not (using the IndicatorHUD's "BlinkRate")
var bool BlinkIndicator;

//the default alpha value for this indicator (IGNORED if "BlinkIndicator" is TRUE)
var float BaseAlphaValue;

//whether to position the indicator above the target actor, based on Actor.CollisionHeight
var bool ShowIndicatorAboveTarget;

//whether to position the text label of the indicator, or the distance label above or below the indicator
var bool IndicatorLabelsAboveIndicator;

DefaultProperties {
    DisableIndicator=false,
    MaxViewDistance=1000.0,
    IndicatorLabelsAboveIndicator=false,
    IndicatorOffsetFromTarget=Vect(0,0,0),
    UseHUDColorForIndicator=false,
    UseCustomColor=false,
    ShowTargetDistanceLabels=false,
    IndicatorColor=(R=255),//red
    IndicatorLabel="",
    ShowIndicatorLabel=false,
    ShowIndicatorAboveTarget=false,
    UseTargetNameForLabel=false,
    ScaleIndicatorSizeToTarget=true,
    StaticIndicatorPercentOfMinScreenDimension=0.05,
    StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen=0.05,
    ShowIndicatorWhenOffScreen=false,
    ShowIndicatorIfTargetHidden=true,
    ShowIndicatorIfInventoryHeld=false,
    ShowIndicatorIfInventoryNotHeld=true,
    ShowIndicatorIfInventoryDropped=true,
    ShowIndicatorsThatAreObscured=true,
    BlinkIndicator=false,
    BaseAlphaValue=1.0,
    BuiltinIndicatorTexture=Empty
}
