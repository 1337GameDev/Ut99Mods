class PlayerSpawnNotify extends SpawnNotify nousercreate;

var PlayerSpawnNotifyCallback Callback;

//Only triggered ONCE per player when they are spawned - when they join a game (they aren't destroyed when they die)
simulated event Actor SpawnNotification(Actor A) {
	if (A.IsA('PlayerPawn') && Callback != None) {
         Callback.SpawnedPlayer = PlayerPawn(A);
         Callback.CallbackFunc();
	}

    return A;
}

static function PlayerSpawnNotify RegisterForPlayerSpawnEvent(Actor context, PlayerSpawnNotifyCallback callback) {
   local PlayerSpawnNotify notify;

    if(callback == None) {
        return None;
    }

    notify = context.Spawn(class'LGDUtilities.PlayerSpawnNotify');
    notify.Callback = callback;

    return notify;
}

defaultproperties {
      callback=None
      ActorClass=Class'Engine.PlayerPawn'
}
