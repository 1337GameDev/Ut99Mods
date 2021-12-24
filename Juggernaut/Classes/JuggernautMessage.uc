// A message from: JuggernautMessage.
// JuggernautMessage is a message indicating a player has become the Juggernaut (or announces who became a Juggernaut)
//
class JuggernautMessage extends CriticalEventPlus;

var localized string PlayerBecameJuggernautMessage;
var localized string YouHaveBecomeAJuggernautMessage;

static function float GetOffset(int Switch, float YL, float ClipY) {
	return ClipY - YL - (64.0/768)*ClipY;
}

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (RelatedPRI_1 == None)
		return "";
	if (RelatedPRI_1.PlayerName == "")
		return "";
	return RelatedPRI_1.PlayerName@Default.PlayerBecameJuggernautMessage;
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

	if (RelatedPRI_1 != P.PlayerReplicationInfo)
		return;

	P.ClientMessage(Default.YouHaveBecomeAJuggernautMessage);
}

defaultproperties {
     FontSize=1
     bIsSpecial=True
     bIsUnique=True
     bFadeMessage=True
     YPos=64.000000
     bCenter=True
     Lifetime=4
     DrawColor=(R=255,G=0,B=0)
	 PlayerBecameJuggernautMessage=" has become a Juggernaut!",
	 YouHaveBecomeAJuggernautMessage="You have become The Juggernaut!"
	 bBeep=False
}
