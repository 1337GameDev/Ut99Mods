// A message from: HeadHunterGameInfo.
// Represents a message when a player bags skulls to their score.
//
class HeadHunterScoredSkullsMessage extends LocalMessagePlus;

static function float GetOffset(int Switch, float YL, float ClipY) {
	return ClipY - YL - (64.0/768)*ClipY;
}

//
// OptionalObject is a SkullItem used for scoring
//
static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	) {
	if ((OptionalObject == None)){
        return "You scored "$SkullItem(OptionalObject).NumCopies$" points!";
	}

    return "";
}

defaultproperties {
     FontSize=1
     bIsSpecial=True
     bIsUnique=True
     bFadeMessage=True
     YPos=64.000000
     bCenter=True
     Lifetime=4
     DrawColor=(R=255,G=255,B=0)
}
