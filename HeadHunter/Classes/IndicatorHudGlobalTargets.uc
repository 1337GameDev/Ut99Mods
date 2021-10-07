class IndicatorHudGlobalTargets extends Actor nousercreate;

var private IndicatorHudGlobalTargets Ref;

var LinkedList GlobalIndicatorTargets;

replication {
	reliable if(Role == ROLE_Authority)
		Ref, GlobalIndicatorTargets;
}

final static function IndicatorHudGlobalTargets GetRef(Actor referenceToUseForSpawn) {
    local IndicatorHudGlobalTargets singleton;
    if(default.Ref == None) {
        singleton = referenceToUseForSpawn.Spawn(class'IndicatorHudGlobalTargets');
        singleton.GlobalIndicatorTargets = new class'LinkedList';
        default.Ref = singleton;
    }

    return default.Ref;
}

final static function SetRef(IndicatorHudGlobalTargets targets) {
    if(targets == None){
        return;
    }

    default.Ref = targets;
}
