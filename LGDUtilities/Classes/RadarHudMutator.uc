class RadarHudMutator extends HUDMutator config;
//Acquired some data for Actor sizes from: https://wiki.beyondunreal.com/Legacy:General_Scale_And_Dimensions#Actor_Dimensions

#exec texture IMPORT NAME=RadarHudBackground FILE=Textures\Radar\RadarHudBackground.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=RadarIcon_SameLevel FILE=Textures\Radar\RadarIcon_SameLevel.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=RadarIcon_DiffLevel FILE=Textures\Radar\RadarIcon_DiffLevel.bmp FLAGS=2 MIPS=OFF

var bool InitiatedPreviously;
var float LastTimeChecked;
var float TimeIntervalToCheck;

var config float RadarDistanceMeters;
var config float RadarAlpha;
var config Color RadarCenterDotColor;
var config float RadarGUICircleRadius;//the radius of the radar display on the HUD (in pixels)
var config int RadarGUICircleOffsetX;//The X position offset (from the center of the GUI texture) for the center of the radar display
var config int RadarGUICircleOffsetY;//The Y position offset (from the center of the GUI texture) for the center of the radar display

var config int RadarBlipSize;
var config bool ShowAlliesAndEnemiesAsDifferentColors;

var config int RadarHudGuiWidth;

var LinkedList RadarTargets;

var config bool InitiallyPositionAbovePlayerHUDOnLowerLeft;
var config float RadarHUDOffsetX;//the offset horizontally for the Radar position on the HUD (from the standard lower left placement)
var config float RadarHudOffsetY;//the offset vertically for the Radar position on the HUD (from the standard lower left placement)

var Texture RadarBackgroundTex;
var Texture Indicator_SameLevel;
var Texture Indicator_DiffLevel;

var config float RadarVelocityThreshold;//A player moves a max of 120units when crouching, and 400 running
var config float RadarSameLevelThreshold;//character height in ut99 is 78 units, and can jump 64->72 units
var config bool ShowTargetsIfBelowVelocityThreshold;
var config bool ShowTargetsIfCrouching;
var config bool IndicateTargetOnDifferentLevel;

simulated function ModifyPlayer(Pawn Other) {
    Super.ModifyPlayer(Other);

    if (Other.IsA('TournamentPlayer') && (Other.PlayerReplicationInfo != None) ) {
       //ensure player has been set up with the proper targets
       if(!InitiatedPreviously) {
           RadarTargets = new class'LGDUtilities.LinkedList';
           RegisterThisHUDMutator();
           InitiatedPreviously = true;
       }
    }
}

