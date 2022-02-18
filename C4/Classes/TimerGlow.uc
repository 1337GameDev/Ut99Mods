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

defaultproperties
{
      CurrentGlowBlinkTimeInterval=0.000000
      BlinkTime=0.100000
      bNetTemporary=False
      bTrailerPrePivot=True
      Physics=PHYS_Trailer
      RemoteRole=ROLE_SimulatedProxy
      DrawType=DT_Sprite
      Style=STY_Translucent
      Sprite=Texture'Botpack.Translocator.Tranglow'
      Texture=Texture'Botpack.Translocator.Tranglow'
      Skin=Texture'Botpack.Translocator.Tranglow'
      DrawScale=0.250000
      PrePivot=(X=-13.000000,Y=-13.000000,Z=14.000000)
}
