class HUDMutator extends Mutator nousercreate;

var PlayerPawn PlayerOwner;
var bool bLogToGameLogfile;

simulated function PostRender(Canvas C) {
    if(NextHUDMutator != None) {
        NextHUDMutator.PostRender(C);
    }
}

// Fixed version of the Mutator function
simulated function RegisterThisHUDMutator() {
    local PlayerPawn P;
    local bool Registered;
    local int NumPlayersSearched;

    if(bLogToGameLogfile) {
        Log("HUDMutator: RegisterThisHUDMutator:"@self.class);
    }

    ForEach AllActors(class'PlayerPawn', P) {
        if (P.myHUD != None) {
            NextHUDMutator = P.myHud.HUDMutator;
            P.myHUD.HUDMutator = Self;
            bHUDMutator = True;
            PlayerOwner = P;

            Registered = true;
        }
        NumPlayersSearched++;
    }

    if(bLogToGameLogfile) {
        Log("HUDMutator: PlayerPawn Found in loop:"@P);
    }

    if(!Registered){
        Log(self.Class$": PlayerPawn.myHud NOT found in any of the ["$NumPlayersSearched$"] PlayerPawns checked.");
    }
}

static function Mutator GetHUDMutatorFromPlayerPawnByClassName(PlayerPawn p, name className){
    local Mutator m;
    if(p.myHUD != None){
        m = p.myHUD.HUDMutator;

        While(m != None) {
            if(m.IsA(className)) {
                return m;
                break;
            } else {
                m = m.NextHUDMutator;
            }
        }
    }

    return None;
}

defaultproperties
{
    bLogToGameLogfile=true
}
