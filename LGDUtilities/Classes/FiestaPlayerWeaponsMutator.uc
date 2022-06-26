//=============================================================================
// FiestaPlayerWeaponsMutator.
// replaces all weapons with random ones, and removes all ammo
//=============================================================================

class FiestaPlayerWeaponsMutator extends Mutator config;

var bool HasInitArrays;
var int WeaponsAvailableCount;

var config class<Weapon> WeaponsAvailableToChoose[256];

function AddMutator(Mutator M) {
    InitRandomlyChosenWeaponsList();

    //if we'll override another arena mutator OR we have no defined weapon classes after compacting the array
	if (M.IsA('Arena') || (WeaponsAvailableCount == 0)) {
		log(M$" not allowed (already have an Arena mutator, thus we don't want to interfere.)");
		return; //only allow one arena mutator
	}

	Super.AddMutator(M);
}

function bool AlwaysKeep(Actor Other) {
    if(Other.Tag == 'DontReplace') {
        return true;
    } else if(NextMutator != None) {
		return NextMutator.AlwaysKeep(Other);
    }
}

// return what should replace the default weapon
// mutators further down the list override earlier mutators
function Class<Weapon> MutatedDefaultWeapon() {
    InitRandomlyChosenWeaponsList();
	return ChooseRandomWeapon();
}
function Class<Weapon> MyDefaultWeapon() {
	InitRandomlyChosenWeaponsList();
	return ChooseRandomWeapon();
}

function InitRandomlyChosenWeaponsList() {
    local LinkedList weps;
    local ListElement le;
    local ClassObj classObj;
    local int i;

	if(!HasInitArrays) {
	    weps = class'LGDUtilities.ServerHelper'.static.GetAllWeaponClasses(self);
        WeaponsAvailableCount = weps.Count;

        le = weps.Head;
        while(le != None) {
            classObj = ClassObj(le.Value);

            WeaponsAvailableToChoose[i] = class<Weapon>(classObj.Value);

            le = le.Next;
            i++;
        }

		HasInitArrays = true;
	}
}

function class<Weapon> ChooseRandomWeapon() {
    local class<Weapon> chosenWep;
	local int randomIdx;

    //find a randomly used entry
    randomIdx = Rand(WeaponsAvailableCount);
    chosenWep = WeaponsAvailableToChoose[randomIdx];

    return chosenWep;
}

defaultproperties {
      HasInitArrays=False,
      WeaponsAvailableCount=0
}
