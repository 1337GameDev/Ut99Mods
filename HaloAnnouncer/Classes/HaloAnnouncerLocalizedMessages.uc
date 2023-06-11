class HaloAnnouncerLocalizedMessages expands CriticalEventLowPlus;

var() localized String NotReplacingDeathMessageStr;

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (Switch == 1) {
		Log("HaloAnnouncerLocalizedMessages - GetString - Switch == 1");
		return Default.NotReplacingDeathMessageStr;
	}
	
	return "";
}

defaultproperties {
      NotReplacingDeathMessageStr="The current gametype has a property called \\"UseHaloAnnouncer\\" so replacing the DeathMessageClass was skipped."
}
