//=============================================================================
// FlameFollower
//=============================================================================
class FlameFollower extends Actor;

var float MaxSpeedToTrailFlame;//the speed at which the flame is behind the skull (in unreal units)
var float CurrentTimeInterval;
var float UpdateIntervalSecs;

function PostBeginPlay() {
	SetTimer(UpdateIntervalSecs, True);
}

function UpdateFlame(){
    local Rotator DesiredFlameRotation;
    local Vector VectorOppositeVelocity;
    local float CurrentSpeed;
    local float PercentageToMaxSpeed;

    //now, calculate rotation based on vector speed
    VectorOppositeVelocity = Normal(Owner.Velocity);
    CurrentSpeed = VSize(Owner.Velocity);
    PercentageToMaxSpeed = FClamp(CurrentSpeed / MaxSpeedToTrailFlame, 0.0, 1.0);
    DesiredFlameRotation = Rotator(class'VectorHelper'.static.SLerpVector(VectorOppositeVelocity, Vect(0,0,1), PercentageToMaxSpeed));

    Self.SetRotation(DesiredFlameRotation);
    Self.SetLocation(Self.Owner.Location + Self.PrePivot);
}

simulated function Timer() {
     if((Owner == None) || Owner.bDeleteMe || (Owner.IsA('Inventory') && Inventory(Owner).bCarriedItem)) {
         Self.Destroy();
     } else {
         UpdateFlame();
     }
}

defaultproperties {
     UpdateIntervalSecs=0.001,
     MaxSpeedToTrailFlame=230,//in unreal units

     bStatic=False,
     bHidden=False,
     AnimRate=2.00000,
     DrawType=DT_Mesh,
     Mesh=LodMesh'UnrealShare.FlameM',
     bUnlit=True,
     LightEffect=LE_FireWaver,
     LightBrightness=40,
     LightRadius=32,
	 bCollideWorld=false,
	 bNoSmooth=true,
	 bCollideActors=false,
	 bMovable=true,
	 bNoDelete=false,
	 CollisionRadius=0,
	 CollisionHeight=0,
	 DrawScale=0.15,
	 Physics=PHYS_None

	 bTrailerPrePivot=false
	 bTrailerSameRotation=false
}

