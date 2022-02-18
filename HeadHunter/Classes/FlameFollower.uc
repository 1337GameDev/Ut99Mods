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

defaultproperties
{
      MaxSpeedToTrailFlame=230.000000
      CurrentTimeInterval=0.000000
      UpdateIntervalSecs=0.001000
      AnimRate=2.000000
      DrawType=DT_Mesh
      Mesh=LodMesh'UnrealShare.FlameM'
      DrawScale=0.150000
      bUnlit=True
      bNoSmooth=True
      CollisionRadius=0.000000
      CollisionHeight=0.000000
      LightEffect=LE_FireWaver
      LightBrightness=40
      LightRadius=32
}
