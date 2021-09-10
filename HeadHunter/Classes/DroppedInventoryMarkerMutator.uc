class DroppedInventoryMarkerMutator extends Mutator nousercreate;

static function DroppedInventoryMarkerMutator RegisterMutator(Actor context) {
    local DroppedInventoryMarkerMutator mut;

    mut = context.Spawn(class'DroppedInventoryMarkerMutator');
    context.Level.Game.BaseMutator.AddMutator(mut);
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
