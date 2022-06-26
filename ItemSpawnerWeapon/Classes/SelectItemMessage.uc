// A message from: ItemSpawnerWeapon.SelectNextClassToSpawn
// SelectItemMessage is a message indicating what item is selected
//
class SelectItemMessage extends LocalMessagePlus;

static function float GetOffset(int Switch, float YL, float ClipY) {
	return ClipY - YL - (64.0/768)*ClipY;
}

//
// OptionalObject is a Class<Actor>
//
static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	) {
	if ((OptionalObject != None)){
        //this message is for the class that will be spawned
        return "Selected "$Class<Actor>(OptionalObject).Name;
	}

    return "Selected Nothing";
}

defaultproperties {
      FontSize=1
      bIsSpecial=True
      bIsUnique=True
      bFadeMessage=True
      Lifetime=4
      YPos=64.000000
      bCenter=True
}
