class Quat extends Object;

var() float W, X, Y, Z;

//Fethed from: https://wiki.beyondunreal.com/Legacy:Quaternions_In_Unreal_Tournament
final operator(16) Quat * (Quat Q1, Quat Q2) {
	local Vector V1, V2, Vp;
	local Quat Qp;
	Qp = new class'LGDUtilities.Quat';
	
	V1 = class'LGDUtilities.VectorHelper'.static.VectorFromComponents(Q1.X, Q1.Y, Q1.Z);
	V2 = class'LGDUtilities.VectorHelper'.static.VectorFromComponents(Q2.X, Q2.Y, Q2.Z);
	
	Qp.W = Q1.W * Q2.W - (V1 dot V2) ;
	Vp = (Q1.W * V2) + (Q2.W * V1) - (V1 cross V2);
	
	Qp.X = Vp.X;
	Qp.Y = Vp.Y;
	Qp.Z = Vp.Z;
	
	return Qp;
}