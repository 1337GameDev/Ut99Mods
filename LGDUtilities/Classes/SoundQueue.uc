class SoundQueue extends Actor nousercreate;

var PlayerPawn PlayerPawnOwner;
var LinkedList SoundQueue;

final static function SoundQueue GetInstance(PlayerPawn pawnOwner) {
    local SoundQueue q;

    if(pawnOwner != None) {
        q = pawnOwner.Spawn(class'LGDUtilities.SoundQueue');
		q.PlayerPawnOwner = pawnOwner;
        q.SoundQueue = new class'LGDUtilities.LinkedList';
    }

    return q;
}

function AddSoundToQueue(SoundToPlaySettings soundDataToPlay) {
	if((SoundQueue != None) && (soundDataToPlay != None)) {
		SoundQueue.Enqueue(soundDataToPlay);
		Enable('Timer');
		SetTimer(0.1, False);
	}
}

function Timer() {
	local ListElement le;
	local SoundToPlaySettings soundDataToPlay;
	local float SoundLength;
	
	if((SoundQueue == None) || (SoundQueue.Count == 0)) {
		Disable('Timer');
	} else {
		le = SoundQueue.Dequeue();
		soundDataToPlay = SoundToPlaySettings(le.Value);
		
		if((soundDataToPlay != None) && (soundDataToPlay.ASound != None) && (PlayerPawnOwner != None)) {
			class'LGDUtilities.SoundHelper'.static.ClientPlaySound(PlayerPawnOwner, soundDataToPlay.ASound, soundDataToPlay.bInterrupt, soundDataToPlay.bVolumeControl, soundDataToPlay.VolumeLevel);
			SoundLength = GetSoundDuration(soundDataToPlay.ASound);
			SetTimer(SoundLength+soundDataToPlay.SecsTimeMargin, False);
		} else {
			SetTimer(0, False);
		}
	}
}

defaultproperties {}
