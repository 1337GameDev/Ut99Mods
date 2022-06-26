//=============================================================================
// InfectionGameHUD
//=============================================================================
class InfectionGameHUD extends ChallengeTeamHUD;

#exec texture IMPORT NAME=ZombieIcon FILE=Textures\Icons\bio.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

var string HumanText;
var string ZombieText;

simulated function DrawGameSynopsis(Canvas Canvas) {
	local float PlayerStatusHudWidth, TimerXPos, TimerYPos, TimerWidth, TimerPadding;
	local InfectionGameReplicationInfo IRI;
	local PlayerReplicationInfo PRI;
	
	local int HumanTeam, ZombieTeam;
	local float XL, YL;
	
	local string TeamMessage;

	IRI = InfectionGameReplicationInfo(PlayerOwner.GameReplicationInfo);
	if (IRI != None) {
		HumanTeam = IRI.HumanTeam;
		ZombieTeam = IRI.ZombieTeam;
		
		DrawTeam(Canvas, IRI.Teams[HumanTeam]);
		DrawTeam(Canvas, IRI.Teams[ZombieTeam]);
		
		PRI = PawnOwner.PlayerReplicationInfo;
		if(PRI != None) {
			Canvas.Font = MyFonts.GetMediumFont(Canvas.ClipX);
			
			if(PRI.Team == HumanTeam) {
				TeamMessage = HumanText;
				Canvas.DrawColor = class'LGDUtilities.ColorHelper'.default.BlueColor;
			} else if(PRI.Team == ZombieTeam) {
				TeamMessage = ZombieText;
				Canvas.DrawColor = class'LGDUtilities.ColorHelper'.default.GreenColor;
			} else {
				return;
			}
			
			Canvas.StrLen(TeamMessage, XL, YL);
			Canvas.SetPos(Canvas.ClipX/2 - XL/2 - (32 * Scale), Canvas.ClipY - (64 * Scale) - YL );

			Canvas.DrawText(TeamMessage);
		}
		
		TimerPadding = 10;
		PlayerStatusHudWidth = 256;
		TimerWidth = 125;//5 sliced textures -- [0][0][:][0][0]
		
		if(IRI.RemainingTime >= 60){
			 TimerWidth += 20;//add an extra 0 if 60 seconds or more
		}
		TimerWidth *= Scale;
		
		TimerXPos = Canvas.ClipX - (TimerWidth * Scale);
		//position under health value / icon
		TimerYPos = ((128 + TimerPadding) * Scale);
		
		DrawTimeAt(Canvas, TimerXPos, TimerYPos);
	}
}

simulated function DrawTeam(Canvas Canvas, TeamInfo TI) {
	local float XL, YL;
	local InfectionGameReplicationInfo IRI;
	local int ZombieTeam, YOffset;
	
	if ((TI != None) && (TI.Size > 0) ) {
		YOffset = 0;
			
		Canvas.Font = MyFonts.GetHugeFont( Canvas.ClipX );
		Canvas.DrawColor = TeamColor[TI.TeamIndex];
		Canvas.SetPos(Canvas.ClipX - (64 * Scale), Canvas.ClipY - ((YOffset + 128 * TI.TeamIndex) * Scale));
		
		IRI = InfectionGameReplicationInfo(PlayerOwner.GameReplicationInfo);
		if (IRI != None) {
			ZombieTeam = IRI.ZombieTeam;
			
			if(TI.TeamIndex == ZombieTeam) {
				Canvas.DrawColor = class'LGDUtilities.ColorHelper'.default.GreenColor;
				Canvas.DrawIcon(Texture'Infection.Icons.ZombieIcon', Scale / 4);
			} else {
				Canvas.DrawColor = class'LGDUtilities.ColorHelper'.default.BlueColor;
				Canvas.DrawIcon(TeamIcon[TI.TeamIndex], Scale);
			}
		} else {
			Canvas.DrawIcon(TeamIcon[TI.TeamIndex], Scale);
		}
		
		Canvas.StrLen(int(TI.Score), XL, YL);
		Canvas.SetPos(Canvas.ClipX - XL - 66 * Scale, Canvas.ClipY - (YOffset + 128 * TI.TeamIndex) * Scale + ((64 * Scale) - YL)/2 );
		Canvas.DrawText(int(TI.Score), false);
	}
}

simulated function bool DrawIdentifyInfo(canvas Canvas) {
	local float XL, YL;
	local Pawn P;

	if (!Super.DrawIdentifyInfo(Canvas)) {
		return false;
	}
	
	Canvas.StrLen("TEST", XL, YL);
	if(PawnOwner.PlayerReplicationInfo.Team == IdentifyTarget.Team) {
		P = Pawn(IdentifyTarget.Owner);
		
		Canvas.Font = MyFonts.GetSmallFont(Canvas.ClipX);
		if (P != None) {
			DrawTwoColorID(Canvas,IdentifyHealth,string(P.Health), (Canvas.ClipY - 256 * Scale) + 1.5 * YL);
		}
	}
	return true;
}

simulated function DrawTimeAt(Canvas Canvas, float X, float Y) {
    local GameReplicationInfo gameInfo;
    local Color timerColor;

	if (PlayerOwner.GameReplicationInfo == None) {
		return;
    }

    gameInfo = PlayerOwner.GameReplicationInfo;

    if (gameInfo == None) {
		return;
    }

    timerColor = HUDColor;

    class'LGDUtilities.HUDHelper'.static.RenderLEDTimerToHUD(Canvas, X, Y, timerColor, Style, Scale, gameInfo.RemainingTime);
}

defaultproperties {
	HumanText="You are a Human!",
	ZombieText="You are a Zombie!"
}
