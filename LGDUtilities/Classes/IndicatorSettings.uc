//-----------------------------------------------------------
// Settings to use for the indicator hud for a target.
// Meant to make settings more "portable"
//-----------------------------------------------------------
class IndicatorSettings extends Object;

//if the existing target for this indicator should be replaced
var bool ReplaceExisting;

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

//the maximum pixel size of the indicator target when scaling for a target
var float ScaleIndicatorMaxPixelSize;

//the maximum size of the indicator as a percentage of the LARGEST screen dimension
var float ScaleIndicatorMaxSizePercentOfScreenLargestDimension;//maximum 25% of largest screen dimension

//the minimum size of the indicator as a percentage of the LARGEST screen dimension
var float ScaleIndicatorMinSizePercentOfScreenLargestDimension;//minimum 5% of largest screen dimension

//the maximum size of the indicator as a percentage of the SMALLEST screen dimension
var float ScaleIndicatorMaxSizePercentOfScreenSmallestDimension;

//the minimum size of the indicator as a percentage of the SMALLEST screen dimension
var float ScaleIndicatorMinSizePercentOfScreenSmallestDimension;

//the maximum size of the indicator as a percentage of the HORIZONTAL screen dimension
var float ScaleIndicatorMaxSizePercentOfScreenHorizontalDimension;//maximum 25% of horizontal screen dimension

//the minimum size of the indicator as a percentage of the HORIZONTAL screen dimension
var float ScaleIndicatorMinSizePercentOfScreenHorizontalDimension;//minimum 5% of horizontal screen dimension

//the maximum size of the indicator as a percentage of the VERTICAL screen dimension
var float ScaleIndicatorMaxSizePercentOfScreenVerticalDimension;//maximum 100% of vertical screen dimension

//the minimum size of the indicator as a percentage of the VERTICAL screen dimension
var float ScaleIndicatorMinSizePercentOfScreenVerticalDimension;//maximum 0% of vertical screen dimension

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

defaultproperties {
      ReplaceExisting=False,
      TextureVariations=None
      BuiltinIndicatorTexture=0
      DisableIndicator=False
      MaxViewDistance=1000.000000
      IndicatorOffsetFromTarget=(X=0.000000,Y=0.000000,Z=0.000000)
      UseHudColorForIndicator=False
      UseCustomColor=False
      IndicatorColor=(R=255,G=0,B=0,A=0)
      ShowTargetDistanceLabels=False
      IndicatorLabel=""
      ShowIndicatorLabel=False
      UseTargetNameForLabel=False
      ScaleIndicatorSizeToTarget=True,
	  ScaleIndicatorMaxPixelSize=256,
	  ScaleIndicatorMaxSizePercentOfScreenLargestDimension=0.25,//maximum 25% of largest screen dimension
	  ScaleIndicatorMinSizePercentOfScreenLargestDimension=0.02,//minimum 5% of largest screen dimension
	  ScaleIndicatorMaxSizePercentOfScreenSmallestDimension=1.0,//maximum 100% of smallest screen dimension
	  ScaleIndicatorMinSizePercentOfScreenSmallestDimension=0.0,//maximum 0% of smallest screen dimension
	  
	  ScaleIndicatorMaxSizePercentOfScreenHorizontalDimension=0.25,//maximum 25% of horizontal screen dimension
	  ScaleIndicatorMinSizePercentOfScreenHorizontalDimension=0.02,//minimum 5% of horizontal screen dimension
	  ScaleIndicatorMaxSizePercentOfScreenVerticalDimension=1.0,//maximum 100% of vertical screen dimension
	  ScaleIndicatorMinSizePercentOfScreenVerticalDimension=0.0,//maximum 0% of vertical screen dimension
	  
      StaticIndicatorPercentOfMinScreenDimension=0.050000//5% of smallest screen dimension
      StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen=0.050000//5% of smallest screen dimension (when off screen)
      ShowIndicatorWhenOffScreen=False
      ShowIndicatorIfTargetHidden=True
      ShowIndicatorIfInventoryHeld=False
      ShowIndicatorIfInventoryNotHeld=False
      ShowIndicatorIfInventoryDropped=False
      ShowIndicatorsThatAreObscured=True
      BlinkIndicator=False
      BaseAlphaValue=1.000000
	  
      ShowIndicatorAboveTarget=False
      IndicatorLabelsAboveIndicator=False
}