simulated function PostRender(Canvas C) {
    local ChallengeHUD PlayerHUD;
    local float PlayerHUDScale;
    local int PlayerOwnerTeam;
    local Vector RadarHUDPositionCenter, RadarHUDPositionTopLeft;
	
	//extra coordinate for prediction of the rendering of the radar on the HUD
	local Vector RadarHUDPositionBottomRight;
	local float RadarHalfHeight;
	
    local color RadarColor, RadarBlipColor;
    local float RadarGuiScale;

    local ListElement element;
    local Actor Target;
    local bool TargetCrouching;
    local Vector TargetVelocity;
    local bool OnSameLevel;
    local Texture TargetRadarTexture;
    local float RadarBlipScale;
    local bool IsEnemy;
    local bool ShowTarget;

    local TournamentPlayer tournamentPlayer;
    local Bot bot;

    local Vector TargetRadarPos, TargetRadarDir;
    local float TargetRadarDistance;//the distance the target is to the PlayerOwner

    local Rotator TargetRadarRotationFromPlayer;//A rotation to apply to the target dir, to translate it to UI x/y

    local float TargetPercentDistance;//the % of the max distance this target is from the player who owns this mutator

    local float HalfRadarHudTexHeight, HalfRadarHudTexWidth;

	//detect problem cases of overlap with standard UI
	local bool IsOverlappingAnotherElement;
	
	//AssaultHUD
	local bool IsAssault;
	local float AssaultTimerX, AssaultTimerY;
	local Vector AssaultTimerTopLeft, AssaultTimerBottomRight;
	
	//DeathMatchPlus
	local bool IsDeathmatch;
	local float DMSpreadX, DMSpreadY, SpreadTextXL, SpreadTextYL;
	local Vector DMSpreadTopLeft, DMSpreadBottomRight;
	local Font PrevCanvasFont;
	
    Super.PostRender(C);

    HalfRadarHudTexHeight = RadarBackgroundTex.VSize / 2.0;
    HalfRadarHudTexWidth = RadarBackgroundTex.USize / 2.0;

    PlayerHUD = ChallengeHUD(PlayerOwner.myHUD);
    PlayerOwnerTeam = -1;
	
    if(PlayerOwner.PlayerReplicationInfo != None){
        PlayerOwnerTeam = PlayerOwner.PlayerReplicationInfo.Team;
    }

    PlayerHUDScale = PlayerHUD.Scale;
    RadarGuiScale = class'LGDUtilities.HUDHelper'.static.getScaleForTextureToGetDesiredWidth(RadarBackgroundTex, RadarHudGuiWidth);
	
	RadarHalfHeight = (HalfRadarHudTexWidth * RadarGuiScale * PlayerHUDScale);
	
    RadarColor = PlayerHUD.HUDColor;
    RadarCenterDotColor =  class'ColorHelper'.default.BlueColor;

	//get values for UI overlp issues
	IsAssault = (Level.Game.Class == class'Botpack.Assault');
	IsDeathmatch = (Level.Game.Class == class'Botpack.DeathMatchPlus');
	
	if(IsAssault) {
		AssaultTimerX = 2;
		
		//Copied from AssaultHUD.uc - DrawFragCount()
		if (PlayerHUD.bHideAllWeapons  || ((PlayerHUD.HudScale * PlayerHUD.WeaponScale * C.ClipX) <= (C.ClipX - 256 * PlayerHUD.Scale))){
			AssaultTimerY = C.ClipY - (128 * PlayerHUD.Scale);
		} else {
			AssaultTimerY = C.ClipY - (192 * PlayerHUD.Scale);
		}
		
		AssaultTimerTopLeft.X = AssaultTimerX;
		AssaultTimerTopLeft.Y = AssaultTimerY;
		
		AssaultTimerBottomRight.X = ((25 * 5) + 20) * PlayerHUD.Scale;
		AssaultTimerBottomRight.Y = AssaultTimerTopLeft.Y + (32 * PlayerHUD.Scale);
		
	} else if(IsDeathmatch) {
		PrevCanvasFont = C.Font;
		C.StrLen("TEST", SpreadTextXL, SpreadTextYL);
		DMSpreadX = SpreadTextXL;
		
		//Copied from ChallengeHUD.uc - DrawGameSynopsis()
		if (PlayerHUD.bHideAllWeapons) {
			DMSpreadY = C.ClipY - (SpreadTextYL*2);
		} else if ((PlayerHUD.HudScale * PlayerHUD.WeaponScale * C.ClipX) <= (C.ClipX - 255 * PlayerHUD.Scale)) {
			DMSpreadY = C.ClipY - (64*PlayerHUD.Scale) - (SpreadTextYL*2);
		} else {
			DMSpreadY = C.ClipY - (128*PlayerHUD.Scale) - (SpreadTextYL*2);
		}
				
		DMSpreadTopLeft.X = 0;
		DMSpreadTopLeft.Y = DMSpreadY;
		
		DMSpreadBottomRight.X = DMSpreadTopLeft.X + SpreadTextXL;
		DMSpreadBottomRight.Y = DMSpreadTopLeft.Y + SpreadTextYL;
	}

    //get position of target on HUD
    RadarHUDPositionCenter = Vect(0,0,0);
	
    if(InitiallyPositionAbovePlayerHUDOnLowerLeft) {
        RadarHUDPositionCenter.Y = -64 * PlayerHUDScale;//offset vertically upwards by 128 units -- the height of the player frag count HUD element
    }	
	
    RadarHUDPositionCenter.X = RadarHUDPositionCenter.X + RadarHalfHeight + RadarHUDOffsetX;
    RadarHUDPositionCenter.Y = RadarHUDPositionCenter.Y + (C.ClipY + RadarHUDOffsetY) - RadarHalfHeight;
	
	RadarHUDPositionTopLeft.X = RadarHUDPositionCenter.X - RadarHalfHeight;
	RadarHUDPositionTopLeft.Y = RadarHUDPositionCenter.Y - RadarHalfHeight;
	
	RadarHUDPositionBottomRight.X = RadarHUDPositionCenter.X + RadarHalfHeight;
	RadarHUDPositionBottomRight.Y = RadarHUDPositionCenter.Y + RadarHalfHeight;
	
	C.Style = ERenderStyle.STY_Normal;
	C.Font = PlayerHUD.MyFonts.GetBigFont(C.ClipX);
	C.DrawColor = class'ColorHelper'.default.GreenColor;
		
	if(IsAssault) {			
		IsOverlappingAnotherElement = class'LGDUtilities.HUDHelper'.static.HUDCanvasRectanglesOverlap(C, AssaultTimerTopLeft,AssaultTimerBottomRight, RadarHUDPositionTopLeft,RadarHUDPositionBottomRight);		
		
		if(IsOverlappingAnotherElement) {
			//move radar ABOVE assault timer
			RadarHUDPositionCenter.Y -= (C.ClipY - AssaultTimerY);
			
			if(InitiallyPositionAbovePlayerHUDOnLowerLeft) {
				RadarHUDPositionCenter.Y += (64*PlayerHUD.Scale);
			}
		}
	} else if(IsDeathmatch) {		
		IsOverlappingAnotherElement = class'LGDUtilities.HUDHelper'.static.HUDCanvasRectanglesOverlap(C, DMSpreadTopLeft,DMSpreadBottomRight, RadarHUDPositionTopLeft,RadarHUDPositionBottomRight);
		
		if(IsOverlappingAnotherElement) {
			//move radar to the ABOVE of the spread text info
			RadarHUDPositionCenter.Y -= (C.ClipY - DMSpreadY);
			
			if(InitiallyPositionAbovePlayerHUDOnLowerLeft) {
				RadarHUDPositionCenter.Y += (64*PlayerHUD.Scale);
			}
		}
		
	}

	C.Style = ERenderStyle.STY_Translucent;
    C.DrawColor = RadarColor * RadarAlpha;
	
    class'LGDUtilities.HUDHelper'.static.DrawTextureAtXY(C, RadarBackgroundTex, RadarHUDPositionCenter.X, RadarHUDPositionCenter.Y, RadarGuiScale, PlayerHUDScale, True, False);

    RadarBlipScale = class'LGDUtilities.HUDHelper'.static.getScaleForTextureToGetDesiredWidth(Indicator_SameLevel, RadarBlipSize);
    
	C.DrawColor = RadarCenterDotColor * RadarAlpha;
    
	class'LGDUtilities.HUDHelper'.static.DrawTextureAtXY(C, Indicator_SameLevel, RadarHUDPositionCenter.X+RadarGUICircleOffsetX, RadarHUDPositionCenter.Y+RadarGUICircleOffsetY, RadarBlipScale, PlayerHUDScale, True, False);

    if(RadarTargets.Count > 0) {
        element = RadarTargets.Head;

        While(element != None) {
            IsEnemy = false;
            ShowTarget = true;
            Target = Actor(element.Value);
            RadarBlipColor = class'LGDUtilities.ColorHelper'.default.GoldColor;

            if(Target != None){
                TargetCrouching = false;
                TargetVelocity = Vect(0,0,0);
                //get target dir from player
                TargetRadarDir = Target.Location - PlayerOwner.Location;
                TargetRadarDistance = VSize(TargetRadarDir);

                if((TargetRadarDistance*class'LGDUtilities.MathHelper'.default.UnrSizeToMeters) > RadarDistanceMeters){
                    element = element.Next;
                    continue;
                }

                if(Target.IsA('TournamentPlayer')) {
                    tournamentPlayer = TournamentPlayer(Target);
                    TargetCrouching = tournamentPlayer.bIsCrouching;
                    TargetVelocity = tournamentPlayer.Velocity;
                    if(tournamentPlayer.PlayerReplicationInfo != None){
                        IsEnemy = (PlayerOwnerTeam != tournamentPlayer.PlayerReplicationInfo.Team) || (tournamentPlayer.PlayerReplicationInfo.Team == 255);
                    }
                } else if(Target.IsA('Bot')){
                    bot = Bot(Target);
                    TargetCrouching = bot.bIsCrouching;
                    TargetVelocity = bot.Velocity;
                    if(bot.PlayerReplicationInfo != None){
                        IsEnemy = (PlayerOwnerTeam != bot.PlayerReplicationInfo.Team) || (bot.PlayerReplicationInfo.Team == 255);
                    }
                } else {
                    TargetCrouching = false;
                    TargetVelocity = Vect(1,1,1) * RadarVelocityThreshold;//ensure the target is assume to be going fast enough
                }

                //should we show this target on the radar?
                ShowTarget = (ShowTargetsIfBelowVelocityThreshold || (VSize(TargetVelocity) >= RadarVelocityThreshold)) && (ShowTargetsIfCrouching || !TargetCrouching);

                if(ShowTarget){
                    OnSameLevel = !IndicateTargetOnDifferentLevel || Abs(TargetRadarDir.Z) <= RadarSameLevelThreshold;

                    //get percentage distance of target VS radar max
                    TargetPercentDistance = TargetRadarDistance / (RadarDistanceMeters * class'LGDUtilities.MathHelper'.default.MetersToUnrSize);
                    TargetRadarDir = Normal(TargetRadarDir);
                    TargetRadarDir.Y *= -1;//reverse direction because of UI having backwards cordinates

                    //rotate the dir according to this player's rotation
                    TargetRadarRotationFromPlayer = PlayerOwner.Rotation;
                    TargetRadarRotationFromPlayer.Pitch = 0;
                    TargetRadarRotationFromPlayer.Roll = 0;
                    TargetRadarRotationFromPlayer.Yaw += (90 * class'LGDUtilities.MathHelper'.default.DegToUnrRot);

                    TargetRadarDir = TargetRadarDir >> TargetRadarRotationFromPlayer;

                    //get new vector to show radar position of target
                    TargetRadarPos = RadarGUICircleRadius * TargetPercentDistance * RadarGuiScale * TargetRadarDir;
                    TargetRadarPos.X = RadarHUDPositionCenter.X + TargetRadarPos.X + RadarGUICircleOffsetX;
                    TargetRadarPos.Y = RadarHUDPositionCenter.Y - TargetRadarPos.Y + RadarGUICircleOffsetY;

                    if(OnSameLevel){
                        TargetRadarTexture = Indicator_SameLevel;
                    } else {
                        TargetRadarTexture = Indicator_DiffLevel;
                    }

                    RadarBlipScale = class'LGDUtilities.HUDHelper'.static.getScaleForTextureToGetDesiredWidth(TargetRadarTexture, RadarBlipSize);

                    if(ShowAlliesAndEnemiesAsDifferentColors) {
                         if(IsEnemy) {
                             RadarBlipColor = class'LGDUtilities.ColorHelper'.default.RedColor;
                         } else {
                             RadarBlipColor = class'LGDUtilities.ColorHelper'.default.GreenColor;
                         }
                    }

                    C.DrawColor = RadarBlipColor * RadarAlpha;
                    class'LGDUtilities.HUDHelper'.static.DrawTextureAtXY(C, TargetRadarTexture, TargetRadarPos.X, TargetRadarPos.Y, RadarBlipScale, PlayerHUDScale, True, True);
                }
            }//target is None check

            element = element.Next;
        }
    }
}

