//=============================================================================
// DroppedInventoryMarkerMutator
//
// This is a mutator loaded by IndicatorHUD to mark items when they are dropped, via the property 'PlayerLastTouched' as this isn't used by the engine AFAIK (it sets this property to 'Dropped' and '')
//=============================================================================

class DroppedInventoryMarkerMutator extends Mutator nousercreate;

static function DroppedInventoryMarkerMutator RegisterMutator(Actor context) {
    local DroppedInventoryMarkerMutator mut;

    mut = context.Spawn(class'LGDUtilities.DroppedInventoryMarkerMutator');
    context.Level.Game.BaseMutator.AddMutator(mut);
    class'LGDUtilities.InventoryHelper'.default.DroppedInventoryMarkerMutatorInstance = mut;

    return mut;
}

//ensure any items we marked as dropped get their special tag reset (if it was set by us)
function bool HandlePickupQuery(Pawn Other, Inventory item, out byte bAllowPickup) {
	local bool DenyPickup;
	DenyPickup = Super.HandlePickupQuery(Other, item, bAllowPickup);

	if(!DenyPickup && item.PlayerLastTouched == 'Dropped'){
	     item.PlayerLastTouched = '';
	}

	return DenyPickup;
}

//ensures any item dropped by a player when they die is marked
//does not modify any item tossed out, as Inventory.bTossedOut exists to denote that
function bool PreventDeath(Pawn Killed, Pawn Killer, name damageType, vector HitLocation) {
    local Inventory Inv;
    local bool DeathPrevented;

    DeathPrevented = Super.PreventDeath(Killed, Killer, damageType, HitLocation);

    if(!DeathPrevented){
        for(Inv=Killed.Inventory; Inv!=None; Inv=Inv.Inventory) {
            Inv.PlayerLastTouched = 'Dropped';
	    }
    }

    return DeathPrevented;
}

defaultproperties {
}
