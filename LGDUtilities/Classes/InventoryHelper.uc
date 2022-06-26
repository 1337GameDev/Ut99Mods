// ============================================================
// InventoryHelper
// ============================================================
class InventoryHelper extends Object;

var DroppedInventoryMarkerMutator DroppedInventoryMarkerMutatorInstance;

static function string GetNiceRelicName(TournamentPickup relic) {
    local string nameToReturn;
	
    if((relic != None) && (relic.IsA('RelicInventory'))) {
        if(relic.IsA('RelicDeathInventory')){
            nameToReturn = "Relic: Vengeance";
        } else if(relic.IsA('RelicRedemptionInventory')){
            nameToReturn = "Relic: Redemption";
        } else if(relic.IsA('RelicDefenseInventory')){
            nameToReturn = "Relic: Defense";
        } else if(relic.IsA('RelicRegenInventory')){
            nameToReturn = "Relic: Regen";
        } else if(relic.IsA('RelicSpeedInventory')){
            nameToReturn = "Relic: Speed";
        } else if(relic.IsA('RelicStrengthInventory')){
            nameToReturn = "Relic: Strength";
        }
    }

    return nameToReturn;
}

//requires the existence of DroppedInventoryMarkerMutator hooked into Actor.Level.Game.BaseMutator
static function bool IsInventoryDropped(Inventory inv){
    local Mutator mut;
    if(inv == None){
        return false;
    }

    if(default.DroppedInventoryMarkerMutatorInstance == None){
        mut = class'LGDUtilities.MutatorHelper'.static.GetGameMutatorByClass(inv, class'LGDUtilities.DroppedInventoryMarkerMutator');
        if(mut != None){
            default.DroppedInventoryMarkerMutatorInstance = DroppedInventoryMarkerMutator(mut);
        }
    }

    return (mut != None) && ((inv.bTossedOut) || (inv.PlayerLastTouched == 'Dropped') );
}

static function int GetItemCountInInventory(Pawn pawn, bool IncludeCopies) {
   local Inventory Inv;
   local int Count;

   for(Inv=pawn.Inventory; Inv!=None; Inv=Inv.Inventory) {
		Count++;
		
		if(IncludeCopies && Inv.IsA('Pickup')) {
		    Count += Pickup(Inv).NumCopies;
		}
   }

   return Count;
}

static function LinkedList GetAllItemsOfTypeInInventory(Pawn pawn, class<Inventory> invClass) {
   local Inventory Inv;
   local LinkedList List;

   List = new class'LGDUtilities.LinkedList';

   for(Inv=pawn.Inventory; Inv!=None; Inv=Inv.Inventory) {
       if(Inv.Class == invClass) {
            List.Push(Inv);
       }
   }

   return List;
}

static function int DeleteInventoriesOnGround(Actor context, name invClass) {
    local int countDeleted;
    local Inventory inv;

    ForEach context.AllActors(class'Inventory', inv) {
        if(inv.IsA(invClass) && !inv.bHeldItem && (inv.Owner == None) && !inv.bCarriedItem && !inv.bOnlyOwnerSee){
            inv.Destroy();
            countDeleted++;
        }
    }
    return countDeleted;
}

static function bool IsAPowerup(Inventory Item, bool includeArmor, bool includeHealth, bool includePowerItems) {
	if(Item == None) {
	    return false;
	} else {
	    if(includeArmor && (Item.IsA('Health') || Item.IsA('HealthPack') || Item.IsA('HealthVial') || Item.IsA('MedBox') || Item.IsA('NaliFruit') || Item.IsA('Bandages') || Item.IsA('SuperHealth')) ) {
			return true;
		} else if(includeArmor && (Item.bIsAnArmor || Item.IsA('c_Armorshard') || Item.IsA('Armor') || Item.IsA('Armor2') || Item.IsA('Armor') || Item.IsA('KevlarSuit') || Item.IsA('ToxinSuit') || Item.IsA('AsbestosSuit')) ) {
		    return true;
		} else if(includePowerItems && (Item.IsA('UT_Jumpboots') || Item.IsA('UDamage') || Item.IsA('UT_Invisibility') || Item.IsA('UT_ShieldBelt') || Item.IsA('ForceField') || Item.IsA('RelicInventory') || Item.IsA('SCUBAGear')) ){
		    return true;
		}
	}

	return false;
}

defaultproperties {
      DroppedInventoryMarkerMutatorInstance=None
}
