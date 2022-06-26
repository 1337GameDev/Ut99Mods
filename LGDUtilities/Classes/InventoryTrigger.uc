//-----------------------------------------------------------
// InventoryTrigger
//-----------------------------------------------------------
class InventoryTrigger extends ManualTrigger;

#exec texture Import File=Textures\ActorIcons\InventoryTrigger.bmp Name=InventoryTrigger Mips=Off Flags=2
var(Logging) bool bLogToGameLogfile;

enum IT_COMPARISON {
	IT_EQUALS,
	IT_LESS_THAN,
	IT_GREATER_THAN,
	IT_LESS_THAN_OR_EQUALS,
	IT_GREATER_THAN_OR_EQUALS
};

var(Trigger) struct InventoryObjectNeeded {
	var() class<Inventory> InvClass;
	var() int NumberNeeded;
	var() bool RemoveUponTrigger;
	var() bool CompareAmmoInstead;
    var() IT_COMPARISON QuantityComparison;//How should the quantity "NumberNeeded" be compared?
} InventoryObjectsNeeded[32];

var(Trigger) string InsufficientCountMessage;

//
// Called when something touches the trigger.
//
function Touch(Actor Other) {
    local bool HasAllObjects;
    local Pawn p;
    local Inventory inv, playerSelectedWep;
    local Pickup pickup;
    local Weapon wep;
    local Ammo pickupAmmo;

    local int i, currentInvCount;
    local InventoryObjectNeeded invNeeded;

    if(IsRelevant(Other)) {
        p = Pawn(Other);

        if(p != None) {
            HasAllObjects = true;

            for(i=0; i<32; i++) {
                invNeeded = InventoryObjectsNeeded[i];

                if(invNeeded.InvClass != None) {
                    inv = p.FindInventoryType(invNeeded.InvClass);
                    currentInvCount = 0;

                    if(inv != None){
                        currentInvCount = 1;

						pickup = Pickup(inv);

						if(pickup != None) {//if this is a pickup, include the "NumCopies" variable
						    currentInvCount += pickup.NumCopies;
						} else if(inv.IsA('Weapon') && invNeeded.CompareAmmoInstead) {
						    wep = Weapon(inv);
                            pickupAmmo = wep.AmmoType;
						    currentInvCount = pickupAmmo.AmmoAmount;
                        } else if(inv.IsA('Ammo')){
						    pickupAmmo = Ammo(inv);
						    currentInvCount = pickupAmmo.AmmoAmount;
						}
                    }

                    switch(invNeeded.QuantityComparison) {
                        case IT_COMPARISON.IT_EQUALS:
							HasAllObjects = HasAllObjects && (currentInvCount == invNeeded.NumberNeeded);
                            break;
						case IT_COMPARISON.IT_GREATER_THAN_OR_EQUALS:
							HasAllObjects = HasAllObjects && (currentInvCount >= invNeeded.NumberNeeded);
                            break;
						case IT_COMPARISON.IT_GREATER_THAN:
							HasAllObjects = HasAllObjects && (currentInvCount > invNeeded.NumberNeeded);
                            break;
						case IT_COMPARISON.IT_LESS_THAN:
							HasAllObjects = HasAllObjects && (currentInvCount < invNeeded.NumberNeeded);
                            break;
						case IT_COMPARISON.IT_LESS_THAN_OR_EQUALS:
							HasAllObjects = HasAllObjects && (currentInvCount <= invNeeded.NumberNeeded);
                            break;
                    }

					if(!HasAllObjects) {
					    break;
					}
                }//inventory class isnt None
            }

            if(HasAllObjects){
                playerSelectedWep = p.Weapon;

				for(i=0; i<32; i++) {
				    invNeeded = InventoryObjectsNeeded[i];

					if((invNeeded.InvClass != None) && invNeeded.RemoveUponTrigger){
						inv = p.FindInventoryType(invNeeded.InvClass);
                        pickup = Pickup(inv);

						if(pickup != None) {//if this is a pickup, include the "NumCopies" variable
                            if(pickup.NumCopies >= invNeeded.NumberNeeded){//we already checked that there's enough of items to subtract
                                pickup.NumCopies -= invNeeded.NumberNeeded;
						    } else {//NumCopies == invNeeded.NumberNeeded, or less, so just remove the item
						        p.DeleteInventory(pickup);
						    }
						} else if(inv.IsA('Weapon') && invNeeded.CompareAmmoInstead){
                            wep = Weapon(inv);
                            pickupAmmo = wep.AmmoType;

                            if(!pickupAmmo.UseAmmo(invNeeded.NumberNeeded)){
                                pickupAmmo.AmmoAmount = 0;
                            }
                        } else if(inv.IsA('Ammo')) {
						    pickupAmmo = Ammo(inv);
                            if(!pickupAmmo.UseAmmo(invNeeded.NumberNeeded)){
                                pickupAmmo.AmmoAmount = 0;
                            }
                        } else {//not a pickup, just remove the item (assuming we aren't comparing ammo)
							p.DeleteInventory(inv);
						}
					}
				}//end of for loop over class names

				//now check if we deleted the player's equipped weapon
				if(p.Weapon != playerSelectedWep){
				   p.SwitchToBestWeapon();
				}

                ActivateTrigger(Other);
            } else {
                p.Instigator.ClientMessage(InsufficientCountMessage);
            }
        }
    }
}

defaultproperties {
      bLogToGameLogfile=False
      InventoryObjectsNeeded(0)=(InvClass=Class'Botpack.UT_FlakCannon',NumberNeeded=1,RemoveUponTrigger=True,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(1)=(InvClass=Class'Botpack.PulseGun',NumberNeeded=1,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(2)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(3)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(4)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(5)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(6)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(7)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(8)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(9)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(10)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(11)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(12)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(13)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(14)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(15)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(16)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(17)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(18)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(19)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(20)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(21)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(22)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(23)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(24)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(25)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(26)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(27)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(28)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(29)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(30)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InventoryObjectsNeeded(31)=(InvClass=None,NumberNeeded=0,RemoveUponTrigger=False,CompareAmmoInstead=False,QuantityComparison=IT_EQUALS)
      InsufficientCountMessage="You do not have the required items."
      Message="You have the required items."
      Texture=Texture'LGDUtilities.InventoryTrigger'
}
