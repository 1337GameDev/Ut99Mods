// A message from: WeaponStealingShockRifle.
// WeaponStolenMessage is a message indicating a player has had their weapon stolen from them
//
class WeaponStolenMessage extends LocalMessagePlus;

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
        //this message is for the VICTIM
        return "Your "$Inventory(OptionalObject).ItemName$" has been stolen!";
	}

    return "";
}

defaultproperties {
      FontSize=1
      bIsSpecial=True
      bIsUnique=True
      bFadeMessage=True
      Lifetime=4
      DrawColor=(G=0,B=0)
      YPos=64.000000
      bCenter=True
}
