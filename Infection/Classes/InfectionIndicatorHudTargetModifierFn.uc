class InfectionIndicatorHudTargetModifierFn extends IndicatorSettingsModifierFn;

function IndicatorSettings ModifierFunc(IndicatorHudTargetListElement indicatorListElement, IndicatorHud indicatorHud) {
   local IndicatorSettings settings;
   local Actor target;
   local PlayerPawn pp;
   local Bot bot;
   local PlayerReplicationInfo pri;
   local BotReplicationInfo bri;
   local int HudOwnerTeam, TargetTeam;
   
   local InfectionGameInfo igi;

   if(indicatorHud.PlayerOwner.PlayerReplicationInfo != None) {
       HudOwnerTeam = indicatorHud.PlayerOwner.PlayerReplicationInfo.Team;
   }
   
   igi = InfectionGameInfo(indicatorHud.Level.Game);

   settings = indicatorListElement.IndicatorSettings;
   target = Actor(indicatorListElement.Value);
      
   if((target != None) && (igi != None)) {
       pp = PlayerPawn(target);
       bot = Bot(target);

       if(pp != None){
            pri = pp.PlayerReplicationInfo;
			TargetTeam = pri.Team;
       } else if(bot != None){
            bri = BotReplicationInfo(bot.PlayerReplicationInfo);
			TargetTeam = bri.Team;
       }
	   	   
       //if diff teams
	   if(TargetTeam != HudOwnerTeam) {
		   settings.IndicatorColor = class'LGDUtilities.ColorHelper'.default.RedColor;
		   
	       if(HudOwnerTeam == igi.ZombieTeam) {
				settings.DisableIndicator = !((TargetTeam == igi.HumanTeam) && igi.ShowHumanIndicators);
		   } else if(HudOwnerTeam == igi.HumanTeam) {
				settings.DisableIndicator = !((TargetTeam == igi.ZombieTeam) && igi.ShowZombieIndicators);
		   }
	   } else if(igi.ShowSameTeamIndicators) {
		   settings.DisableIndicator = false;
		   settings.IndicatorColor = class'LGDUtilities.ColorHelper'.default.GreenColor;
	   } else {
	       settings.DisableIndicator = true;
	   }
   }
	
   return settings;
}

defaultproperties {}
