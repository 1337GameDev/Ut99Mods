class HUDMutator extends Mutator nousercreate;

var PlayerPawn PlayerOwner;
var bool bLogToGameLogfile;

simulated function PostRender(Canvas C) {
    if(NextHUDMutator != None) {
        NextHUDMutator.PostRender(C);
    }
}

// Fixed version of the Mutator function
simulated function bool RegisterThisHUDMutator() {
    local PlayerPawn P;
    local bool Registered, HasExisting;
    local int NumPlayersSearched;
    local Mutator currentHudMut;

    if(bLogToGameLogfile) {
        Log("HUDMutator: RegisterThisHUDMutator:"@self.class);
    }

    ForEach AllActors(class'PlayerPawn', P) {
        NumPlayersSearched++;

        if (P.myHUD != None) {
            //check if we already have a hud mutator
            currentHudMut = P.myHud.HUDMutator;
            while(currentHudMut != None){
                if(currentHudMut.Class == self.Class){
                    HasExisting = true;
                    break;
                } else {
                    currentHudMut = currentHudMut.NextHUDMutator;
                }
            }

            if(!HasExisting){
                NextHUDMutator = P.myHud.HUDMutator;
                P.myHUD.HUDMutator = Self;
                bHUDMutator = True;
                PlayerOwner = P;

                Registered = true;
                break;
            }
        }
    }

    if(bLogToGameLogfile) {
        if(!Registered){
            Log(self.Class$": PlayerPawn.myHud NOT found in any of the ["$NumPlayersSearched$"] PlayerPawns checked, or found EXISTING HUDmutator.");
        } else {
            Log(self.Class$": PlayerPawn.myHud found and NO existing HUDmutator in any of the ["$NumPlayersSearched$"] PlayerPawns checked.");
        }
    }

    return Registered;
}

function Mutator GetThisHUDMutatorFromAnyPlayerPawn(){
    return class'HUDMutator'.static.GetHUDMutatorFromAnyPlayerPawnByClass(self, self.Class);
}
static function Mutator GetHUDMutatorFromAnyPlayerPawnByClass(Actor context, class<Mutator> mutClass){
    local PlayerPawn P;

    ForEach context.AllActors(class'PlayerPawn', P) {
        if (P.myHUD != None) {
            return class'HUDMutator'.static.GetHUDMutatorFromPlayerPawnByClass(P, mutClass);
        }
    }

    return None;
}

static function Mutator GetHUDMutatorFromPlayerPawnByClass(PlayerPawn p, class<Mutator> mutClass){
    local Mutator m;

    if(p.myHUD != None){
        m = p.myHUD.HUDMutator;

        While(m != None) {
            if(m.Class == mutClass) {
                return m;
            } else {
                m = m.NextHUDMutator;
            }
        }
    }

    return None;
}
static function Mutator GetHUDMutatorFromPlayerPawnByClassName(PlayerPawn p, name className){
    local Mutator m;

    if(p.myHUD != None){
        m = p.myHUD.HUDMutator;

        While(m != None) {
            if(m.IsA(className)) {
                return m;
            } else {
                m = m.NextHUDMutator;
            }
        }
    }

    return None;
}

//this should work fine, as there will only every be ONE PlayerPawn with a muHUD instance, and hence only one PlayerPawn can possibly have a given HUDMutator
function Mutator GetThisHUDMutatorFromPlayerPawn(PlayerPawn p){
    local Mutator m;
    if(p.myHUD != None){
        m = p.myHUD.HUDMutator;

        While(m != None) {
            if(m.Class == self.Class) {
                return m;
                break;
            } else {
                m = m.NextHUDMutator;
            }
        }
    }

    return None;
}

defaultproperties {
    bLogToGameLogfile=false
}
