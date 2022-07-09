class PlayerDeathLocationMutator extends Mutator;

var config bool ShowAllyIndicators;
var config bool ShowEnemyIndicators;
var config bool ShowNeutralIndicators;

function bool PreventDeath(Pawn Killed, Pawn Killer, name damageType, vector HitLocation) {
    local PlayerDeathLocationMarker marker;
    local PlayerDeathLocationMarkerIndicatorFn fn;

    fn = new class'LGDUtilities.PlayerDeathLocationMarkerIndicatorFn';
    fn.ShowAllyIndicators = ShowAllyIndicators;
    fn.ShowEnemyIndicators = ShowEnemyIndicators;
    fn.ShowNeutralIndicators = ShowNeutralIndicators;

    //spawn a death marker for this player
    marker = class'LGDUtilities.PlayerDeathLocationMarker'.static.SpawnAtPlayerLocation(self, Killed);

    return Super.PreventDeath(Killed, Killer, damageType, HitLocation);
}

defaultproperties {
  ShowAllyIndicators=True
  ShowEnemyIndicators=False
  ShowNeutralIndicators=False
}
