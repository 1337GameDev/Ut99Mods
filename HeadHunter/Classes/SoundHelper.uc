class SoundHelper extends Actor nousercreate;

/***********************************************************************
*  FETCHED FROM: FlagAnnouncements                                     *
*  Author - The_Cowboy                                                 *
*  Special thanks to Feralidragon , Spongebob and Anthrax              *
***********************************************************************/
// =============================================================================
// DynamicLoadSound ~ Load a sound from a package
// =============================================================================

function bool DynamicLoadSound (out Sound SoundObj, string SoundPackage, string SoundName) {
    SoundObj = Sound(DynamicLoadObject(SoundPackage$"."$SoundName, class'sound', true));

    if (SoundObj == None) {
        return false;
    } else {
        return true;
	}
}

//Play a sound client side (so only client will hear it
simulated static function ClientPlaySound(PlayerPawn pp, sound ASound, optional bool bInterrupt, optional bool bVolumeControl, optional float VolumeLevel) {
	local Actor SoundPlayer;

    if(pp == None){
        return;
    }

    VolumeLevel = FClamp(VolumeLevel, 0.1, 200.0);

	pp.LastPlaySound = pp.Level.TimeSeconds;	// so voice messages won't overlap
	if (pp.ViewTarget != None) {
		SoundPlayer = pp.ViewTarget;
	} else {
		SoundPlayer = pp;
    }

	SoundPlayer.PlaySound(ASound, pp.ESoundSlot.SLOT_None, VolumeLevel, bInterrupt);
	SoundPlayer.PlaySound(ASound, pp.ESoundSlot.SLOT_Interface, VolumeLevel, bInterrupt);
	SoundPlayer.PlaySound(ASound, pp.ESoundSlot.SLOT_Misc, VolumeLevel, bInterrupt);
	SoundPlayer.PlaySound(ASound, pp.ESoundSlot.SLOT_Talk, VolumeLevel, bInterrupt);
}

defaultproperties
{
}
