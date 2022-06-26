class WeaponHelper extends Actor nousercreate;

var string BaseWeaponClasses[23];
var string ChaosUTWeapons[11];
/*
  Referenced: https://beyondunrealwiki.github.io/pages/how-ut-weapons-work-switchi.html
  Used methods: Pawn.ChangedWeapon, PlayerPawn.SwitchWeapon, Prev/NextWeapon and Bot/Pawn.SwitchToBestWeapon
*/
static function bool SwitchPlayerPawnWeapon(Pawn p, Weapon wep){
    local Weapon existing;
    local Ammo existingAmmo;
    local bool EmptyAmmo;

    EmptyAmmo = ((wep != None) && (wep.AmmoType != None)) && ((wep.AmmoType.AmmoAmount <= 0) && (wep.AmmoType.AmmoAmount != wep.PickupAmmoCount));

    //avoid switching to a weapon that has no ammo
    if((p == None) || (wep == None) || EmptyAmmo){
        if(EmptyAmmo && (wep != None) && (p != None)) {
           p.ClientMessage(wep.ItemName$wep.MessageNoAmmo);
        }
        return false;
    }

    existing = Weapon(p.FindInventoryType(wep.Class));
    if(existing == None){
        wep.GiveTo(p);//ensure the pawn has ownership of the weapon
    }

    //code derived from Weapon.TravelPostAccept
    if(wep.AmmoName != None){
        existingAmmo = Ammo(p.FindInventoryType(wep.AmmoName));
    }
    if(existingAmmo == None){
       //create new ammo, if possible
       if(wep.AmmoName != None){
           wep.GiveAmmo(p);
       }
    //if player had weapon before, and it's prior ammo was 0 (and it started with ammo on pickup)
    } else if((existing != None) && ((existingAmmo.AmmoAmount == 0) && (existing.PickupAmmoCount > 0)) ) {
       return false;
    }

    p.PendingWeapon = wep;
	if (p.PendingWeapon == p.Weapon) {
	    p.PendingWeapon = None;
	}

	if (p.Weapon == None){
		p.ChangedWeapon();
	}

	if (p.Weapon != p.PendingWeapon) {
	    if(p.Weapon != None) {
	        p.Weapon.PutDown();
		}
    }

    return true;
}

static function bool StealWeapon(Pawn thief, Pawn victim, out Weapon PreviouslyHeldWeapon, out Weapon WeaponStolen){
    local Weapon WeaponToSteal, ExistingWeapon;
    local Inventory ExistingWeaponInv;

    if((thief == None) || thief.bDeleteMe || (victim == None) || victim.bDeleteMe) {
        return false;
    }

    PreviouslyHeldWeapon = thief.Weapon;

    WeaponToSteal = victim.Weapon;
    if((WeaponToSteal == None) || WeaponToSteal.bDeleteMe){
        return false;
    }

    victim.DeleteInventory(WeaponToSteal);
    if(WeaponToSteal.AmmoType != None){
        victim.DeleteInventory(WeaponToSteal.AmmoType);
    }

    victim.SwitchToBestWeapon();

    ExistingWeaponInv = thief.FindInventoryType(WeaponToSteal.Class);

    if(ExistingWeaponInv == None) {
        //add this weapon to my inventory and switch to it
        class'LGDUtilities.WeaponHelper'.static.SwitchPlayerPawnWeapon(thief, WeaponToSteal);
    } else {
        ExistingWeapon = Weapon(ExistingWeaponInv);
        if((ExistingWeapon.AmmoType != None) && (WeaponToSteal.AmmoType != None)){
             ExistingWeapon.AmmoType.AddAmmo(WeaponToSteal.AmmoType.AmmoAmount);
        }

        class'LGDUtilities.WeaponHelper'.static.SwitchPlayerPawnWeapon(thief, ExistingWeapon);
    }

    thief.ReceiveLocalizedMessage(class'PickupMessagePlus', 0, None, None, WeaponToSteal.Class);
    if(WeaponToSteal.PickupSound != None){
        WeaponToSteal.PlaySound(WeaponToSteal.PickupSound);
    }

    if (thief.Level.Game.LocalLog != None) {
        thief.Level.Game.LocalLog.LogPickup(WeaponToSteal, thief);
    }

    if (thief.Level.Game.WorldLog != None) {
        thief.Level.Game.WorldLog.LogPickup(WeaponToSteal, thief);
    }

    WeaponStolen = WeaponToSteal;

    return true;
}

