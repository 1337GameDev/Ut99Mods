//-----------------------------------------------------------
// A list element for an object on the InventoryToolbelt HUD.
// The ListElment has a value, which in terms of an InventoryToolbelt HUD, is an Inventory object to display.
//-----------------------------------------------------------
class ToolbeltInvItem extends ListElement;

var Texture ToolbeltIcon;//a 64x64 texture, otherwise the texture is scaled by it's largest dimension to be 64x64
var float TexScaleToBe64Pixels;

static function ToolbeltInvItem GetInstanceForInvItem(Inventory inv){
    local ToolbeltInvItem toolbeltItem;

    if(inv != None){
        toolbeltItem = new class'LGDUtilities.ToolbeltInvItem';
        toolbeltItem.Value = inv;
        if(inv.Icon == None){
            toolbeltItem.ToolbeltIcon = class'LGDUtilities.InventoryToolbelt'.default.DefaultIcon;
        } else {
            toolbeltItem.ToolbeltIcon = inv.Icon;
        }

        toolbeltItem.TexScaleToBe64Pixels = class'LGDUtilities.HudHelper'.static.getScaleForTextureToGetDesiredWidth(toolbeltItem.ToolbeltIcon, 64.0);
    }

    return toolbeltItem;
}

defaultproperties {
      ToolbeltIcon=None
      TexScaleToBe64Pixels=0.000000
}
