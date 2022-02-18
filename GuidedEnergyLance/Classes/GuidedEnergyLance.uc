//=============================================================================
// GuidedEnergyLance - A shock rifle that has 2 special modes: Primary fire is a beam that steals the weapon of somebody it hits -- Alt fire is bouncy plasma balls.
//=============================================================================
class GuidedEnergyLance extends UT_Eightball;

//the distance the xy of the projectile has to be away from the center of the screen to be steered by the weapon
var int DistanceFromCenterToSteer;

var GuidedEnergyProj ProjectileToSteer;
var bool ControllingProjectile;

function AltFire(float Value) {
	if(Owner == None) {
		return;
	}
    
	ControllingProjectile = true;
	if ((PlayerPawn(Owner) != None) && (PlayerPawn(Owner).Player != None) && PlayerPawn(Owner).Player.IsA('ViewPort')) {
		//PlayerPawn(Owner).ToggleZoom();
		//fov is between 1 and 170
		PlayerPawn(Owner).DesiredFOV = 30; 
	}
	
	Log("GuidedEnergyLance - AltFire - SET ControllingProjectile");
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
	}
}

function Actor CheckTarget() {
	return None;
}

function Tick(float DeltaTime) {
	if(Pawn(Owner).bAltFire != 0) {//alt fire held down
		ControllingProjectile = true;
	} else {
	    ControllingProjectile = false;
		
		if ((PlayerPawn(Owner) != None) && (PlayerPawn(Owner).Player != None) && PlayerPawn(Owner).Player.IsA('ViewPort')) {
			//PlayerPawn(Owner).StopZoom();
			PlayerPawn(Owner).DesiredFOV = PlayerPawn(Owner).DefaultFOV; 
			PlayerPawn(Owner).bZooming = false;
			
		}
	}
}

simulated function PostRender(Canvas C) {
    local int ProjectileXCoord, ProjectileYCoord, middleX, middleY;
	
    //Set "bLockedOn" to trigger the lock on reticle
	bLockedOn = ControllingProjectile;
	Super.PostRender(C);
	//reset "bLockedOn" variable
	bLockedOn = false;

	if(ControllingProjectile && (ProjectileToSteer != None)) {
	    class'HUDHelper'.static.getXY(C, ProjectileToSteer.Location, ProjectileXCoord, ProjectileYCoord);

	    if(class'HUDHelper'.static.GetScreenPointOutsideCenterCircle(C, ProjectileXCoord, ProjectileYCoord, Self.DistanceFromCenterToSteer)) {
            middleX = C.ClipX / 2;
            middleY = C.ClipY / 2;

            if(ProjectileXCoord > middleX) {
                ProjectileToSteer.SteerHorizontally = -1;
            } else {
                ProjectileToSteer.SteerHorizontally = 1;
            }

            if(ProjectileYCoord > middleY) {
                ProjectileToSteer.SteerVertically = 1;
            } else {
                ProjectileToSteer.SteerVertically = -1;
            }

            ProjectileToSteer.ProjectileSteeredByWeapon = true;
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

simulated function PlayRFiring(int num) {
	if (Owner.IsA('PlayerPawn')) {
		PlayerPawn(Owner).shakeview(ShakeTime, ShakeMag*RocketsLoaded, ShakeVert); //shake player view
		PlayerPawn(Owner).ClientInstantFlash(-0.4, vect(650, 450, 190));
	}

	if (Affector != None) {
		Affector.FireEffect();
	}

	if (bFireLoad) {
		//PlayOwnedSound(Self.ProjectileClass.Default.SpawnSound, SLOT_None, 4.0*Pawn(Owner).SoundDampening);
		PlayOwnedSound(Class'GuidedEnergyProj'.Default.SpawnSound, SLOT_None, 4.0*Pawn(Owner).SoundDampening);
	} else {
		//PlayOwnedSound(AltFireSound, SLOT_None, 4.0*Pawn(Owner).SoundDampening);
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
	function AltFire(float F) {}

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
		}

		RocketsLoaded = 0;
		bTightWad = false;
		bRotated = false;
	}

	function AnimEnd() {
		if (!bRotated && (AmmoType.AmmoAmount > 0)) {
			PlayLoading(1.5, 0);
			RocketsLoaded = 1;
			bRotated = true;
			return;
		}

		LockedTarget = None;
		Finish();
	}
Begin:
}

///////////////////////////////////////////////////////
state Idle {

Begin:
	if (Pawn(Owner).bFire!=0) { 
	    Fire(0.0); 
	}
	
	if (Pawn(Owner).bAltFire!=0) { 
	    AltFire(0.0); 
	}
	
	bPointing=False;
	
	if (AmmoType.AmmoAmount<=0) { 
		Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
	}
	
	PlayIdleAnim();
	LockedTarget = None;
	bLockedOn = False;
	ControllingProjectile = false;
	Log("GuidedEnergyLance - IDLE - Reset ControllingProjectile");
	
}

defaultproperties {
      WeaponDescription="Classification: Energy Lance\nPrimary Fire: Instant hit laser beam that steals the targets weapon.\nSecondary Fire: Large, slow moving plasma balls, that ricochet off walls.\nTechniques: Hitting the secondary fire plasma balls with the regular fire's laser beam will cause an immensely powerful explosion. You can even aim the plasma balls around corners or bounce them in hallways to block a path."
      AltProjectileClass=Class'HeadHunter.RicochetShockProj'
      PickupMessage="You got the Guided Energy Lance."
      ItemName="Guided Energy Lance"
      DistanceFromCenterToSteer=10
      bAlwaysInstant=true
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
