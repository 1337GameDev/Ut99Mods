class LookTriggerHUDMutator extends HUDMutator nousercreate;

//Indicators
#exec texture IMPORT NAME=Ring FILE=Textures\UseTrigger\Ring.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=Ring_B FILE=Textures\UseTrigger\Ring_B.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=SelectionBox FILE=Textures\UseTrigger\SelectionBox.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=SelectionBox2 FILE=Textures\UseTrigger\SelectionBox2.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=Square_Open FILE=Textures\UseTrigger\Square_Open.bmp FLAGS=2 MIPS=OFF

//Icons
#exec texture IMPORT NAME=Lever FILE=Textures\UseTrigger\Lever.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=Hand FILE=Textures\UseTrigger\Hand.bmp FLAGS=2 MIPS=OFF

var FontInfo MyFonts;

var LookTrigger TriggerActor;

var() texture IndicatorTexture;//the normal indicator texture when the use trigger is in view

var bool IsLookingAtTarget;
var float LookTime;

function PreBeginPlay() {
    if(bLogToGameLogfile) {
        Log("LookTriggerHUDMutator: PreBeginPlay");
    }

    MyFonts = class'LGDUtilities.MyFontsSingleton'.static.GetRef(self);
}

simulated function PostRender(Canvas C) {
    Super.PostRender(C);

    if(PlayerOwner == ChallengeHUD(PlayerOwner.myHUD).PawnOwner) {
        if((TriggerActor != None) && (IndicatorTexture != None)) {
            //draw the player specific indicators
            DrawLookIndicatorLocation(C, PlayerOwner);
        }
    } else if(PlayerOwner == None){
          Destroy();
    }
}

