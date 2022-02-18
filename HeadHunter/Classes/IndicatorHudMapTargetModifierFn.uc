class IndicatorHudMapTargetModifierFn extends IndicatorSettingsModifierFn;

var bool ShowIndicatorToHudOwnerTeamNum;
var byte IndicatorVisibleToTeamNum;

function IndicatorSettings ModifierFunc(IndicatorHudTargetListElement indicatorListElement, IndicatorHud indicatorHud) {
   local IndicatorSettings settings;
   local Actor target;
   local PlayerPawn pp;
   local Bot bot;
   local PlayerReplicationInfo pri;
   local BotReplicationInfo bri;
   local int HudOwnerTeam;

   if(indicatorHud.PlayerOwner.PlayerReplicationInfo != None){
       HudOwnerTeam = indicatorHud.PlayerOwner.PlayerReplicationInfo.Team;
   }

   settings = indicatorListElement.IndicatorSettings;
   target = Actor(indicatorListElement.Value);

   if(target != None){
       pp = PlayerPawn(target);
       bot = Bot(target);

       if(pp != None){
            pri = pp.PlayerReplicationInfo;

       } else if(bot != None){
            bri = BotReplicationInfo(bot.PlayerReplicationInfo);

       }

       settings.DisableIndicator = ShowIndicatorToHudOwnerTeamNum && (HudOwnerTeam != IndicatorVisibleToTeamNum);
   }

   return settings;
}

defaultproperties
{
      ShowIndicatorToHudOwnerTeamNum=False
      IndicatorVisibleToTeamNum=0
}
