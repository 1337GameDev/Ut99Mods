//
// Messages common to JuggernautMessage derivatives.
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
// Switch 5: New Juggernaut!
//	RelatedPRI_1 is the player
//
// Switch 6: No Juggernaut! [Error]
//	


class JuggernautMessage expands CriticalEventPlus;

var localized string OvertimeMessage;
var localized string GlobalNameChange;
var localized string NewTeamMessage;
var localized string NewTeamMessageTrailer;
var localized string NewJuggernautText;
var localized string NoJuggernautText;

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
		case 5://new juggernaut
			if (RelatedPRI_1 == None)
				return "";

			return RelatedPRI_1.PlayerName@Default.NewJuggernautText;
			break;
		case 6://NO juggernaut
			return Default.NoJuggernautText;
			break;
	}
	return "";
}

defaultproperties {
      OvertimeMessage="Score tied at the end of regulation. Sudden Death Overtime!!!"
      GlobalNameChange="changed name to"
      NewTeamMessage="is now on"
      NewTeamMessageTrailer=""
      NewJuggernautText="is the new Juggernaut!"
      NoJuggernautText="No Juggernaut was chosen! Please restart the match!"
}
