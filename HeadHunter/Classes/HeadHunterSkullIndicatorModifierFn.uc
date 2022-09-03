class HeadHunterSkullIndicatorModifierFn extends IndicatorSettingsModifierFn;

function IndicatorSettings ModifierFunc(IndicatorHudTargetListElement indicatorListElement, IndicatorHud indicatorHud) {
   local Actor thisSkull;
   local HeadHunterGameInfo hhGameInfo;

   thisSkull = Actor(indicatorListElement.Value);
   
   if(thisSkull != None){
       hhGameInfo = HeadHunterGameInfo(thisSkull.Level.Game);

       if(hhGameInfo != None){
           if(!thisSkull.bHidden && hhGameInfo.ShowDroppedSkullIndicators){
               indicatorListElement.IndicatorSettings.DisableIndicator = false;
           } else {
               indicatorListElement.IndicatorSettings.DisableIndicator = true;
           }
       }
   }
   return indicatorListElement.IndicatorSettings;
}

defaultproperties {}