//=============================================================================
// function DrawIndicatorLocations.
//=============================================================================
simulated final function DrawLookIndicatorLocation(Canvas C, PlayerPawn Player) {
    local bool ShowIndicator, targetIsBehind, isOffScreen;
    local ChallengeHUD PlayerHUD;
    local texture IndicatorTextureToDisplay;
    local int targetScreenXPos, targetScreenYPos, drawAtScreenX, drawAtScreenY, screenMiddleX, screenMiddleY, screenSmallestDimension, screenLargestDimension;
    local Vector screenMiddlePos;

    local float FinalIndicatorScale, PlayerHUDScale, IndicatorWidth, IndicatorHeight, IndicatorXLimitMargin, IndicatorYLimitMargin;

    local Vector targetPos;
    local Color ColorForIndicator;

    local vector CamLoc, camX, camY, camZ;
    local rotator CamRot;
    local Actor Camera;

    local float LookMessageSizeX, LookMessageSizeY;
    local int LookMessageXPos, LookMessageYPos;

    local string TimeLookedAtMessage;

    local float targetHudSize;//the original hud size, as well as the intended hud size for an indicator

    local Vector Indicator_TopL, Indicator_TopR, Indicator_BottomL, Indicator_BottomR, Indicator_Center;
    local int Indicator_CenterX, Indicator_CenterY;

    if((Player != None) && (TriggerActor != None)){
        PlayerHUD = ChallengeHUD(Player.myHUD);
        C.ViewPort.Actor.PlayerCalcView(Camera, CamLoc, CamRot);
        GetAxes(CamRot, camX, camY, camZ);

        PlayerHUDScale = PlayerHUD.Scale;

        screenMiddleX = C.ClipX / 2.0;
        screenMiddleY = C.ClipY / 2.0;
        screenMiddlePos = Vect(0,0,0);
        screenMiddlePos.X = screenMiddleX;
        screenMiddlePos.Y = screenMiddleY;

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

        class'LGDUtilities.HUDHelper'.static.getXY(C, targetPos, targetScreenXPos, targetScreenYPos);

        C.Font = MyFonts.GetMediumFont(C.ClipX);
        if((C.Font == None) && (C.LargeFont != None)){
            C.Font = C.LargeFont;
        }

        targetIsBehind = class'LGDUtilities.VectorHelper'.static.isBehind(CamLoc, camX, targetPos);
        isOffScreen = class'LGDUtilities.HUDHelper'.static.IsOffScreenNoReturnValues(C, targetScreenXPos, targetScreenYPos, 15);

        ShowIndicator = (!isOffScreen && !targetIsBehind);

        if(bLogToGameLogfile){
            Log("LookTriggerHUDMutator - ShowIndicator:"@ShowIndicator);
            Log("LookTriggerHUDMutator - isOffScreen:"@isOffScreen@" - targetIsBehind:"$targetIsBehind);
        }

        //DONE setting indicator, now can fetch indicator sizes
        IndicatorWidth = IndicatorTextureToDisplay.USize;
        IndicatorHeight = IndicatorTextureToDisplay.VSize;

        if(TriggerActor.ScaleIndicatorSizeToTarget){
            targetHudSize = class'LGDUtilities.HUDHelper'.static.getActorSizeOnHudFromCollider(C, TriggerActor, false, false) + 10;
            
			//ensure size of indicator isn't too large/small on the hud
            //limit that it can't be more less than 10% the smallest screen dimension, and no more than 25% o the screen dimension
            targetHudSize = Clamp(targetHudSize, screenLargestDimension * 0.05, screenLargestDimension * 0.25);
			
            finalIndicatorScale = class'LGDUtilities.HUDHelper'.static.getScaleForTextureFromMaxTextureDimension(IndicatorTextureToDisplay, targetHudSize);
        } else {//if we arent scaling indicator based on the target, then use the static scale value
            finalIndicatorScale = class'LGDUtilities.HUDHelper'.static.getScaleForTextureFromMaxTextureDimension(IndicatorTextureToDisplay, (TriggerActor.StaticIndicatorPercentOfMinScreenDimension / 100.0) * screenSmallestDimension);
        }

        IndicatorXLimitMargin = ((IndicatorWidth/2.0) * finalIndicatorScale);
        IndicatorYLimitMargin = ((IndicatorHeight/2.0) * finalIndicatorScale);

        //if the target is behind, then apply special rules to "glue" the indicator to the side of the screen
        //set the position of the indicator like normal

        drawAtScreenX = Clamp(targetScreenXPos, IndicatorXLimitMargin, C.ClipX-IndicatorXLimitMargin);
        drawAtScreenY = Clamp(targetScreenYPos, IndicatorYLimitMargin, C.ClipY-IndicatorYLimitMargin);

        if(ShowIndicator) {
            C.DrawColor = ColorForIndicator*TriggerActor.BaseAlphaValue;

            C.Style = ERenderStyle.STY_Translucent;
            if(bLogToGameLogfile){
                Log("target indicator rendering with params drawAtScreenX:"@drawAtScreenX@" - drawAtScreenY:"@drawAtScreenY@" - finalIndicatorScale:"@finalIndicatorScale@" - PlayerHUDScale:"@PlayerHUDScale@" - IndicatorTextureToDisplay is None? - "@(IndicatorTextureToDisplay == None)@" - C.Color(R,G,B): ("@C.DrawColor.R@","@C.DrawColor.G@","@C.DrawColor.B@")");
            }

            class'LGDUtilities.HUDHelper'.static.DrawTextureAtXY_OutputEdgeCordinates(C, IndicatorTextureToDisplay, drawAtScreenX, drawAtScreenY, finalIndicatorScale, PlayerHUDScale, True, False, Indicator_TopL, Indicator_TopR, Indicator_BottomL, Indicator_BottomR);
            Indicator_CenterX = int((Indicator_TopL.X+Indicator_TopR.X)/2.0);
            Indicator_CenterY = int((Indicator_TopL.Y+Indicator_BottomL.Y)/2.0);
            Indicator_Center = Vect(0,0,0);
            Indicator_Center.X = Indicator_CenterX;
            Indicator_Center.Y = Indicator_CenterY;
            class'LGDUtilities.HUDHelper'.static.DrawTextAtXY(C, self, "X", Indicator_CenterX, Indicator_CenterY, true);

            //show the "target" to look at in the screen center
            if(TriggerActor.ShowTargetLookCircle){
                class'LGDUtilities.HUDHelper'.static.DrawCircleMidScreenWithWidth(self, C, TriggerActor.TargetLookCircleWidth, PlayerHUDScale);
            }

            if(VSize(screenMiddlePos - Indicator_Center) > ((TriggerActor.TargetLookCircleWidth*PlayerHUDScale))) {//diff between center of screen and center of indicator, outside circle dimensions
                //add 1, to give a margin of error
                IsLookingAtTarget = false;
                LookTime = 0;
            } else {
                IsLookingAtTarget = true;
            }

            //if we can activate this trigger, OR we cant AND it's set to show messages after it's been activated
            if(TriggerActor.CanActivateTrigger() || (!TriggerActor.CanActivateTrigger() && TriggerActor.ShowMessagesAfterActivated)){
                if(TriggerActor.CanActivateTrigger()){
                    LookMessageXPos = (Indicator_BottomL.X + Indicator_BottomR.X) * 0.5;
					
                    if(TriggerActor.ShowLookMessage){
					    C.SetPos(0,0);
				  	    C.TextSize(TriggerActor.LookMessage, LookMessageSizeX, LookMessageSizeY);
					    LookMessageYPos = Indicator_BottomL.Y+LookMessageSizeY;
					    C.Style = ERenderStyle.STY_Normal;
					    class'LGDUtilities.HUDHelper'.static.DrawTextAtXY(C, self, TriggerActor.LookMessage, LookMessageXPos, LookMessageYPos, true);
				    } else {
					    LookMessageYPos = Indicator_BottomL.Y;
				    }

                    //show normal countdown message text
                    if(TriggerActor.ShowTimeLookedAt){
						if(TriggerActor.ShowTimeRemaining) {
							if(TriggerActor.ShowTimeCountingDown){
								TimeLookedAtMessage = (TriggerActor.LookTimeToTrigger - LookTime)$" Secs Remaining";
							} else {
								TimeLookedAtMessage = LookTime$"/"$TriggerActor.LookTimeToTrigger$" Secs";
							}
						} else {
							TimeLookedAtMessage = LookTime$" secs";
						}

						class'LGDUtilities.HUDHelper'.static.DrawTextAtXY(C, self, TimeLookedAtMessage, LookMessageXPos, LookMessageYPos+LookMessageSizeY+10, true);
					}
                } else {//cannot activate trigger
                    LookMessageXPos = (Indicator_BottomL.X + Indicator_BottomR.X) * 0.5;
					
                    if(TriggerActor.ShowRetriggerCooldownMessage){
                        C.SetPos(0,0);
					    C.TextSize(TriggerActor.RetriggerCooldownMessage, LookMessageSizeX, LookMessageSizeY);
					    LookMessageYPos = Indicator_BottomL.Y+LookMessageSizeY;
					    C.Style = ERenderStyle.STY_Normal;
					    class'LGDUtilities.HUDHelper'.static.DrawTextAtXY(C, self, TriggerActor.RetriggerCooldownMessage, LookMessageXPos, LookMessageYPos, true);
                    } else {
					    LookMessageYPos = Indicator_BottomL.Y;
                    }

                    TimeLookedAtMessage = "";
					
                    if(TriggerActor.ShowCooldownTime){
                       TimeLookedAtMessage = (Level.TimeSeconds-TriggerActor.TriggerTime)$"/"$TriggerActor.ReTriggerDelay$" Secs";
                    } else if(TriggerActor.ShowCooldownTimeRemaining && (TriggerActor.ReTriggerDelay > 0)){
                       TimeLookedAtMessage = (TriggerActor.ReTriggerDelay - (Level.TimeSeconds-TriggerActor.TriggerTime))$" Secs To Reactivate";
                    }

                    if(TimeLookedAtMessage != ""){
                        class'LGDUtilities.HUDHelper'.static.DrawTextAtXY(C, self, TimeLookedAtMessage, LookMessageXPos, LookMessageYPos+LookMessageSizeY+10, true);
                    }
                }//end of block for not being able to activate trigger
            }//end of check to display messages
        }//end of block for showing indicators
    }//player and trigger NOT empty
}

