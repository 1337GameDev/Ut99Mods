//--------------------------------------------------
// A class that's used to call PlayerPawn.ReceiveLocalizedMessage
//--------------------------------------------------
class LocalMessageToSendSettings extends Object;

var class<LocalMessage> LocalMessageClass;

var int SwitchValToSend;
var PlayerReplicationInfo RelatedPRI_1ToSend;
var PlayerReplicationInfo RelatedPRI_2ToSend;
var Object OptionalObjectToSend;

//a margin of time AFTER the message before playing another message in a LocalMessageQueue
var float SecsTimeMargin;

defaultproperties {
	SwitchValToSend=0,
	SecsTimeMargin=0.5
}
