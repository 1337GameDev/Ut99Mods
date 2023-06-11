//=============================================================================
// GuidedEnergyLance - A rocket launcher that has 2 special modes: Primary fire is a beam that steals the weapon of somebody it hits -- Alt fire is bouncy plasma balls.
//=============================================================================
class GuidedEnergyLance extends UT_Eightball;

//the distance the xy of the projectile has to be away from the center of the screen to be steered by the weapon
var int DistanceFromCenterToSteer;

var GuidedEnergyProj ProjectileToSteer;
var bool ControllingProjectile;

var float TimeHoldingAltFire;

function AltFire(float Value) {
	if(Owner == None) {
		return;
	}
}

function Fire(float Value) {
	if(AmmoType == None) {
		// ammocheck
		GiveAmmo(Pawn(Owner));
	}

	if(AmmoType.UseAmmo(1)) {
		bFireLoad = True;
		RocketsLoaded = 1;
		GotoState('');
		GotoState('FireRockets', 'Begin');
	} else if ((AmmoType.AmmoAmount <= 0) && (ProjectileToSteer == None)) {
		Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
	}
}

simulated function PostRender(Canvas C) {
	local PlayerPawn PawnOwner;
	local Vector AimTraceHitLoc, AimTraceHitNormal, StartTraceLoc, EndTraceLoc;
	local Actor TraceHitActor;

	PawnOwner = PlayerPawn(Owner);

	if(PawnOwner == None) {
	    return;
	}

    //Set "bLockedOn" to trigger the lock on reticle
	bLockedOn = ControllingProjectile;
	Super.PostRender(C);
	//reset "bLockedOn" variable
	bLockedOn = false;

    if(ProjectileToSteer != None) {
		if(ControllingProjectile) {
		    class'LGDUtilities.WeaponHelper'.static.FindTracePointsOfWeapon(self,100000, StartTraceLoc, EndTraceLoc);

			TraceHitActor = Trace(AimTraceHitLoc, AimTraceHitNormal, EndTraceLoc, StartTraceLoc, true);
			if(TraceHitActor != None){
                ProjectileToSteer.TargetLocation = AimTraceHitLoc;
            }

			ProjectileToSteer.ProjectileSteeredByWeapon = true;
		} else {
			ProjectileToSteer.ProjectileSteeredByWeapon = false;
		}
	}
}
simulated event RenderTexture(ScriptedTexture Tex) {
	local Color C;
	local string Temp;

	if (AmmoType != None) {
		Temp = String(AmmoType.AmmoAmount);
    }

	while(Len(Temp) < 3) {
        Temp = "0"$Temp;
    }

	C.R = 199;
	C.G = 36;
	C.B = 177;

	Tex.DrawColoredText(2, 10, Temp, Font'LEDFont2', C);
}

function Tick(float DeltaTime) {
    local Pawn PawnOwner;
    local PlayerPawn PlayerOwner;

    PawnOwner = Pawn(Owner);
    PlayerOwner = PlayerPawn(Owner);

    if((PawnOwner == None) || !bWeaponUp){
        Disable('Tick');
    } else {
        if(PawnOwner.bAltFire != 0) {
             TimeHoldingAltFire += DeltaTime;

             if(TimeHoldingAltFire >= AltRefireRate) {
                 ControllingProjectile = !ControllingProjectile;
                 TimeHoldingAltFire = 0;

                 if ((PlayerOwner != None) && (PlayerOwner.Player != None) && PlayerOwner.Player.IsA('ViewPort')) {
			         //fov is between 1 and 170
		             if(ControllingProjectile) {
                         PlayerOwner.DesiredFOV = 50;
                     } else {
                         PlayerOwner.DesiredFOV = PlayerOwner.DefaultFOV;
			             PlayerOwner.bZooming = false;
                     }
                 }


             }
        }
	}
}

simulated function PlayRFiring(int num) {
	if (Owner.IsA('PlayerPawn')) {
		PlayerPawn(Owner).shakeview(ShakeTime, ShakeMag*RocketsLoaded, ShakeVert); //shake player view
		PlayerPawn(Owner).ClientInstantFlash(-0.4, vect(650, 450, 190));
	}

	if (Affector != None) {
		Affector.FireEffect();
	}

	if (bFireLoad) {
		PlayOwnedSound(Class'GuidedEnergyLance.GuidedEnergyProj'.Default.SpawnSound, SLOT_None, 4.0*Pawn(Owner).SoundDampening);
	}

	if (bFireLoad && bInstantRocket) {
		PlayAnim(FireAnim[num], 0.54, 0.05);
	} else {
		PlayAnim(FireAnim[num], 0.6, 0.05);
	}
}

