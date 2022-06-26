//=============================================================================
// UseTriggerWeapon
//=============================================================================
class WeaponEventListenerWeapon extends TournamentWeapon nousercreate;

var bool bBroadCastLog;
var bool bLogToGameLogfile;
var Weapon PreviouslySelectedWeapon;

var WeaponUseCallback fireCallback;
var WeaponUseCallback altFireCallback;
var WeaponUseCallback activateCallback;
var WeaponUseCallback useCallback;

function SetCallbackForAllEvents(WeaponUseCallback callback) {
     if(callback != None) {
         fireCallback = callback;
         altFireCallback = callback;
         activateCallback = callback;
         useCallback = callback;
     }
}

function Destroyed() {
    if(Self.bDeleteMe){
        return;
    }

	RestorePreviousWeapon();
    Super.Destroyed();

	PreviouslySelectedWeapon = None;
	fireCallback = None;
    altFireCallback = None;
    activateCallback = None;
    useCallback = None;
}

function BecomePickup(){}

function DropFrom(vector StartLocation){
    if(Pawn(Owner) != None){
        Pawn(Owner).DeleteInventory(self);
    }

    Destroy();
}

function Activate() {
    if(bActivatable) {
        if(activateCallback != None){
           activateCallback.WeaponInstance = self;
           activateCallback.CallbackFunc();
        }
    }
}
function Fire(float Value){
    if(fireCallback != None){
        fireCallback.WeaponInstance = self;
        fireCallback.CallbackFunc();
    }
}
function AltFire(float Value){
    if(altFireCallback != None){
        altFireCallback.WeaponInstance = self;
        altFireCallback.CallbackFunc();
    }
}
function Use(Pawn User){
    if(useCallback != None){
        useCallback.WeaponInstance = self;
        useCallback.CallbackFunc();
    }
}

function SelectWeapon(){
    local PlayerPawn ppOwner;

    if(Self.bDeleteMe){
        return;
    }

	//store weapon of player
	ppOwner = PlayerPawn(Owner);
	if((ppOwner != None) && (ppOwner.Weapon != self)){
	    //if current weapon is equal to this weapon, ignore this call
        if((ppOwner.Weapon != None) && (ppOwner.Weapon.class == self.Class)){
            return;
        }

        PreviouslySelectedWeapon = ppOwner.Weapon;

	    class'LGDUtilities.WeaponHelper'.static.SwitchPlayerPawnWeapon(ppOwner, self);
	}
}
function RestorePreviousWeapon(){
    local PlayerPawn ppOwner;
	
    if(Self.bDeleteMe){
        return;
    }

	//restore old weapon of player
	ppOwner = PlayerPawn(Owner);
	
	if(ppOwner != None){
	    if(PreviouslySelectedWeapon != None) {
			class'LGDUtilities.WeaponHelper'.static.SwitchPlayerPawnWeapon(ppOwner, PreviouslySelectedWeapon);
	    } else {
            ppOwner.SwitchToBestWeapon();
	    }
	}
}

simulated function PlaySelect() {
	bForceFire = false;
	bForceAltFire = false;
	bCanClientFire = false;
	Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);
}
simulated function TweenDown() { }
simulated function TweenToStill() { }


defaultproperties {
      bBroadCastLog=False
      bLogToGameLogfile=True
      PreviouslySelectedWeapon=None
      fireCallback=None
      altFireCallback=None
      activateCallback=None
      useCallback=None
      DeathMessage=""
      bActivatable=True
      PickupMessage=""
      ItemName="UseTriggerWeapon"
      RespawnTime=0.000000
      bHidden=True,
      bHideWeapon=true,
      //Visibility=false,
      AmmoName=Class'UnrealShare.NullAmmo',
      SelectSound=Sound'UnrealShare.General.ArrowSpawn',
      AutoSwitchPriority=0,
      InventoryGroup=0,
	  PickupAmmoCount=1,
      //PlayerViewMesh=LodMesh'Botpack.chainsawM',
      //Mesh=LodMesh'Botpack.ChainSawPick'
}
