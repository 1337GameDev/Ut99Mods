class RotatorHelper extends Actor nousercreate;

//*************************************************
//Obtain a 'middle' point between 2 given rotations
//*************************************************
static final function Rotator AlphaRotation(Rotator End, Rotator Start, float Alpha) {
	local Rotator Middle;

	Middle.Yaw   = (Start.Yaw   + (End.Yaw   - Start.Yaw  ) * Alpha) & 65535;
	Middle.Pitch = (Start.Pitch + (End.Pitch - Start.Pitch) * Alpha) & 65535;
	Middle.Roll  = (Start.Roll  + (End.Roll  - Start.Roll ) * Alpha) & 65535;

	return Middle;
}

static final function Rotator RandomlyVaryRotation(Rotator RotationToVary, float VaryYawByDegrees, float VaryPitchByDegrees, float VaryRollByDegrees){
    local Rotator r;
    r = RotationToVary;

    if(VaryYawByDegrees > 0){
	    r.Yaw   += ((FRand() * 2 - 1) * VaryYawByDegrees * class'MathHelper'.default.DegToUnrRot) & 65535;//-1 to 1, then increase range based on what degrees to vary
	}
	if(VaryPitchByDegrees > 0){
	    r.Pitch  += ((FRand() * 2 - 1) * VaryPitchByDegrees * class'MathHelper'.default.DegToUnrRot) & 65535;//-1 to 1, then increase range based on what degrees to vary
	}
	if(VaryRollByDegrees > 0){
	    r.Roll   += ((FRand() * 2 - 1) * VaryRollByDegrees * class'MathHelper'.default.DegToUnrRot) & 65535;//-1 to 1, then increase range based on what degrees to vary
	}

	return r;
}

static final function Rotator RandomRotationByDegrees(float MaxYawByDegrees, float MaxPitchByDegrees, float MaxRollByDegrees){
	return class'RotatorHelper'.static.RandomlyVaryRotation(Rot(0,0,0), MaxYawByDegrees, MaxPitchByDegrees, MaxRollByDegrees);
}

static final function string RotatorToString(Rotator r, optional bool convertToDegrees) {
    if(convertToDegrees){
        return "(Roll:" $ r.Pitch*class'MathHelper'.default.UnrRotToDeg $ ", Yaw:" $ r.Yaw*class'MathHelper'.default.UnrRotToDeg $ ", Roll:" $ r.Roll*class'MathHelper'.default.UnrRotToDeg $ ")";
    } else {
        return "(Roll:" $ r.Pitch $ ", Yaw:" $ r.Yaw $ ", Roll:" $ r.Roll $ ")";
    }
}

/*
  Lerps a rotation, starting at "From" and anding at "To" using a percentage to indicator how far between the two rotations to return.
  Percent - The percentage (expressed as a value from 0.0 -> 1.0)
*/
static final function Rotator LerpRotation(Rotator From, Rotator To, float Percent){
    local Rotator Difference, Result;
    local float ClampedPercent;

    ClampedPercent = FClamp(Percent, 0.0, 1.0);//ensure we are between 0 and 1
    Difference = To - From;
    Result = From + (ClampedPercent * Difference); //how far along the difference are we, from the FROM value to the TO value
    return Result;
}

/*
  Rotate a rotator by another rotator
  Fetched from: https://wiki.beyondunreal.com/Legacy:UnrealScript_Vector_Maths
*/
static function rotator rTurn(Rotator rHeading, Rotator rTurnAngle) {
    // Generate a turn in object coordinates
    //     this should handle any gymbal lock issues
    local vector vForward,vRight,vUpward;
    local vector vForward2,vRight2,vUpward2;
    local rotator T;
    local vector  V;

    GetAxes(rHeading, vForward, vRight, vUpward);
    //  rotate in plane that contains vForward&vRight
    T.Yaw = rTurnAngle.Yaw;
    V = Vector(T);

    vForward2 = V.X*vForward + V.Y*vRight;
    vRight2 = V.X*vRight - V.Y*vForward;
    vUpward2 = vUpward;

    // rotate in plane that contains vForward&vUpward
    T.Yaw = rTurnAngle.Pitch;
    V = Vector(T);

    vForward = V.X*vForward2 + V.Y*vUpward2;
    vRight = vRight2;
    vUpward = V.X*vUpward2 - V.Y*vForward2;

    // rotate in plane that contains vUpward&vRight
    T.Yaw = rTurnAngle.Roll;
    V = Vector(T);

    vForward2 = vForward;
    vRight2 = V.X*vRight + V.Y*vUpward;
    vUpward2=V.X*vUpward - V.Y*vRight;

    T = OrthoRotation(vForward2, vRight2, vUpward2);

   return(T);
}



