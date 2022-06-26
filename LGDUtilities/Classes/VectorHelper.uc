// ============================================================
// VectorHelper
// ============================================================

class VectorHelper extends Object;

//Fethed from: https://wiki.beyondunreal.com/Legacy:Quaternions_In_Unreal_Tournament
// Sets the components of a vector. Vect cannot be used as it will not accept an expression.
static function vector VectorFromComponents(float x, float y, float z) {
    // for some reason vect() wont work when setting an array element
    local vector v ;

    v.x = x ;
    v.y = y ;
    v.z = z ;

    return v ;
}

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
   return (class'LGDUtilities.VectorHelper'.static.VSizeSq(a-b) < distance**2 );
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

final operator(44) string $= (out string A, Vector B) {
    A $= class'LGDUtilities.VectorHelper'.static.VectorToString(B);
    return A;
}
final operator(44) string @= (out string A, Vector B) {
    A @= class'LGDUtilities.VectorHelper'.static.VectorToString(B);
    return A;
}
final operator(40) string $ (coerce string A, Vector B) {
    return A $ class'LGDUtilities.VectorHelper'.static.VectorToString(B);
}
final operator(40) string @ (coerce string A, Vector B) {
    return A @ class'LGDUtilities.VectorHelper'.static.VectorToString(B);
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

	DeltaRot.Yaw = (class'LGDUtilities.MathHelper'.static.acos(Normal(ATop) dot Normal(BTop)) * class'LGDUtilities.MathHelper'.default.RadToUnrRot) & 65535;
	DeltaRot.Pitch = (class'LGDUtilities.MathHelper'.static.acos(Normal(ASide) dot Normal(BSide)) * class'LGDUtilities.MathHelper'.default.RadToUnrRot) & 65535;
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
     Theta = class'LGDUtilities.MathHelper'.static.acos(FdotT) * PercentDecimal;

     RelativeVec = To - (From * FdotT);

     RelativeVec = Normal(RelativeVec);

     // Orthonormal basis
     // The final result.
     Result = ((From * Cos(Theta)) + (RelativeVec * Sin(Theta)) );

     return Result;
}

static function float GetRadiansBetweenNormalizedVectors(Vector A, Vector B){
     return class'LGDUtilities.MathHelper'.static.acos(A dot B);
}
static function float GetDegreesBetweenNormalizedVectors(Vector A, Vector B){
     return class'LGDUtilities.VectorHelper'.static.GetRadiansBetweenNormalizedVectors(A, B) * class'LGDUtilities.MathHelper'.default.RadToDeg;
}

//This, given 2 vectors -- A and B, computes the angles of rotation on each axis, x/y/z to make the vectors parallel
static function Rotator GetAnglesBetweenVectorsAsRotator(Vector A, Vector B) {
    local Vector ResultingAnglesVector;

    ResultingAnglesVector = class'LGDUtilities.VectorHelper'.static.GetAnglesBetweenVectorsAsVector(A,B);

    return class'LGDUtilities.RotatorHelper'.static.RotatorFromVectorOfDegrees(ResultingAnglesVector);
}

