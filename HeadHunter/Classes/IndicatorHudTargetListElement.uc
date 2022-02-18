//-----------------------------------------------------------
// A list element for an indicator hud.
// The ListElment has a value, which in terms of an indicator hud, is a target Actor to have an indicator for.
//-----------------------------------------------------------
class IndicatorHudTargetListElement extends ListElement;

var IndicatorSettings IndicatorSettings;
var IndicatorSettingsModifierFn IndicatorSettingsModifier;

function ApplyModifierFunction(IndicatorHud hud){
    if(IndicatorSettingsModifier != None){
         IndicatorSettings = IndicatorSettingsModifier.ModifierFunc(self, hud);
    }
}

defaultproperties
{
      IndicatorSettings=None
      IndicatorSettingsModifier=None
}
