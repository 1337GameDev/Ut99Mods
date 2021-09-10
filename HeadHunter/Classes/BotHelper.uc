class BotHelper extends Object;

static function AddBots(Actor context, int N) {
    local int i;

    if(!context.Level.Game.bDeathMatch) {
        return;
    }

    for(i=0; i<N; i++){
        context.Level.Game.ForceAddBot();
    }
}

defaultproperties
{
}