//This, given 2 vectors -- A and B, computes the angles of rotation on each axis, x/y/z to make the vectors parallel
//Fetched from: https://stackoverflow.com/questions/42554960/get-xyz-angles-between-vectors
//Extra info from: https://stackoverflow.com/questions/42554960/get-xyz-angles-between-vectors
static function Vector GetAnglesBetweenVectorsAsVector(Vector A, Vector B) {
    local Vector ResultingRot, AlignedVectorA, AlignedVectorB, ResultingCrossProd;
    local float xAngle, yAngle, zAngle;
    local bool xIs180, yIs180, zIs180;

    //if either vector is the orgin, no rotation can rotate one towards / from the other
    if(((A.X ~= 0) && (A.Y ~= 0) && (A.Z ~= 0)) || ((B.X ~= 0) && (B.Y ~= 0) && (B.Z ~= 0)) ){
        return Vect(0,0,0);
    }

    //align a vector on each plan, to isolate x axis at a time
    //make a plane with yz, to get x rotation
    AlignedVectorA = A;
    A.X = 0;
    AlignedVectorB = B;
    B.X = 0;
    ResultingCrossProd = AlignedVectorA cross AlignedVectorB;
    xAngle = class'LGDUtilities.MathHelper'.static.atan2((ResultingCrossProd.X + ResultingCrossProd.Y + ResultingCrossProd.Z), AlignedVectorA dot AlignedVectorB) * class'LGDUtilities.MathHelper'.default.RadToDeg;
    if(xAngle != 0){
        xAngle *= -1;
    }

    //make a plane with xz, to get Y rotation
    AlignedVectorA = A;
    A.Y = 0;
    AlignedVectorB = B;
    B.Y = 0;
    ResultingCrossProd = AlignedVectorA cross AlignedVectorB;
    yAngle = class'LGDUtilities.MathHelper'.static.atan2((ResultingCrossProd.X + ResultingCrossProd.Y + ResultingCrossProd.Z), AlignedVectorA dot AlignedVectorB) * class'LGDUtilities.MathHelper'.default.RadToDeg;
    if(yAngle != 0){
        yAngle *= -1;
    }

    //make a plane with xy, to get z rotation
    AlignedVectorA = A;
    A.Z = 0;
    AlignedVectorB = B;
    B.Z = 0;
    ResultingCrossProd = AlignedVectorA cross AlignedVectorB;
    zAngle = class'LGDUtilities.MathHelper'.static.atan2((ResultingCrossProd.X + ResultingCrossProd.Y + ResultingCrossProd.Z), AlignedVectorA dot AlignedVectorB) * class'LGDUtilities.MathHelper'.default.RadToDeg;
    if(zAngle != 0){
        zAngle *= -1;
    }

    //do extra sanity check for 180* rotations (as antiparallel vectors can cause multiple axis to have 180 degree results)
    xIs180 = Abs(xAngle) ~= 180;
    yIs180 = Abs(yAngle) ~= 180;
    zIs180 = Abs(zAngle) ~= 180;

    if(xIs180) {
        if(yIs180) {
            yAngle = 0;
        }

        if(zIs180) {
            zAngle = 0;
        }
    } else if(yIs180) {
        if(zIs180) {
            zAngle = 0;
        }
    }

    //apply some logic to smooth out values very close to zero/1/-1 to make calculations easier
    if(xAngle ~= 0){
        xAngle = 0;
    } else if(xAngle ~= 1){
        xAngle = 1;
    } else if(xAngle ~= -1){
        xAngle = -1;
    }

    if(yAngle ~= 0){
        yAngle = 0;
    } else if(yAngle ~= 1){
        yAngle = 1;
    } else if(yAngle ~= -1){
        yAngle = -1;
    }

    if(zAngle ~= 0){
        zAngle = 0;
    } else if(zAngle ~= 1){
        zAngle = 1;
    } else if(zAngle ~= -1){
        zAngle = -1;
    }

    xAngle = class'LGDUtilities.MathHelper'.static.RoundGivenLimits(xAngle, 0.999999, 0.000001);
    yAngle = class'LGDUtilities.MathHelper'.static.RoundGivenLimits(yAngle, 0.999999, 0.000001);
    zAngle = class'LGDUtilities.MathHelper'.static.RoundGivenLimits(zAngle, 0.999999, 0.000001);

    //pitch, yaw, roll values
    //found rotator axis defined here: https://lodev.org/unrealed/movers/movers.html
    ResultingRot.X = xAngle;
    ResultingRot.Y = yAngle;
    ResultingRot.Z = zAngle;

    return ResultingRot;
}

//Given Points A,B and C (where A & B are points for a line) determines if Point C is on the left side of the line (Line is FROM point A TOWARDS point B)
//essentially uses cross product fundamentals
static function bool isPointCLeftOfLinePointsAB(float PointAX, float PointAY, float PointBX, float PointBY, float PointCX, float PointCY) {
    return ((PointBX - PointAX)*(PointCY - PointAY) - (PointBY - PointAY)*(PointCX - PointAX)) > 0;
}

