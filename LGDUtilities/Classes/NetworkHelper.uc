// ============================================================
// NetworkHelper
// ============================================================

class NetworkHelper extends Object;

//FETCHED from: https://ut99.org/viewtopic.php?f=15&t=12985&sid=ac656310d36baab639b0fd591518ae17

//Used to get NETWORK MOVE TIME for a given mover, given an input amount of time to move a particular mover
//This is used to smooth a mover's move time, as to prevent oddities over network play
//This will smooth the given input time, and output a "better" time that should be used over a network
//Generally used with XC_Engine and it's replacing of "Mover.InterpolateTo" using XC_Engine's ReplaceFunction function replacer shimming - use like: "ReplaceFunction( class'Mover', class'XC_Engine_Mover', 'InterpolateTo', 'InterpolateTo_MPFix');
//Demontsrated by user: Sektor2111
static final function float GetNMT(float f) {
    f = int(100.f * FMax(0.01, (1.0 / FMax(f, 0.005))) + 0.5f);
    f/=100.f;
    Return (1.f/f);
}

defaultproperties {
}
