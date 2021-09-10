class RandomHelper extends Actor nousercreate;

const MULTIPLIER = 0x015a4e35;
const INCREMENT = 1;

//**********************************************************************
// Generates a semi random number based on a given seed, seed is updated
// Ranges from -1 to 1 *************************************************
static final function float fRandom_Seed(float Scale, out int RandomSeed) {
	local int aRs;
	local float Result;

	if(Scale == 0) {
		Scale = 1;
	}

	RandomSeed = MULTIPLIER * RandomSeed + INCREMENT;
	aRs = ((RandomSeed >>> 16) & 65535) - 32768; //Sign is kept, precision increased
	Result = scale * aRs / 32768f;

	return Result;
}

static final function Rotator GetRandomRotation(){
		local Rotator RandRot;
		RandRot.Pitch = FRand() * 200 - 100;//-100 -> 100
		RandRot.Yaw = FRand() * 200 - 100;//-100 -> 100
		RandRot.Roll = FRand() * 200 - 100;//-100 -> 100

		return RandRot;
}
