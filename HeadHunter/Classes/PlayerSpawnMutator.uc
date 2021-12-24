class PlayerSpawnMutator extends Mutator nousercreate;

var PlayerSpawnMutatorCallback Callback;
var bool FirstSpawnOnly;

function ModifyPlayer(Pawn Other) {
   if (Other.IsA('TournamentPlayer') && (Other.PlayerReplicationInfo != None) && (Callback != None)) {
       Callback.IsLogin = false;
       Callback.SpawnedPlayer = PlayerPawn(Other);

       if((FirstSpawnOnly && Other.PlayerReplicationInfo.Deaths < 1) || (!FirstSpawnOnly)) {
           //first spawn or we don't specify we only want the first spawn
           Callback.CallbackFunc();
       }
   }

   Super.ModifyPlayer(Other);
}

//before playerpawn created
function ModifyLogin(out class<playerpawn> SpawnClass, out string Portal, out string Options) {
    Callback.IsLogin = true;
    Callback.SpawnedPlayer = None;
    Callback.CallbackFunc();

    Super.ModifyLogin(SpawnClass, Portal, Options);
}

static function PlayerSpawnMutator RegisterToPlayerSpawn(Actor context, PlayerSpawnMutatorCallback callback) {
    local PlayerSpawnMutator mut;

    if(callback == None) {
        return None;
    }

    mut = context.Spawn(class'PlayerSpawnMutator');
    mut.Callback = callback;
    context.Level.Game.BaseMutator.AddMutator(mut);

    return mut;
}

defaultproperties {
    FirstSpawnOnly=false
}
