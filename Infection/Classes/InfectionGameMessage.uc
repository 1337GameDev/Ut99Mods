//
// Messages common to Infection derivatives.
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
//	OptionalObject is a 'InfectionGameMessageInfoObj' (has 2 fields - 'TeamInfo' and 'InfectionGame').
//
// Switch 4: Left game.
//	RelatedPRI_1 is the player.

class InfectionGameMessage expands CriticalEventPlus;

var localized string OvertimeMessage;
var localized string GlobalNameChange;
var localized string NewTeamMessage;
var localized string NewTeamMessageTrailer;

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	) {
	
	local InfectionGameMessageInfoObj info;
	local byte PlayerTeamNum;
	
	switch (Switch)
	{
		case 0:
			return Default.OverTimeMessage;
			break;
		case 1:
			if (RelatedPRI_1 == None)
				return "";

			return RelatedPRI_1.PlayerName$class'GameInfo'.Default.EnteredMessage;
			break;
		case 2:
			if (RelatedPRI_1 == None)
				return "";

			return RelatedPRI_1.OldName@Default.GlobalNameChange@RelatedPRI_1.PlayerName;
			break;
		case 3:
			if (RelatedPRI_1 == None)
				return "";
			if (OptionalObject == None)
				return "";
			
			info = InfectionGameMessageInfoObj(OptionalObject);
			
			if(info == None) {
				return "";
			}
			
			PlayerTeamNum = RelatedPRI_1.Team;
			
			if(info.InfectionGame.NeutralTeam == PlayerTeamNum) {
				return "";
			} else if(info.InfectionGame.ZombieTeam == PlayerTeamNum) {
				return RelatedPRI_1.PlayerName@Default.NewTeamMessage@"Zombie"$Default.NewTeamMessageTrailer;
			} else if(info.InfectionGame.HumanTeam == PlayerTeamNum) {
				return RelatedPRI_1.PlayerName@Default.NewTeamMessage@"Human"$Default.NewTeamMessageTrailer;
			} else {
				return RelatedPRI_1.PlayerName@Default.NewTeamMessage@info.TeamInfo.TeamName$Default.NewTeamMessageTrailer;
			}
			
			break;
		case 4:
			if (RelatedPRI_1 == None)
				return "";

			return RelatedPRI_1.PlayerName$class'GameInfo'.Default.LeftMessage;
			break;
	}
	return "";
}

defaultproperties {
      OvertimeMessage="Score tied at the end of regulation. Sudden Death Overtime!!!"
      GlobalNameChange="changed name to"
      NewTeamMessage="is now a"
      NewTeamMessageTrailer="!"
}
