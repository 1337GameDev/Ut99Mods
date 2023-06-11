class LocalMessageQueue extends Actor nousercreate;

var PlayerPawn PlayerPawnOwner;
var LinkedList LocalMessageQueue;

final static function LocalMessageQueue GetInstance(PlayerPawn pawnOwner) {
    local LocalMessageQueue q;

    if(pawnOwner != None) {
        q = pawnOwner.Spawn(class'LGDUtilities.LocalMessageQueue');
		q.PlayerPawnOwner = pawnOwner;
        q.LocalMessageQueue = new class'LGDUtilities.LinkedList';
    }

    return q;
}

function AddMessageToQueue(LocalMessageToSendSettings messageData) {
	if((LocalMessageQueue != None) && (messageData != None)) {
		LocalMessageQueue.Enqueue(messageData);
		Enable('Timer');
		SetTimer(0.1, False);
	}
}

function Timer() {
	local ListElement le;
	local LocalMessageToSendSettings messageSettings;
	local float MessageLength;
	
	if((LocalMessageQueue == None) || (LocalMessageQueue.Count == 0)) {
		Disable('Timer');
	} else {
		le = LocalMessageQueue.Dequeue();
		messageSettings = LocalMessageToSendSettings(le.Value);
		
		if((messageSettings != None) && (messageSettings.LocalMessageClass != None) && (PlayerPawnOwner != None)) {
			MessageLength = messageSettings.LocalMessageClass.default.Lifetime;
			SetTimer(MessageLength+messageSettings.SecsTimeMargin, False);
		} else {
			SetTimer(0, False);
		}
	}
}

defaultproperties {}