function Tick(float DeltaTime) {
    if(IsLookingAtTarget){
       LookTime += DeltaTime;

       if(TriggerActor != None) {
           if(LookTime >= TriggerActor.LookTimeToTrigger) {
              //trigger
              TriggerActor.ActivateTrigger(PlayerOwner);
              LookTime = 0;
           }
       }
    }
}

static function LookTriggerHUDMutator GetCurrentPlayerLookTriggerHudInstance(Actor context, PlayerPawn pp){
    local Mutator m;
    local LookTriggerHUDMutator hm;

    foreach context.AllActors(class'PlayerPawn', pp) {
       m = class'LGDUtilities.HUDMutator'.static.GetHUDMutatorFromPlayerPawnByClassName(pp, 'LookTriggerHUDMutator');
       if(m == None){
           continue;
       } else {
           hm = LookTriggerHUDMutator(m);
       }
    }

    return hm;
}

static function LookTriggerHUDMutator SpawnAndRegister(Actor context){
    local LookTriggerHUDMutator hud;
    hud = context.Spawn(class'LGDUtilities.LookTriggerHUDMutator');
    hud.RegisterThisHUDMutator();
    return hud;
}

function SetTrigger(LookTrigger trigger) {
    TriggerActor = trigger;

    if(trigger == None){
        //any special logic here
    }
}

//used to compare the positions of the current LookTrigger and a new possible one
function float GetDistanceToTrigger(LookTrigger trigger, PlayerPawn p){
    local Vector triggerPos;
    if(trigger == None){
        return 0;
    } else {
        triggerPos = TriggerActor.Location;
    }

    return VSize(triggerPos - p.Location);
}

function bool SetTriggerActorIfClosest(LookTrigger trigger, PlayerPawn p){
     local float triggerPos;
     local float currentTriggerPos;
     local bool triggerChanged;

     if(TriggerActor != None) {
         triggerPos = GetDistanceToTrigger(trigger, p);
         currentTriggerPos = GetDistanceToTrigger(TriggerActor, p);

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

function RemoveTriggerIfSet(LookTrigger trigger){
     if(TriggerActor == trigger) {
          TriggerActor = None;
     }
}

function Mutate(string MutateString, PlayerPawn Sender) {
    if (MutateString ~= "Grab") {
        Log("LookTriggerHUDMutator - Pressed: Grab");
    }

    Log("LookTriggerHUDMutator - Mutate:"$MutateString);

    if(NextMutator != None) {
        NextMutator.Mutate(MutateString, Sender);
    }
}

defaultproperties {
      MyFonts=None
      TriggerActor=None
      IndicatorTexture=Texture'LGDUtilities.SelectionBox'
      IsLookingAtTarget=False
      LookTime=0.000000
}
