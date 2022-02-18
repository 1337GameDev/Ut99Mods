class ActorDirectionRelationResult extends ValueContainer;

//Is the target considered in front of the source?
var bool InFrontOf;

//Is the target considered EXACTLY to left/right of the source?
var bool IsLeftRightOf;

//Is the target considered behind of the source?
var bool InBehindOf;

//Fetched from: https://wiki.beyondunreal.com/Legacy:UnrealScript_Vector_Maths#...find_out_vector_B_that_points_x_degrees_to_the_left_or_right_of_vector_A
function SetRelationFromDotResult(float DotResult){
    InFrontOf = DotResult > 0;
    IsLeftRightOf = DotResult == 0;
    InBehindOf = DotResult < 0;
}

defaultproperties
{
      InFrontOf=False
      IsLeftRightOf=False
      InBehindOf=False
}
