//=============================================================================
// GuidedEnergyProj.
//=============================================================================
class GuidedEnergyProj extends UT_SeekingRocket;

var Weapon FiringWeapon;
var bool ProjectileSteeredByWeapon;
var int SteerVertically;
var int SteerHorizontally;

var int VerticalDegreeRotateSpeed;
var int HorizontalDegreeRotateSpeed;

var int NumWallHits;
var int MaxWallHits;
var bool bCanHitInstigator;

replication {
	// Relationships.
	reliable if(Role==ROLE_Authority)
		FiringWeapon;
}

simulated function Timer() {
	//local ut_SpriteSmokePuff b;
	local AnimSpriteEffect b;
	local PlayerPawn player;
	local int verticalDegreeChange, horizontalDegreeChange;

    if (bHitWater || (Level.NetMode == NM_DedicatedServer)) {
	    DetachFromGun();
		return;
    }

	if(ProjectileSteeredByWeapon) {
	    player = PlayerPawn(FiringWeapon.Owner);

	    if ((player != None) && (FiringWeapon != None) && (player.Weapon == FiringWeapon)) {
		    if(Self.SteerVertically > 0) {
			    verticalDegreeChange = Self.VerticalDegreeRotateSpeed;
			}
			if(Self.SteerHorizontally > 0) {
			    horizontalDegreeChange = Self.HorizontalDegreeRotateSpeed;
			}

            class'RotatorHelper'.static.RotateActorUpDownLeftRightByDegrees(Self, verticalDegreeChange, horizontalDegreeChange);
	    } else {
	        DetachFromGun();
	    }
	}

	if ((Level.bHighDetailMode && !Level.bDropDetail) || (FRand() < 0.5)) {
		//b = Spawn(class'ut_SpriteSmokePuff');
		b = Spawn(class'SpriteLightning',,,Location);
		b.RemoteRole = ROLE_None;
	}
}

function EnableGunControl() {
	SetPhysics(PHYS_None);
	ProjectileSteeredByWeapon = true;
}

function DisableGunControl() {
    SetPhysics(PHYS_Falling);
	ProjectileSteeredByWeapon = false;
}

function DetachFromGun() {
	FiringWeapon = None;
	SteerVertically = 0;
	SteerHorizontally = 0;

	DisableGunControl();
}

simulated function PostBeginPlay() {
	Super.PostBeginPlay();
	SetTimer(0.1, true);
}

///////////////////////////////////////////////////////
function BlowUp(vector HitLocation) {
	HurtRadius(damage, 200, MyDamageType, MomentumTransfer, HitLocation);
	MakeNoise(1.0);
}

simulated function Explosion(vector HitLocation, vector HitNormal) {
	//local UT_SpriteBallExplosion s;
    local AnimSpriteEffect s;
	BlowUp(HitLocation);

	if (Level.NetMode != NM_DedicatedServer) {
		Spawn(class'Botpack.BlastMark',,,,rot(16384,0,0));
  		//s = Spawn(class'UT_SpriteBallExplosion',,,HitLocation);
  		s = Spawn(class'ShockExplo',,,HitLocation);
		s.RemoteRole = ROLE_None;
		s.DrawScale = 2.5;
	}

 	Destroy();
}

///////////////////////////////////////
auto state Flying {
	simulated function ZoneChange(Zoneinfo NewZone) {
		local waterring w;

		if (!NewZone.bWaterZone || bHitWater) { return; }

		bHitWater = True;

		if (Level.NetMode != NM_DedicatedServer) {
			w = Spawn(class'WaterRing',,,,rot(16384,0,0));

			w.DrawScale = 0.2;
			w.RemoteRole = ROLE_None;
			PlayAnim('Still', 3.0);
		}

		Velocity = 0.6*Velocity;
	}

	simulated function ProcessTouch (Actor Other, Vector HitLocation) {
		if ((Other != instigator) && !Other.IsA('Projectile')) {
			Explosion(HitLocation, Normal(HitLocation-Other.Location));
		}
	}

	function BlowUp(vector HitLocation) {
		HurtRadius(Damage, 220.0, MyDamageType, MomentumTransfer, HitLocation);
		MakeNoise(1.0);
	}

	simulated function HitWall (vector HitNormal, actor Wall) {
		local vector Vel2D, Norm2D;

		bCanHitInstigator = true;
		PlaySound(ImpactSound, SLOT_Misc, 2.0);

		if((Mover(Wall) != None) && Mover(Wall).bDamageTriggered) {
			if(Role == ROLE_Authority) {
				Wall.TakeDamage(Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
			}

            Explode(Location, HitNormal);

			return;
		}

		NumWallHits++;
		SetTimer(0, False);
		MakeNoise(0.3);

		if(NumWallHits > MaxWallHits) {
			Explode(Self.Location, Normal(Self.Velocity));
		}

		Spawn(class'WallCrack',,,Location, rotator(HitNormal));

		Vel2D = Velocity;
		Vel2D.Z = 0;
		Norm2D = HitNormal;
		Norm2D.Z = 0;
		Norm2D = Normal(Norm2D);
		Vel2D = Normal(Vel2D);

		if((Vel2D Dot Norm2D) < -0.999) {
			HitNormal = Normal(HitNormal + 0.6 * Vel2D);
			Norm2D = HitNormal;
			Norm2D.Z = 0;
			Norm2D = Normal(Norm2D);

			if((Vel2D Dot Norm2D) < -0.999) {
				if(Rand(1) == 0) {
					HitNormal = HitNormal + vect(0.05,0,0);
				} else {
					HitNormal = HitNormal - vect(0.05,0,0);
				}

				if(Rand(1) == 0) {
					HitNormal = HitNormal + vect(0,0.05,0);
				} else {
					HitNormal = HitNormal - vect(0,0.05,0);
				}

				HitNormal = Normal(HitNormal);
			}
		}

		Velocity -= 2 * (Velocity dot HitNormal) * HitNormal;
	}

	function BeginState() {
		local vector Dir;

		Dir = vector(Rotation);
		Velocity = speed * Dir;
		Acceleration = Dir * 50;

		if (Region.Zone.bWaterZone) {
			bHitWater = True;
			Velocity = 0.6*Velocity;
		}
	}

	simulated function Explode(vector HitLocation, vector HitNormal) {
		//local UT_SpriteBallExplosion s;
		local AnimSpriteEffect s;

		s = spawn(class'ShockExplo',,,HitLocation + HitNormal*16);
 		s.RemoteRole = ROLE_None;
        s.DrawScale = 2.5;

		BlowUp(HitLocation);

 		Destroy();
	}
}

defaultproperties {
      bCanHitInstigator=False
      Seeking=None
      InitialDir=(X=0.000000,Y=0.000000,Z=0.000000)
      LifeSpan=20.000000
	  Physics=PHYS_Falling
	  VerticalDegreeRotateSpeed=5
	  HorizontalDegreeRotateSpeed=5
	  ProjectileSteeredByWeapon=false
	  SteerVertically=0
	  SteerHorizontally=0
	  NumWallHits=0
      MaxWallHits=1

	  AmbientSound=Sound'UnrealShare.Dispersion.DispFly'
      Mesh=LodMesh'Botpack.ShockRWM'
      DrawScale=0.5
      MyDamageType="jolted"
      SpawnSound=Sound'UnrealShare.Skaarj.Skrjshot'
      ImpactSound=Sound'UnrealShare.General.DispEX1'
      ExplosionDecal=Class'Botpack.EnergyImpact'
      AnimSequence=""
      speed=1500.000000
      Damage=35.000000
      MomentumTransfer=90000
      Mass=100.000000
}
