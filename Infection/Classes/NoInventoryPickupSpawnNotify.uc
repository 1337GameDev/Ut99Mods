class NoInventoryPickupSpawnNotify extends SpawnNotify nousercreate;

simulated event Actor SpawnNotification(Actor A) {
	local Inventory inv;
	inv = Inventory(A);
	
	if (inv != None) {
        inv.MaxDesireability = 0;
	}

    return A;
}

defaultproperties {
      ActorClass=Class'Engine.Inventory'
}
