//=============================================================================
// C4WeaponGhost - The ghost mesh indicator for where a C4 will be placed
//=============================================================================
class C4WeaponGhost extends Actor nousercreate;

var C4Weapon C4WeaponOwner;
var float UpdateIntervalSecs;
var float CurrentTimeInterval;

function Destroyed(){
	Super.Destroyed();
    C4WeaponOwner = None;
}

simulated function Tick(float DeltaTime) {
    local Pawn C4WepPawnOwner;

	CurrentTimeInterval += DeltaTime;

	if(CurrentTimeInterval >= UpdateIntervalSecs) {
		CurrentTimeInterval = 0;
		if((C4WeaponOwner != None) && (C4WeaponOwner.Owner != None)) {
            C4WepPawnOwner = Pawn(C4WeaponOwner.Owner);
        }

		if((C4WeaponOwner == None) || C4WeaponOwner.bDeleteMe) {
			Destroy();
		} else if(!C4WeaponOwner.bCarriedItem || C4WepPawnOwner == None || C4WepPawnOwner.Weapon != C4WeaponOwner){
		    C4WeaponOwner.DestroyGhost();
		}
	}
}

function UpdateTimer(int timerValue){
   local int mins, tens, ones;

   if(C4WeaponOwner != None){
       class'MathHelper'.static.Get3DigitTimerPartsFromSeconds(timerValue, mins, tens, ones);

       Self.MultiSkins[2] = class'C4.C4Weapon'.default.TimerDigitTextures[mins];
       Self.MultiSkins[3] = class'C4.C4Weapon'.default.TimerDigitTextures[tens];
       Self.MultiSkins[4] = class'C4.C4Weapon'.default.TimerDigitTextures[ones];
   }
}

function HideGhost(){
    Self.bHidden = true;
    Self.DrawType = DT_None;
}
function ShowGhost(){
    Self.bHidden = false;
    Self.DrawType = DT_Mesh;
}

defaultproperties {
     RemoteRole=ROLE_None,
     bUnlit=true,
     bNoSmooth=true,
     bBounce=false,
     SoundRadius=16,
     CollisionRadius=1,
     CollisionHeight=1,
     bCollideActors=true,
     bCollideWorld=true,
     RemoteRole=ROLE_SimulatedProxy
     Mass=0,
     Physics=PHYS_None,
     DrawType=DT_Mesh,
     Mesh=Mesh'C4.C4',

	 UpdateIntervalSecs=1.0
}

