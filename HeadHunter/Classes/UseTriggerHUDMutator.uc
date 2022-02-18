class UseTriggerHUDMutator extends HUDMutator nousercreate;

//Indicators
#exec texture IMPORT NAME=Ring FILE=Textures\UseTrigger\Ring.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=Ring_B FILE=Textures\UseTrigger\Ring_B.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=SelectionBox FILE=Textures\UseTrigger\SelectionBox.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=SelectionBox2 FILE=Textures\UseTrigger\SelectionBox2.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=Square_Open FILE=Textures\UseTrigger\Square_Open.bmp FLAGS=2 MIPS=OFF

//Icons
#exec texture IMPORT NAME=Lever FILE=Textures\UseTrigger\Lever.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=Hand FILE=Textures\UseTrigger\Hand.bmp FLAGS=2 MIPS=OFF


var bool ScaleIndicatorSizeToTarget;
var float StaticIndicatorPercentOfMinScreenDimension;
var() bool UseHudColorForIndicator;

var FontInfo MyFonts;

var UseTrigger TriggerActor;

var bool ShowIndicatorWhenObscured;
var Vector IndicatorOffsetFromTriggerActor;
var() color IndicatorColor;
var() string UseMessage;
var() bool ShowUseMessage;

var() texture IndicatorTexture;//the normal indicator texture when the use trigger is in view

var() float BaseAlphaValue;

function PreBeginPlay() {
    if(bLogToGameLogfile) {
        Log("UseTriggerHUDMutator: PreBeginPlay");
    }

    MyFonts = class'MyFontsSingleton'.static.GetRef(self);
}

simulated function PostRender(Canvas C) {
    Super.PostRender(C);

    if(PlayerOwner == ChallengeHUD(PlayerOwner.myHUD).PawnOwner) {
        if((TriggerActor != None) && (IndicatorTexture != None)) {
            //draw the player specific indicators
            DrawUseIndicatorLocation(C, PlayerOwner);
        }
    } else if(PlayerOwner == None){
          Destroy();
    }
}

