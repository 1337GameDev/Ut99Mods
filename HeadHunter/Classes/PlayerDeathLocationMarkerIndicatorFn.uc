//-----------------------------------------------------------
//
//-----------------------------------------------------------
class PlayerDeathLocationMarkerIndicatorFn extends IndicatorSettingsModifierFn;

var PlayerReplicationInfo TargetPRI;

var bool ShowAllyIndicators;
var bool ShowEnemyIndicators;
var bool ShowNeutralIndicators;

var Color NeutralColor;
var byte NeutralTexture;
var Color EnemyColor;
var byte EnemyTexture;
var Color AllyColor;
var byte AllyTexture;

function IndicatorSettings ModifierFunc(IndicatorHudTargetListElement indicatorListElement, IndicatorHud indicatorHud) {
    local int HudOwnerTeam;
    local IndicatorSettings settings;

    HudOwnerTeam = -1;
    settings = indicatorListElement.IndicatorSettings;

    if(indicatorHud != None && settings != None){
        settings.DisableIndicator = true;

        if(indicatorHud.PlayerOwner.PlayerReplicationInfo != None){
            HudOwnerTeam = indicatorHud.PlayerOwner.PlayerReplicationInfo.Team;
        }

        if((HudOwnerTeam == -1 || TargetPRI == None) && ShowNeutralIndicators){
            settings.IndicatorColor = NeutralColor;
            settings.BuiltinIndicatorTexture = NeutralTexture;
            settings.DisableIndicator = false;
        } else if(TargetPRI != None) {
            if((HudOwnerTeam == TargetPRI.Team) && ShowAllyIndicators){
                settings.IndicatorColor = AllyColor;
                settings.BuiltinIndicatorTexture = AllyTexture;
                settings.DisableIndicator = false;
            } else if((HudOwnerTeam != TargetPRI.Team) && ShowEnemyIndicators){
                settings.IndicatorColor = EnemyColor;
                settings.BuiltinIndicatorTexture = EnemyTexture;
                settings.DisableIndicator = false;
            }
        }
    }

    return settings;
}

defaultproperties
{
      TargetPRI=None
      ShowAllyIndicators=True
      ShowEnemyIndicators=True
      ShowNeutralIndicators=False
      NeutralColor=(R=255,G=255,B=255,A=0)
      NeutralTexture=17
      EnemyColor=(R=255,G=0,B=0,A=0)
      EnemyTexture=48
      AllyColor=(R=0,G=255,B=0,A=0)
      AllyTexture=48
}
