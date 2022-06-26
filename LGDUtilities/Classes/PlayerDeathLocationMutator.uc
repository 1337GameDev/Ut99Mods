class PlayerDeathLocationMutator extends Mutator;

function bool PreventDeath(Pawn Killed, Pawn Killer, name damageType, vector HitLocation) {
    local PlayerDeathLocationMarker marker;
    //spawn a death marker for this player
    marker = class'LGDUtilities.PlayerDeathLocationMarker'.static.SpawnAtPlayerLocation(self, Killed);

    return Super.PreventDeath(Killed, Killer, damageType, HitLocation);
}

defaultproperties {
}
