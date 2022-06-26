class Matrix3x3 extends Object;

var() float a11, a21, a31;
var() float a12, a22, a32;
var() float a13, a23, a33;

static function Matrix3x3 defMatrix9f(
float a11,float a12,float a13, 
float a21,float a22,float a23,
float a31,float a32,float a33
) {
	local Matrix3x3 theMatrix;
	theMatrix = new class'LGDUtilities.Matrix3x3';
	
	theMatrix.a11 = a11;
	theMatrix.a12 = a12;
	theMatrix.a13 = a13;
	theMatrix.a21 = a21;
	theMatrix.a22 = a22;
	theMatrix.a23 = a23;
	theMatrix.a31 = a31;
	theMatrix.a32 = a32;
	theMatrix.a33 = a33;
	
	return theMatrix;
}

static final operator(16) vector * (Matrix3x3 M, Vector v) {
    local Vector Mv, R1, R2, R3;

    R1.x = M.a11; R1.y = M.a12; R1.z = M.a13;
    R2.x = M.a21; R2.y = M.a22; R2.z = M.a23;
    R3.x = M.a31; R3.y = M.a32; R3.z = M.a33;

    Mv = R1 * V.X + R2 * V.Y + R3 * V.Z;

    return Mv;
}