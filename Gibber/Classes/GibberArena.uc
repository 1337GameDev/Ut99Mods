//=============================================================================
// GibberArena.
// replaces all weapons and ammo with The Gibber and ammo
//=============================================================================

class GibberArena expands Arena;

function bool AlwaysKeep(Actor Other) {
    if((WeaponName != '') && Other.IsA(WeaponName)) {
        return true;
	}

    if((AmmoName != '') && Other.IsA(AmmoName)) {
		return true;
	}

	if(NextMutator != None) {
		return (NextMutator.AlwaysKeep(Other));
	}

    return false;
}

defaultproperties {
      WeaponName="Gibber"
      WeaponString="Gibber.Gibber"
      DefaultWeapon=Class'Gibber.Gibber'
}
