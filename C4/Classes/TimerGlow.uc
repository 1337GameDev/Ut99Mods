//=============================================================================
// TimerGlow.
//=============================================================================
class TimerGlow extends Effects;

var float CurrentGlowBlinkTimeInterval;
var float BlinkTime;

simulated function StartBlink() {
    GotoState('Blinking');
}

state Blinking {
    simulated function Tick(float DeltaTime) {
		if(CurrentGlowBlinkTimeInterval > 0){
			CurrentGlowBlinkTimeInterval -= DeltaTime;

			if(CurrentGlowBlinkTimeInterval <= 0) {
				CurrentGlowBlinkTimeInterval = 0;
                GotoState('');
			}
		}
	}

	function BeginState() {
		CurrentGlowBlinkTimeInterval = BlinkTime;
        Self.DrawType = DT_None;
	}

	function EndState() {
		Self.DrawType = DT_Sprite;
	}
}

defaultproperties {
     BlinkTime=0.1,
     bNetTemporary=False
     Physics=PHYS_Trailer
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_Sprite
     Style=STY_Translucent
     Sprite=Texture'Botpack.Translocator.Tranglow'
     Texture=Texture'Botpack.Translocator.Tranglow'
     Skin=Texture'Botpack.Translocator.Tranglow'
     DrawScale=0.2500000
     bTrailerPrePivot=True
     PrePivot=(X=-13,Y=-13,Z=14.000000)
}
