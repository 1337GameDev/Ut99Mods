//=============================================================================
// HeadHunterHUD
//=============================================================================
class HeadHunterHUD extends ChallengeHUD;
var color SkullIconColor;

simulated function DrawFragCount(Canvas C){
    local float PlayerStatusHudWidth, TimerXPos, SkullIconScale, SkullIconXPos, TimerWidth, TimerPadding;
    local byte PrevRenderStyle;
    local Color PrevDrawColor;
    local HeadHunterGameReplicationInfo gameInfo;

	if (PlayerOwner.GameReplicationInfo == None) {
		return;
    }

    gameInfo = HeadHunterGameReplicationInfo(PlayerOwner.GameReplicationInfo);

    if (gameInfo == None) {
		return;
    }

    SkullIconScale = 2.0 * Scale;
    TimerPadding = 5;
    PlayerStatusHudWidth = 256;
    TimerWidth = 125;//5 sliced textures -- [0][0][:][0][0]
    if(gameInfo.SkullCollectTimeInterval >= 600){
         TimerWidth += 25;//add an extra 0
    }
	TimerWidth *= Scale;

    TimerXPos = C.ClipX - ((PlayerStatusHudWidth + TimerWidth + (2*TimerPadding)) * Scale);

	DrawTimeAt(C, TimerXPos, 25);

    PrevRenderStyle = C.Style;
    PrevDrawColor = C.DrawColor;

    C.Style = ERenderStyle.STY_Translucent;
    C.DrawColor = SkullIconColor;

    SkullIconXPos = TimerXPos - (32*SkullIconScale) - TimerPadding;
    //if(gameInfo.SkullsCollectedCountdown >= 600){
    //     SkullIconXPos -= 25;
    //}

    C.SetPos(SkullIconXPos, 16);
    C.DrawIcon(Texture'UnrealShare.Icons.ICONSKULL', SkullIconScale);

    C.Style = PrevRenderStyle;
    C.DrawColor = PrevDrawColor;

	Super.DrawFragCount(C);
}

simulated function DrawGameSynopsis(Canvas Canvas) {
}

simulated function DrawTimeAt(Canvas Canvas, float X, float Y) {
    local HeadHunterGameReplicationInfo gameInfo;
    local Color timerColor;

	if (PlayerOwner.GameReplicationInfo == None) {
		return;
    }

    gameInfo = HeadHunterGameReplicationInfo(PlayerOwner.GameReplicationInfo);

    if (gameInfo == None) {
		return;
    }

    timerColor = HUDColor;

    class'LGDUtilities.HUDHelper'.static.RenderLEDTimerToHUD(Canvas, X, Y, timerColor, Style, Scale, gameInfo.SkullsCollectedCountdown);
}

defaultproperties {
      SkullIconColor=(R=255,G=186,B=3,A=0)
}
