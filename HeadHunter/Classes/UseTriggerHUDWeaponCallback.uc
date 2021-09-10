//-----------------------------------------------------------
// UseTriggerHUDWeaponCallback
//-----------------------------------------------------------
class UseTriggerHUDWeaponCallback extends WeaponUseCallback;

var UseTriggerHUDMutator hudMutator;

function CallbackFunc() {
    if(hudMutator != None){
        hudMutator.ActivateTrigger(Pawn(WeaponInstance.Owner));
    }

    Super.CallbackFunc();
}

defaultProperties {

}
