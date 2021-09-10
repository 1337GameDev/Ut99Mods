//=============================================================================
// CustomTrigger - A trigger meant to be spawned in code, and listens for a particular event, and then fires a given CallbackFnObject's main function.
//                 Meant to allow flexibility in responding to events, and having custom callbacks.
//=============================================================================
class CustomTrigger extends Trigger nousercreate;

var() private name DefaultEvent;
var() CallbackFnObject triggerCallback;

event Trigger( Actor Other, Pawn EventInstigator ) {
    if(triggerCallback != none) {
         triggerCallback.CallbackFunc();
    }
}

static function CustomTrigger SpawnAndListenForEvent(Actor src, name eventName, CallbackFnObject ca){
   local CustomTrigger tr;

   if(src == None){
        return none;
   } else {
     if(eventName == '') {
         eventName = default.DefaultEvent;
     }

     if(eventName == '') {
         return None;
     }

     tr = src.Spawn(class'CustomTrigger',,eventName);
     tr.triggerCallback = ca;

     return tr;
   }
}

defaultproperties {
	Tag=MyDesiredEvent
	DefaultEvent='CustomEvent'
}
