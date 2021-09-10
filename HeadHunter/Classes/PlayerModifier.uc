class PlayerModifier extends Actor;

var(Damage) float DamageMultiplierFromPlayers;
var(Damage) float DamageMultiplierFromNonPlayers;

var(Damage) float DamageMultiplierToPlayers;
var(Damage) float DamageMultiplierToNonPlayers;

var(Momentum) float MomentumMultiplierFromPlayers;
var(Momentum) float MomentumMultiplierFromNonPlayers;

var(Momentum) float MomentumMultiplierToPlayers;
var(Momentum) float MomentumMultiplierToNonPlayers;

function PreBeginPlay() {
     //class'TestPlayerModifierMutator'.static.SpawnAndRegister(self, self);
}

defaultproperties {
    DamageMultiplierFromPlayers=1000.0,
    DamageMultiplierFromNonPlayers=0.0,
    DamageMultiplierToPlayers=1.0,
    DamageMultiplierToNonPlayers=1.0,

    MomentumMultiplierFromPlayers=1000.0,
    MomentumMultiplierFromNonPlayers=0.0,
    MomentumMultiplierToPlayers=1.0,
    MomentumMultiplierToNonPlayers=1.0
}
