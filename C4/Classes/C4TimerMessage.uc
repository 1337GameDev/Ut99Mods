// A message from: C4.C4Weapon.IncrementTimer
// C4TimerMessage is a message indicating what timer value is selected
//
class C4TimerMessage extends LocalMessagePlus;

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

    return "Timer set to...";
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