//**********************************
//Finds Weapon based on a superclass
// Fetched from: https://github.com/CacoFFF/LCWeapons-UT99/blob/master/classes/LCStatics.uc
//**********************************
static final function Weapon FindBasedWeapon(Pawn Other, class<Weapon> WC) {
	local Weapon First, Cur;
	local inventory Inv;
	local bool bNext;
	local int i;

	for(Inv=Other.Inventory ; Inv!=none ; Inv=Inv.Inventory){
		if((i++ > 200) || (Weapon(Inv) == none)) {
			continue;
		}

        if(ClassIsChildOf(Inv.Class, WC)) {
			if ( (Weapon(Inv).AmmoType != none) && (Weapon(Inv).AmmoType.AmmoAmount <= 0) ){
				continue;
			}

            if(First == None) {
				First = Weapon(Inv);
			}

            if(bNext) {
				Cur = Weapon(Inv);
				Goto WSWITCH;
			}
		}

		if(Other.Weapon == Inv) {
			bNext = True;
		}
	}

	Cur = First;
	WSWITCH:
	if(Other.Weapon == Cur){
		return Cur;
	}

    if(Other.Weapon != None) {
		Other.Weapon.PutDown();
		Other.PendingWeapon = Cur;
	} else {
		Other.Weapon = Cur;
		Other.Weapon.BringUp();
	}

	return Cur;
}

static final function FindTracePointsOfWeapon(Weapon wep, float TraceLength, out Vector TraceStartLoc, out Vector TraceEndLoc) {
    local PlayerPawn PawnOwner;
	local Vector X,Y,Z;

    if((wep == None) && (wep.Owner == None)) {
        return;
    }

    PawnOwner = PlayerPawn(wep.Owner);

    GetAxes(PawnOwner.ViewRotation,X,Y,Z);
    TraceStartLoc = PawnOwner.Location + wep.CalcDrawOffset() + wep.FireOffset.X * X + wep.FireOffset.Y * Y + wep.FireOffset.Z * Z;
    TraceEndLoc = TraceStartLoc + (TraceLength * X);
}

defaultproperties {
      //Unreal1
      BaseWeaponClasses(0)="UnrealShare.ASMD",
      BaseWeaponClasses(1)="UnrealShare.DispersionPistol",
      BaseWeaponClasses(2)="UnrealShare.Eightball",
      BaseWeaponClasses(3)="UnrealShare.Stinger",
      BaseWeaponClasses(4)="UnrealShare.AutoMag",
      BaseWeaponClasses(5)="UnrealI.GESBioRifle",
      BaseWeaponClasses(6)="UnrealI.FlakCannon",
      BaseWeaponClasses(7)="UnrealI.Minigun",
      BaseWeaponClasses(8)="UnrealI.Razorjack",
      BaseWeaponClasses(9)="UnrealI.Rifle",
      //UT99
      BaseWeaponClasses(10)="Botpack.UT_FlakCannon",
      BaseWeaponClasses(11)="Botpack.UT_Eightball",
      BaseWeaponClasses(12)="Botpack.ut_biorifle",
      BaseWeaponClasses(13)="Botpack.Translocator",
      BaseWeaponClasses(14)="Botpack.SniperRifle",
      BaseWeaponClasses(15)="Botpack.ShockRifle",
      BaseWeaponClasses(16)="Botpack.ripper",
      BaseWeaponClasses(17)="Botpack.PulseGun",
      BaseWeaponClasses(18)="Botpack.minigun2",
      BaseWeaponClasses(19)="Botpack.ImpactHammer",
      BaseWeaponClasses(20)="Botpack.enforcer",
      BaseWeaponClasses(21)="Botpack.ChainSaw",
      BaseWeaponClasses(22)="Botpack.WarheadLauncher",
      //ChaosUT
      ChaosUTWeapons(0)="ChaosUT.ch_WarHeadLauncher",
      ChaosUTWeapons(1)="ChaosUT.Crossbow",
      ChaosUTWeapons(2)="ChaosUT.Flak2",
      ChaosUTWeapons(3)="ChaosUT.ProxyArm",
      ChaosUTWeapons(4)="ChaosUT.Sniper2",
      ChaosUTWeapons(5)="ChaosUT.Sword",
      ChaosUTWeapons(6)="ChaosUT.TurretLauncher",
      ChaosUTWeapons(7)="ChaosUT.VortexArm",
      ChaosUTWeapons(8)="ChaosUT.explosivecrossbow",
      ChaosUTWeapons(9)="ChaosUT.poisoncrossbow",
      ChaosUTWeapons(10)="ChaosUT.sniper_rpb",
}
