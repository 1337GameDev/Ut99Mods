//=============================================================================
// WeaponStealingShockRifle - A shock rifle that has 2 special modes: Primary fire is a beam that steals the weapon of somebody it hits -- Alt fire is bouncy plasma balls.
//=============================================================================
class WeaponStealingShockRifle extends ShockRifle;

var bool AllowStealingLastWeapon;//Allow the ability to steal the player's last weapon in their inventory
var bool AllowStealingImpactHammer;
var bool AllowStealingChainsaw;
var bool AllowStealingSword;//allow stealing of the ChoasUT Bastard Sword
var bool AllowStealingRedeemer;
var bool AllowStealingTranslocator;

function AltFire(float Value) {
	local actor HitActor;
	local vector HitLocation, HitNormal, Start;

	if(Owner == None) {
		return;
	}

	if(Owner.IsA('Bot')){ //make sure won't blow self up
		Start = Owner.Location + CalcDrawOffset() + FireOffset.Z * vect(0,0,1);
		if(Pawn(Owner).Enemy != None){
			HitActor = Trace(HitLocation, HitNormal, Start + 250 * Normal(Pawn(Owner).Enemy.Location - Start), Start, false, vect(12,12,12));
		} else {
			HitActor = self;
		}

		if(HitActor != None) {
			Global.Fire(Value);
			return;
		}
	}

	if(AmmoType.UseAmmo(1)) {
		GotoState('AltFiring');
		bCanClientFire = true;

        if(Owner.IsA('Bot')) {
			if(Owner.IsInState('TacticalMove') && (Owner.Target == Pawn(Owner).Enemy)
			 && (Owner.Physics == PHYS_Walking) && !Bot(Owner).bNovice
			 && (FRand() * 6 < Pawn(Owner).Skill)) {
				Pawn(Owner).SpecialFire();
			}
		}

		Pawn(Owner).PlayRecoil(FiringSpeed);
		bPointing = True;

		ProjectileFire(AltProjectileClass, AltProjectileSpeed, bAltWarnTarget);

        ClientAltFire(value);
	}
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z) {
	local PlayerPawn PlayerOwner;
	local Pawn HitPawn;
	local Weapon WeaponStolen, PreviouslyHeldWeapon;
    local bool HasStolenWeapon;//if we have stolen a weapon
    //special variables for edge cases
    local WarHeadLauncher redeemer;

	if (Other == None) {
		HitNormal = -X;
		HitLocation = Owner.Location + X*10000.0;
	}

	PlayerOwner = PlayerPawn(Owner);
	if (PlayerOwner != None) {
		PlayerOwner.ClientInstantFlash( -0.4, vect(450, 190, 650));
	}

	SpawnEffect(HitLocation, Owner.Location + CalcDrawOffset() + (FireOffset.X + 20) * X + FireOffset.Y * Y + FireOffset.Z * Z);

	if(ShockProj(Other) != None) {
		AmmoType.UseAmmo(2);
		ShockProj(Other).SuperExplosion();
	} else {
		Spawn(class'ut_RingExplosion5',,, HitLocation+HitNormal*8,rotator(HitNormal));
    }

	if((Other != self) && (Other != Owner) && (Other != None)) {
	    HitPawn = Pawn(Other);
	    //detect if they have a weapon
        if((HitPawn != None) && (HitPawn.Weapon != None)){
            //it has a weapon, so steal it, if we are configured to allow that
            if(WeaponEligibleToBeStolen(HitPawn.Weapon)) {
                redeemer = WarHeadLauncher(HitPawn.Weapon);
                if((redeemer != None) && redeemer.bGuiding && redeemer.IsInState('Guiding')){
                     //HitPawn is guiding a warhead, so trigger it to explode
                     redeemer.Fire(0);
                } else if(!((class'InventoryHelper'.static.GetItemCountInInventory(HitPawn, false) <= 1) && !AllowStealingLastWeapon)){
                    HasStolenWeapon = class'WeaponHelper'.static.StealWeapon(PlayerOwner, HitPawn, PreviouslyHeldWeapon, WeaponStolen);
                    if(HasStolenWeapon && (WeaponStolen != None)){
                        if(PlayerOwner.IsA('PlayerPawn')){
                            PlayerOwner.ReceiveLocalizedMessage(class'StealWeaponMessage', 0, None, None, WeaponStolen);
                        }

                        if(HitPawn.IsA('PlayerPawn')){
                            HitPawn.ReceiveLocalizedMessage(class'WeaponStolenMessage', 0, None, None, WeaponStolen);
                        }
                    }
                }


            }
        }
	}
}

function SpawnEffect(vector HitLocation, vector SmokeLocation) {
	local StealShockBeam Smoke;
	local Vector DVector;
	local int NumPoints;
	local rotator SmokeRotation;

	DVector = HitLocation - SmokeLocation;
	NumPoints = VSize(DVector)/135.0;
	if ( NumPoints < 1 ){
		return;
	}

	SmokeRotation = rotator(DVector);
	SmokeRotation.roll = Rand(65535);

	Smoke = Spawn(class'StealShockBeam',,,SmokeLocation,SmokeRotation);
	Smoke.MoveAmount = DVector/NumPoints;
	Smoke.NumPuffs = NumPoints - 1;
}

function bool WeaponEligibleToBeStolen(Weapon wep){
    local bool CanBeStolen;
    if(wep != None){
        CanBeStolen = true;

        if(wep.IsA('ImpactHammer') && !AllowStealingImpactHammer){
            CanBeStolen = false;
        } else if(wep.IsA('ChainSaw') && !AllowStealingChainsaw){
            CanBeStolen = false;
        } else if(wep.IsA('Sword') && !AllowStealingSword){
            CanBeStolen = false;
        } else if(wep.IsA('WarHeadLauncher') && !AllowStealingRedeemer){
            CanBeStolen = false;
        } else if(wep.IsA('Translocator') && !AllowStealingTranslocator){
            CanBeStolen = false;
        } else {
            //weapon can be stolen
        }
    }

    return CanBeStolen;
}

defaultproperties {
     hitdamage=40
     WeaponDescription="Classification: Energy Rifle\n\nPrimary Fire: Instant hit laser beam that steals the targets weapon.\n\nSecondary Fire: Large, slow moving plasma balls, that ricochet off walls.\n\nTechniques: Hitting the secondary fire plasma balls with the regular fire's laser beam will cause an immensely powerful explosion. You can even aim the plasma balls around corners or bounce them in hallways to block a path."
     AmmoName=Class'Botpack.ShockCore'
     PickupAmmoCount=20
     FiringSpeed=2.000000
     AutoSwitchPriority=4
     InventoryGroup=4
     AltProjectileClass=Class'HeadHunter.RicochetShockProj'
     MyDamageType=jolted
     AIRating=0.630000
     AltRefireRate=0.700000
     PickupMessage="You got the ASMD THIEF Shock Rifle."
     ItemName="THIEF Shock Rifle"
     StatusIcon=Texture'Botpack.Icons.UseASMD'
     Icon=Texture'Botpack.Icons.UseASMD'

     AllowStealingLastWeapon=false
     AllowStealingImpactHammer=false
     AllowStealingChainsaw=false
     AllowStealingSword=false
     AllowStealingRedeemer=true
     AllowStealingTranslocator=false
}
