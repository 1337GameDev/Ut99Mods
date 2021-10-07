//-----------------------------------------------------------
// Settings to use for the inditaor hud for a target.
// Meant to make settings more "portable"
//-----------------------------------------------------------
class IndicatorSettings extends Object;

var IndicatorTextureVariations TextureVariations;

var byte BuiltinIndicatorTexture;//IndicatorHud.HUDIndicator_Texture_BuiltIn

var bool DisableIndicator;
var float MaxViewDistance;
var Vector IndicatorOffsetFromTarget;
var bool UseHUDColorForIndicator;
var bool UseCustomColor;
var Color IndicatorColor;
var bool ShowTargetDistanceLabels;
var string IndicatorLabel;
var bool ShowIndicatorLabel;
var bool UseTargetNameForLabel;
var bool ScaleIndicatorSizeToTarget;
var float StaticIndicatorPercentOfMinScreenDimension;
var bool ShowIndicatorWhenOffScreen;
var bool ShowIndicatorIfTargetHidden;
var bool ShowIndicatorIfInventoryHeld;
var bool ShowIndicatorIfInventoryNotHeld;
var bool ShowIndicatorIfInventoryDropped;
var bool ShowIndicatorsThatAreObscured;
var bool BlinkIndicator;
var float BaseAlphaValue;
var bool ShowIndicatorAboveTarget;

DefaultProperties {
    DisableIndicator=false,
    MaxViewDistance=1000.0,
    IndicatorOffsetFromTarget=Vect(0,0,0),
    UseHUDColorForIndicator=false,
    UseCustomColor=false,
    ShowTargetDistanceLabels=true,
    IndicatorColor=(R=255),//red
    IndicatorLabel="",
    ShowIndicatorLabel=false,
    ShowIndicatorAboveTarget=false,
    UseTargetNameForLabel=false,
    ScaleIndicatorSizeToTarget=true,
    StaticIndicatorPercentOfMinScreenDimension=0.05,
    ShowIndicatorWhenOffScreen=true,
    ShowIndicatorIfTargetHidden=true,
    ShowIndicatorIfInventoryHeld=false,
    ShowIndicatorIfInventoryNotHeld=true,
    ShowIndicatorIfInventoryDropped=true,
    ShowIndicatorsThatAreObscured=true,
    BlinkIndicator=false,
    BaseAlphaValue=1.0,
    BuiltinIndicatorTexture=Empty
}
