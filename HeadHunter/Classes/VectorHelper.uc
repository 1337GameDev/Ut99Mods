// ============================================================
// VectorHelper
// ============================================================

class VectorHelper extends Object;

static function vector RandomVelocity(vector ExistingVelocity, bool bWaterZone) {
    local vector RandDir, ResultVelocity;

	RandDir = 700 * FRand() * VRand();
	RandDir.Z = 200 * FRand() - 50;
	ResultVelocity = Vect(1,1,1) * (0.2 + FRand());

	if(VSize(ExistingVelocity) <= 0.1) {
	     ResultVelocity *= RandDir;
	} else {
	     ResultVelocity *= (ExistingVelocity + RandDir);
	}

	if(bWaterZone) {
		ResultVelocity *= 0.5;
	}

	return ResultVelocity;
}

static function vector GetBounceVelocity(vector CurrentVelocity, vector HitNormal, float CoefOfRestitution) {
    local vector resultVelocity;
    //calculate the resulting velocity+dir
    //then, taking into elasticity, reistence, and mass then adjust the velocity
    resultVelocity = MirrorVectorByNormal(CurrentVelocity, HitNormal);
    resultVelocity *= CoefOfRestitution;

    return resultVelocity;
}

static function bool isBehind(vector position, vector forward, vector target){
    local vector TargetDir, directionToTargetNormalized;
    local bool isBehind;

    TargetDir = position - target;
   	directionToTargetNormalized = Normal(TargetDir);
	isBehind = (directionToTargetNormalized dot forward) >= 0;

	return isBehind;
}

//more efficient distance comparison -- skips the sqr root operation, and trades for a multiply operation
static final function bool IsDistanceLessThan(vector a, vector b, float distance) {
   return (class'VectorHelper'.static.VSizeSq(a-b) < distance**2 );
}

static final function float VSizeSq(Vector a) {
  return a dot a;
}

static final function bool WallFacing(Actor A) {
	local rotator AdjRot;
	local vector EndTrace, RotDir;
	local bool bFreeDir;

	if(A==None || A.bDeleteMe) { //Should log this funky situation ?
		return False;
    }

	AdjRot = A.Rotation;
	RotDir = Vector(AdjRot);
	EndTrace = A.Location + 280 * RotDir;
	bFreeDir = A.FastTrace(EndTrace, A.Location);

	return !bFreeDir;
}

static final function string VectorToString(Vector v) {
  return "(X:" $ v.X $ ", Y:" $ v.Y $ ", Z:" $ v.Z $ ")";
}

//Rotate vector A towards vector B, an amount of degrees.
//Fetched from: https://wiki.beyondunreal.com/Legacy:Useful_Maths_Functions
static final function RotateVector(out vector A, vector B, float Degree) {
	local float Magnitude;
	local vector C;

	Degree = Degree * Pi / 180.0;//Convert to radians.
	Magnitude = VSize(A);
	A = Normal(A);
	B = Normal(B);

	if(A Dot B == -1.0) {//Vectors are pointing in opposite directions.
		B.x += 0.0001;//fudge it a little
    }

	C = Normal(B - (A Dot B) * A);//This forms a right angle with A
	A = Normal(A * Cos(Degree) + C * Sin(Degree)) * Magnitude;
}

/**
 * RotBetweenVect
 *
 * This function returns a rotator with pitch and yaw values which
 * would be needed to rotate the first passed vector to the second one
 *
 * @param A - First vector
 * @param B - Second vector
 * @return DeltaRot - Pitch and Yaw rotation between vector A and B
 * Fetched from: https://wiki.beyondunreal.com/Legacy:Useful_Maths_Functions
 */
static function Rotator RotBetweenVect(Vector A, Vector B) {
	local Rotator DeltaRot;
	local Vector  ATop, BTop;   //Top projections of the vectors
	local Vector  ASide, BSide; //Side projections of the vectors

	ATop = A;
	BTop = B;
	ATop.Z = 0;
	BTop.Z = 0;

	ASide = A;
	BSide = B;
	ASide.Y = 0;
	BSide.Y = 0;

	DeltaRot.Yaw = (class'MathHelper'.static.acos(Normal(ATop) dot Normal(BTop)) * class'MathHelper'.default.RadToUnrRot) & 65535;
	DeltaRot.Pitch = (class'MathHelper'.static.acos(Normal(ASide) dot Normal(BSide)) * class'MathHelper'.default.RadToUnrRot) & 65535;
	DeltaRot.Roll = 0;

	return DeltaRot;
}

