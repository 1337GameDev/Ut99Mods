//=============================================================================
// StealShockBeam
//=============================================================================
class StealShockBeam extends Projectile;
#exec TEXTURE IMPORT NAME=StealEnergyBeam FILE=Textures\Weapons\WeaponStealingShockRifle\EnergyBeam1.png GROUP="Projectiles" FLAGS=2

var vector MoveAmount;
var int NumPuffs;

replication {
	// Things the server should send to the client.
	unreliable if(Role==ROLE_Authority)
		MoveAmount, NumPuffs;
}

simulated function Tick(float DeltaTime) {
	if (Level.NetMode != NM_DedicatedServer){
		ScaleGlow = (Lifespan/Default.Lifespan)*1.0;
		AmbientGlow = ScaleGlow * 210;
	}
}


simulated function PostBeginPlay() {
	if (Level.NetMode != NM_DedicatedServer) {
		SetTimer(0.05, false);
	}
}

simulated function Timer() {
	local StealShockBeam r;

	if (NumPuffs>0) {
		r = Spawn(class'StealShockBeam',,,Location+MoveAmount);
		r.RemoteRole = ROLE_None;
		r.NumPuffs = NumPuffs -1;
		r.MoveAmount = MoveAmount;
	}
}

defaultproperties {
     Physics=PHYS_Rotating
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.270000
     Rotation=(Roll=20000)
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=Texture'Headhunter.Projectiles.StealEnergyBeam'
     Mesh=LodMesh'Botpack.Shockbm'
     DrawScale=0.440000
     bUnlit=True
     bParticles=True
     bFixedRotationDir=True
     RotationRate=(Roll=1000000)
     DesiredRotation=(Roll=20000)
}
