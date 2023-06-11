class ServerHelper extends Actor nousercreate;

static function bool IsPackageNameInServerPackages(Actor context, string PackageNameToLookFor) {
    local string ServerPackages;
	ServerPackages = (context.consoleCommand("get Engine.GameEngine ServerPackages"));

    return (instr(ServerPackages, PackageNameToLookFor) > 0);
}

static function LinkedList GetAllWeaponClasses(Actor context, optional bool OnlyIncludeBaseWeapons, optional bool ExcludeChaosUTWeapons, optional bool bLogToGameLogfile) {
    local LinkedList FoundClasses;
    local ListElement el, elToRemove;
    local string classPackage, className;
    local bool RemovedEntry;
    local ClassObj classObjVal;//value for a list element, essentially a class variable wrapper

    //get u1 weapons, and any with meta of Engine.Weapon
    FoundClasses = class'LGDUtilities.ServerHelper'.static.GetClassesLoadedFromIntFiles(context, "Engine.Weapon");
    //get UT99 weapons, and any with meta of Botpack.TournamentWeapon
    FoundClasses.Concat(class'LGDUtilities.ServerHelper'.static.GetClassesLoadedFromIntFiles(context, "Botpack.TournamentWeapon") );

    if(!OnlyIncludeBaseWeapons) {
        //get Wormbo EnhanceWeapon weapons, and any with meta of EnhancedItems.EnhancedWeapon
        FoundClasses.Concat(class'LGDUtilities.ServerHelper'.static.GetClassesLoadedFromIntFiles(context, "EnhancedItems.EnhancedWeapon") );
    } else {
        el = FoundClasses.Head;

        while(el != None) {
            RemovedEntry = false;
            elToRemove = None;

            if((el.Value != None) && ClassIsChildOf(el.Value.class, class'LGDUtilities.ClassObj')) {
                classObjVal = ClassObj(el.Value);
                classPackage = class'LGDUtilities.StringHelper'.static.GetPackageNameFromQualifiedClass(classObjVal.ClassQualifiedName);

                if(!((classPackage ~= "ChaosUT") || (classPackage ~= "Botpack") || (classPackage ~= "UnrealShare") || (classPackage ~= "UnrealI")) ){
                    RemovedEntry = true;
                    elToRemove = el;
                    el = el.Next;

                    elToRemove.RemoveFromList();
                }
            }

            if(!RemovedEntry) {
                el = el.Next;
            }
        }
    }

    if(ExcludeChaosUTWeapons) {
        el = FoundClasses.Head;

        while(el != None) {
            RemovedEntry = false;
            elToRemove = None;

            if((el.Value != None) && ClassIsChildOf(el.Value.class, class'LGDUtilities.ClassObj')) {
                classObjVal = ClassObj(el.Value);
                classPackage = class'LGDUtilities.StringHelper'.static.GetPackageNameFromQualifiedClass(classObjVal.ClassQualifiedName);

                if(classPackage ~= "ChaosUT") {
                    RemovedEntry = true;
                    elToRemove = el;
                    el = el.Next;

                    elToRemove.RemoveFromList();
                }
            }

            if(!RemovedEntry) {
                el = el.Next;
            }
        }
    }

    el = FoundClasses.Head;
    //filter out any weapons we shouldn't include, due to their unique use case nature -- eg: ChaosUT kamikaze
    while(el != None) {
		RemovedEntry = false;
		elToRemove = None;

		if((el.Value != None) && ClassIsChildOf(el.Value.class, class'LGDUtilities.ClassObj')) {
			classObjVal = ClassObj(el.Value);
            className = class'LGDUtilities.StringHelper'.static.RemovePackageNameFromQualifiedClass(classObjVal.ClassQualifiedName);

			if((className ~= "Kamikaze") || (className ~= "WeaponEventListenerWeapon") || (className ~= "ItemSpawnerWeapon") || (className ~= "MenuSuperShockRifle") || (className ~= "doubleenforcer")){
                RemovedEntry = true;
				elToRemove = el;
				el = el.Next;

				elToRemove.RemoveFromList();
			} else {
			    //if we aren't removing the element, load the class
			    classObjVal.LoadClassFromQualifiedName();
			}
		}

		if(!RemovedEntry) {
			el = el.Next;
		}
	}

    return FoundClasses;
}

static function LinkedList GetClassesLoadedFromIntFiles(Actor context, string IntMetaClassToCompareTo, optional bool LoadClasses, optional int MaxClassIntNum, optional bool bLogToGameLogfile){
    local LinkedList FoundClasses;
    local int ClassIntNum;
    local class<Actor> LoadedClass;
    local string NextClassNameToLoad, NextClassNameToLoadDescr;

    FoundClasses = new class'LGDUtilities.LinkedList';

    if(MaxClassIntNum == 0){
        MaxClassIntNum = 255;
    }

    if(IntMetaClassToCompareTo == ""){
        IntMetaClassToCompareTo = "Botpack.TournamentWeapon";
    }

    if(bLogToGameLogfile) {
        Log("ServerHelper - GetClassesLoadedFromIntFiles - Before fetching first INT file for meta class name:"$IntMetaClassToCompareTo);
    }

    LoadedClass = class<Weapon>(DynamicLoadObject(IntMetaClassToCompareTo, class'Class'));
    if(LoadedClass == None) {
        if(bLogToGameLogfile) {
            Log("ServerHelper - GetClassesLoadedFromIntFiles - Unable to load class for meta class:"$IntMetaClassToCompareTo);
        }

        return FoundClasses;
    } else if(bLogToGameLogfile) {
        Log("ServerHelper - GetClassesLoadedFromIntFiles - Loaded class for meta class:"$IntMetaClassToCompareTo);
    }

	ClassIntNum = 0;
    context.GetNextIntDesc(IntMetaClassToCompareTo, 0, NextClassNameToLoad, NextClassNameToLoadDescr);

    if(bLogToGameLogfile) {
        Log("ServerHelper - GetClassesLoadedFromIntFiles - First INT file class name:"$NextClassNameToLoad);
    }

	while((NextClassNameToLoad != "") && (ClassIntNum < MaxClassIntNum)) {
	    if(LoadClasses) {
	        LoadedClass = class<Weapon>(DynamicLoadObject(NextClassNameToLoad, class'Class'));
	    } else {
	        LoadedClass = None;
	    }

        class'LGDUtilities.ClassObj'.static.PushClassOntoLinkedList(FoundClasses, LoadedClass, NextClassNameToLoad);

		ClassIntNum++;
		context.GetNextIntDesc(IntMetaClassToCompareTo, ClassIntNum, NextClassNameToLoad, NextClassNameToLoadDescr);

		if(bLogToGameLogfile) {
            Log("ServerHelper - GetClassesLoadedFromIntFiles - First INT file class name:"$NextClassNameToLoad);
        }
	}

    return FoundClasses;
}

static function int GetPing(Actor context) {
	if (context != None) {
		return int(context.ConsoleCommand("GETPING"));
	} else {
		return -1;
	}
}

static function byte GetPacketLoss(Actor context) {
	if (context != None) {
		return int(context.ConsoleCommand("GETLOSS"));
	} else {
		return -1;
	}
}

defaultproperties {
}
