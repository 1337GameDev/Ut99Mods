class PlayerDeathLocationMarker extends Actor;

#exec texture Import File=Textures\ActorIcons\DeathLocation.bmp Name=DeathLocation Mips=Off Flags=2

var bool bLogToGameLogfile;

var float KeepForSecondsAfterRespawn;

var float LastTimeChecked;

var int PawnTeam;
var string PawnType;

static function PlayerDeathLocationMarker SpawnAtPlayerLocation(Actor context, Pawn Player) {
    local PlayerDeathLocationMarker marker;
    local PlayerReplicationInfo pri;
    local IndicatorHudTargetListElement listElement;
    local IndicatorSettings settings;
    local PlayerDeathLocationMarkerIndicatorFn fn;

    local IndicatorHud ih;

    marker = context.Spawn(class'PlayerDeathLocationMarker',,, Player.Location);

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
    listElement = new class'IndicatorHudTargetListElement';
    settings = new class'IndicatorSettings';
    settings.UseTargetNameForLabel = false;
    settings.IndicatorLabel = string(Player.Name);
    settings.ShowIndicatorLabel = true;
    settings.ScaleIndicatorSizeToTarget = false;
    settings.UseCustomColor = true;
    settings.ShowTargetDistanceLabels = false;
    settings.MaxViewDistance = -1;
    settings.DisableIndicator = true;//this will be enabled based on the modifier function, based on team and showing neutral indicators
    settings.ShowIndicatorWhenOffScreen = false;
    settings.IndicatorOffsetFromTarget = class'PawnHelper'.static.GetOffsetAbovePawn(Player);

    fn = new class'PlayerDeathLocationMarkerIndicatorFn';
    fn.TargetPRI = pri;

    listElement.Value = marker;
    listElement.IndicatorSettingsModifier = fn;
    listElement.IndicatorSettings = settings;

    ih = class'IndicatorHud'.static.GetCurrentPlayerIndicatorHudInstance(context);
    ih.AddAdvancedTarget(listElement, true);

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
    LastTimeChecked=0.0,
    KeepForSecondsAfterRespawn=10.0;
    bHidden=false,
    DrawType=DT_Sprite,
    Style=STY_Normal,
    Physics=PHYS_None,
    bCollideActors=false,
    RemoteRole=ROLE_SimulatedProxy,
    DrawType=DT_Mesh,
    Texture=Texture'DeathLocation',

    PawnType='Pawn',
    PawnTeam=-1,
    bLogToGameLogfile=false
}