//=============================================================================
// function DrawIndicatorLocations.
//=============================================================================
simulated final function DrawUseIndicatorLocation(Canvas C, PlayerPawn Player) {
    local bool ShowIndicator, targetIsBehind, isOffScreen, AimWithinIndicator;
    local ChallengeHUD PlayerHUD;
    local texture IndicatorTextureToDisplay;
    local int targetScreenXPos, targetScreenYPos, drawAtScreenX, drawAtScreenY, screenMiddleX, screenMiddleY, screenSmallestDimension, screenLargestDimension;

    local float FinalIndicatorScale, PlayerHUDScale, IndicatorWidth, IndicatorHeight, IndicatorXLimitMargin, IndicatorYLimitMargin;

    local Vector targetPos;
    local Color ColorForIndicator;

    local vector CamLoc, camX, camY, camZ;
    local rotator CamRot;
    local Actor Camera;

    local float UseMessageSizeX, UseMessageSizeY;
    local int UseMessageXPos, UseMessageYPos;

    local float targetHudSize;//the original hud size, as well as the intended hud size for an indicator

    local Vector Indicator_TopL, Indicator_TopR, Indicator_BottomL, Indicator_BottomR;

    local WeaponEventListenerWeapon wep;

    if((Player != None) && (TriggerActor != None)){
        PlayerHUD = ChallengeHUD(Player.myHUD);
        C.ViewPort.Actor.PlayerCalcView(Camera, CamLoc, CamRot);
        GetAxes(CamRot, camX, camY, camZ);

        PlayerHUDScale = PlayerHUD.Scale;

        screenMiddleX = C.ClipX / 2.0;
        screenMiddleY = C.ClipY / 2.0;
        screenSmallestDimension = Min(C.ClipX, C.ClipY);
        screenLargestDimension =  Max(C.ClipX, C.ClipY);

        if(TriggerActor.UseHudColorForIndicator) {
            ColorForIndicator = PlayerHUD.HUDColor;
        } else {
            ColorForIndicator = TriggerActor.IndicatorColor;
        }

        if(bLogToGameLogfile){
            Log("TriggerActor is:"@TriggerActor.Name);
        }

        if(!TriggerActor.ShowIndicatorWhenObscured && !FastTrace(PlayerOwner.Location, TriggerActor.Location)){
            //the target is obscured by world geometry, so ignore this target
            return;
        }

        IndicatorTextureToDisplay = IndicatorTexture;
        C.DrawColor = ColorForIndicator;

        targetPos = TriggerActor.Location + TriggerActor.IndicatorOffsetFromTriggerActor;

        class'HUDHelper'.static.getXY(C, targetPos, targetScreenXPos, targetScreenYPos);

        C.Font = MyFonts.GetMediumFont(C.ClipX);
        if((C.Font == None) && (C.LargeFont != None)){
            C.Font = C.LargeFont;
        }

        targetIsBehind = class'VectorHelper'.static.isBehind(CamLoc, camX, targetPos);
        isOffScreen = class'HUDHelper'.static.IsOffScreenNoReturnValues(C, targetScreenXPos, targetScreenYPos, 15);

        ShowIndicator = (!isOffScreen && !targetIsBehind);

        if(bLogToGameLogfile){
            Log("UseTriggerHUDMutator - ShowIndicator:"@ShowIndicator);
            Log("UseTriggerHUDMutator - isOffScreen:"@isOffScreen@" - targetIsBehind:"$targetIsBehind);
        }

        //DONE setting indicator, now can fetch indicator sizes
        IndicatorWidth = IndicatorTextureToDisplay.USize;
        IndicatorHeight = IndicatorTextureToDisplay.VSize;

        if(TriggerActor.ScaleIndicatorSizeToTarget){
            targetHudSize = class'HUDHelper'.static.getActorSizeOnHudFromCollider(C, TriggerActor, false) + 10;
            //ensure size of indicator isn't too large/small on the hud
            //limit that it can't be more less than 10% the smallest screen dimension, and no more than 25% o the screen dimension
            targetHudSize = Clamp(targetHudSize, screenLargestDimension * 0.05, screenLargestDimension * 0.25);
            finalIndicatorScale = class'HUDHelper'.static.getScaleForTextureFromMaxDimension(IndicatorTextureToDisplay, targetHudSize);
        } else {//if we arent scaling indicator based on the target, then use the static scale value
            finalIndicatorScale = class'HUDHelper'.static.getScaleForTextureFromMaxDimension(IndicatorTextureToDisplay, (TriggerActor.StaticIndicatorPercentOfMinScreenDimension / 100.0) * screenSmallestDimension);
        }

        IndicatorXLimitMargin = ((IndicatorWidth/2.0) * finalIndicatorScale);
        IndicatorYLimitMargin = ((IndicatorHeight/2.0) * finalIndicatorScale);

        //if the target is behind, then apply special rules to "glue" the indicator to the side of the screen
        //set the position of the indicator like normal

        drawAtScreenX = Clamp(targetScreenXPos, IndicatorXLimitMargin, C.ClipX-IndicatorXLimitMargin);
        drawAtScreenY = Clamp(targetScreenYPos, IndicatorYLimitMargin, C.ClipY-IndicatorYLimitMargin);

        if(TriggerActor.ShowIndicator) {
            C.DrawColor = ColorForIndicator*BaseAlphaValue;
            C.Style = ERenderStyle.STY_Translucent;

            if(bLogToGameLogfile){
                Log("target indicator rendering with params drawAtScreenX:"@drawAtScreenX@" - drawAtScreenY:"@drawAtScreenY@" - finalIndicatorScale:"@finalIndicatorScale@" - PlayerHUDScale:"@PlayerHUDScale@" - IndicatorTextureToDisplay is None? - "@(IndicatorTextureToDisplay == None)@" - C.Color(R,G,B): ("@C.DrawColor.R@","@C.DrawColor.G@","@C.DrawColor.B@")");
            }
        }
        class'HUDHelper'.static.DrawTextureAtXY_OutputEdgeCordinates(C, IndicatorTextureToDisplay, drawAtScreenX, drawAtScreenY, finalIndicatorScale, PlayerHUDScale, True, False, Indicator_TopL, Indicator_TopR, Indicator_BottomL, Indicator_BottomR, !TriggerActor.ShowIndicator);

        AimWithinIndicator = ((screenMiddleX >= Indicator_TopL.X) && (screenMiddleX <= Indicator_TopR.X))    &&    ((screenMiddleY >= Indicator_TopL.Y) && (screenMiddleY <= Indicator_BottomL.Y));

        if(AimWithinIndicator){
            wep = GiveOwnerHUDWeapon();

            if((PlayerOwner.Weapon != wep) && (PlayerOwner.PendingWeapon != wep)) {
			    Log("UseTriggerHUDMutator - PawnOwner does NOT have the event weapon selected, so select it");
                wep.SelectWeapon();
            }
        } else {
            RemoveHUDWeapon();
        }

		if(TriggerActor.ShowUseMessage){
			C.SetPos(0, 0);
			C.TextSize(TriggerActor.UseMessage, UseMessageSizeX, UseMessageSizeY);
			UseMessageXPos = (Indicator_BottomL.X + Indicator_BottomR.X) * 0.5;
			UseMessageYPos = Indicator_BottomL.Y + UseMessageSizeY;

			C.Style = ERenderStyle.STY_Normal;
			class'HUDHelper'.static.DrawTextAtXY(C, self, TriggerActor.UseMessage, UseMessageXPos, UseMessageYPos, true);
		}
    }
}

