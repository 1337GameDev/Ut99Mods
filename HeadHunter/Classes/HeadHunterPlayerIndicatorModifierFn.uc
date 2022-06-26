class HeadHunterPlayerIndicatorModifierFn extends IndicatorSettingsModifierFn;

var Pawn Player;

function IndicatorSettings ModifierFunc(IndicatorHudTargetListElement indicatorListElement, IndicatorHud indicatorHud) {
   local HeadHunterGameInfo hhGameInfo;
   local SkullItem existingSkull;
   local int numSkulls;
   local IndicatorTextureVariations texVars;
   //should we show this player? What should be shown?

   if(Player != None){
       hhGameInfo = HeadHunterGameInfo(Player.Level.Game);

       if(hhGameInfo != None){
           existingSkull = SkullItem(Player.FindInventoryType(class'HeadHunter.SkullItem'));

           if(existingSkull != None){
               numSkulls = existingSkull.NumCopies;
           }

           if(!Player.bHidden && hhGameInfo.ShowPlayersWithSkullThreshold && (numSkulls >= hhGameInfo.SkullThresholdToShowPlayers)){
               indicatorListElement.IndicatorSettings.DisableIndicator = false;
           } else {
               indicatorListElement.IndicatorSettings.DisableIndicator = true;
           }

           if(!indicatorListElement.IndicatorSettings.DisableIndicator){
                //if player has more than 0 skulls
                if(numSkulls > 0){
                    texVars = class'LGDUtilities.IndicatorHud'.static.GetTexturesForBuiltInOption(73, 64);//HudIndicator_Skull
                    texVars.BehindViewTex = None;

                    indicatorListElement.IndicatorSettings.TextureVariations = texVars;
                    indicatorListElement.IndicatorSettings.ShowIndicatorLabel = true;
                    indicatorListElement.IndicatorSettings.IndicatorLabel = string(numSkulls);
                } else {
                    texVars = class'LGDUtilities.IndicatorHud'.static.GetTexturesForBuiltInOption(64);//HudIndicator_DownTriangle_Solid
                    texVars.BehindViewTex = None;

                    indicatorListElement.IndicatorSettings.TextureVariations = texVars;
                    indicatorListElement.IndicatorSettings.ShowIndicatorLabel = false;
                    indicatorListElement.IndicatorSettings.IndicatorLabel = "";
                }

           }
       }
   }
   return indicatorListElement.IndicatorSettings;
}

defaultproperties {
      Player=None
}
