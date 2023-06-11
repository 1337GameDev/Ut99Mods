class SingletonActor extends Actor nousercreate;

var private SingletonActor Ref;

final static function SingletonActor GetRef(Actor referenceToUseForSpawn) {
    local SingletonActor singleton;

    if(default.Ref == None) {
        singleton = referenceToUseForSpawn.Spawn(class'LGDUtilities.SingletonActor');
        default.Ref = singleton;
    }

    return default.Ref;
}

defaultproperties {
      Ref=None
}
