//=============================================================================
// FiestaMapWeapons.
// replaces all weapons with random ones, and removes all ammo
//=============================================================================

class FiestaMapWeaponsMutator extends Mutator config;

var bool HasReplacedWeaponsOnMap;

var bool HasInitArrays;
var int WeaponsAvailableCount;

var config class<Weapon> WeaponsAvailableToChoose[256];

//for switching mutator precedance
var Mutator GameBaseMutator;
var Mutator MutatorBeforeThis;
var Mutator MutatorAfterThis;

function PostBeginPlay() {
    InitRandomlyChosenWeaponsList();
    ReplaceMapWeapons();
}

function AddMutator(Mutator M) {
    InitRandomlyChosenWeaponsList();

    //if we'll override another arena mutator OR we have no defined weapon classes after compacting the array
	if (M.IsA('Arena') || (WeaponsAvailableCount == 0)) {
		log(M$" not allowed (already have an Arena mutator, this we don't want to interfere.)");
		return; //only allow one arena mutator
	}

	Super.AddMutator(M);
}

function ReplaceMapWeapons() {
    local Weapon w, newWep;
    local Inventory i;
	local class<Weapon> wepClass;
	local LinkedList list;
	local ListElement le;

	list = new class'LGDUtilities.LinkedList';

    if(!HasReplacedWeaponsOnMap) {

		ForEach AllActors(class'Inventory', i) {
			if(i.Owner == None) {
				if(i.IsA('Weapon')) {
				    w = Weapon(i);

				    if(!w.bHeldItem) {
                        list.Push(i);
                    }
				} else if(i.IsA('Ammo')) {
					i.Destroy();
				}
			}
		}

		le = list.Head;

		while(le != None) {
		    if(Ammo(le.Value) != None) {
		        Ammo(le.Value).Destroy();
		    } else {
				w = Weapon(le.Value);

				if(w != None) {
					wepClass = Self.ChooseRandomWeapon();

					newWep = Spawn(wepClass,, 'DontReplace', w.Location, w.Rotation);

					if(newWep != None) {
						newWep.RespawnTime = w.RespawnTime;
					}

					w.Destroy();
				}
			}

            le = le.Next;
		}

        HasReplacedWeaponsOnMap = true;
    }
}

function bool AlwaysKeep(Actor Other) {
    if(Other.IsA('Weapon') || Other.IsA('TournamentWeapon') || (Other.Tag == 'DontReplace')) {
	    return true;
	} else if(NextMutator != None) {
		return NextMutator.AlwaysKeep(Other);
	}
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
        while((le != None) && (i < ArrayCount(WeaponsAvailableToChoose)) ) {
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
      HasReplacedWeaponsOnMap=False,
      HasInitArrays=False,
      WeaponsAvailableCount=0
}
