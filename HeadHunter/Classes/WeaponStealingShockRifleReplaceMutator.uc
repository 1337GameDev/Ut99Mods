class WeaponStealingShockRifleReplaceMutator extends Mutator nousercreate;

static function WeaponStealingShockRifleReplaceMutator RegisterMutator(Actor context) {
    local WeaponStealingShockRifleReplaceMutator mut;

    mut = context.Spawn(class'WeaponStealingShockRifleReplaceMutator');
    context.Level.Game.BaseMutator.AddMutator(mut);
    return mut;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant) {
	if((Other.Class == Class'Botpack.ShockRifle')) {
	    ReplaceWith(Other, "Headhunter.WeaponStealingShockRifle");
		return false;
	}

	return true;
}

function bool AlwaysKeep(Actor Other) {
	if (Other.IsA('WeaponStealingShockRifle')) {
		return true;
	}

	return Super.AlwaysKeep(Other);
}

defaultproperties
{
}
