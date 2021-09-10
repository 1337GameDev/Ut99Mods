// A message from: ItemSpawnerWeapon.SpawnSelectedClass
// CannotSpawnMessage is a message indicating an item cannot be spawned
//
class CannotSpawnMessage extends LocalMessagePlus;

static function float GetOffset(int Switch, float YL, float ClipY) {
	return ClipY - YL - (64.0/768)*ClipY;
}

//
// OptionalObject is a StringObj
//
static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	) {
	if ((OptionalObject != None)){
        //this message is for the class that will be spawned
        return StringObj(OptionalObject).Value;
	}

    return "Cannot Spawn Object";
}

defaultproperties {
     FontSize=1
     bIsSpecial=True
     bIsUnique=True
     bFadeMessage=True
     YPos=64.000000
     bCenter=True
     Lifetime=4
     DrawColor=(R=255, G=0, B=0)
}