//Fetched from: https://keithmaggio.wordpress.com/2011/02/15/math-magician-lerp-slerp-and-nlerp/
static function Vector LerpVector(Vector From, Vector To, float PercentDecimal) {
     local Vector Result;
     PercentDecimal = FClamp(PercentDecimal, 0.0, 1.0);
     //Result = (From * PercentDecimal) + (To * (1.0 - PercentDecimal));

     Result = From + ((To - From) * PercentDecimal);

     return result;
}

//Fetched from: https://keithmaggio.wordpress.com/2011/02/15/math-magician-lerp-slerp-and-nlerp/
static function Vector SLerpVector(Vector From, Vector To, float PercentDecimal){
     local Vector Result, RelativeVec;
     local float FdotT, Theta;

     PercentDecimal = FClamp(PercentDecimal, 0.0, 1.0);
     // Dot product - the cosine of the angle between 2 vectors.
     FdotT = From dot To;

     // Clamp it to be in the range of Acos()
     // This may be unnecessary, but floating point
     // precision can be a fickle mistress.
     FdotT = FClamp(FdotT, -1.0, 1.0);

     // Acos(dot) returns the angle between start and end,
     // And multiplying that by percent returns the angle between
     // start and the final result.
     Theta = class'MathHelper'.static.acos(FdotT) * PercentDecimal;

     RelativeVec = To - (From * FdotT);

     RelativeVec = Normal(RelativeVec);

     // Orthonormal basis
     // The final result.
     Result = ((From * Cos(Theta)) + (RelativeVec * Sin(Theta)) );

     return Result;
}

static function float GetRadiansBetweenNormalizedVectors(Vector A, Vector B){
     return class'MathHelper'.static.acos(A dot B);
}
static function float GetDegreesBetweenNormalizedVectors(Vector A, Vector B){
     return class'VectorHelper'.static.GetRadiansBetweenNormalizedVectors(A, B) * class'MathHelper'.default.RadToDeg;
}

//This, given 2 vectors -- A and B, computes the angles of rotation on each axis, x/y/z to make the vectors parallel
//Fetched from: https://stackoverflow.com/questions/42554960/get-xyz-angles-between-vectors
static function Rotator GetAnglesBetweenVectors(Vector A, Vector B) {
    local Rotator ResultingRot;
    local Vector AlignedVectorA, AlignedVectorB;
    local float xAngle, yAngle, zAngle;

    //align a vector on each plan, to isolate x axis at a time
    //make a plane with yz, to get x rotation
    AlignedVectorA = A;
    A.X = 0;
    AlignedVectorB = B;
    B.X = 0;
    xAngle = class'MathHelper'.static.acos(AlignedVectorA dot AlignedVectorB);

    //make a plane with xz, to get Y rotation
    AlignedVectorA = A;
    A.Y = 0;
    AlignedVectorB = B;
    B.Y = 0;
    yAngle = class'MathHelper'.static.acos(AlignedVectorA dot AlignedVectorB);

    //make a plane with xy, to get z rotation
    AlignedVectorA = A;
    A.Z = 0;
    AlignedVectorB = B;
    B.Z = 0;
    zAngle = class'MathHelper'.static.acos(AlignedVectorA dot AlignedVectorB);

    //pitch, yaw, roll values
    //found rotator axis defined here: https://lodev.org/unrealed/movers/movers.html
    ResultingRot.Pitch = (xAngle * class'MathHelper'.default.DegToUnrRot) & 65535;
    ResultingRot.Yaw = (zAngle * class'MathHelper'.default.DegToUnrRot) & 65535;
    ResultingRot.Roll = (yAngle * class'MathHelper'.default.DegToUnrRot) & 65535;

    return ResultingRot;
}

defaultproperties {

}
