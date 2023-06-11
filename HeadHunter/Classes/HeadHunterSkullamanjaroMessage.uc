// A message from: HeadHunterGameInfo.
// Represents a message when a player collects 10 or more skulls at once.
//
class HeadHunterSkullamanjaroMessage extends LocalMessagePlus;

static function float GetOffset(int Switch, float YL, float ClipY) {
	return ClipY - YL - (64.0/768)*ClipY;
}

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	) {

    return "Skullamanjaro!";
}

defaultproperties {
      FontSize=3
      bIsSpecial=True
      bIsUnique=True
      bFadeMessage=True
      Lifetime=4
      DrawColor=(R=255,G=103,B=0)
      YPos=64.000000
      bCenter=True
}
