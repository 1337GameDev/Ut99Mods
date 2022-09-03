class PlayerDeathLocationMarker extends Actor;

#exec texture Import File=Textures\ActorIcons\DeathLocation.bmp Name=DeathLocation Mips=Off Flags=2

var bool bLogToGameLogfile;

var float KeepForSecondsAfterRespawn;

var float LastTimeChecked;

var int PawnTeam;
var string PawnType;

static function PlayerDeathLocationMarker SpawnAtPlayerLocation(Actor context, Pawn Player, optional PlayerDeathLocationMarkerIndicatorFn fn) {
    local PlayerDeathLocationMarker marker;
    local PlayerReplicationInfo pri;
    local IndicatorHudTargetListElement listElement;
    local IndicatorSettings settings;

    local IndicatorHud ih;

    marker = context.Spawn(class'LGDUtilities.PlayerDeathLocationMarker',,, Player.Location);

    if(Player.IsA('Bot')){
        pri = (Bot(Player)).PlayerReplicationInfo;
        marker.PawnType = "Bot";
    } else if(Player.IsA('TournamentPlayer')){
        pri = (TournamentPlayer(Player)).PlayerReplicationInfo;
        marker.PawnType = "TournamentPlayer";
    }

    if(default.bLogToGameLogfile) {
        Log("PlayerDeathLocationMarker: Spawned");
    }

    //register globally with indicator hud
    listElement = new class'LGDUtilities.IndicatorHudTargetListElement';
	listElement.IndicatorSource = class'LGDUtilities.PlayerDeathLocationMarker';
    settings = new class'LGDUtilities.IndicatorSettings';
    settings.UseTargetNameForLabel = false;
    settings.IndicatorLabel = string(Player.Name);
    settings.ShowIndicatorLabel = true;
    settings.ScaleIndicatorSizeToTarget = false;
    settings.UseCustomColor = true;
    settings.ShowTargetDistanceLabels = false;
    settings.MaxViewDistance = -1;
    settings.DisableIndicator = true;//this will be enabled based on the modifier function, based on team and showing neutral indicators
    settings.ShowIndicatorWhenOffScreen = false;
    settings.IndicatorOffsetFromTarget = class'LGDUtilities.PawnHelper'.static.GetOffsetAbovePawn(Player);

    if(fn == None) {
      fn = new class'LGDUtilities.PlayerDeathLocationMarkerIndicatorFn';
    }
    fn.TargetPRI = pri;

    listElement.Value = marker;
    listElement.IndicatorSettingsModifier = fn;
    listElement.IndicatorSettings = settings;

    ih = class'LGDUtilities.IndicatorHud'.static.GetCurrentPlayerIndicatorHudInstance(context);
    ih.AddAdvancedTarget(listElement, true, false, true);

    return marker;
}

simulated function Tick(float DeltaTime) {
    LastTimeChecked += DeltaTime;

    if(LastTimeChecked >= KeepForSecondsAfterRespawn){
        if(bLogToGameLogfile) {
            Log("PlayerDeathLocationMarker: Time Elapsed:"$LastTimeChecked$" -- Destroy - KeepForSecondsAfterRespawn:"$KeepForSecondsAfterRespawn);
        }
        Destroy();
    }
}

defaultproperties {
      bLogToGameLogfile=False
      KeepForSecondsAfterRespawn=10.000000
      LastTimeChecked=0.000000
      PawnTeam=-1
      PawnType="'"
      RemoteRole=ROLE_SimulatedProxy
      DrawType=DT_Mesh
      Texture=Texture'LGDUtilities.DeathLocation'
}
