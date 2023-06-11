//--------------------------------------------------
// A class that's used by HaloAnnouncer and other mods/gametypes to look at tracked data
// THEN trigger LocalMessage class being sent to PlayerPawns.
//--------------------------------------------------
class HaloKillingSpreeMessageSender extends Object;

function TriggerSendingMessages(HaloStatsPlayerReplicationInfo killerStats, HaloStatsPlayerReplicationInfo victimStats, bool OnlyInvolvedPlayers, bool IsSuicide, bool IsBetrayal, Name DamageType) {
	//trigger messages to be shown to players here
	//call: PlayerPawn.ReceiveLocalizedMessage(class'LocalMessage', Num, Victim.PlayerReplicationInfo, Killer.PlayerReplicationInfo );
}