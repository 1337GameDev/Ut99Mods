class AssaultHelper extends Actor nousercreate;

static final function bool IsFortNameFriendly(string fortName) {
    local bool containsUnfriendlyWord;
    local string fortNameCap;

    if(Len(fortName) == 0) {
        return false;
    }

    fortNameCap = Caps(fortName);

    containsUnfriendlyWord =
    InStr(fortNameCap, "BREACHING") > -1
    ||
    InStr(fortNameCap, "BREACHED") > -1
    ||
    InStr(fortNameCap, "ATTACKING") > -1
    ||
    InStr(fortNameCap, "ATTACKED") > -1
    ||
    InStr(fortNameCap, "DESTROYING") > -1
    ||
    InStr(fortNameCap, "DESTROYED") > -1
    ||
    InStr(fortNameCap, "ATTACKERS") > -1
    ||
    InStr(fortNameCap, "DEFENDERS") > -1
    ||
    InStr(fortNameCap, "ENTERED") > -1
    ||
    InStr(fortNameCap, "ENTERING") > -1
    ||
    InStr(fortNameCap, "OPENED") > -1
    ||
    InStr(fortNameCap, "OPENING") > -1
    ||
    InStr(fortNameCap, "CLOSED") > -1
    ||
    InStr(fortNameCap, "CLOSING") > -1
    ||
    InStr(fortNameCap, "BEEN") > -1
    ||
    InStr(fortNameCap, "MANIPULATING") > -1
    ||
    InStr(fortNameCap, "MANIPULATED") > -1
    ||
    InStr(fortNameCap, "ACTIVATING") > -1
    ||
    InStr(fortNameCap, "ACTIVATED") > -1
    ||
    InStr(fortNameCap, "TRIGGERED") > -1
    ||
    InStr(fortNameCap, "TRIGGERING") > -1
    ||
    InStr(fortNameCap, "STOPPING") > -1
    ||
    InStr(fortNameCap, "STOPPED") > -1
    ||
    InStr(fortNameCap, "STARTING") > -1
    ||
    InStr(fortNameCap, "STARTED") > -1
    ||
    InStr(fortNameCap, "MOVING") > -1
    ||
    InStr(fortNameCap, "MOVED") > -1
    ||
    InStr(fortNameCap, "BUILDING") > -1
    ||
    InStr(fortNameCap, "BUILT") > -1
    ||
    InStr(fortNameCap, "COLLAPSING") > -1
    ||
    InStr(fortNameCap, "COLLASPED") > -1
    ||
    InStr(fortNameCap, "BURNING") > -1
    ||
    InStr(fortNameCap, "BURNED") > -1
    ||
    InStr(fortNameCap, "FUELING") > -1
    ||
    InStr(fortNameCap, "FUELD") > -1
    ||
    InStr(fortNameCap, "FUELED") > -1
    ||
    InStr(fortNameCap, "FORTSTANDARD") > -1
    ||
    InStr(fortNameCap, "DEFENSEPOINT") > -1
    ||
    InStr(fortNameCap, "LAUNCHED") > -1
    ||
    InStr(fortNameCap, "LAUNCHING") > -1
    ||
    InStr(fortNameCap, "SUBMERGED") > -1
    ||
    InStr(fortNameCap, "SUBMERGING") > -1
    ;
    return !containsUnfriendlyWord;
}

static final function string GetFriendlyFortName(FortStandard fort){
    local string fortName;
    local DefensePoint defensePoint;

    if(fort != None){
        fortName = fort.FortName;
        if(!IsFortNameFriendly(fortName)){
            fortName = string(fort.Tag);

            if(!IsFortNameFriendly(fortName)){
                fortName = string(fort.Name);

                if(!IsFortNameFriendly(fortName)){
                     //find the nearest DefencePoint that's associated with this fort
                     ForEach fort.AllActors(class'DefensePoint', defensePoint) {
                         if(defensePoint.FortTag == fort.Tag){
                             fortName = string(defensePoint.Tag);

                             if(!IsFortNameFriendly(fortName)){
                                 fortName = string(defensePoint.Name);

                                 if(!IsFortNameFriendly(fortName)){
                                     fortName = "Objective";
                                 }
                             }
                         }
                     }
                }

            } else {
                //remove the "Fort" suffix that's common
                fortName -= "Fort";
                fortName -= "fort";
            }
        }
    }

    return fortName;
}

defaultproperties {
}
