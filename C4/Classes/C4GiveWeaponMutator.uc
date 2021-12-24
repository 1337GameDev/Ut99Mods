class C4GiveWeaponMutator extends Mutator;

function bool AlwaysKeep(Actor Other) {
	if (Other.IsA('C4Weapon') || Other.IsA('C4Ammo')) {
		return true;
	}

	return Super.AlwaysKeep(Other);
}

simulated function ModifyPlayer(Pawn Other) {
    local Inventory inv;

	Super.ModifyPlayer(Other);

	if(!Other.IsA('Bot')){
	    inv = Spawn(class'C4.C4Weapon');

	    if(inv != None) {
		    inv.bHeldItem = true;
		    inv.bTossedOut = false;
		    inv.GiveTo(Other);
		    Weapon(inv).GiveAmmo(Other);
	    }
	}
}