simulated function Tick(float DeltaTime) {
    LastTimeChecked += DeltaTime;

    if(LastTimeChecked >= TimeIntervalToCheck){
        LastTimeChecked = 0.0;

        //execute check to ensure targets are still valid
        if(InitiatedPreviously){
            ResetAllTargets();
            GetTargets();
        }
    }
}

function ResetAllTargets(){
    if(RadarTargets != None){
        RadarTargets.RemoveAll();
    } else {
        RadarTargets = new class'LGDUtilities.LinkedList';
    }
}

function GetTargets() {
    local ListElement listElement;
    local TournamentPlayer tournamentPlayer;
    local Bot bot;

    if(RadarTargets == None){
        RadarTargets = new class'LGDUtilities.LinkedList';
    }

    //loop through every player
    ForEach RadiusActors(class'TournamentPlayer', tournamentPlayer, (RadarDistanceMeters * class'LGDUtilities.MathHelper'.default.MetersToUnrSize), PlayerOwner.Location) {
        if(tournamentPlayer == PlayerOwner) {
            continue;
        }

        listElement = new class'LGDUtilities.ListElement';
        listElement.Value = tournamentPlayer;
        RadarTargets.Push(listElement);
    }


    //loop through each bot
    ForEach RadiusActors(class'Bot', bot, (RadarDistanceMeters * class'LGDUtilities.MathHelper'.default.MetersToUnrSize), PlayerOwner.Location) {
        listElement = new class'LGDUtilities.ListElement';
        listElement.Value = bot;

        RadarTargets.Push(listElement);
    }
}

defaultproperties {
      InitiatedPreviously=False
      LastTimeChecked=0.000000
      TimeIntervalToCheck=0.250000
      RadarDistanceMeters=30.000000
      RadarAlpha=0.400000
      RadarCenterDotColor=(R=0,G=0,B=0,A=0)
      RadarGUICircleRadius=110.000000
      RadarGUICircleOffsetX=0
      RadarGUICircleOffsetY=0
      RadarBlipSize=15
      ShowAlliesAndEnemiesAsDifferentColors=True
      RadarHudGuiWidth=150
      RadarTargets=None
      InitiallyPositionAbovePlayerHUDOnLowerLeft=True
      RadarHUDOffsetX=0.000000
      RadarHudOffsetY=0.000000
      RadarBackgroundTex=Texture'LGDUtilities.RadarHudBackground'
      Indicator_SameLevel=Texture'LGDUtilities.RadarIcon_SameLevel'
      Indicator_DiffLevel=Texture'LGDUtilities.RadarIcon_DiffLevel'
      RadarVelocityThreshold=200.000000
      RadarSameLevelThreshold=83.000000
      ShowTargetsIfBelowVelocityThreshold=False
      ShowTargetsIfCrouching=False
      IndicateTargetOnDifferentLevel=True
}
