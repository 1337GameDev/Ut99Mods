class CallbackFnObject extends Object;

var Actor Context;

//allows chaining callbacks to have multiple
var CallbackFnObject NextCallback;

function CallbackFunc() {
    if(NextCallback != None){
        NextCallback.CallbackFunc();
    }
}

defaultproperties {
      Context=None
      NextCallback=None
}
