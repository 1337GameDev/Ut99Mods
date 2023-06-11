class InfectionVictimMessage extends VictimMessage;

var localized string YouWereInfectedBy;

//
// Messages for an infection gametype victim
//
// Switch 0: Invalid
//
// Switch 1: Victim infected by zombie
//	KillerPRI is the KILLER of a player.
//	VictimPRI is the VICTIM.
//  OptionalObject is an instance of InfectionGameInfo
//


static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo KillerPRI,
	optional PlayerReplicationInfo VictimPRI,
	optional Object OptionalObject 
	)
{
	local InfectionGameInfo infGame;
	
	if ((KillerPRI == None) || (VictimPRI == None)) {
		return "";
	}
		
	if (KillerPRI.PlayerName != "") {
		//if a zombie killed this player
		infGame = InfectionGameInfo(OptionalObject);
		
		if(infGame != None) {
			if (Switch == 1) {
				Default.Lifetime = 5;
				Default.DrawColor = class'LGDUtilities.ColorHelper'.default.GreenColor;
				Default.FontSize = 3;
				return Default.YouWereInfectedBy@KillerPRI.PlayerName$Default.KilledByTrailer;
			} else {
				Default.Lifetime = 3;
				Default.DrawColor = class'LGDUtilities.ColorHelper'.default.BlackColor;
				Default.FontSize = 1;
				return Super.GetString(Switch, KillerPRI, VictimPRI, OptionalObject);
			}
		}
	}
	
	return "";
}

defaultproperties {
      YouWereInfectedBy="You were INFECTED by"
}
