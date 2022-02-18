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

defaultproperties
{
      DamageMultiplierFromPlayers=1000.000000
      DamageMultiplierFromNonPlayers=0.000000
      DamageMultiplierToPlayers=1.000000
      DamageMultiplierToNonPlayers=1.000000
      MomentumMultiplierFromPlayers=1000.000000
      MomentumMultiplierFromNonPlayers=0.000000
      MomentumMultiplierToPlayers=1.000000
      MomentumMultiplierToNonPlayers=1.000000
}
