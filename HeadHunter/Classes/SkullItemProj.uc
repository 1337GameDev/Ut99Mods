//=============================================================================
// Grenade.
//=============================================================================
class SkullItemProj extends Projectile;

var bool bHitWater;
var float Count;
var Sound PickupSound;
var FlameFollower FlameActor;

var int MaxBouncesOnSteepSurface;
var float AngleForSteepSurface;

var int NumSteepBounces;

var HeadHunterGameInfo HHGameInfo;

simulated function PostBeginPlay() {
	Super.PostBeginPlay();

	if(Role == ROLE_Authority) {
		RandSpin(50000);

		if (Instigator.HeadRegion.Zone.bWaterZone) {
			bHitWater = True;
			Disable('Tick');
			Velocity = 0.6 * Velocity;
		}
	}

	CreateFlame();
}

simulated function PreBeginPlay() {
    HHGameInfo = HeadHunterGameInfo(Level.Game);
}

function CreateFlame() {
     local Vector FlamePos;

     if(FlameActor == None) {
         FlamePos = Self.Location;
         FlamePos.Z += (Self.CollisionHeight / 2.0) - 4;
         FlamePos = FlamePos - Self.Location;//used as an offset, not absolute position

         FlameActor = Spawn(class'LGDUtilities.FlameFollower', Self);
         if(FlameActor != None){
             FlameActor.PrePivot = FlamePos;
         }
     }
}

simulated function ZoneChange(Zoneinfo NewZone) {
	local waterring w;

	if(!NewZone.bWaterZone || bHitWater) {
	    return;
    }

	bHitWater = True;
	w = Spawn(class'WaterRing',,,,rot(16384,0,0));

	w.DrawScale = 0.2;
	w.RemoteRole = ROLE_None;
	Velocity = 0.6 * Velocity;
}

simulated function Tick(float DeltaTime) {
	if (bHitWater || Level.bDropDetail)  {
		Disable('Tick');
		return;
	}

	Count += DeltaTime;
}

simulated function Landed(Vector HitNormal) {
	HitWall(HitNormal, None);
}

simulated function ProcessTouch(Actor Touched, Vector HitLocation) {
	local Inventory skullInv;
    local SkullItem skull;
    local Pawn touchedPawn;
    touchedPawn = Pawn(Touched);

    if(touchedPawn != None) {
        if((touchedPawn.Health <= 0) || (touchedPawn.IsInState('Dying'))){
            return;
        }

        skullInv = Pawn(Touched).FindInventoryType(class'Headhunter.SkullItem');

        if(skullInv != None){
            skull = SkullItem(skullInv);
            //we already have a skull, so attempt to give us another
            if(skull.CanPickupMore()){
                skull.NumCopies++;

                if(Level.NetMode != NM_DedicatedServer) {
	    	        PlaySound(PickupSound,, 32.0);
	            }

                Destroy();
            } else {
                touchedPawn.ReceiveLocalizedMessage(class'HeadHunter.HeadHunterMaxSkullsMessage', 0);
                return;
            }
        } else {
            skull = Spawn(class'Headhunter.SkullItem',,,Location, Rotation);
            skull.NumCopies = 1;
            skull.GiveTo(Pawn(Touched));

            if(Level.NetMode != NM_DedicatedServer) {
	    	    PlaySound(PickupSound,, 32.0);
	        }

	        Destroy();
        }
	}
}

simulated function HitWall(Vector HitNormal, Actor Wall) {
	local SkullItem skull;
	local Vector PrevVelocity;
	local float degreesBetweenVectors;

	if(Level.NetMode != NM_DedicatedServer) {
		PlaySound(ImpactSound,, 32.0);
	}

    PrevVelocity = Velocity;
	Velocity = 0.75 * ((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
    speed = VSize(Velocity);

    if(speed < 20) {
	    degreesBetweenVectors = class'LGDUtilities.VectorHelper'.static.GetDegreesBetweenNormalizedVectors(Vect(0,0,1), HitNormal);

        if((degreesBetweenVectors <= AngleForSteepSurface) || (NumSteepBounces >= MaxBouncesOnSteepSurface)){
		    //create a SkullItem in place of this
		    skull = Spawn(class'Headhunter.SkullItem',,,Location,Rotation);

            if(skull != None){
		        skull.NumCopies = 1;

		        if((HHGameInfo != None) && (HHGameInfo.HHRepInfo != None) && HHGameInfo.HHRepInfo.ShowDroppedSkullIndicators) {
                    HHGameInfo.AddSkullItemIndicator(skull);
                }

		        Destroy();
		    }
		} else {
		    Velocity = PrevVelocity;
		    speed = VSize(Velocity);
            RandSpin(50000);
            NumSteepBounces++;
		}
	} else {
	    RandSpin(50000);
	    NumSteepBounces = 0;
	}
}


function Destroyed() {
	if(FlameActor != None) {
		FlameActor.Destroy();
	}

	if(HHGameInfo != None) {
        HHGameInfo.RemoveSkullItemProjIndicator(self);
    }

	Super.Destroyed();
}

defaultproperties {
      bHitWater=False
      Count=0.000000
      PickupSound=Sound'HeadHunter.SkullItem.SkullPickup'
      FlameActor=None
      MaxBouncesOnSteepSurface=8
      AngleForSteepSurface=45.000000
      NumSteepBounces=0
      HHGameInfo=None
      speed=700.000000
      MaxSpeed=700.000000
      MomentumTransfer=50
      ImpactSound=Sound'HeadHunter.SkullItem.SkullBounce'
      bAlwaysRelevant=True
      Physics=PHYS_Falling
      RemoteRole=ROLE_SimulatedProxy
      LifeSpan=0.000000
      LODBias=8.000000
      Mesh=LodMesh'HeadHunter.Skull'
      AmbientGlow=64
      bUnlit=True
      SoundRadius=16
      CollisionRadius=25.000000
      CollisionHeight=25.000000
      LightEffect=LE_NonIncidence
      LightBrightness=255
      LightHue=170
      LightSaturation=255
      LightRadius=2
      LightPeriod=64
      LightPhase=255
      bBounce=True
      Mass=3.000000
}
