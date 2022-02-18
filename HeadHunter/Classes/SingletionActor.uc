class SingletionActor extends Actor nousercreate;

var private SingletionActor Ref;

final static function SingletionActor GetRef(Actor referenceToUseForSpawn) {
    local SingletionActor singleton;

    if(default.Ref == None) {
        singleton = referenceToUseForSpawn.Spawn(class'SingletionActor');
        default.Ref = singleton;
    }

    return default.Ref;
}

defaultproperties
{
      Ref=None
}
