class WeaponHelper extends Actor nousercreate;

/*
  Referenced: https://beyondunrealwiki.github.io/pages/how-ut-weapons-work-switchi.html
  Used methods: Pawn.ChangedWeapon, PlayerPawn.SwitchWeapon, and Bot/Pawn.SwitchToBestWeapon
*/
static function bool SwitchPlayerPawnWeapon(Pawn p, Weapon wep){
    local Weapon existing;
    local Ammo existingAmmo;
    local bool Switched, EmptyAmmo;
    local PlayerPawn pp;
    local Bot bot;

    EmptyAmmo = (wep == None) || (wep.AmmoType != None) && (wep.AmmoType.AmmoAmount <= 0);

    if((p == None) || (wep == None) || EmptyAmmo){
        if(EmptyAmmo && (wep != None) && (p != None)){
           p.ClientMessage(wep.ItemName$wep.MessageNoAmmo);
        }

        return false;
    }

    existing = Weapon(p.FindInventoryType(wep.Class));
    if(existing == None){
        wep.GiveTo(p);
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
    } else {
        //combine ammo
        wep.AmmoType.AddAmmo(existingAmmo.AmmoAmount);
    }

    Switched = false;
    if(p.IsA('PlayerPawn')){
        pp = PlayerPawn(p);
        //code derived rom PlayerPawn.SwitchWeapon(byte F); -- weapon group number as parameter
		if(pp.bShowMenu || pp.Level.Pauser!=""){
			if(pp.myHud != None){
				pp.myHud.InputNumber(wep.InventoryGroup);
			}
		} else {
		    if(pp.Weapon == None) {
			    pp.PendingWeapon = wep;
			    pp.ChangedWeapon();
		    } else if(pp.Weapon != wep) {
			    pp.PendingWeapon = wep;

			    if(!pp.Weapon.PutDown()) {
				    pp.PendingWeapon = None;
			    }
		    }
		}

        Switched = true;
    } else if(p.IsA('Bot')){
        bot = Bot(p);

        //derived from Bot.SwitchToBestWeapon
        bot.PendingWeapon = wep;
        if (bot.Weapon == None){
            bot.ChangedWeapon();
        } else if(bot.Weapon != bot.PendingWeapon) {
            bot.Weapon.PutDown();
        }

        Switched = true;
    } else {
        //derived from Pawn.SwitchToBestWeapon
        p.PendingWeapon = wep;
        if (p.Weapon == None){
            p.ChangedWeapon();
        } else if(p.Weapon != p.PendingWeapon) {
            p.Weapon.PutDown();
        }

        Switched = true;
    }

    return Switched;
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
        class'WeaponHelper'.static.SwitchPlayerPawnWeapon(thief, WeaponToSteal);
    } else {
        ExistingWeapon = Weapon(ExistingWeaponInv);
        if((ExistingWeapon.AmmoType != None) && (WeaponToSteal.AmmoType != None)){
             ExistingWeapon.AmmoType.AddAmmo(WeaponToSteal.AmmoType.AmmoAmount);
        }

        class'WeaponHelper'.static.SwitchPlayerPawnWeapon(thief, ExistingWeapon);
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

defaultproperties
{
}
