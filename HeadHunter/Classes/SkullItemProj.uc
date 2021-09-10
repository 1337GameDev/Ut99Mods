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

//test vars
var bool performTestSpawn;
var bool firstBounce;

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

function CreateFlame() {
     local Vector FlamePos;

     if(FlameActor == None) {
         FlamePos = Self.Location;
         FlamePos.Z += (Self.CollisionHeight / 2.0) - 4;
         FlamePos = FlamePos - Self.Location;//used as an offset, not absolute position

         FlameActor = Spawn(class'HeadHunter.FlameFollower', Self);
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

simulated function ProcessTouch(Actor Other, Vector HitLocation) {
	local Inventory skullInv;
    local SkullItem skull;

    if(Pawn(Other) != None) {
        skullInv = Pawn(Other).FindInventoryType(class'Headhunter.SkullItem');

        if(skullInv != None){
            skull = SkullItem(skullInv);

            //we already have a skull, so attempt to give us another
            if(skull.CanPickupMore()){
                skull.NumCopies++;

                if(Level.NetMode != NM_DedicatedServer) {
	    	        PlaySound(PickupSound, SLOT_Misc, 1.5);
	            }

                Destroy();
            }
        } else {
            skull = Spawn(class'Headhunter.SkullItem',,,Location, Rotation);
            skull.GiveTo(Pawn(Other));

            if(Level.NetMode != NM_DedicatedServer) {
	    	    PlaySound(PickupSound, SLOT_Misc, 1.5);
	        }

	        Destroy();
        }
	}
}

simulated function HitWall(Vector HitNormal, Actor Wall) {
	local SkullItem skull;
	local Vector PrevVelocity;
	local float degreesBetweenVectors;

	//test vars
	local int spawnedSkullAmount;

	if(Level.NetMode != NM_DedicatedServer) {
		PlaySound(ImpactSound, SLOT_Misc, 1.5);
	}

	if(firstBounce && performTestSpawn) {
        spawnedSkullAmount = class'SkullItem'.static.SpawnNumberFromPoint(Self, Self.Location, 4, Vect(0,0,1) * 150);
	}

    firstBounce = false;

    PrevVelocity = Velocity;
	Velocity = 0.75 * (( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
    speed = VSize(Velocity);

    if(speed < 20) {
	    degreesBetweenVectors = class'VectorHelper'.static.GetDegreesBetweenNormalizedVectors(Vect(0,0,1), HitNormal);

        if((degreesBetweenVectors <= AngleForSteepSurface) || (NumSteepBounces >= MaxBouncesOnSteepSurface)){
		    //create a SkullItem in place of this
		    Destroy();
		    skull = Spawn(class'Headhunter.SkullItem',,,Location,Rotation);
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

	Super.Destroyed();
}

defaultproperties {
     //test vars
     firstBounce=true,
     performTestSpawn=false,

     speed=700.000000,
     MaxSpeed=700.000000,
     Damage=0.000000,
     Mass=3.000000,
     MomentumTransfer=50,
     MyDamageType=None,
     SoundRadius=16,
     ImpactSound=Sound'HeadHunter.SkullItem.SkullBounce',
     Physics=PHYS_Falling,
     RemoteRole=ROLE_SimulatedProxy,
     Mesh=LodMesh'Headhunter.Skull'
     AmbientGlow=64,
     bUnlit=True,
     LightEffect=LE_NonIncidence,
     LightBrightness=255,
     LightHue=170,
     LightSaturation=255,
     LightRadius=2,
     LightPeriod=64,
     LightPhase=255,
     bBounce=True,
     CollisionRadius=18.000000,
     CollisionHeight=15.000000,
     bAlwaysRelevant=True,
     LODBias=8.0,
     LifeSpan=0,
     PickupSound=Sound'HeadHunter.SkullItem.SkullPickup',
     AngleForSteepSurface=45,
     MaxBouncesOnSteepSurface=8
}
