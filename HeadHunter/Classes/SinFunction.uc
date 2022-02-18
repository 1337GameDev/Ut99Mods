//-----------------------------------------------------------
//  SinFunction - An object that represents a basic sin function eg: ~~~~~~~
//-----------------------------------------------------------
class SinFunction extends TimeFunction;

function float TimeFx(float time) {
    return (0.5*Sin(time)) + 0.5;
}

defaultproperties
{
      MaxFunctionTime=5.000000
}
