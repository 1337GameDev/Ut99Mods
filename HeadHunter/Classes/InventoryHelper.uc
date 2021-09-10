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
        mut = class'MutatorHelper'.static.GetGameMutatorByClass(inv, class'DroppedInventoryMarkerMutator');
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

defaultproperties
{
}
