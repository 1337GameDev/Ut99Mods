//-----------------------------------------------------------
// A list element for an indicator hud.
// The ListElment has a value, which in terms of an indicator hud, is a target Actor to have an indicator for.
//-----------------------------------------------------------
class IndicatorHudTargetListElement extends ListElement;

//the origin object used to add the target to have an indicator
//used to identify "groups" of objects added to have indicators
//can be used to get all objects added with a source, or remove all objects of a given source, etc
//can be ANY object, actor, etc
var Object IndicatorSource;

var IndicatorSettings IndicatorSettings;
var IndicatorSettingsModifierFn IndicatorSettingsModifier;

function ApplyModifierFunction(IndicatorHud hud){
    if(IndicatorSettingsModifier != None){
         IndicatorSettings = IndicatorSettingsModifier.ModifierFunc(self, hud);
    }
}

defaultproperties {
      IndicatorSettings=None
      IndicatorSettingsModifier=None
}
