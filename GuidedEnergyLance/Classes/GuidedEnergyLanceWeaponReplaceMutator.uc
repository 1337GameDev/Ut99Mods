class GuidedEnergyLanceWeaponReplaceMutator extends Mutator nousercreate;

static function GuidedEnergyLanceWeaponReplaceMutator RegisterMutator(Actor context) {
    local GuidedEnergyLanceWeaponReplaceMutator mut;

    mut = context.Spawn(class'GuidedEnergyLance.GuidedEnergyLanceWeaponReplaceMutator');
    context.Level.Game.BaseMutator.AddMutator(mut);
    return mut;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
	if((Other.Class == Class'Botpack.UT_Eightball')) {
	    ReplaceWith(Other, "GuidedEnergyLance.GuidedEnergyLance");
		return false;
	}

	return true;
}

defaultproperties {
}
