class CollectDogTagMessage extends VictimMessage;

var localized string KillConfirmed;
var localized string KillDenied;

//
// Messages for a person who collects a dogtag
//
// Switch 0: Invalid
//
// Switch 1: Kill Confirmed (collected a DogTagItem of an enemy)
//	CollectorPRI is the person who collected the dogtags.
//	NOT USED - Always None
//  OptionalObject is an instance of DogTagItem 
//
// Switch 2: Kill Denied (collected a DogTagItem of a friendly/theirself)
//	CollectorPRI is the person who collected the dogtags.
//	NOT USED - Always None
//  OptionalObject is an instance of DogTagItem 

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo CollectorPRI,
	optional PlayerReplicationInfo NotUsed,
	optional Object OptionalObject 
	)
{	
	if (CollectorPRI == None) {
		return "";
	}
		
	if (Switch == 1) {
		Default.DrawColor = class'LGDUtilities.ColorHelper'.default.RedColor;
		return Default.KillConfirmed;
	} else if(Switch == 2) {
		Default.DrawColor = class'LGDUtilities.ColorHelper'.default.BlueColor;
		return Default.KillDenied;
	}
	
	return "";
}

defaultproperties {
      KillConfirmed="Kill Confirmed!"
      KillDenied="Kill Denied!"
	  Lifetime=2
	  FontSize=3
}
