class GibberWeaponReplaceMutator extends Mutator nousercreate;

static function GibberWeaponReplaceMutator RegisterMutator(Actor context) {
    local GibberWeaponReplaceMutator mut;

    mut = context.Spawn(class'Gibber.GibberWeaponReplaceMutator');
    context.Level.Game.BaseMutator.AddMutator(mut);
    return mut;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
	if((Other.Class == Class'Botpack.PulseGun')) {
	    ReplaceWith(Other, "Gibber.Gibber");
		return false;
	} else if ((Other.Class == Class'Botpack.PAmmo') && (Other.Owner == None) && (Other.Tag != 'GibberAmmo')){
	    Log("GibberWeaponReplaceMutator - CheckReplacement - Destroyed PAmmo:"$Other.Name);
	    Other.Destroy();
	}

	return true;
}
