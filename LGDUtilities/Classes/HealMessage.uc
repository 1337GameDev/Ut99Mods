// A message from: PawnHelper.HealPawn
// HealMessage is a message indicating a player has healed
//
class HealMessage extends LocalMessagePlus;

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
        //this message is for the person being healed
        return StringObj(OptionalObject).Value;
	}

    return "";
}

defaultproperties {
      FontSize=1
      bIsSpecial=True
      bIsUnique=True
      bFadeMessage=True
      Lifetime=4
      DrawColor=(R=0,G=0)
      YPos=64.000000
      bCenter=True
}
