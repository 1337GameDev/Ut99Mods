// ============================================================
// KCScoreBoard
// ============================================================
class KCScoreBoard expands TournamentScoreBoard;

var color LightGreenColor, DarkGreenColor;
var Texture DogTagTex;

var string EnemyTagsString;
var string EnemyTagsString2;
var string FriendlyTagsString;
var string FriendlyTagsString2;
var string TagsDroppedString;
var string TagsDroppedString2;

var int NumberColumns;
var float ColumnWidth;

function DrawHeader(Canvas Canvas) {
	local GameReplicationInfo GRI;
	local float XL, YL;
	local font CanvasFont;
	ColumnWidth = Canvas.ClipX / float(NumberColumns);

	Canvas.DrawColor = RedColor;
	GRI = PlayerPawn(Owner).GameReplicationInfo;

	Canvas.Font = MyFonts.GetHugeFont(Canvas.ClipX);

	Canvas.bCenter = True;
	Canvas.StrLen("Test", XL, YL);
	ScoreStart = 58.0/768.0 * Canvas.ClipY;
	CanvasFont = Canvas.Font;

	if ( GRI.GameEndedComments != "") {
		Canvas.DrawColor = GoldColor;
		Canvas.SetPos(0, ScoreStart);
		Canvas.DrawText(GRI.GameEndedComments, True);
	} else {
		Canvas.SetPos(0, ScoreStart);
		DrawVictoryConditions(Canvas);
	}

	Canvas.bCenter = False;
	Canvas.Font = CanvasFont;
}

function DrawVictoryConditions(Canvas Canvas) {
	local TournamentGameReplicationInfo TGRI;
	local float XL, YL, TexScale, XPosToDrawGameName, XPosForDogTag;
	ColumnWidth = Canvas.ClipX / float(NumberColumns);
	
	TGRI = TournamentGameReplicationInfo(PlayerPawn(Owner).GameReplicationInfo);
	if (TGRI == None) {
		return;
	}

    XPosToDrawGameName = Canvas.CurX;
    Canvas.StrLen(TGRI.GameName, XL, YL);
	TexScale = class'LGDUtilities.HudHelper'.static.getScaleForTextureToGetDesiredWidth(DogTagTex, 64.0);
    XPosForDogTag = (Canvas.SizeX / 2.0) - (XL / 2.0) - 64;

    Canvas.SetPos(XPosForDogTag, Canvas.CurY);
    Canvas.DrawColor = RedColor;
    Canvas.DrawIcon(DogTagTex, TexScale);

    Canvas.SetPos(XPosToDrawGameName, Canvas.CurY);
    Canvas.DrawColor = RedColor;
	Canvas.DrawText(TGRI.GameName);

    XPosForDogTag = (Canvas.SizeX / 2.0) + (XL / 2.0);
	Canvas.SetPos(XPosForDogTag, Canvas.CurY - (YL) - 64);
	Canvas.DrawColor = RedColor;
    Canvas.DrawIcon(DogTagTex, TexScale);

	Canvas.SetPos(0, Canvas.CurY - YL);

	Canvas.DrawColor = LightGreenColor;

	if (TGRI.TimeLimit > 0) {
		Canvas.DrawText(TimeLimit@TGRI.TimeLimit$":00");
	}
}

