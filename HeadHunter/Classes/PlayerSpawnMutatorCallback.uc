class PlayerSpawnMutatorCallback extends CallbackFnObject;

var PlayerPawn SpawnedPlayer;
var bool IsLogin;

function CallbackFunc() {
    if(IsLogin){
        LoginCallback();
    } else {
        PlayerSpawnedCallback();
    }

    Super.CallbackFunc();
}

function LoginCallback(){
     //Log("Player Login Mutator Callback - SpawnedPlayer: "@SpawnedPlayer);
}

function PlayerSpawnedCallback(){
     //Log("Player Spawn Mutator Callback - SpawnedPlayer: "@SpawnedPlayer);
}

defaultproperties
{

}
