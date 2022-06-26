class MutatorHelper extends Actor nousercreate;

static function Mutator GetHUDMutatorFromActivePlayerPawnByClass(Actor context, name className){
    local Mutator m;
    local PlayerPawn pp;

    foreach context.AllActors(class'PlayerPawn', pp) {
       m = class'LGDUtilities.HUDMutator'.static.GetHUDMutatorFromPlayerPawnByClassName(pp, className);
       if(m != None){
           break;
       }
    }

    return m;
}

static function Mutator GetGameMutatorByClass(Actor context, class<Mutator> mutatorClass){
    local Mutator m;
    m = context.Level.Game.BaseMutator;

    while(m != None){
        if(m.Class == mutatorClass){
            break;
        } else {
            m = m.NextMutator;
        }
    }

    return m;
}

static function Mutator GetGameDamageMutatorByClass(Actor context, class<Mutator> mutatorClass){
    local Mutator m;
    m = context.Level.Game.DamageMutator;

    while(m != None){
        if(m.Class == mutatorClass){
            break;
        } else {
            m = m.NextDamageMutator;
        }
    }

    return m;
}

static function Mutator GetGameMessageMutatorByClass(Actor context, class<Mutator> mutatorClass){
    local Mutator m;
    m = context.Level.Game.MessageMutator;

    while(m != None){
        if(m.Class == mutatorClass){
            break;
        } else {
            m = m.NextMessageMutator;
        }
    }

    return m;
}

static function Mutator GetMutatorBeforeMutatorInChain(Mutator mut){
    local Mutator m;
    if(mut != None) {
        m = mut.Level.Game.BaseMutator;

        while(m != None){
            if(m.NextMutator == mut){
                break;
            } else {
                m = m.NextMutator;
            }
        }
    }

    return m;
}

defaultproperties {
}
