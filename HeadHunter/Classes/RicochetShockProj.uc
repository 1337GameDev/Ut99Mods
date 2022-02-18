//=============================================================================
// RicochetShockProj
//=============================================================================
class RicochetShockProj extends Projectile;

var() Sound ExploSound;
var int NumWallHits;
var int MaxWallHits;
var bool bCanHitInstigator, bHitWater;

simulated function PostBeginPlay() {
	Super.PostBeginPlay();

	if(Level.bDropDetail) {
		LightType = LT_None;
	}

    SetTimer(0.2, false);
}

function SuperExplosion() {
	HurtRadius(Damage*3, 250, MyDamageType, MomentumTransfer*2, Location );

	Spawn(Class'ut_ComboRing',,'',Location, Instigator.ViewRotation);
	PlaySound(ExploSound,,20.0,,2000,0.6);

	Destroy();
}

auto state Flying {
	function ProcessTouch (Actor Other, vector HitLocation) {
	    //if we are flagged to be able to hit the "owner" player, OR we hit another player / hit a projectil / another object that has a collision radius > 0
	    if((bCanHitInstigator || (Other!=Instigator)) && (!Other.IsA('Projectile') || (Other.CollisionRadius > 0)) ) {
			Explode(HitLocation,Normal(HitLocation-Other.Location));
		}
	}

    simulated function ZoneChange(Zoneinfo NewZone) {
		local Splash w;

		if(!NewZone.bWaterZone || bHitWater) {
            return;
        }

		bHitWater = True;

		if(Level.NetMode != NM_DedicatedServer) {
			w = Spawn(class'Splash',,,,rot(16384,0,0));
			w.DrawScale = 0.5;
			w.RemoteRole = ROLE_None;
		}

		Velocity=0.6*Velocity;
	}

	function BeginState() {
	    SetTimer(0.2, false);
		SetUp();

		if(Level.NetMode != NM_DedicatedServer) {
			if(Level.NetMode == NM_Standalone) {
				SoundPitch = 200 + 50 * FRand();
			}
		}

		Velocity = vector(Rotation) * speed;
	}

	simulated function SetRoll(vector NewVelocity) {
		local rotator newRot;

		newRot = rotator(NewVelocity);
		SetRotation(newRot);
	}

	simulated function HitWall (vector HitNormal, actor Wall) {
		local vector Vel2D, Norm2D;

		bCanHitInstigator = true;
		PlaySound(ImpactSound, SLOT_Misc, 2.0);

		if((Mover(Wall) != None) && Mover(Wall).bDamageTriggered) {
			if(Role == ROLE_Authority) {
				Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
			}

            Destroy();
			return;
		}

		NumWallHits++;
		SetTimer(0, False);
		MakeNoise(0.3);

		if(NumWallHits > MaxWallHits) {
			Destroy();
		}

		if(NumWallHits == 1) {
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
		}

		Velocity -= 2 * (Velocity dot HitNormal) * HitNormal;
		SetRoll(Velocity);
	}

	function SetUp() {
		local vector X;

		X = vector(Rotation);
		Velocity = Speed * X;     // Impart ONLY forward vel

		if(Instigator.HeadRegion.Zone.bWaterZone) {
			bHitWater = True;
		}
	}

	simulated function Timer() {
		bCanHitInstigator = true;
	}
}

function Explode(vector HitLocation,vector HitNormal) {
	PlaySound(ImpactSound, SLOT_Misc, 0.5,,, 0.5+FRand());
	HurtRadius(Damage, 70, MyDamageType, MomentumTransfer, Location);

	if (Damage > 60) {
		Spawn(class'ut_RingExplosion3',,, HitLocation+HitNormal*8,rotator(HitNormal));
	} else {
		Spawn(class'ut_RingExplosion',,, HitLocation+HitNormal*8,rotator(Velocity));
    }

	Destroy();
}

defaultproperties
{
      ExploSound=Sound'UnrealShare.General.SpecialExpl'
      NumWallHits=0
      MaxWallHits=2
      bCanHitInstigator=False
      bHitWater=False
      speed=1500.000000
      Damage=35.000000
      MomentumTransfer=90000
      MyDamageType="jolted"
      ImpactSound=Sound'UnrealShare.General.Expla02'
      ExplosionDecal=Class'Botpack.EnergyImpact'
      bNetTemporary=False
      RemoteRole=ROLE_SimulatedProxy
      LifeSpan=5.000000
      DrawType=DT_Sprite
      Style=STY_Translucent
      Texture=Texture'Botpack.ASMDAlt.ASMDAlt_a00'
      DrawScale=0.400000
      bUnlit=True
      CollisionRadius=12.000000
      CollisionHeight=12.000000
      bProjTarget=True
      LightType=LT_Steady
      LightEffect=LE_NonIncidence
      LightBrightness=255
      LightHue=165
      LightSaturation=72
      LightRadius=6
      bBounce=True
      bFixedRotationDir=True
      RotationRate=(Pitch=45345,Yaw=33453,Roll=63466)
      DesiredRotation=(Pitch=23442,Yaw=34234,Roll=34234)
}
