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
var config int RadarGUICircleOffsetY;//The Y position osset (from the center of the GUI texture) for the center of the radar display

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
           RadarTargets = new class'LinkedList';
           RegisterThisHUDMutator();
           InitiatedPreviously = true;
       }
    }
}

simulated function PostRender(Canvas C) {
    local ChallengeHUD PlayerHUD;
    local float PlayerHUDScale;
    local int PlayerOwnerTeam;
    local Vector RadarHUDPositionCenter;
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

    Super.PostRender(C);

    HalfRadarHudTexHeight = RadarBackgroundTex.VSize / 2.0;
    HalfRadarHudTexWidth = RadarBackgroundTex.USize / 2.0;

    PlayerHUD = ChallengeHUD(PlayerOwner.myHUD);
    PlayerOwnerTeam = -1;
    if(PlayerOwner.PlayerReplicationInfo != None){
        PlayerOwnerTeam = PlayerOwner.PlayerReplicationInfo.TeamID;
    }

    PlayerHUDScale = PlayerHUD.Scale;
    RadarGuiScale = class'HUDHelper'.static.getScaleForTextureToGetDesiredWidth(RadarBackgroundTex, RadarHudGuiWidth);

    C.Style = ERenderStyle.STY_Translucent;
    RadarColor = PlayerHUD.HUDColor;
    RadarCenterDotColor =  class'ColorHelper'.default.BlueColor;

    C.DrawColor = RadarColor * RadarAlpha;

    //get position of target on HUD
    RadarHUDPositionCenter = Vect(0,0,0);
    if(InitiallyPositionAbovePlayerHUDOnLowerLeft){
        RadarHUDPositionCenter.Y = -64 * PlayerHUDScale;//offset vertically upwards by 64 units -- the height of the player frag count HUD element
    }
    RadarHUDPositionCenter.X = RadarHUDPositionCenter.X + (HalfRadarHudTexWidth * RadarGuiScale) + RadarHUDOffsetX;
    RadarHUDPositionCenter.Y = RadarHUDPositionCenter.Y + (C.ClipY + RadarHUDOffsetY) - (HalfRadarHudTexHeight * RadarGuiScale);

    class'HUDHelper'.static.DrawTextureAtXY(C, RadarBackgroundTex, RadarHUDPositionCenter.X, RadarHUDPositionCenter.Y, RadarGuiScale, PlayerHUDScale, True, True);

    RadarBlipScale = class'HUDHelper'.static.getScaleForTextureToGetDesiredWidth(Indicator_SameLevel, RadarBlipSize);
    C.DrawColor = RadarCenterDotColor * RadarAlpha;
    class'HUDHelper'.static.DrawTextureAtXY(C, Indicator_SameLevel, RadarHUDPositionCenter.X+RadarGUICircleOffsetX, RadarHUDPositionCenter.Y+RadarGUICircleOffsetY, RadarBlipScale, PlayerHUDScale, True, True);

    if(RadarTargets.Count > 0) {
        element = RadarTargets.Head;

        While(element != None) {
            IsEnemy = false;
            ShowTarget = true;
            Target = Actor(element.Value);
            RadarBlipColor = class'ColorHelper'.default.GoldColor;

            if(Target != None){
                TargetCrouching = false;
                TargetVelocity = Vect(0,0,0);
                //get target dir from player
                TargetRadarDir = Target.Location - PlayerOwner.Location;
                TargetRadarDistance = VSize(TargetRadarDir);

                if((TargetRadarDistance*class'MathHelper'.default.UnrSizeToMeters) > RadarDistanceMeters){
                    element = element.Next;
                    continue;
                }

                if(Target.IsA('TournamentPlayer')) {
                    tournamentPlayer = TournamentPlayer(Target);
                    TargetCrouching = tournamentPlayer.bIsCrouching;
                    TargetVelocity = tournamentPlayer.Velocity;
                    if(tournamentPlayer.PlayerReplicationInfo != None){
                        IsEnemy = PlayerOwnerTeam != tournamentPlayer.PlayerReplicationInfo.TeamID;
                    }
                } else if(Target.IsA('Bot')){
                    bot = Bot(Target);
                    TargetCrouching = bot.bIsCrouching;
                    TargetVelocity = bot.Velocity;
                    if(bot.PlayerReplicationInfo != None){
                        IsEnemy = PlayerOwnerTeam != bot.PlayerReplicationInfo.TeamID;
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
                    TargetPercentDistance = TargetRadarDistance / (RadarDistanceMeters * class'MathHelper'.default.MetersToUnrSize);
                    TargetRadarDir = Normal(TargetRadarDir);
                    TargetRadarDir.Y *= -1;//reverse direction because of UI having backwards cordinates

                    //rotate the dir according to this player's rotation
                    TargetRadarRotationFromPlayer = PlayerOwner.Rotation;
                    TargetRadarRotationFromPlayer.Pitch = 0;
                    TargetRadarRotationFromPlayer.Roll = 0;
                    TargetRadarRotationFromPlayer.Yaw += (90 * class'MathHelper'.default.DegToUnrRot);

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

                    RadarBlipScale = class'HUDHelper'.static.getScaleForTextureToGetDesiredWidth(TargetRadarTexture, RadarBlipSize);

                    if(ShowAlliesAndEnemiesAsDifferentColors) {
                         if(IsEnemy) {
                             RadarBlipColor = class'ColorHelper'.default.RedColor;
                         } else {
                             RadarBlipColor = class'ColorHelper'.default.GreenColor;
                         }
                    }

                    C.DrawColor = RadarBlipColor * RadarAlpha;
                    class'HUDHelper'.static.DrawTextureAtXY(C, TargetRadarTexture, TargetRadarPos.X, TargetRadarPos.Y, RadarBlipScale, PlayerHUDScale, True, True);
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
        RadarTargets = new class'LinkedList';
    }
}

function GetTargets() {
    local ListElement listElement;
    local TournamentPlayer tournamentPlayer;
    local Bot bot;

    if(RadarTargets == None){
        RadarTargets = new class'LinkedList';
    }

    //loop through every player
    ForEach RadiusActors(class'TournamentPlayer', tournamentPlayer, (RadarDistanceMeters * class'MathHelper'.default.MetersToUnrSize), PlayerOwner.Location) {
        if(tournamentPlayer == PlayerOwner) {
            continue;
        }

        listElement = new class'ListElement';
        listElement.Value = tournamentPlayer;
        RadarTargets.Push(listElement);
    }


    //loop through each bot
    ForEach RadiusActors(class'Bot', bot, (RadarDistanceMeters * class'MathHelper'.default.MetersToUnrSize), PlayerOwner.Location) {
        listElement = new class'ListElement';
        listElement.Value = bot;

        RadarTargets.Push(listElement);
    }
}

defaultproperties {
   bLogToGameLogfile=false,
   TimeIntervalToCheck=0.25,
   LastTimeChecked=0.0,
   RadarDistanceMeters=30,
   RadarAlpha=0.4,
   RadarCenterDotColor=Color(B=255);
   RadarBlipSize=15,
   ShowAlliesAndEnemiesAsDifferentColors=true,
   IndicateTargetOnDifferentLevel=false,

   InitiallyPositionAbovePlayerHUDOnLowerLeft=true,
   RadarHUDOffsetX=0,
   RadarHUDOffsetY=0,
   RadarBackgroundTex=Texture'RadarHudBackground',
   Indicator_SameLevel=Texture'RadarIcon_SameLevel',
   Indicator_DiffLevel=Texture'RadarIcon_DiffLevel',

   RadarHudGuiWidth=150,
   RadarGUICircleRadius=110,
   RadarGUICircleOffsetX=0,
   RadarGUICircleOffsetY=0,
   RadarVelocityThreshold=200,
   ShowTargetsIfBelowVelocityThreshold=false,
   ShowTargetsIfCrouching=false,
   RadarSameLevelThreshold=83//a minimum recommended height for ceilings
}
