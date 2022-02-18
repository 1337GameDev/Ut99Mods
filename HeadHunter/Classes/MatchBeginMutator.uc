class MatchBeginMutator extends Mutator nousercreate;

var MatchBeginMutatorCallback Callback;

function ModifyPlayer(Pawn Other) {
   if (Other.IsA('TournamentPlayer') && (Other.PlayerReplicationInfo != None) && (Level.Game.GameReplicationInfo != None) && (Callback != None)) {
       Callback.GameInfo = Level.Game;

       if((Other.PlayerReplicationInfo.Deaths < 1) && (Level.Game.GameReplicationInfo.ElapsedTime < 1)) {
           //first spawn and elapsed time in game of game is < 1
           Callback.CallbackFunc();
       }
   }

   Super.ModifyPlayer(Other);
}

static function MatchBeginMutator RegisterToMatchBegin(Actor context, MatchBeginMutatorCallback callback) {
    local MatchBeginMutator mut;

    if(callback == None) {
        return None;
    }

    mut = context.Spawn(class'MatchBeginMutator');
    mut.Callback = callback;
    context.Level.Game.BaseMutator.AddMutator(mut);
    return mut;
}

defaultproperties
{
      callback=None
}
