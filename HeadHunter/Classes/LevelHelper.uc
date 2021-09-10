class LevelHelper extends Actor nousercreate;

//************************************
//Get detail value, 3 is max, 0 is min
//************************************
static final function int GetDetailMode(LevelInfo Level) {
	return 2 + int(Level.bHighDetailMode)
			- (int(Level.bDropDetail) + int(Level.bAggressiveLOD));
}

defaultproperties {

}
