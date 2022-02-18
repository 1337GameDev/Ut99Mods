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
    Log("WeaponEventListenerWeapon - Destroyed");

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
        if((ppOwner.Weapon != None) && (ppOwner.Weapon.class == self.Class)){
            return;
        }

        PreviouslySelectedWeapon = ppOwner.Weapon;
        //AutoSwitchPriority = 100;
	    if(class'WeaponHelper'.static.SwitchPlayerPawnWeapon(ppOwner, self)) {
	        Log("WeaponEventListenerWeapon - SelectWeapon - WeaponHelper.SwitchPlayerPawnWeapon reported TRUE for switching to THIS weapon");
        } else {
            Log("WeaponEventListenerWeapon - SelectWeapon - WeaponHelper.SwitchPlayerPawnWeapon reported FALSE for switching to THIS weapon");
        }
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
	    //if((ppOwner.Weapon != None) && ppOwner.Weapon.class == self.class) {
	    //if((ppOwner.Weapon != None)) {
	        //AutoSwitchPriority = -100;
	        Log("WeaponEventListenerWeapon - RestorePreviousWeapon - PreviouslySelectedWeapon:"$PreviouslySelectedWeapon);
	        if(class'WeaponHelper'.static.SwitchPlayerPawnWeapon(ppOwner, PreviouslySelectedWeapon)) {
	            Log("WeaponEventListenerWeapon - RestorePreviousWeapon - WeaponHelper.SwitchPlayerPawnWeapon reported TRUE for switching to previous weapon");
	        } else {
	            Log("WeaponEventListenerWeapon - RestorePreviousWeapon - WeaponHelper.SwitchPlayerPawnWeapon reported FALSE for switching to previous weapon");
	        }
	    //}
	    } else {
	        Log("WeaponEventListenerWeapon - RestorePreviousWeapon - PreviouslySelectedWeapon was NONE, so choosing best weapon");

            ppOwner.SwitchToBestWeapon();
	    }
	}
}

/*

function Weapon WeaponChange(byte F){
    return self;
}

function bool WeaponSet(Pawn Other) {
    return false;
}

function Weapon RecommendWeapon(out float rating, out int bUseAltMode) {
    return self;
}

simulated function PlaySelect() {
	bForceFire = false;
	bForceAltFire = false;
	bCanClientFire = false;

	if (!IsAnimating() || (AnimSequence != 'Select')) {
	    if(Self.Mesh != None) {
		    PlayAnim('Select',1.0,0.0);
		}
	}

	if(Owner != None) {
	    Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);
	}
}
function BringUp() {
	if ((Owner != None) && Owner.IsA('PlayerPawn')) {
		SetHand(PlayerPawn(Owner).Handedness);
		PlayerPawn(Owner).EndZoom();
	}

	bWeaponUp = false;
	PlaySelect();
	GotoState('Active');
}

function float SwitchPriority() {
    return AutoSwitchPriority;
}

State DownWeapon
{
ignores Fire, AltFire;

	function bool PutDown() {
	    if(Owner != None) {
		    Pawn(Owner).ClientPutDown(self, Pawn(Owner).PendingWeapon);
		}
		return true; //just keep putting it down
	}

	function BeginState()
	{
		bChangeWeapon = false;
		bMuzzleFlash = 0;
		if(Owner != None){
		    Pawn(Owner).ClientPutDown(self, Pawn(Owner).PendingWeapon);
		}
	}

Begin:
	TweenDown();
	FinishAnim();

	if(Owner != None){
	    Pawn(Owner).ChangedWeapon();
	}
}
*/

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

      SelectSound=Sound'UnrealShare.General.ArrowSpawn',
      PlayerViewMesh=LodMesh'Botpack.chainsawM',
      Mesh=LodMesh'Botpack.ChainSawPick'
}
