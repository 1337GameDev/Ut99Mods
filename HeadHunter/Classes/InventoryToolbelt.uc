class InventoryToolbelt extends HUDMutator nousercreate;

#exec TEXTURE IMPORT NAME=ToolbeltSlotBackground FILE=Textures\Toolbelt\ToolbeltSlotBackground.bmp GROUP="Background" MIPS=OFF

var FontInfo MyFonts;

var LinkedList InventoryItemsInBelt;

var Texture DefaultIcon;
var Texture ToolbeltSlotTexture;
var Vector ToolbeltGUIRootPos;
var bool DrawVertically;

function PreBeginPlay() {
    if(bLogToGameLogfile) {
        Log("LookTriggerHUDMutator: PreBeginPlay");
    }

    MyFonts = class'MyFontsSingleton'.static.GetRef(self);
}

simulated function PostRender(Canvas C) {
    Super.PostRender(C);

    if(PlayerOwner == ChallengeHUD(PlayerOwner.myHUD).PawnOwner) {
        DrawToolbelt(C, PlayerOwner);
    } else if(PlayerOwner == None){
        Destroy();
    }
}

//=============================================================================
// function DrawIndicatorLocations.
//=============================================================================
simulated final function DrawToolbelt(Canvas C, PlayerPawn Player) {
    local ChallengeHUD PlayerHUD;
    local float PlayerHUDScale;
    local ToolbeltInvItem toolbeltItem;
    local Vector ToolbeltDrawPosition;

    local Pickup invAsPickup;

    if((Player != None) && (InventoryItemsInBelt != None)){
        PlayerHUD = ChallengeHUD(Player.myHUD);
        PlayerHUDScale = PlayerHUD.Scale;
        ToolbeltDrawPosition = ToolbeltGUIRootPos;

        C.Font = MyFonts.GetMediumFont(C.ClipX);
        if((C.Font == None) && (C.LargeFont != None)){
            C.Font = C.LargeFont;
        }

        if(InventoryItemsInBelt != None){
            toolbeltItem = ToolbeltInvItem(InventoryItemsInBelt.Head);
        }

        While(toolbeltItem != None){
           C.Style = ERenderStyle.STY_Normal;
           C.SetPos(ToolbeltDrawPosition.X, ToolbeltDrawPosition.Y);

           C.DrawIcon(ToolbeltSlotTexture, PlayerHUDScale);
           C.DrawIcon(toolbeltItem.ToolbeltIcon, toolbeltItem.TexScaleToBe64Pixels * PlayerHUDScale);

           invAsPickup = Pickup(toolbeltItem.Value);
           if((invAsPickup != None) && (invAsPickup.NumCopies > 0)){
               C.DrawColor = class'ColorHelper'.static.GetWhiteColor();
               C.DrawTextClipped(invAsPickup.NumCopies);
           }

           toolbeltItem = ToolbeltInvItem(toolbeltItem.Next);
           if(DrawVertically){
               ToolbeltDrawPosition.Y -= 64;
           } else {
               ToolbeltDrawPosition.X += 64;
           }
        }

    }//player and trigger NOT empty
}

static function InventoryToolbelt GetCurrentPlayerInventoryToolbeltHudInstance(Actor context, PlayerPawn pp){
    local Mutator m;
    local InventoryToolbelt tb;

    if(pp == None){
       return None;
    }

    foreach context.AllActors(class'PlayerPawn', pp) {
       m = class'HUDMutator'.static.GetHUDMutatorFromPlayerPawnByClassName(pp, 'InventoryToolbelt');

       if(m == None){
           continue;
       } else {
           tb = InventoryToolbelt(m);
       }
    }

    if(tb == None){
       tb = class'InventoryToolbelt'.static.SpawnAndRegister(context);
    }

    return tb;
}

static function InventoryToolbelt SpawnAndRegister(Actor context){
    local InventoryToolbelt hud;
    hud = context.Spawn(class'InventoryToolbelt');
    hud.InventoryItemsInBelt = new class'LinkedList';
    hud.RegisterThisHUDMutator();
    return hud;
}

//can provide an Inventory or ToolbeltInvItem;
function bool AddInventoryToToolbelt(object inv){
    local ToolbeltInvItem itemElement;
    local Inventory invToAdd;

    if(inv == None){
        return false;
    }
    if(InventoryItemsInBelt != None){
        InventoryItemsInBelt = new class'LinkedList';
    }

    itemElement = ToolbeltInvItem(inv);
    if(itemElement == None){//not a ToolbeltInvItem object
        invToAdd = Inventory(inv);
        if(invToAdd != None){//IS an Inventory object
            itemElement = class'ToolbeltInvItem'.static.GetInstanceForInvItem(invToAdd);
        }
    }

    if(itemElement != None){
        InventoryItemsInBelt.Push(itemElement);
        return true;
    }

    return false;
}

//can provide an Inventory or ToolbeltInvItem;
function bool RemoveInventoryFromToolbelt(object inv){
    local ToolbeltInvItem itemElement;
    local Inventory invToAdd;

    if((inv == None) || (InventoryItemsInBelt == None) || (InventoryItemsInBelt.Count < 1)){
        return false;
    }

    itemElement = ToolbeltInvItem(inv);
    if(itemElement == None){//not a ToolbeltInvItem object
        invToAdd = Inventory(inv);
        if(invToAdd != None){//not an Inventory object
             return InventoryItemsInBelt.RemoveElementByValue(invToAdd);
        }
    } else {
        itemElement.RemoveFromList();
        return true;
    }

    return false;
}

defaultproperties {
   bLogToGameLogfile=false,
   DefaultIcon=Texture'Engine.S_INVENTORY',
   ToolbeltSlotTexture=Texture'HeadHunter.Background.ToolbeltSlotBackground',
   ToolbeltGUIRootPos=Vect(0,-128,0),
   DrawVertically=false
}