function DrawTrailer(Canvas Canvas ) {
	local int Hours, Minutes, Seconds;
	local float XL, YL, HorizontalPos;
	local PlayerPawn PlayerOwner;
	local string TextToDraw;
	
	ColumnWidth = Canvas.ClipX / float(NumberColumns);
	
	Canvas.bCenter = true;
	Canvas.DrawColor = LightGreenColor;
	PlayerOwner = PlayerPawn(Owner);

	if ((Level.NetMode == NM_Standalone) && Level.Game.IsA('DeathMatchPlus')) {
		if (DeathMatchPlus(Level.Game).bRatedGame) {
			TextToDraw = DeathMatchPlus(Level.Game).RatedGameLadderObj.SkillText@PlayerOwner.GameReplicationInfo.GameName@MapTitle@MapTitleQuote$Level.Title$MapTitleQuote;
		} else if(DeathMatchPlus(Level.Game).bNoviceMode) {
			TextToDraw = class'ChallengeBotInfo'.default.Skills[Level.Game.Difficulty]@PlayerOwner.GameReplicationInfo.GameName@MapTitle@MapTitleQuote$Level.Title$MapTitleQuote;
		} else {
			TextToDraw = class'ChallengeBotInfo'.default.Skills[Level.Game.Difficulty + 4]@PlayerOwner.GameReplicationInfo.GameName@MapTitle@MapTitleQuote$Level.Title$MapTitleQuote;
	    }
    } else {
		TextToDraw = PlayerOwner.GameReplicationInfo.GameName@MapTitle@Level.Title;
    }
	
	Canvas.StrLen(TextToDraw, XL, YL);
	HorizontalPos = ColumnWidth - (XL/2.0);
	Canvas.SetPos(HorizontalPos, Canvas.ClipY - 2 * YL);
	Canvas.DrawText(TextToDraw, true);

	Canvas.SetPos(0, Canvas.ClipY - YL);
	if(bTimeDown || (PlayerOwner.GameReplicationInfo.RemainingTime > 0)) {
		bTimeDown = true;
		if (PlayerOwner.GameReplicationInfo.RemainingTime <= 0) {
			Canvas.DrawText(RemainingTime@"00:00", true);
		} else {
			Minutes = PlayerOwner.GameReplicationInfo.RemainingTime/60;
			Seconds = PlayerOwner.GameReplicationInfo.RemainingTime % 60;
			Canvas.DrawText(RemainingTime@TwoDigitString(Minutes)$":"$TwoDigitString(Seconds), true);
		}
	} else {
		Seconds = PlayerOwner.GameReplicationInfo.ElapsedTime;
		Minutes = Seconds / 60;
		Hours   = Minutes / 60;
		Seconds = Seconds - (Minutes * 60);
		Minutes = Minutes - (Hours * 60);

		Canvas.DrawText(ElapsedTime@TwoDigitString(Hours)$":"$TwoDigitString(Minutes)$":"$TwoDigitString(Seconds), true);
	}

	if (PlayerOwner.GameReplicationInfo.GameEndedComments != "") {
		Canvas.bCenter = true;
		Canvas.StrLen("Test", XL, YL);
		Canvas.SetPos(0, Canvas.ClipY - Min(YL*6, Canvas.ClipY * 0.1));
		Canvas.DrawColor = GreenColor;

		if (Level.NetMode == NM_Standalone) {
			Canvas.DrawText(Ended@Continue, true);
		} else {
			Canvas.DrawText(Ended, true);
		}
	} else if ((PlayerOwner != None) && (PlayerOwner.Health <= 0)) {
		Canvas.bCenter = true;
		Canvas.StrLen("Test", XL, YL);
		Canvas.SetPos(0, Canvas.ClipY - Min(YL*6, Canvas.ClipY * 0.1));
		Canvas.DrawColor = GreenColor;
		Canvas.DrawText(Restart, true);
	}

	Canvas.bCenter = false;
}

function DrawCategoryHeaders(Canvas Canvas) {
	local float VerticalPos, HorizontalPos, HorizontalPosLine2, XL, YL;
	ColumnWidth = Canvas.ClipX / float(NumberColumns);
	
	VerticalPos = Canvas.CurY;
	Canvas.DrawColor = LightGreenColor;
		
	//Player
	Canvas.StrLen(PlayerString, XL, YL);
	HorizontalPos = ColumnWidth;	
	Canvas.SetPos(HorizontalPos - (XL/2.0), VerticalPos);
	Canvas.DrawText(PlayerString);

	//Enemy DogTags Collected
	Canvas.StrLen(EnemyTagsString, XL, YL);
	HorizontalPos += (2*ColumnWidth);
	HorizontalPosLine2 = HorizontalPos;
	
 	Canvas.SetPos(HorizontalPos - (XL/2.0), VerticalPos);
	Canvas.DrawText(EnemyTagsString);
	//line 2
	Canvas.StrLen(EnemyTagsString2, XL, YL);
	
	Canvas.SetPos(HorizontalPosLine2 - (XL/2.0), VerticalPos+YL);
	Canvas.DrawText(EnemyTagsString2);
	
	//Friendly DogTags Collected
	Canvas.StrLen(FriendlyTagsString, XL, YL);
	HorizontalPos += (2*ColumnWidth);
	HorizontalPosLine2 = HorizontalPos;
	
	Canvas.SetPos(HorizontalPos - (XL/2.0), VerticalPos);
	Canvas.DrawText(FriendlyTagsString);
	//line 2
	Canvas.StrLen(FriendlyTagsString2, XL, YL);
	Canvas.SetPos(HorizontalPosLine2 - (XL/2.0), VerticalPos+YL);
	Canvas.DrawText(FriendlyTagsString2);
	
	//Tags Dropped (Deaths)
	Canvas.StrLen(TagsDroppedString, XL, YL);
	HorizontalPos += (2*ColumnWidth);
	HorizontalPosLine2 = HorizontalPos;
	
	Canvas.SetPos(HorizontalPos - (XL/2.0), VerticalPos);
	Canvas.DrawText(TagsDroppedString);
	//line 2
	Canvas.StrLen(TagsDroppedString2, XL, YL);
	Canvas.SetPos(HorizontalPosLine2 - (XL/2.0), VerticalPos+YL);
	Canvas.DrawText(TagsDroppedString2);
}