///////////////////////////////////////////////////////
state FireRockets {
	function Fire(float F) {}

	function ForceFire() {
		bForceFire = true;
	}

	function ForceAltFire() {
		bForceAltFire = true;
	}

	function bool SplashJump() {
		return false;
	}

	function BeginState() {
		local vector StartLoc, X,Y,Z;
		local GuidedEnergyProj r;
		local Pawn PawnOwner;
		local PlayerPawn PlayerOwner;

		PawnOwner = Pawn(Owner);
		if (PawnOwner == None) {
			return;
		}

		PawnOwner.PlayRecoil(FiringSpeed);
		PlayerOwner = PlayerPawn(Owner);

		if (PlayerOwner == None) {
			bTightWad = (FRand() * 4 < PawnOwner.skill);
		}

		GetAxes(PawnOwner.ViewRotation, X, Y, Z);
		StartLoc = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;

        AdjustedAim = PawnOwner.AdjustAim(ProjectileSpeed, StartLoc, AimError, True, bWarnTarget);

		if (PlayerOwner != None) {
			AdjustedAim = PawnOwner.ViewRotation;
        }

		PlayRFiring(0);
		Owner.MakeNoise(PawnOwner.SoundDampening);

		bPendingLock = false;
		bPointing = true;

		r = Spawn(Class'GuidedEnergyLance.GuidedEnergyProj',, '', StartLoc, AdjustedAim);
		if (r != none) {
		    ProjectileToSteer = r;
			ProjectileToSteer.FiringWeapon = Self;
		}

		RocketsLoaded = 0;
		bTightWad = false;
		bRotated = false;
	}

	function AnimEnd() {
	    local Pawn PawnOwner;
		PawnOwner = Pawn(Owner);

		if (!bRotated && (AmmoType.AmmoAmount > 0)) {
			PlayLoading(1.5, 0);
			RocketsLoaded = 1;
			bRotated = true;
			return;
		}

		LockedTarget = None;
		Finish();

		if (PawnOwner.bAltFire != 0) {
		    //if alt fire was pressed, we didn't transition to another state and should
			PawnOwner.StopFiring();
			GotoState('Idle');
		}
	}
Begin:
}

///////////////////////////////////////////////////////
state Idle {
Begin:
	if (Pawn(Owner).bFire != 0) {
	    Fire(0.0);
	}

	bPointing = False;

	if ((AmmoType.AmmoAmount<=0) && (ProjectileToSteer == None)) {
		Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
	}

	PlayIdleAnim();
	LockedTarget = None;
	bLockedOn = False;
}

State DownWeapon {
    ignores Fire, AltFire, AnimEnd;

	function BeginState() {
	    local PlayerPawn PawnOwner;
		PawnOwner = PlayerPawn(Owner);

		Super.BeginState();
		bCanClientFire = false;

		LockedTarget = None;
		bLockedOn = False;
        ControllingProjectile = False;

		if(ProjectileToSteer != None) {
		    ProjectileToSteer.DetachFromGun();
			ProjectileToSteer = None;
		}

		if ((PawnOwner.Player != None) && PawnOwner.Player.IsA('ViewPort')) {
			PawnOwner.DesiredFOV = PawnOwner.DefaultFOV;
			PawnOwner.bZooming = false;
		}
		
		Disable('Tick');
	}
}

state Active {
	function Fire(float F){}
	function AltFire(float F){}

	function bool PutDown() {
	    ControllingProjectile = False;

		if (bWeaponUp || (AnimFrame < 0.75)) {
			GotoState('DownWeapon');
		} else {
			bChangeWeapon = true;
        }

		return True;
	}

	function BeginState() {
		bChangeWeapon = false;
	}

Begin:
	FinishAnim();
	if (bChangeWeapon) {
		GotoState('DownWeapon');
	}

	bWeaponUp = True;
	Enable('Tick');

	PlayPostSelect();
	FinishAnim();
	Finish();
}

defaultproperties {
      WeaponDescription="Classification: Energy Lance\\n\\nPrimary Fire: Instant hit laser beam that steals the targets weapon.\\n\\nSecondary Fire: Large, slow moving plasma balls, that ricochet off walls.\\n\\nTechniques: Hitting the secondary fire plasma balls with the regular fire's laser beam will cause an immensely powerful explosion. You can even aim the plasma balls around corners or bounce them in hallways to block a path."
	  PickupMessage="You got the Guided Energy Lance."
      ItemName="Guided Energy Lance"
      DistanceFromCenterToSteer=10
      bAlwaysInstant=true
	  AltRefireRate=0.5

      ControllingProjectile=false

      SelectSound=Sound'UnrealShare.Eightball.Selecting'
      AltFireSound=Sound'UnrealShare.Eightball.EightAltFire'
      PickupAmmoCount=6
      ProjectileClass=Class'GuidedEnergyLance.GuidedEnergyProj'
      AltProjectileClass=Class'GuidedEnergyLance.GuidedEnergyProj'

      CockingSound=None
      SelectSound=Sound'UnrealShare.Eightball.Selecting'
      Misc3Sound=None
}
