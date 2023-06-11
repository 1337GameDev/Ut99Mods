class TestPlayerModifierMutator extends HUDMutator config;

var PlayerModifier playerModifierInstance;

static function TestPlayerModifierMutator SpawnAndRegister(Actor context, PlayerModifier modifierActor){
    local TestPlayerModifierMutator mut;
    mut = context.Spawn(class'LGDUtilities.TestPlayerModifierMutator');
	
    context.Level.Game.RegisterDamageMutator(mut);
    context.Level.Game.BaseMutator.AddMutator(mut);
    context.Level.Game.RegisterMessageMutator(mut);

    mut.playerModifierInstance = modifierActor;

    return mut;
}

simulated function ModifyPlayer(Pawn Other) {
   Super.ModifyPlayer(Other);
}

simulated function MutatorTakeDamage(out int ActualDamage, Pawn Victim, Pawn InstigatedBy, out Vector HitLocation, out Vector Momentum, name DamageType){
    local TournamentPlayer playerVictim, playerInstigator;
    playerVictim = TournamentPlayer(Victim);
    playerInstigator = TournamentPlayer(InstigatedBy);

    if(playerVictim != None){//victim is a player
        ActualDamage *= playerModifierInstance.DamageMultiplierToPlayers;
        Momentum *= playerModifierInstance.MomentumMultiplierToPlayers;
    } else {//victim is a NON player
        ActualDamage *= playerModifierInstance.DamageMultiplierToNonPlayers;
        Momentum *= playerModifierInstance.MomentumMultiplierToNonPlayers;
    }

    if(playerInstigator != None){//instigator is a player
        ActualDamage *= playerModifierInstance.DamageMultiplierFromPlayers;
        Momentum *= playerModifierInstance.MomentumMultiplierFromPlayers;
    } else {//instigator is a NON player
        ActualDamage *= playerModifierInstance.DamageMultiplierFromNonPlayers;
        Momentum *= playerModifierInstance.MomentumMultiplierFromNonPlayers;
    }
	
	Super.MutatorTakeDamage(ActualDamage, Victim, InstigatedBy, HitLocation, Momentum, DamageType);
}

function Mutate(string MutateString, PlayerPawn Sender) {
	Sender.ClientMessage("Test mutate string mutator: string:"$MutateString$" - Sender:"$Sender.MenuName);

    Super.Mutate(MutateString, Sender);
}

defaultproperties {
      playerModifierInstance=None
}
