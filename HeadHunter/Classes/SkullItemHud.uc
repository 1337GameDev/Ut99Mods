class SkullItemHud extends HUDMutator nousercreate;

var() bool ShowMaxAmount;
var() bool UseHudColorForSkullCount;
var() color SkullCountColor;

var SkullItem MySkullItem;
var float LastChecked;

var FontInfo MyFonts;

function PreBeginPlay() {
    if(bLogToGameLogfile) {
        Log("SkullItemHud: PreBeginPlay");
    }

    MyFonts = class'MyFontsSingleton'.static.GetRef(self);
}

simulated function PostRender(canvas C) {
    local float HudScale, IconScale;
    local Inventory inv;

    Super.PostRender(C);

    if(PlayerOwner == ChallengeHUD(PlayerOwner.myHUD).PawnOwner) {
        if ((MySkullItem == None) || MySkullItem.bDeleteMe || (MySkullItem.Owner == None) || (MySkullItem.Owner != PlayerOwner) ) {
            if(Level.TimeSeconds - LastChecked > 0.3) {
                MySkullItem = None;
                LastChecked = Level.TimeSeconds;

                inv = PlayerOwner.Inventory;
                While(inv != None) {
                    if(inv.IsA('SkullItem')) {
                        MySkullItem = SkullItem(inv);
                        break;
                    }

                    inv = inv.inventory;
                }
            }
        }

        if(MySkullItem != None) {
            HudScale = ChallengeHUD(PlayerOwner.myHUD).Scale;

            if(UseHudColorForSkullCount) {
               C.DrawColor = ChallengeHUD(PlayerOwner.myHUD).HUDColor;
            } else {
               C.DrawColor = SkullCountColor;
            }

            C.Style = ERenderStyle.STY_Translucent;
            C.SetPos(C.ClipX - 58 * HudScale, C.ClipY - 133 * HudScale);
            IconScale = class'HudHelper'.static.getScaleForTextureToGetDesiredWidth(MySkullItem.Icon, 64.0);
            C.DrawIcon(MySkullItem.Icon, HudScale*IconScale);

            C.Font = MyFonts.GetHugeFont(C.ClipX);

            if(ShowMaxAmount) {
               C.SetPos(C.ClipX - 130 * HudScale, C.ClipY - 118 * HudScale);
               C.DrawText(MySkullItem.NumCopies@"\\"@MySkullItem.MaxCount, True);
            } else {
               C.SetPos(C.ClipX - 90 * HudScale, C.ClipY - 118 * HudScale);
               C.DrawText(MySkullItem.NumCopies, True);
            }
        }
    } else if(PlayerOwner == None){
          Destroy();
    }
}

defaultproperties
{
      ShowMaxAmount=False
      UseHudColorForSkullCount=False
      SkullCountColor=(R=255,G=186,B=3,A=0)
      MySkullItem=None
      LastChecked=0.000000
      MyFonts=None
}
