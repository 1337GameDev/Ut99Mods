// ============================================================
// InventoryHelper
// ============================================================
class PatternLight extends Light;

var float Direction;
var float CurrentTime;
var() bool StartAtEnd;
var() bool Loop;
var() bool StartEnabled;
var bool IsEnabled;

var() TimeFunction TimeFX;

simulated function BeginPlay() {
    DrawType = DT_None;

    if(!StartEnabled){
        return;
    }

    if(TimeFX == None){
       TimeFX = new class'SinFunction';
    }

    IsEnabled = true;

    if(StartAtEnd) {
        Direction = -1;
        CurrentTime = TimeFX.MaxFunctionTime;
    } else {
        Direction = 1;
    }

    UpdateBrightnessFromTime();
}

// Called whenever time passes.
function Tick(float DeltaTime) {
    if(TimeFX == None){
        return;
    }

    CurrentTime += Direction * DeltaTime;

    if(Direction == 0) {
        CurrentTime = 0;
        IsEnabled = false;
    } else if(Direction == -1){
        if(CurrentTime <= 0){
           CurrentTime = 0;
           if(Loop) {
               Direction *= -1;
           } else {
               IsEnabled = false;
           }
        }
    } else if(Direction == 1) {
         if(CurrentTime >= TimeFX.MaxFunctionTime){
           CurrentTime = TimeFX.MaxFunctionTime;
           if(Loop) {
               Direction *= -1;
           } else {
               IsEnabled = false;
           }
        }
    }

    UpdateBrightnessFromTime();
}

function SetBrightnessFromTime(float time){
    if(TimeFX == None){
         return;
    }

    LightBrightness = 255 * Clamp(TimeFX.TimeFx(time), 0, 1);
}

function UpdateBrightnessFromTime(){
    local float fxResult, newBrightness;
    if(TimeFX == None){
         return;
    }

    fxResult = TimeFX.TimeFx(CurrentTime);
    newBrightness = 255 * FClamp(fxResult, 0.0, 1.0);
    LightBrightness = newBrightness;

}

static function PatternLight SpawnWithFX(Actor context, TimeFunction fx, optional Vector location){
    local PatternLight light;

    if(fx == None){
        return None;
    } else {
        light = context.Spawn(class'PatternLight', None, '', location);
        light.TimeFX = fx;
    }

    return light;
}

defaultproperties
{
      Direction=1.000000
      CurrentTime=0.000000
      StartAtEnd=False
      Loop=True
      StartEnabled=True
      IsEnabled=True
      TimeFX=None
      bStatic=False
      bHidden=False
      RemoteRole=ROLE_SimulatedProxy
      bMovable=True
      LightBrightness=0
}
