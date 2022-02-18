class JuggernautPlayerIndicatorModifierFn extends IndicatorSettingsModifierFn;

var Pawn Player;

function IndicatorSettings ModifierFunc(IndicatorHudTargetListElement indicatorListElement, IndicatorHud indicatorHud) {
   local JuggernautGameInfo jugGameInfo;
   local JuggernautGameInfoReplicationInfo jugGameRepInfo;
   //local IndicatorTextureVariations texVars;
   
   //should we show this player?

   if(Player != None) {
       indicatorListElement.IndicatorSettings.DisableIndicator = true;
	   jugGameInfo = JuggernautGameInfo(Player.Level.Game);
       jugGameRepInfo = jugGameInfo.JugRepInfo;

       if((jugGameRepInfo != None) && (Player.PlayerReplicationInfo != None)) {
           if(!Player.bHidden && jugGameRepInfo.ShowJuggernautIndicator && (jugGameRepInfo.CurrentJuggernautPlayerID == Player.PlayerReplicationInfo.PlayerID)) {
               indicatorListElement.IndicatorSettings.DisableIndicator = false;
           } else {
               indicatorListElement.IndicatorSettings.DisableIndicator = true;
           }
       }
   }
   return indicatorListElement.IndicatorSettings;
}

defaultproperties
{
      Player=None
}
