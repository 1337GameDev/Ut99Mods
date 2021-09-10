class MatchBeginMutatorCallback extends CallbackFnObject;

var GameInfo GameInfo;

function CallbackFunc() {
    Log("MatchBeginMutatorCallback - Match Begin: "@GameInfo);

    Super.CallbackFunc();
}

defaultproperties
{

}
