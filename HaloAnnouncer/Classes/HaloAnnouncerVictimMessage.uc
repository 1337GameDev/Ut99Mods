class HaloAnnouncerVictimMessage extends VictimMessage;

static function float GetOffset(int Switch, float YL, float ClipY) {
	return (Default.YPos/768.0) * ClipY + 4*YL;
}

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
	//override in subclass
	return "";
}

defaultproperties {
	YPos=196.000000
}