static function UseTriggerHUDMutator GetCurrentPlayerUseTriggerHudInstance(Actor context, PlayerPawn pp){
    local Mutator m;
    local UseTriggerHUDMutator hm;

    foreach context.AllActors(class'PlayerPawn', pp) {
       m = class'HUDMutator'.static.GetHUDMutatorFromPlayerPawnByClassName(pp, 'UseTriggerHUDMutator');
       if(m == None){
           continue;
       } else {
           hm = UseTriggerHUDMutator(m);
       }
    }

    return hm;
}

static function UseTriggerHUDMutator SpawnAndRegister(Actor context){
    local UseTriggerHUDMutator hud;
    hud = context.Spawn(class'UseTriggerHUDMutator');
    hud.RegisterThisHUDMutator();
    Log("UseTriggerHUDMutator - SpawnAndRegister");
    return hud;
}

function SetTrigger(UseTrigger trigger) {
    TriggerActor = trigger;
    //set other trigger values
    UseMessage = TriggerActor.Message;
    ShowUseMessage = TriggerActor.ShowUseMessage;
    IndicatorColor = TriggerActor.IndicatorColor;
    IndicatorOffsetFromTriggerActor = TriggerActor.IndicatorOffsetFromTriggerActor;
    ShowIndicatorWhenObscured = TriggerActor.ShowIndicatorWhenObscured;
    UseHudColorForIndicator = TriggerActor.UseHudColorForIndicator;
    StaticIndicatorPercentOfMinScreenDimension = TriggerActor.StaticIndicatorPercentOfMinScreenDimension;
    ScaleIndicatorSizeToTarget = TriggerActor.ScaleIndicatorSizeToTarget;
}

function float GetDistanceToTrigger(UseTrigger trigger){
    local Vector triggerPos;
    triggerPos = trigger.Location + IndicatorOffsetFromTriggerActor;
    return VSize(triggerPos);
}

function bool SetTriggerActorIfClosest(UseTrigger trigger){
     local float triggerPos;
     local float currentTriggerPos;
     local bool triggerChanged;

     if(TriggerActor != None) {
         triggerPos = GetDistanceToTrigger(trigger);
         currentTriggerPos = GetDistanceToTrigger(TriggerActor);

         if(triggerPos < currentTriggerPos) {
             SetTrigger(trigger);
             triggerChanged = true;
         }
     } else {
         SetTrigger(trigger);
         triggerChanged = true;
     }

     return triggerChanged;
}

function RemoveTriggerIfSet(UseTrigger trigger){
     if(TriggerActor == trigger) {
          TriggerActor = None;

     }
}

function WeaponEventListenerWeapon GiveOwnerHUDWeapon(){
    local Inventory inv;
    local WeaponEventListenerWeapon wep;
    local UseTriggerHUDWeaponCallback callback;

    if(PlayerOwner != None){
        inv = PlayerOwner.FindInventoryType(class'WeaponEventListenerWeapon');

        if(inv == None){
            wep = Spawn(class'WeaponEventListenerWeapon');
            callback = new class'UseTriggerHUDWeaponCallback';
            callback.hudMutator = self;
            callback.WeaponInstance = wep;

            wep.SetCallbackForAllEvents(callback);

            wep.GiveTo(PlayerOwner);
        } else {
            wep = WeaponEventListenerWeapon(inv);
        }
    }

    return wep;
}

function RemoveHUDWeapon(){
    local Inventory inv;
    local WeaponEventListenerWeapon wep;

    if(PlayerOwner != None){
        inv = PlayerOwner.FindInventoryType(class'WeaponEventListenerWeapon');

        if(inv != None){
            wep = WeaponEventListenerWeapon(inv);
            wep.Destroy();
        }
    }
}

function ActivateTrigger(Pawn Other){
    if(TriggerActor != None){
        TriggerActor.ActivateTrigger(Other);
    }
}

defaultproperties
{
      ScaleIndicatorSizeToTarget=True
      StaticIndicatorPercentOfMinScreenDimension=0.050000
      UseHudColorForIndicator=True
      MyFonts=None
      TriggerActor=None
      ShowIndicatorWhenObscured=True
      IndicatorOffsetFromTriggerActor=(X=0.000000,Y=0.000000,Z=0.000000)
      IndicatorColor=(R=255,G=186,B=3,A=0)
      UseMessage=""
      ShowUseMessage=True
      IndicatorTexture=Texture'HeadHunter.SelectionBox'
      BaseAlphaValue=1.000000
}
