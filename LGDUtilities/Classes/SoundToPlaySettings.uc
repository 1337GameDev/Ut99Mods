class SoundToPlaySettings extends Object;

var Sound ASound;
var bool bInterrupt;
var bool bVolumeControl;
var float VolumeLevel;

//a margin of time AFTER the sound before playing another sound in a SoundQueue
var float SecsTimeMargin;

defaultproperties {
	bInterrupt=true,
	bVolumeControl=false,
	VolumeLevel=16.0
	SecsTimeMargin=0.5
}