function DrawNameAndPing(Canvas Canvas, PlayerReplicationInfo PRI, float XOffset, float YOffset, bool bCompressed) {
	local float XL, XL2, XL3, YL, YL2, YL3, HorizontalPos;
	local string TextToDraw;
	
	local bool bLocalPlayer;
	local PlayerPawn PlayerOwner;
	local KillConfirmedGameInfo KCGI;
	local DogTagStatsObj statsObj;
	local int Time;

	ColumnWidth = Canvas.ClipX / float(NumberColumns);
	PlayerOwner = PlayerPawn(Owner);
	KCGI = KillConfirmedGameInfo(PRI.Level.Game);
	bLocalPlayer = (PRI.PlayerName == PlayerOwner.PlayerReplicationInfo.PlayerName);
	Canvas.Font = MyFonts.GetBigFont(Canvas.ClipX);

	// Draw Name
	if (PRI.bAdmin) {
		Canvas.DrawColor = WhiteColor;
	} else if (bLocalPlayer) {
		Canvas.DrawColor = RedColor;
	} else {
		Canvas.DrawColor = BronzeColor;
    }

	HorizontalPos = ColumnWidth;	
	
	//Draw name
	TextToDraw = PRI.PlayerName;
	Canvas.StrLen(TextToDraw, XL, YL);
	
	Canvas.SetPos(HorizontalPos - (XL/2.0), YOffset);
	Canvas.DrawText(TextToDraw, True);
	
	if(KCGI != None) {
		statsObj = KCGI.GetDogTagStatsForPlayer(PRI.PlayerID, True);
	}
	
	if (!bLocalPlayer) {
		Canvas.DrawColor = GoldColor;
    }
	
	//Enemy DogTags Collected
	TextToDraw = "0";
	if(statsObj != None) {
		TextToDraw = string(statsObj.EnemyTagsCollected);
	}
	
	Canvas.StrLen(TextToDraw, XL, YL);
	HorizontalPos += (2*ColumnWidth);	
	Canvas.SetPos(HorizontalPos - (XL/2.0), YOffset);
	Canvas.DrawText(TextToDraw);
	
	//Friendly DogTags Collected
	TextToDraw = "0";
	if(statsObj != None) {
		TextToDraw = string(statsObj.FriendlyTagsCollected);
	}
	
	Canvas.StrLen(TextToDraw, XL, YL);
	HorizontalPos += (2*ColumnWidth);	
	Canvas.SetPos(HorizontalPos - (XL/2.0), YOffset);
	Canvas.DrawText(TextToDraw);
	
	//Tags Dropped (Deaths)
	TextToDraw = "0";
	if(statsObj != None) {
		TextToDraw = string(statsObj.TagsDropped);
	}
	
	Canvas.StrLen(TextToDraw, XL, YL);
	HorizontalPos += (2*ColumnWidth);	
	Canvas.SetPos(HorizontalPos - (XL/2.0), YOffset);
	Canvas.DrawText(TextToDraw);

	if ((Canvas.ClipX > 512) && (Level.NetMode != NM_Standalone)) {
		Canvas.DrawColor = LightGreenColor;
		Canvas.Font = MyFonts.GetSmallestFont(Canvas.ClipX);

		// Draw Time
		Time = Max(1, (Level.TimeSeconds + PlayerOwner.PlayerReplicationInfo.StartTime - PRI.StartTime)/60);
		Canvas.TextSize(TimeString$": 999", XL3, YL3);
		Canvas.SetPos(Canvas.ClipX * 0.75 + XL, YOffset);
		Canvas.DrawText(TimeString$":"@Time, false);

		// Draw FPH
		Canvas.TextSize(FPHString$": 999", XL2, YL2);
		Canvas.SetPos(Canvas.ClipX * 0.75 + XL, YOffset + 0.5 * YL);
		Canvas.DrawText(FPHString$": "@int(60 * PRI.Score/Time), false);

		XL3 = FMax(XL3, XL2);
		// Draw Ping
		Canvas.SetPos(Canvas.ClipX * 0.75 + XL + XL3 + 16, YOffset);
		Canvas.DrawText(PingString$":"@PRI.Ping, false);

		// Draw Packetloss
		Canvas.SetPos(Canvas.ClipX * 0.75 + XL + XL3 + 16, YOffset + 0.5 * YL);
		Canvas.DrawText(LossString$":"@PRI.PacketLoss$"%", false);
	}
}

