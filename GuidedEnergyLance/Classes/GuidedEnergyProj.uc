//=============================================================================
// GuidedEnergyProj.
//=============================================================================
class GuidedEnergyProj extends UT_SeekingRocket;

var GuidedEnergyLance FiringWeapon;
var bool ProjectileSteeredByWeapon;
var Vector TargetLocation;

var int NumWallHits;
var int MaxWallHits;
var bool bCanHitInstigator;

var float SeekingAcceleration;
var float SeekingDirBlendValue;//how much of the new direction should be added to the old? (0 -> 1 range)

var EffectFollower TrailingEffect;

replication {
	// Relationships.
	reliable if(Role==ROLE_Authority)
		FiringWeapon;
}

simulated function Destroyed() {
	if (TrailingEffect != None) {
		TrailingEffect.Destroy();
	}

	Super.Destroyed();
}

function PreBeginPlay() {
    TrailingEffect = Spawn(Class'LGDUtilities.EffectFollower', Self ,, Location);
	TrailingEffect.Mesh = LodMesh'Botpack.SparksM';
	TrailingEffect.Texture = Texture'Botpack.Effects.Sparky';
	TrailingEffect.DrawScale = 0.100000;
	TrailingEffect.DrawType = DT_Mesh;
    TrailingEffect.Style = STY_Translucent;
	TrailingEffect.bParticles = True;
    TrailingEffect.bCollideWorld = True;
	TrailingEffect.PlayAnim('Trail');
    TrailingEffect.bGameRelevant = True;

	TrailingEffect.BaseRotation.Pitch = class'LGDUtilities.MathHelper'.default.DegToUnrRot * -180;
	Self.PrePivot.X = -5;
}

simulated function Timer() {
	local AnimSpriteEffect b;
	local PlayerPawn player;
	local Vector SeekingDir;
	local float MagnitudeVel;

    if (bHitWater || (Level.NetMode == NM_DedicatedServer)) {
	    DetachFromGun();
		return;
    }

	if(InitialDir == Vect(0,0,0) ) {//store the original firing direction
		InitialDir = Normal(Velocity);
	}

	if(ProjectileSteeredByWeapon) {
	    if(FiringWeapon != None) {
			player = PlayerPawn(FiringWeapon.Owner);

			if ((player != None) && (player.Weapon == FiringWeapon)) {
			    SeekingDir = Normal(TargetLocation - Location);

				if((SeekingDir Dot InitialDir) > 0) {//if the projectile is going back gainst initial direction
                    MagnitudeVel = VSize(Velocity);
                    SeekingDir = Normal(SeekingDir * SeekingDirBlendValue * MagnitudeVel + Velocity);
				    Velocity =  MagnitudeVel * SeekingDir;
				    Acceleration = SeekingAcceleration * SeekingDir;

				    SetRotation(Rotator(Velocity));
                }
			} else {
				DetachFromGun();
			}
		} else {
		    ProjectileSteeredByWeapon = false;
		}
	}

	if ((Level.bHighDetailMode && !Level.bDropDetail) || (FRand() < 0.5)) {
		b = Spawn(class'ut_SpriteSmokePuff',,,Location);
		b.RemoteRole = ROLE_None;
		b = Spawn(class'UnrealShare.EnergyBurst',,,Location);
		b.RemoteRole = ROLE_None;
	}
}

function DetachFromGun() {
    Log("GuidedEnergyProj - DetachFromGun");
    if(FiringWeapon != None) {
		FiringWeapon.ProjectileToSteer = None;
		FiringWeapon = None;
        TargetLocation = Vect(0,0,0);
	}
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
    local AnimSpriteEffect s;
	BlowUp(HitLocation);

	if (Level.NetMode != NM_DedicatedServer) {
		Spawn(class'Botpack.BlastMark',,,,rot(16384,0,0));
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
		local AnimSpriteEffect s;

		s = spawn(class'ShockExplo',,,HitLocation + HitNormal*16);
 		s.RemoteRole = ROLE_None;
        s.DrawScale = 2.5;

		BlowUp(HitLocation);

 		Destroy();
	}
}

defaultproperties {
      InitialDir=(X=0.000000,Y=0.000000,Z=0.000000)
      bCanHitInstigator=False
      LifeSpan=20.000000
	  	Physics=PHYS_Falling
	  	ProjectileSteeredByWeapon=false
	  	NumWallHits=0
      MaxWallHits=1
      SeekingDirBlendValue=0.4
      SeekingAcceleration=45

	  	AmbientSound=Sound'UnrealShare.Dispersion.DispFly'
      Mesh=LodMesh'Botpack.ShockRWM'
      DrawScale=0.5
      MyDamageType="jolted"
      SpawnSound=Sound'UnrealShare.Skaarj.Skrjshot'
      ImpactSound=Sound'UnrealShare.General.DispEX1'
      ExplosionDecal=Class'Botpack.EnergyImpact'
      AnimSequence=""
      speed=1200.000000
      Damage=35.000000
      MomentumTransfer=90000
      Mass=100.000000
}
