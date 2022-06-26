//=============================================================================
// JuggernautShieldBelt.
//
// A special shield belt to assist with juggernaut abilities
//=============================================================================
class JuggernautShieldBelt extends UT_ShieldBelt;

function bool HandlePickupQuery(Inventory Item) {
	if(Item.IsA('JuggernautBelt') || class'LGDUtilities.InventoryHelper'.static.IsAPowerup(Item, true, true, true)) {
		return true;
	} else {
	    return Super.HandlePickupQuery(Item);
	}
}

function GiveTo(Pawn Other) {
	Super.GiveTo(Other);
	PickupFunction(Other);
}

defaultproperties {
      PickupMessage=""
      ItemName=""
      PickupSound=None
}
