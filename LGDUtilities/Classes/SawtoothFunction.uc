//-----------------------------------------------------------
//  SawtoothFunction - An object that represents a basic sawtooth function eg: /|/|/|
//-----------------------------------------------------------
class SawtoothFunction extends TimeFunction;

function float TimeFx(float time) {
    return time - int(0.5 + time) + 0.5;
}

defaultproperties {
      MaxFunctionTime=5.000000
}