//calculates if a vector is left or right (ignoring the Z dimension) of another vector
//returns an INT with the following conditions:
// < 0 : left side
// > 0 : right side
// == 0 : in front of
static function int TwoDimensionalVectorBRelationToA(Vector A, Vector B) {
    local float DotProdResult;

    DotProdResult = (A.X*(-1*B.Y)) + (A.Y*B.X);

    if(DotProdResult > 0) {//B was on the right
        return 1;
    } else if(DotProdResult < 0) {//B on the left
        return -1;
    } else {//colinear vectors
        //dot == 0
        return 0;
    }
}

//ensures the B vector is constrained within +- the degress in relation to the first vector A
static function Vector ClampNormalVectorAxisAnglesInRelationToAnother(Vector A, Vector B, float MaxXAngleDeviation, float MaxYAngleDeviation, float MaxZAngleDeviation, optional bool bLogToGameFile) {
    local Vector AnglesBetweenVectors, ResultingVector;
    local bool IsNegative;
    local Rotator RotationOfVector;

    AnglesBetweenVectors = class'LGDUtilities.VectorHelper'.static.GetAnglesBetweenVectorsAsVector(A, B);

    IsNegative = AnglesBetweenVectors.X < 0;
    AnglesBetweenVectors.X = FClamp(Abs(AnglesBetweenVectors.X), 0, MaxXAngleDeviation);
    if(IsNegative) {
        AnglesBetweenVectors.X = -1 * AnglesBetweenVectors.X;
    }

    IsNegative = AnglesBetweenVectors.Y < 0;
    AnglesBetweenVectors.Y = FClamp(Abs(AnglesBetweenVectors.Y), 0, MaxYAngleDeviation);
    if(IsNegative) {
        AnglesBetweenVectors.Y = -1 * AnglesBetweenVectors.Y;
    }

    IsNegative = AnglesBetweenVectors.Z < 0;
    AnglesBetweenVectors.Z = FClamp(Abs(AnglesBetweenVectors.Z), 0, MaxZAngleDeviation);
    if(IsNegative) {
        AnglesBetweenVectors.Z = -1 * AnglesBetweenVectors.Z;
    }

    RotationOfVector = class'LGDUtilities.RotatorHelper'.static.RotatorFromVectorOfDegrees(AnglesBetweenVectors);

    ResultingVector = A;
    ResultingVector = ResultingVector << RotationOfVector;

    ResultingVector = class'LGDUtilities.VectorHelper'.static.RoundValuesOfVector(ResultingVector, 0.999999, 0.000001);

    return ResultingVector;
}

//returns the 2D clockwise perindicular vector to the given vector (ignoring the Z value)
static function Vector ClockwisePerpindicular2D(Vector A) {
    local Vector ResultingVector;
    ResultingVector.X = A.Y;
    ResultingVector.Y = -1 * A.X;

    return ResultingVector;
}

//returns the 2D clockwise perindicular vector to the given vector (ignoring the Z value)
static function Vector CounterClockwisePerpindicular2D(Vector A) {
    local Vector ResultingVector;
    ResultingVector.X = -1*A.Y;
    ResultingVector.Y = A.X;

    return ResultingVector;
}

static function Vector RoundValuesOfVector(Vector v, optional float upperLimit, optional float lowerLimit){
    v.X = class'LGDUtilities.MathHelper'.static.RoundGivenLimits(v.X, upperLimit, lowerLimit);
    v.Y = class'LGDUtilities.MathHelper'.static.RoundGivenLimits(v.Y, upperLimit, lowerLimit);
    v.Z = class'LGDUtilities.MathHelper'.static.RoundGivenLimits(v.Z, upperLimit, lowerLimit);

    return v;
}

defaultproperties {
}
