//
// Messages common to HeadHunterMessage derivatives.
//
// Switch 0: OverTime
//
// Switch 1: Entered game.
//	RelatedPRI_1 is the player.
//
// Switch 2: Name change.
//	RelatedPRI_1 is the player.
//
// Switch 3: Team change.
//	RelatedPRI_1 is the player.
//	OptionalObject is a TeamInfo.
//
// Switch 4: Left game.
//	RelatedPRI_1 is the player.
//
// Switch 5: Skulls collecting countdown
//	OptionalObject is an IntObj representing the seconds until skull collection
//
// Switch 6: Skulls collecting NOW


class HeadHunterMessage expands CriticalEventPlus;

var localized string OvertimeMessage;
var localized string GlobalNameChange;
var localized string NewTeamMessage;
var localized string NewTeamMessageTrailer;

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	switch (Switch)
	{
		case 0://overtime
			return Default.OverTimeMessage;
			break;
		case 1:
			if (RelatedPRI_1 == None)
				return "";

			return RelatedPRI_1.PlayerName$class'GameInfo'.Default.EnteredMessage;
			break;
		case 2://entered game
			if (RelatedPRI_1 == None)
				return "";

			return RelatedPRI_1.OldName@Default.GlobalNameChange@RelatedPRI_1.PlayerName;
			break;
		case 3://team change
			if (RelatedPRI_1 == None)
				return "";
			if (OptionalObject == None)
				return "";

			return RelatedPRI_1.PlayerName@Default.NewTeamMessage@TeamInfo(OptionalObject).TeamName$Default.NewTeamMessageTrailer;
			break;
		case 4://left game
			if (RelatedPRI_1 == None)
				return "";

			return RelatedPRI_1.PlayerName$class'GameInfo'.Default.LeftMessage;
			break;
		case 5://skulls collecting countdown
			if (OptionalObject == None)
				return "";

			return "Skulls collecting in "$IntObj(OptionalObject).Value$" seconds.";
			break;
		case 6://skulls collecting NOW
			return "Skulls collected!";
			break;
	}
	return "";
}

static simulated function ClientReceive( 
	PlayerPawn P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	if(Switch == 6) {
	    Log("HeadHunterMessage - ClientRecieve - collecting skulls message switch");
	}

	//P.ClientPlaySound(sound'Announcer.FirstBlood',, true);
}

defaultproperties
{
      OvertimeMessage="Score tied at the end of regulation. Sudden Death Overtime!!!"
      GlobalNameChange="changed name to"
      NewTeamMessage="is now on"
      NewTeamMessageTrailer=""
}
