//-----------------------------------------------------------
//  SqWaveFunction - An object that represents a basic square wave function eg: |-|_|-|_
//-----------------------------------------------------------
class SqWaveFunction extends TimeFunction;

function float TimeFx(float time) {
    return 1 + ((2 * int(time)) - int(2 * time));
}

DefaultProperties
{
    MaxFunctionTime=5.0
}
