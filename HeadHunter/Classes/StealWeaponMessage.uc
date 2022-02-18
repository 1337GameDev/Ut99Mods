// A message from: WeaponStealingShockRifle.
// StealWeaponMessage is a message indicating you have stolen an enemy's weapon.
//
class StealWeaponMessage extends LocalMessagePlus;

static function float GetOffset(int Switch, float YL, float ClipY) {
	return ClipY - YL - (64.0/768)*ClipY;
}

//
// OptionalObject is an Inventory
//
static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	) {
	if ((OptionalObject != None)){
        //this message is for the THIEF
        return "You stole "$Inventory(OptionalObject).ItemArticle$" "$Inventory(OptionalObject).ItemName$"!";
	}

    return "";
}

defaultproperties
{
      FontSize=1
      bIsSpecial=True
      bIsUnique=True
      bFadeMessage=True
      Lifetime=4
      DrawColor=(R=0,B=0)
      YPos=64.000000
      bCenter=True
}
