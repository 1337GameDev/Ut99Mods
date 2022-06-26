// A message from: SkullItem.
// Represents a message when a player cannot pick up any more skulls.
//
class HeadHunterMaxSkullsMessage extends LocalMessagePlus;

static function float GetOffset(int Switch, float YL, float ClipY) {
	return ClipY - YL - (64.0/768)*ClipY;
}

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	) {

    return "You cannot pick up any more skulls.";
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
