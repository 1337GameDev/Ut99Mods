class C4GiveWeaponMutator extends Mutator;

simulated function ModifyPlayer(Pawn Other) {
    local Inventory inv;

	Super.ModifyPlayer(Other);

	if(!Other.IsA('Bot')){
	    inv = Spawn(class'C4Weapon');
	    if(inv != None) {
		    inv.bHeldItem = true;
		    inv.bTossedOut = false;
		    inv.GiveTo(Other);
		    Weapon(inv).GiveAmmo(Other);
	    }
	}
}
