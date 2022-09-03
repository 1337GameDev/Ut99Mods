class GeometryHelper extends Actor nousercreate;

/*
A utility function to calculate area of triangle formed by (x1, y1),
   (x2, y2) and (x3, y3)
*/
static final function float areaOfTriangle(int x1, int y1, int x2, int y2, int x3, int y3) {
    return Abs((x1*(y2-y3) + x2*(y3-y1) + x3*(y1-y2)) / 2.0);
}

/*
A function to check whether point P(x, y) lies
   inside the triangle formed by A(x1, y1),
   B(x2, y2) and C(x3, y3)
*/
static final function bool isInsideTriangle(int vertex1x, int vertex1y, int vertex2x, int vertex2y, int vertex3x, int vertex3y, int testPointX, int testPointY) {
       local float A, A1, A2, A3;

       /* Calculate area of triangle ABC */
       A = class'LGDUtilities.GeometryHelper'.static.areaOfTriangle(vertex1x, vertex1y, vertex2x, vertex2y, vertex3x, vertex3y);

       /* Calculate area of triangle PBC */
       A1 = class'LGDUtilities.GeometryHelper'.static.areaOfTriangle(testPointX, testPointY, vertex2x, vertex2y, vertex3x, vertex3y);

       /* Calculate area of triangle PAC */
       A2 = class'LGDUtilities.GeometryHelper'.static.areaOfTriangle(vertex1x, vertex1y, testPointX, testPointY, vertex3x, vertex3y);

       /* Calculate area of triangle PAB */
       A3 = class'LGDUtilities.GeometryHelper'.static.areaOfTriangle(vertex1x, vertex1y, vertex2x, vertex2y, testPointX, testPointY);

       /* Check if sum of A1, A2 and A3 is same as A */
        return (A == A1 + A2 + A3);
}

/*
Given 2 Rectangles, Rectangle A and Rectangle B, this method checks if the rectangles overlap.
The rectangles are defined by their Top-Left and Bottom-Right coordinates.

Modified from: https://www.baeldung.com/java-check-if-two-rectangles-overlap

Rectangles overlap if either rectangle are not explicitly above, or to the side of the other.

Checks: 
above/below
1. Rect A is UNDER rect B
2. Rect A is ABOVE rect B

left/right
1. Rect A to the LEFT of rect B
2. Rect A to the RIGHT of rect B
*/
static final function bool RectanglesOverlap(Vector RectATopLeft, Vector RectABottomRight, Vector RectBTopLeft, Vector RectBBottomRight) {
	if (RectATopLeft.Y < RectBBottomRight.Y 
      || RectABottomRight.Y > RectBTopLeft.Y) {
        return false;
    }
    if (RectABottomRight.X < RectBTopLeft.X
	  || RectATopLeft.X > RectBBottomRight.X) {
        return false;
    }
	
    return true;
}


defaultproperties {
}
