class WaitTriggerHUDMutator extends HUDMutator nousercreate;

var FontInfo MyFonts;

var WaitTrigger TriggerActor;

var float WaitTime;

function PreBeginPlay() {
    if(bLogToGameLogfile) {
        Log("WaitTriggerHUDMutator: PreBeginPlay");
    }

    MyFonts = class'MyFontsSingleton'.static.GetRef(self);
}

simulated function PostRender(Canvas C) {
    Super.PostRender(C);

    if(PlayerOwner == ChallengeHUD(PlayerOwner.myHUD).PawnOwner) {
        if((TriggerActor != None)) {
            //draw the player specific indicators
            DrawWaitMessages(C, PlayerOwner);
        }
    } else if(PlayerOwner == None){
          Destroy();
    }
}

//=============================================================================
// function DrawIndicatorLocations.
//=============================================================================
simulated final function DrawWaitMessages(Canvas C, PlayerPawn Player) {
    local ChallengeHUD PlayerHUD;
    local int screenMiddleX, screenMiddleY;
    local Vector screenMiddlePos;

    local float PlayerHUDScale;
    local string TimeWaitedAtMessage;
    local float WaitMessageSizeX, WaitMessageSizeY;
    local int WaitMessageXPos, WaitMessageYPos;

    if((Player != None) && (TriggerActor != None)){
        PlayerHUD = ChallengeHUD(Player.myHUD);
        //C.ViewPort.Actor.PlayerCalcView(Camera, CamLoc, CamRot);
        //GetAxes(CamRot, camX, camY, camZ);

        PlayerHUDScale = PlayerHUD.Scale;

        screenMiddleX = C.SizeX / 2.0;
        screenMiddleY = C.SizeY / 2.0;
        screenMiddlePos = Vect(0,0,0);
        screenMiddlePos.X = screenMiddleX;
        screenMiddlePos.Y = screenMiddleY;

        if(bLogToGameLogfile){
            Log("TriggerActor is:"@TriggerActor.Name);
        }

        C.DrawColor = class'ColorHelper'.default.WhiteColor;

        C.Font = MyFonts.GetMediumFont(C.ClipX);
        if((C.Font == None) && (C.LargeFont != None)){
            C.Font = C.LargeFont;
        }

		//if we can activate this trigger, OR we cant AND it's set to show messages after it's been activated
		if(TriggerActor.CanActivateTrigger() || (!TriggerActor.CanActivateTrigger() && TriggerActor.ShowMessagesAfterActivated)){
			if(TriggerActor.CanActivateTrigger()){
				WaitMessageXPos = screenMiddleX;
				WaitMessageYPos = screenMiddleY;

				if(TriggerActor.ShowWaitMessage){
					C.SetPos(0,0);
					C.TextSize(TriggerActor.WaitMessage, WaitMessageSizeX, WaitMessageSizeY);
					WaitMessageYPos = screenMiddleY+(WaitMessageSizeY*0.5);
					C.Style = ERenderStyle.STY_Normal;
					class'HUDHelper'.static.DrawTextAtXY(C, self, TriggerActor.WaitMessage, WaitMessageXPos, WaitMessageYPos, true);
				}

				//show normal countdown message text
				if(TriggerActor.ShowTimeWaitedAt){
					if(TriggerActor.ShowTimeRemaining) {
						if(TriggerActor.ShowTimeCountingDown){
							TimeWaitedAtMessage = (TriggerActor.TimeToTrigger - WaitTime)$" Secs Remaining";
						} else {
							TimeWaitedAtMessage = WaitTime$"/"$TriggerActor.TimeToTrigger$" Secs";
						}
					} else {
						TimeWaitedAtMessage = WaitTime$" secs";
					}

					class'HUDHelper'.static.DrawTextAtXY(C, self, TimeWaitedAtMessage, WaitMessageXPos, WaitMessageYPos+WaitMessageSizeY+10, true);
				}
			} else {//cannot activate trigger
				WaitMessageXPos = screenMiddleX;
				WaitMessageYPos = screenMiddleY;

				if(TriggerActor.ShowRetriggerCooldownMessage){
					C.SetPos(0,0);
					C.TextSize(TriggerActor.RetriggerCooldownMessage, WaitMessageSizeX, WaitMessageSizeY);
					WaitMessageYPos = WaitMessageYPos+(WaitMessageSizeY*0.5);
					C.Style = ERenderStyle.STY_Normal;
					class'HUDHelper'.static.DrawTextAtXY(C, self, TriggerActor.RetriggerCooldownMessage, WaitMessageXPos, WaitMessageYPos, true);
				}

				TimeWaitedAtMessage = "";
				if(TriggerActor.ShowCooldownTime){
				   TimeWaitedAtMessage = (Level.TimeSeconds-TriggerActor.TriggerTime)$"/"$TriggerActor.ReTriggerDelay$" Secs";
				} else if(TriggerActor.ShowCooldownTimeRemaining && (TriggerActor.ReTriggerDelay > 0)){
				   TimeWaitedAtMessage = (TriggerActor.ReTriggerDelay - (Level.TimeSeconds-TriggerActor.TriggerTime))$" Secs To Reactivate";
				}

				if(TimeWaitedAtMessage != ""){
					class'HUDHelper'.static.DrawTextAtXY(C, self, TimeWaitedAtMessage, WaitMessageXPos, WaitMessageYPos+WaitMessageSizeY+10, true);
				}
			}//end of block for not being able to activate trigger
		}//end of check to display messages
    }//player and trigger NOT empty
}

function Tick(float DeltaTime) {
       WaitTime += DeltaTime;

       if(TriggerActor != None) {
           if(WaitTime >= TriggerActor.TimeToTrigger) {
              //trigger
              TriggerActor.ActivateTrigger(PlayerOwner);
              WaitTime = 0;
           }
       }
}

static function WaitTriggerHUDMutator GetCurrentPlayerWaitTriggerHudInstance(Actor context, PlayerPawn pp){
    local Mutator m;
    local WaitTriggerHUDMutator hm;

    foreach context.AllActors(class'PlayerPawn', pp) {
       m = class'HUDMutator'.static.GetHUDMutatorFromPlayerPawnByClassName(pp, 'WaitTriggerHUDMutator');
       if(m == None){
           continue;
       } else {
           hm = WaitTriggerHUDMutator(m);
       }
    }

    return hm;
}

static function WaitTriggerHUDMutator SpawnAndRegister(Actor context){
    local WaitTriggerHUDMutator hud;
    hud = context.Spawn(class'WaitTriggerHUDMutator');
    hud.RegisterThisHUDMutator();
    return hud;
}

function SetTrigger(WaitTrigger trigger) {
    TriggerActor = trigger;

    if(trigger == None){
        //any special logic here
    }
}

//used to compare the positions of the current LookTrigger and a new possible one
function float GetDistanceToTrigger(WaitTrigger trigger, PlayerPawn p){
    local Vector triggerPos;
    if(trigger == None){
        return 0;
    } else {
        triggerPos = TriggerActor.Location;
    }

    return VSize(triggerPos - p.Location);
}

function bool SetTriggerActorIfClosest(WaitTrigger trigger, PlayerPawn p){
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

     if(triggerChanged){
         WaitTime = 0;
     }

     return triggerChanged;
}

function RemoveTriggerIfSet(WaitTrigger trigger){
     if(TriggerActor == trigger) {
          TriggerActor = None;
          WaitTime = 0;
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
   bLogToGameLogfile=false,
   WaitTime=0.0
}