function SortScores(int N) {
	local int I, J, Max;
	local PlayerReplicationInfo TempPRI;

	for (I=0; I<N-1; I++) {
		Max = I;

		for (J=I+1; J<N; J++) {
			if (Ordered[J].Score > Ordered[Max].Score) {
				Max = J;
			} else if ((Ordered[J].Score == Ordered[Max].Score) && (Ordered[J].Deaths < Ordered[Max].Deaths)) {
				Max = J;
			} else if ((Ordered[J].Score == Ordered[Max].Score) && (Ordered[J].Deaths == Ordered[Max].Deaths) &&
					 (Ordered[J].PlayerID < Ordered[Max].Score)) {
				Max = J;
			}
		}

		TempPRI = Ordered[Max];
		Ordered[Max] = Ordered[I];
		Ordered[I] = TempPRI;
	}
}

function ShowScores(Canvas Canvas) {
	local PlayerReplicationInfo PRI;
	local int PlayerCount, i;
	local float XL, YL;
	local float YOffset, YStart;
	local font CanvasFont;

	Canvas.Style = ERenderStyle.STY_Normal;

	// Header
	Canvas.SetPos(0, 0);
	DrawHeader(Canvas);

	// Wipe everything.
	for (i=0; i<ArrayCount(Ordered); i++) {
		Ordered[i] = None;
	}

    for (i=0; i<32; i++) {
		if (PlayerPawn(Owner).GameReplicationInfo.PRIArray[i] != None) {
			PRI = PlayerPawn(Owner).GameReplicationInfo.PRIArray[i];

			if (!PRI.bIsSpectator || PRI.bWaitingPlayer) {
				Ordered[PlayerCount] = PRI;
				PlayerCount++;

				if (PlayerCount == ArrayCount(Ordered)) {
					break;
				}
			}
		}
	}

	SortScores(PlayerCount);

	CanvasFont = Canvas.Font;
	Canvas.Font = MyFonts.GetBigFont(Canvas.ClipX);

	Canvas.SetPos(0, 160.0/768.0 * Canvas.ClipY);
	DrawCategoryHeaders(Canvas);

	Canvas.StrLen("TEST", XL, YL);
	YStart = Canvas.CurY;
	YOffset = YStart;

	if (PlayerCount > 15) {
		PlayerCount = FMin(PlayerCount, (Canvas.ClipY - YStart)/YL - 1);
    }

	Canvas.SetPos(0, 0);

	for (I=0; I<PlayerCount; I++) {
		YOffset = YStart + I * YL;
		DrawNameAndPing(Canvas, Ordered[I], 0, YOffset, false);
	}

	Canvas.DrawColor = LightGreenColor;
	Canvas.Font = CanvasFont;

	// Trailer
	if (!Level.bLowRes) {
		Canvas.Font = MyFonts.GetSmallFont(Canvas.ClipX);
		DrawTrailer(Canvas);
	}

	Canvas.DrawColor = WhiteColor;
	Canvas.Font = CanvasFont;
}

defaultproperties {
	NumberColumns=8,
    LightGreenColor=(R=0,G=136,B=0,A=0)
    DarkGreenColor=(R=0,G=255,B=128,A=0)
    DogTagTex=Texture'KillConfirmed.DogTagIcon'
    Restart="You have been killed.  Hit [Fire] to respawn!"
    Continue="Hit [Fire] to begin the next match!"
    Ended="The game has ended."
    FragsString=""
    EnemyTagsString="Enemy DogTags"
    EnemyTagsString2="Collected"
    FriendlyTagsString="Friendly DogTags"
    FriendlyTagsString2="Collected"
    TagsDroppedString="DogTags"
    TagsDroppedString2="Dropped"
}
