class TesterCache extends Actor nousercreate;

var private TesterCache Ref;

var LinkedList AllTesters;

replication {
	reliable if(Role == ROLE_Authority)
		Ref, AllTesters;
}

final static function TesterCache GetRef(Actor referenceToUseForSpawn) {
    local TesterCache singleton;
    if(default.Ref == None) {
        singleton = referenceToUseForSpawn.Spawn(class'TesterCache');
        singleton.AllTesters = new class'LinkedList';
        default.Ref = singleton;
    }

    return default.Ref;
}

final static function SetRef(TesterCache cache) {
    if(cache == None){
        return;
    }

    default.Ref = cache;
}

final static function bool HasATesterLoaded(Actor context){
    local TesterCache cache;
    cache = class'TesterCache'.static.GetRef(context);
    return cache.AllTesters.Count > 0;
}

defaultproperties
{
      Ref=None
      AllTesters=None
}
