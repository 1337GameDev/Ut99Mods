//=============================================================================
// JuggernautHUD
//=============================================================================
class JuggernautHUD extends ChallengeHUD;

var string YouAreTheJuggernautText;
var string NoJuggernaut;

simulated function DrawFragCount(Canvas C) {
    local JuggernautGameInfoReplicationInfo gameInfo;

	if (PlayerOwner.GameReplicationInfo == None) {
		return;
    }

    gameInfo = JuggernautGameInfoReplicationInfo(PlayerOwner.GameReplicationInfo);

    if (gameInfo == None) {
		return;
    }

	WriteCurrentJuggernautMessage(C, gameInfo, PlayerOwner.PlayerReplicationInfo);

	Super.DrawFragCount(C);
}

simulated function DrawGameSynopsis(Canvas Canvas) {
}

simulated function WriteCurrentJuggernautMessage(Canvas Canvas, JuggernautGameInfoReplicationInfo JugGameInfo, PlayerReplicationInfo PRI) {
	local float XL, YL;

    if(JugGameInfo.CurrentJuggernautPlayerID == PRI.PlayerID) {
	    Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);

	    Canvas.DrawColor = class'ColorHelper'.default.RedColor;
	    Canvas.StrLen(YouAreTheJuggernautText, XL, YL);
	    Canvas.SetPos(Canvas.ClipX/2 - XL/2 - 32, Canvas.ClipY - 106);

	    Canvas.DrawText(YouAreTheJuggernautText);
	} else if (JugGameInfo.CurrentJuggernautPlayerID == -1){
	    Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);

	    Canvas.DrawColor = class'ColorHelper'.default.RedColor;
	    Canvas.StrLen(NoJuggernaut, XL, YL);
	    Canvas.SetPos(Canvas.ClipX/2 - XL/2, YL);

	    Canvas.DrawText(NoJuggernaut);
	}
}

defaultproperties
{
      YouAreTheJuggernautText="You are the Juggernaut!"
      NoJuggernaut="No Juggernaut was chosen! Please restart the match!"
}
