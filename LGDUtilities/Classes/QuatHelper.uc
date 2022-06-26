// ============================================================
// QuatHelper
// ============================================================

class QuatHelper extends Object;

//Fethed from: https://wiki.beyondunreal.com/Legacy:Quaternions_In_Unreal_Tournament
// Takes a vector representing an axis and an angle in radians.
// Returns the quaternion representing a rotation of Theta about the axis.
static function Quat RotationToQuat(Vector Axis, float Theta) {
    // Theta must be given in radians
    // Axis need not be normalised
    local Quat Q ;
    local float L ;
	Q = new class'LGDUtilities.Quat';
	
    Axis = Normal(Axis);
	
    Q.W = cos(Theta / 2);
    Q.X = Axis.X * sin(Theta / 2);
    Q.Y = Axis.Y * sin(Theta / 2);
    Q.Z = Axis.Z * sin(Theta / 2);
	
    // NORMALISE
    L = Sqrt(Q.W**2 + Q.X ** 2 + Q.Y ** 2 + Q.Z**2);
    Q.W /= L;
    Q.X /= L;
    Q.Y /= L;
    Q.Z /= L;
    
	return Q ;
}

defaultproperties {
}
