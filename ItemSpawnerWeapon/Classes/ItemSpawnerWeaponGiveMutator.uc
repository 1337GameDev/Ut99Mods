class ItemSpawnerWeaponGiveMutator extends Mutator nousercreate;

static function ItemSpawnerWeaponGiveMutator RegisterMutator(Actor context) {
    local ItemSpawnerWeaponGiveMutator mut;

    mut = context.Spawn(class'ItemSpawnerWeapon.ItemSpawnerWeaponGiveMutator');
    context.Level.Game.BaseMutator.AddMutator(mut);
    return mut;
}

simulated function ModifyPlayer(Pawn Other) {
    local Inventory inv;

	Super.ModifyPlayer(Other);

	if(!Other.IsA('Bot')){
	    inv = Spawn(class'ItemSpawnerWeapon.ItemSpawnerWeapon');
	    if(inv != None) {
		    inv.bHeldItem = true;
		    inv.bTossedOut = false;
		    inv.GiveTo(Other);
		    Weapon(inv).GiveAmmo(Other);
	    }
	}
}

function bool AlwaysKeep(Actor Other) {
	if (Other.IsA('ItemSpawnerWeapon')) {
		return true;
	}

	return Super.AlwaysKeep(Other);
}

defaultproperties
{
}
