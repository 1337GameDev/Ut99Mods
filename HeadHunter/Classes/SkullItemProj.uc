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

simulated function ProcessTouch(Actor Touched, Vector HitLocation) {
	local Inventory skullInv;
    local SkullItem skull;
    local Pawn touchedPawn;
    touchedPawn = Pawn(Touched);

    if(touchedPawn != None) {
        if((touchedPawn.Health <= 0) || (touchedPawn.IsInState('Dying'))){
            return;
        }

        //Log("SkullItemProj - ProcessTouch - Touched: "$Touched.Name);
        skullInv = Pawn(Touched).FindInventoryType(class'Headhunter.SkullItem');

        if(skullInv != None){
            skull = SkullItem(skullInv);
            //Log("SkullItemProj - ProcessTouch - Pawn already has skull");
            //we already have a skull, so attempt to give us another
            if(skull.CanPickupMore()){
                //Log("SkullItemProj - ProcessTouch - Pawn \""$Touched.Name$"\" CAN pickup more skulls, as they had:"$skull.NumCopies);
                skull.NumCopies++;

                if(Level.NetMode != NM_DedicatedServer) {
	    	        PlaySound(PickupSound,, 32.0);
	            }

                Destroy();
            } else {
                //Log("SkullItemProj - ProcessTouch - Pawn \""$Touched.Name$"\" can NOT pickup more skulls");
                touchedPawn.ReceiveLocalizedMessage(class'HeadHunterMaxSkullsMessage', 0);
                return;
            }
        } else {
            //Log("SkullItemProj - ProcessTouch - Pawn \""$Touched.Name$"\" did not have any skulls, so pick this up");

            skull = Spawn(class'Headhunter.SkullItem',,,Location, Rotation);
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
	Velocity = 0.75 * (( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
    speed = VSize(Velocity);

    if(speed < 20) {
	    degreesBetweenVectors = class'VectorHelper'.static.GetDegreesBetweenNormalizedVectors(Vect(0,0,1), HitNormal);

        if((degreesBetweenVectors <= AngleForSteepSurface) || (NumSteepBounces >= MaxBouncesOnSteepSurface)){
		    //create a SkullItem in place of this
		    skull = Spawn(class'Headhunter.SkullItem',,,Location,Rotation);
		    if(skull != None){
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
