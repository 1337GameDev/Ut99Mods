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
function SetCallbackForAllEvents(WeaponUseCallback callback){
     if(callback != None){
         fireCallback = callback;
         altFireCallback = callback;
         activateCallback = callback;
         useCallback = callback;
     }
}

simulated function PostBeginPlay() {
    Super.PostBeginPlay();
}

simulated function Destroyed() {
	Super.Destroyed();

	RestorePreviousWeapon();

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

function Weapon WeaponChange(byte F){
    return self;
}

function bool WeaponSet(Pawn Other) {
    return false;
}

function Weapon RecommendWeapon(out float rating, out int bUseAltMode) {
    return self;
}

function SelectWeapon(){
    local PlayerPawn ppOwner;

	//store weapon of player
	ppOwner = PlayerPawn(Owner);
	if(ppOwner != None){
        if((ppOwner.Weapon != None) && (ppOwner.Weapon.class == self.Class)){
            return;
        }

        PreviouslySelectedWeapon = ppOwner.Weapon;
	    class'WeaponHelper'.static.SwitchPlayerPawnWeapon(ppOwner, self);
	}
}
function RestorePreviousWeapon(){
    local PlayerPawn ppOwner;

	//restore old weapon of player
	ppOwner = PlayerPawn(Owner);
	if(ppOwner != None){
	    if((ppOwner.Weapon != None) && ppOwner.Weapon.class == self.class) {
	        class'WeaponHelper'.static.SwitchPlayerPawnWeapon(ppOwner, PreviouslySelectedWeapon);
	    }
	}
}

defaultproperties {
     bBroadCastLog=false,
     bLogToGameLogfile=true,
     bActivatable=true,
     ActivateSound=None,
     bHidden=True,

     MessageNoAmmo=" has no ammo.",
     NameColor=(R=255,G=255,B=255),
     InventoryGroup=1,
     PickupMessage="",
     DeathMessage="",
     ItemName="UseTriggerWeapon",
     RespawnTime=0.0,
}

