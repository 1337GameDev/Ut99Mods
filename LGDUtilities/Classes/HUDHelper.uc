// ============================================================
// InventoryHelper
//
// Some functions fetched from: https://ut99.org/viewtopic.php?t=13998
// ============================================================

class HUDHelper extends Object;

#exec texture IMPORT NAME=CenterRing FILE=Textures\HUDHelper\CenterRing.bmp FLAGS=2 MIPS=OFF

// ----- Tips & Explanations ----- //
/*
Canvas.DrawTile (Texture (UT) Tex, float XL, float YL, float U, float V, float UL, float VL)
This draws a rectangle within the texture onto the screen. The upper left of the texture will be at the current pen position.

* Tex - the texture to draw.
* XL, YL - width and height on the screen, in number of pixels.
* U, V - coordinates, within the texture, of the upper left of the rectangular window.
* UL, VL - width and height, in pixels, of the window within the texture.
*/

 /*
 Get screen X Y coordinates for specified Location:
 */
static function float getXY(Canvas C, vector location, out int screenX, out int screenY) {
    local vector X, Y, Z, CamLoc, TargetDir, Dir, XY;
    local rotator CamRot;
    local Actor Camera;
    local float TanFOVx, TanFOVy;
    local float returnVal;

    C.ViewPort.Actor.PlayerCalcView(Camera, CamLoc, CamRot);

    TanFOVx = Tan(C.ViewPort.Actor.FOVAngle / 114.591559); // 360/Pi = 114.5915590...
    TanFOVy = (C.ClipY / C.ClipX) * TanFOVx;
    GetAxes(CamRot, X, Y, Z);

    TargetDir = Location - CamLoc;
    returnVal = X dot TargetDir;
    Dir = X * returnVal;
    XY = TargetDir - Dir;

    screenX = C.ClipX * 0.5 * (1.0 + (XY dot Y) / (VSize(Dir) * TanFOVx));
    screenY = C.ClipY * 0.5 * (1.0 - (XY dot Z) / (VSize(Dir) * TanFOVy));

    return returnVal;
}

static function float getActorSizeOnHudFromCollider(Canvas C, Actor target, optional bool getMinSize, optional bool showColliderDebugIndicators) {
    local float height, width;

    if((target != None) && (C != None)){
        height = target.CollisionHeight;
		width = target.CollisionRadius;
		
		if(getMinSize) {//we want the minimum dimension
			if(height <= width) {
				return class'LGDUtilities.HUDHelper'.static.getActorVerticalSizeOnHudFromCollider(C, target, showColliderDebugIndicators);
			} else {
				return class'LGDUtilities.HUDHelper'.static.getActorHorizontalSizeOnHudFromCollider(C, target, showColliderDebugIndicators);
			}
		} else {//we want the maximum dimension
			if(height >= width) {
				return class'LGDUtilities.HUDHelper'.static.getActorVerticalSizeOnHudFromCollider(C, target, showColliderDebugIndicators);
			} else {
				return class'LGDUtilities.HUDHelper'.static.getActorHorizontalSizeOnHudFromCollider(C, target, showColliderDebugIndicators);
			}
		}
	} else {
		return 0;
	}
}

static function float getActorVerticalSizeOnHudFromCollider(Canvas C, Actor target, optional bool showColliderDebugIndicators) {
    local Vector topOfActor, bottomOfActor, amountToOffset;
    local int topX,topY, bottomX,bottomY, middleOfActorX,middleOfActorY;
    local float size;

    topOfActor = target.Location;
    bottomOfActor = target.Location;

    if((target != None) && (C != None)){
        amountToOffset = Vect(0,0,1)*target.CollisionHeight;
		topOfActor += amountToOffset;
        bottomOfActor -= amountToOffset;

        class'LGDUtilities.HUDHelper'.static.getXY(C, topOfActor, topX, topY);
        class'LGDUtilities.HUDHelper'.static.getXY(C, bottomOfActor, bottomX, bottomY);
        topX = Clamp(topX, 0, C.ClipX);
        topY = Clamp(topY, 0, C.ClipY);
        bottomX = Clamp(bottomX, 0, C.ClipX);
        bottomY = Clamp(bottomY, 0, C.ClipY);

        if(showColliderDebugIndicators) {
		    class'LGDUtilities.HUDHelper'.static.getXY(C, target.Location, middleOfActorX, middleOfActorY);

            C.SetPos(topX, topY);
            C.DrawText("(^)", True);
            C.SetPos(middleOfActorX, middleOfActorY);
            C.DrawText("(-)", True);
            C.SetPos(bottomX, bottomY);
            C.DrawText("(X)", True);
        }

        topOfActor.x = topX;
        topOfActor.y = topY;

        bottomOfActor.x = bottomX;
        bottomOfActor.y = bottomY;

        size = VSize(topOfActor-bottomOfActor);
    }

    return size;
}

static function float getActorHorizontalSizeOnHudFromCollider(Canvas C, Actor target, optional bool showColliderDebugIndicators) {
    local Vector LSideOfActor, RSideOfActor, amountToOffset;
    local int leftX,leftY, rightX,rightY, middleOfActorX,middleOfActorY;
    local float size;

    LSideOfActor = target.Location;
    RSideOfActor = target.Location;

    if((target != None) && (C != None)) {
        amountToOffset = Vect(1,0,0)*target.CollisionRadius;
		LSideOfActor -= amountToOffset;
        RSideOfActor += amountToOffset;

        class'LGDUtilities.HUDHelper'.static.getXY(C, LSideOfActor, leftX, leftY);
        class'LGDUtilities.HUDHelper'.static.getXY(C, RSideOfActor, rightX, rightY);
        leftX = Clamp(leftX, 0, C.ClipX);
        leftY = Clamp(leftY, 0, C.ClipY);
        rightX = Clamp(rightX, 0, C.ClipX);
        rightY = Clamp(rightY, 0, C.ClipY);

        if(showColliderDebugIndicators) {
		    class'LGDUtilities.HUDHelper'.static.getXY(C, target.Location, middleOfActorX, middleOfActorY);

            C.SetPos(leftX, leftY);
            C.DrawText("(^)", True);
            C.SetPos(middleOfActorX, middleOfActorY);
            C.DrawText("(-)", True);
            C.SetPos(rightX, rightY);
            C.DrawText("(X)", True);
        }

        LSideOfActor.x = leftX;
        LSideOfActor.y = leftY;

        RSideOfActor.x = rightX;
        RSideOfActor.y = rightY;

        size = VSize(LSideOfActor-RSideOfActor);
    }

    return size;
}

static function float getActorSizeOnHudFromColliderWithPoints(Canvas C, Actor target, out Vector ActorSidePoint1, out Vector ActorSidePoint2, optional bool getMinSize, optional bool showColliderDebugIndicators) {
    local float height, width;

    if((target != None) && (C != None)) {
        height = target.CollisionHeight;
		width = target.CollisionRadius;
		
		if(getMinSize) {//we want the minimum dimension
			if(height <= width) {
				return class'LGDUtilities.HUDHelper'.static.getActorVerticalSizeOnHudFromColliderWithPoints(C, target, ActorSidePoint1, ActorSidePoint2, showColliderDebugIndicators);
			} else {
				return class'LGDUtilities.HUDHelper'.static.getActorHorizontalSizeOnHudFromColliderWithPoints(C, target, ActorSidePoint1, ActorSidePoint2, showColliderDebugIndicators);
			}
		} else {//we want the maximum dimension
			if(height >= width) {
				return class'LGDUtilities.HUDHelper'.static.getActorVerticalSizeOnHudFromColliderWithPoints(C, target, ActorSidePoint1, ActorSidePoint2, showColliderDebugIndicators);
			} else {
				return class'LGDUtilities.HUDHelper'.static.getActorHorizontalSizeOnHudFromColliderWithPoints(C, target, ActorSidePoint1, ActorSidePoint2, showColliderDebugIndicators);
			}
		}
	} else {
		return 0;
	}
}

static function float getActorVerticalSizeOnHudFromColliderWithPoints(Canvas C, Actor target, out Vector topOfActor, out Vector bottomOfActor, optional bool showColliderDebugIndicators) {
    local Vector amountToOffset, topScreenPos, bottomScreenPos;
    local int topX,topY, bottomX,bottomY, middleOfActorX,middleOfActorY;
    local float size;

    topOfActor = target.Location;
    bottomOfActor = target.Location;

    if((target != None) && (C != None)){
        amountToOffset = Vect(0,0,1)*target.CollisionHeight;
		topOfActor += amountToOffset;
        bottomOfActor -= amountToOffset;

        class'LGDUtilities.HUDHelper'.static.getXY(C, topOfActor, topX, topY);
        class'LGDUtilities.HUDHelper'.static.getXY(C, bottomOfActor, bottomX, bottomY);
        topX = Clamp(topX, 0, C.ClipX);
        topY = Clamp(topY, 0, C.ClipY);
        bottomX = Clamp(bottomX, 0, C.ClipX);
        bottomY = Clamp(bottomY, 0, C.ClipY);

        if(showColliderDebugIndicators) {
            class'LGDUtilities.HUDHelper'.static.getXY(C, target.Location, middleOfActorX, middleOfActorY);

            C.SetPos(topX, topY);
            C.DrawText("(^)", True);
            C.SetPos(middleOfActorX, middleOfActorY);
            C.DrawText("(-)", True);
            C.SetPos(bottomX, bottomY);
            C.DrawText("(X)", True);
        }

        topScreenPos.x = topX;
        topScreenPos.y = topY;

        bottomScreenPos.x = bottomX;
        bottomScreenPos.y = bottomY;

        size = VSize(topScreenPos-bottomScreenPos);
    }

    return size;
}

static function float getActorHorizontalSizeOnHudFromColliderWithPoints(Canvas C, Actor target, out Vector RSideOfActor, out Vector LSideOfActor, optional bool showColliderDebugIndicators) {
    local Vector amountToOffset, leftScreenPos, rightScreenPos;
    local int leftX,leftY, rightX,rightY, middleOfActorX,middleOfActorY;
    local float size;

    RSideOfActor = target.Location;
    LSideOfActor = target.Location;

    if((target != None) && (C != None)){
        amountToOffset = Vect(1,0,0)*target.CollisionRadius;
		RSideOfActor -= amountToOffset;
        LSideOfActor += amountToOffset;

        class'LGDUtilities.HUDHelper'.static.getXY(C, LSideOfActor, leftX, leftY);
        class'LGDUtilities.HUDHelper'.static.getXY(C, RSideOfActor, rightX, rightY);
        leftX = Clamp(leftX, 0, C.ClipX);
        leftY = Clamp(leftY, 0, C.ClipY);
        rightX = Clamp(rightX, 0, C.ClipX);
        rightY = Clamp(rightY, 0, C.ClipY);

        if(showColliderDebugIndicators) {
            class'LGDUtilities.HUDHelper'.static.getXY(C, target.Location, middleOfActorX, middleOfActorY);

            C.SetPos(leftX, leftY);
            C.DrawText("(^)", True);
            C.SetPos(middleOfActorX, middleOfActorY);
            C.DrawText("(-)", True);
            C.SetPos(rightX, rightY);
            C.DrawText("(X)", True);
        }

        leftScreenPos.x = leftX;
        leftScreenPos.y = leftY;

        rightScreenPos.x = rightX;
        rightScreenPos.y = rightY;

        size = VSize(leftScreenPos-rightScreenPos);
    }

    return size;
}

static function bool IsOffScreen(Canvas C, int screenPosX, int screenPosY, out int offLeft, out int offRight, out int offTop, out int offBottom, optional int margin){
    offLeft = int(screenPosX < margin);
    offRight = int(screenPosX > C.ClipX-margin);
    offTop = int(screenPosY < margin);
    offBottom = int(screenPosY > C.ClipY-margin);

    return offLeft==1 || offRight==1 || offTop==1 || offBottom==1;
}

static function bool IsOffScreenNoReturnValues(Canvas C, int screenPosX, int screenPosY, optional int margin){
    local int offLeft, offRight, offTop, offBottom;

    offLeft = int(screenPosX < margin);
    offRight = int(screenPosX > C.ClipX-margin);
    offTop = int(screenPosY < margin);
    offBottom = int(screenPosY > C.ClipY-margin);

    return offLeft==1 || offRight==1 || offTop==1 || offBottom==1;
}

 /*
 Draw text with outline around it:
 */
static simulated function DrawTextClipped(Canvas C, int X, int Y, string text, color outline) {
    local Color old;

    old = C.DrawColor;
    C.DrawColor = outline;

    C.SetPos(X - 1, Y - 1);
    C.DrawTextClipped(text, False);
    C.SetPos(X + 1, Y + 1);
    C.DrawTextClipped(text, False);
    C.SetPos(X - 1, Y + 1);
    C.DrawTextClipped(text, False);
    C.SetPos(X + 1, Y - 1);
    C.DrawTextClipped(text, False);

    C.DrawColor = old;
    C.SetPos(X, Y);
    C.DrawTextClipped(text, False);
}

/*
Draw line between two points on screen with one pixel texture:
Slow! Don't use often. Better use another approach.
*/
static simulated function DrawLine(Canvas Canvas, int x1, int y1, int x2, int y2) {
    local int i, j, n, dx, dy;
    if (x1 == 0 && y1 == 0) return;
    if (x2 == 0 && y2 == 0) return;

    dx = x2 - x1;
    dy = y2 - y1;

    if (Abs(dx) > Abs(dy)) {
        if (dx == 0) return;
        if (dx > 0) j = 1; else j = -1;

        n = Min(Canvas.ClipX, Max(0, x2));

        for (i = Min(Canvas.ClipX, Max(0, x1)); i != n; i += j) {
            canvas.SetPos(i, y1 + dy*(i - x1)/dx);
            canvas.DrawRect(Texture'Botpack.AmmoCountJunk', 1, 1);
        }
    } else {
        if (dy == 0) return;
        if (dy > 0) j = 1; else j = -1;

        n = Min(Canvas.ClipY, Max(0, y2));

        for (i = Min(Canvas.ClipY, Max(0, y1)); i != n; i += j) {
            canvas.SetPos(x1 + dx*(i - y1)/dy, i);
            canvas.DrawRect(Texture'Botpack.AmmoCountJunk', 1, 1);
        }
    }
}

//Draw 3D Line properly, even if one point is going to back of camera
static simulated function DrawLine3D(Canvas C, vector P1, vector P2, float R, float G, float B){
	local int x1, y1, x2, y2;
	local float a1, a2;
	local Color drawColor;

	a1 = class'LGDUtilities.HUDHelper'.static.getXY(C, P1, x1, y1);
	a2 = class'LGDUtilities.HUDHelper'.static.getXY(C, P2, x2, y2);

	if((a1 <= 0) && (a2 <= 0)){
        return;
    }

	if(a1 <= 0){
		P1 -= P2;
		P1 *= a2/(a2 - a1);
		P1 -= Normal(P1);
		P1 += P2;
		class'LGDUtilities.HUDHelper'.static.getXY(C, P1, x1, y1);
	} else if(a2 <= 0){
		P2 -= P1;
		P2 *= a1/(a1 - a2);
		P2 -= Normal(P2);
		P2 += P1;
		class'LGDUtilities.HUDHelper'.static.getXY(C, P2, x2, y2);
	}

	if(R >= 0) {
		drawColor.R = R;
		drawColor.G = G;
		drawColor.B = B;

		C.DrawColor = drawColor;
	}

	class'LGDUtilities.HUDHelper'.static.DrawLine(C, x1, y1, x2, y2);
}

static simulated function DrawTextureAtXY(Canvas canvas, Texture tex, int screenX, int screenY, float texScale, float playerHudScale, bool centerIcon, optional bool excludePlayerHUDScaleFromOffset) {
      local float xOffset, yOffset;
      if(tex == None) {
          return;
      }

      if(centerIcon) {
          xOffset = tex.USize*texScale*0.5;
          yOffset = tex.VSize*texScale*0.5;

          if(!excludePlayerHUDScaleFromOffset){
              xOffset *= playerHudScale;
              yOffset *= playerHudScale;
          }

          screenX -= xOffset;//shift icon position left half the size of the texture
          screenY -= yOffset;//shift icon position up half the size of the texture
      }

      canvas.SetPos(screenX, screenY);
      canvas.DrawIcon(Tex, (texScale*playerHudScale));
}
static simulated function DrawTextureAtXY_OutputEdgeCordinates(Canvas canvas, Texture tex, int screenX, int screenY, float texScale, float playerHudScale, bool centerIcon, bool excludePlayerHUDScaleFromOffset, out Vector TopL, out Vector TopR, out Vector BottomL, out Vector BottomR, optional bool IgnoreDrawOnlyOutputCordinates) {
      local float xOffset, yOffset, texSizeX, texSizeY;
      if(tex == None) {
          return;
      }

      if(centerIcon) {
          xOffset = tex.USize*texScale*0.5;
          yOffset = tex.VSize*texScale*0.5;

          if(!excludePlayerHUDScaleFromOffset){
              xOffset *= playerHudScale;
              yOffset *= playerHudScale;
          }

          screenX -= xOffset;//shift icon position left half the size of the texture
          screenY -= yOffset;//shift icon position up half the size of the texture
      }

      if(!IgnoreDrawOnlyOutputCordinates){
          canvas.SetPos(screenX, screenY);
          canvas.DrawIcon(Tex, (playerHudScale*texScale));
      }

      texSizeX = tex.USize*texScale;
      texSizeY = tex.VSize*texScale;

      TopL = Vect(0,0,0);
      TopR = Vect(0,0,0);
      BottomR = Vect(0,0,0);
      BottomL = Vect(0,0,0);

      TopL.X = screenX;
      TopL.Y = screenY;

      TopR.X = TopL.X + texSizeX;
      TopR.Y = TopL.Y;

      BottomL.X = TopL.X;
      BottomL.Y = TopL.Y + texSizeY;

      BottomR.X = BottomL.X + texSizeX;
      BottomR.Y = BottomL.Y;
}

//same as above function, but draws the texture centered, but above the point dictated by x/y coords
static simulated function DrawTextureCenteredAboveAtXY(Canvas canvas, Texture tex, int screenX, int screenY, float texScale, float playerHudScale, optional bool excludePlayerHUDScaleFromOffset) {
      local float xOffset, yOffset;
      if(tex == None) {
          return;
      }

      xOffset = tex.USize*texScale*0.5;
      yOffset = tex.VSize*texScale;

      if(!excludePlayerHUDScaleFromOffset){
          xOffset *= playerHudScale;//shift icon position left half the horizontal size of the texture
          yOffset *= playerHudScale;//shift icon position up the full vertical size of the texture
      }

      screenX -= xOffset;
      screenY -= yOffset;

      canvas.SetPos(screenX, screenY);
      canvas.DrawIcon(Tex, (playerHudScale*texScale));
}

static simulated function DrawCircleMidScreenWithWidth(Actor context, Canvas canvas, float wantedWidth, float playerHudScale) {
      local int screenX, screenY;
      screenX = canvas.ClipX * 0.5;
      screenY = canvas.ClipY * 0.5;

      class'LGDUtilities.HUDHelper'.static.DrawCircleAtPosWithWidth(context, canvas, screenX, screenY, wantedWidth, playerHudScale);
}
static simulated function DrawCircleAtPosWithWidth(Actor context, Canvas canvas, int screenX, int screenY, float wantedWidth, float playerHudScale) {
      local Texture tex;
      local float resultingScale;
      tex = Texture'CenterRing';

      resultingScale = class'LGDUtilities.HUDHelper'.static.getScaleForTextureFromMaxTextureDimension(tex, wantedWidth);
      canvas.Style = context.ERenderStyle.STY_Translucent;
      class'LGDUtilities.HUDHelper'.static.DrawTextureAtXY(canvas, tex, screenX, screenY, resultingScale, playerHudScale, true, true);
}

static simulated function DrawTextAtXY(Canvas canvas, Actor context, string text, int screenX, int screenY, optional bool centerText) {
      local float xOffset, yOffset, textSizeX, textSizeY;
      if(text == "") {
          return;
      }

      if(centerText) {
          canvas.SetPos(0, 0);
          canvas.TextSize(text, textSizeX, textSizeY);

          xOffset = textSizeX*0.5;
          yOffset = textSizeY*0.5;

          screenX -= xOffset;//shift icon position left half the size of the texture
          screenY -= yOffset;//shift icon position up half the size of the texture
      }
      canvas.SetPos(screenX, screenY);
      canvas.Style = context.ERenderStyle.STY_Normal;
      canvas.DrawColor = class'LGDUtilities.ColorHelper'.static.GetWhiteColor();
      canvas.DrawTextClipped(text);
}

/*
  Get whether a point on screen is in what screen triangle, using out integers (booleans cannot be out variables):
________________
|\            /|
|  \        /  |
|    \   /     |
|      *       |
|    /   \     |
|  /       \   |
|/____________\|

    Returns: Whether point x/y is in ANY triangle
*/
static simulated function bool GetScreenTrianglesPointIsIn(Canvas canvas, int pointX, int pointY, out int inTop_int, out int inBottom_int, out int inLeft_int, out int inRight_int) {
     local int middleX, middleY;
     middleX = canvas.ClipX / 2;
     middleY = canvas.ClipY / 2;

     inTop_int = int(class'LGDUtilities.GeometryHelper'.static.isInsideTriangle(0,0, middleX,middleY, canvas.ClipX,0, pointX,pointY));
     inBottom_int = int(class'LGDUtilities.GeometryHelper'.static.isInsideTriangle(0,canvas.ClipY, middleX,middleY, canvas.ClipX,canvas.ClipY, pointX,pointY));
     inLeft_int = int(class'LGDUtilities.GeometryHelper'.static.isInsideTriangle(0,0, middleX,middleY, 0,canvas.ClipY, pointX,pointY));
     inRight_int = int(class'LGDUtilities.GeometryHelper'.static.isInsideTriangle(canvas.ClipX,0, middleX,middleY, canvas.ClipX,canvas.ClipY, pointX,pointY));

     return (inTop_int + inBottom_int + inLeft_int + inRight_int) > 0;
}

static function bool GetScreenPointOutsideCenterCircle(Canvas canvas, int pointX, int pointY, int centerCircleRadius) {
     local int middleX, middleY, DistanceLimitFromCenterSqrd;//we square this to avoid a sqr root
     local float yDiff, xDiff;

     middleX = canvas.ClipX / 2;
     middleY = canvas.ClipY / 2;

     if(centerCircleRadius <= 0) {
          centerCircleRadius = 10;
     }

     DistanceLimitFromCenterSqrd = centerCircleRadius*centerCircleRadius;
     xDiff = middleX - pointX;
     yDiff = middleY - pointY;

     return ((xDiff*xDiff) + (yDiff*yDiff)) > DistanceLimitFromCenterSqrd;
}

//given a texture (and based on it's current width), and a desired width, this returns a scale to use for the texture to get the desired width
static simulated function float getScaleForTextureToGetDesiredWidth(Texture tex, float wantedWidth) {
     local float currentTextureWidth, resultingScale;
     currentTextureWidth = tex.USize;

     //resultingScale = (wantedWidth - currentTextureWidth) / wantedWidth;
     resultingScale = (wantedWidth - currentTextureWidth) / currentTextureWidth;
     if(resultingScale < 0) {//if we are to get smaller
         resultingScale = 1.0 - Abs(resultingScale);
     } else if(resultingScale == 0) {//0% change needed
         resultingScale = 1;
     } else {
         resultingScale += 1;//increase by 1
     }

     return resultingScale;
}

//given a texture (and based on it's current height), and a desired height, this returns a scale to use for the texture to get the desired height
static simulated function float getScaleForTextureToGetDesiredHeight(Texture tex, float wantedHeight) {
     local float currentTextureHeight, resultingScale;
     currentTextureHeight = tex.USize;

     //resultingScale = (wantedHeight - currentTextureHeight) / wantedHeight;
     resultingScale = (wantedHeight - currentTextureHeight) / currentTextureHeight;
     if(resultingScale < 0) {//if we are to get smaller
         resultingScale = 1.0 - Abs(resultingScale);
     } else if(resultingScale == 0) {//0% change needed
         resultingScale = 1;
     } else {
         resultingScale += 1;//increase by 1
     }

     return resultingScale;
}

//given a texture (and based on it's current height), and a desired height, this returns a scale to use for the texture to get the desired height
static simulated function float getScaleForTextureFromMaxTextureDimension(Texture tex, float wantedMaxDimensionSize) {
     local float currentTextureMaxDimension, resultingScale;
     currentTextureMaxDimension = Max(tex.USize, tex.VSize);

     resultingScale = (wantedMaxDimensionSize - currentTextureMaxDimension) / currentTextureMaxDimension;
     if(resultingScale < 0) {//if we are to get smaller
         resultingScale = 1.0 - Abs(resultingScale);
     } else if(resultingScale == 0) {//0% change needed
         resultingScale = 1;
     } else {
         resultingScale += 1;//increase by 1
     }

     return resultingScale;
}

/*
Given 2 Rectangles (via HUD Canvas coordinates), Rectangle A and Rectangle B, this method checks if the rectangles overlap.
The rectangles are defined by their Top-Left and Bottom-Right coordinates.

DisplayDebugPoints - This determines if debug text is drawn on the given cordinates for debug reasons.
This will RETAIN the current canvas's color and position (it'll store, modify and then set them to their prior values).

This will use the canvas's CURRENT values for FONT and STYLE (value from ENUM of Actor.ERenderStyle).
If these debug points don't render correctly, these are likely incorrectly set.

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
static final function bool HUDCanvasRectanglesOverlap(Canvas C, Vector RectATopLeft, Vector RectABottomRight, Vector RectBTopLeft, Vector RectBBottomRight, optional bool DisplayDebugPoints) {
	local Vector TranslatedRectATopLeft,TranslatedRectABottomRight     ,TranslatedRectBTopLeft,TranslatedRectBBottomRight;
	
	//Previous Values of the canvas
	local Color PrevColor;
	local Vector PrevPosition;
	
	TranslatedRectATopLeft.X = RectATopLeft.X;
	TranslatedRectATopLeft.Y = C.ClipY - RectATopLeft.Y;
	
	TranslatedRectABottomRight.X = RectABottomRight.X;
	TranslatedRectABottomRight.Y = C.ClipY - RectABottomRight.Y;
	
	TranslatedRectBTopLeft.X = RectBTopLeft.X;
	TranslatedRectBTopLeft.Y = C.ClipY - RectBTopLeft.Y;
	
	TranslatedRectBBottomRight.X = RectBBottomRight.X;
	TranslatedRectBBottomRight.Y = C.ClipY - RectBBottomRight.Y;
	
	if(DisplayDebugPoints) {
		PrevColor = C.DrawColor;
		PrevPosition.X = C.CurX;
		PrevPosition.Y = C.CurY;
		
	    C.DrawColor = class'LGDUtilities.ColorHelper'.default.GreenColor;
		C.SetPos(RectATopLeft.X, RectATopLeft.Y);
		C.DrawText("A_TL");
		C.SetPos(RectABottomRight.X, RectABottomRight.Y);
		C.DrawText("A_BR");
		
		C.SetPos(RectBTopLeft.X, RectBTopLeft.Y);
		C.DrawText("B_TL");
		C.SetPos(RectBBottomRight.X, RectBBottomRight.Y);
		C.DrawText("B_BR");
		
		C.DrawColor = PrevColor;
		C.CurX = PrevPosition.X;
		C.CurY = PrevPosition.Y;
	}
		
	return class'LGDUtilities.GeometryHelper'.static.RectanglesOverlap(TranslatedRectATopLeft,TranslatedRectABottomRight, TranslatedRectBTopLeft,TranslatedRectBBottomRight);
}

/*
Get value from Actor (works with network play):

"context" UWindowRootWindow is merely a "source" window that is calling this, to use to access "Root"
*/
static simulated function string getValueFromActor(UWindowRootWindow context, Actor actor, string prop) {
    local string ret;

    context.Root.Console.ViewPort.Actor.MyHUD.Role = actor.Role; // hack for avoid Enum set issues, here always ROLE_Authority before that
    actor.Role = actor.ENetRole.ROLE_Authority;
    ret = actor.GetPropertyText(prop);
    actor.Role = context.Root.Console.ViewPort.Actor.MyHUD.Role;
    context.Root.Console.ViewPort.Actor.MyHUD.Role = actor.ENetRole.ROLE_Authority;

    return ret;
}

static simulated function Mutator PlayerHasHUDMutator(PlayerPawn p, name mutClass){
    local Mutator m;

    if(P.myHud != None) {
        m = P.myHud.HUDMutator;
    }

    While(m != None) {
        if(m.IsA(mutClass)) {
            break;
        } else {
            m = m.NextHUDMutator;
        }
    }

    return m;
}

static simulated function RenderLEDTimerToHUD(Canvas c, float xPos, float yPos, Color col, byte drawStyle, float hudScale, int timerSeconds){
    local Color PrevColor;
    local byte PrevStyle;
    local int Minutes, Seconds, d;

    PrevColor = C.DrawColor;
    PrevStyle = C.Style;

    C.DrawColor = col;

	C.CurX = xPos;
	C.CurY = yPos;

	C.Style = drawStyle;

	if (timerSeconds > 0) {
		Minutes = timerSeconds / 60;
		Seconds = timerSeconds % 60;
	}
	else
	{
		Minutes = 0;
		Seconds = 0;
	}

	if ( Minutes > 0 )
	{
		if ( Minutes >= 10 )//draw tens minute digit
		{
			d = Minutes / 10;//digit # position
			//draw digit sliced from texture, with X pos based on d*25 (25 = width of digit in texture)
			C.DrawTile(Texture'BotPack.HudElements1', hudScale*25, 64*hudScale, d*25, 0, 25.0, 64.0);
			C.CurX += 7*hudScale;
			Minutes = Minutes - 10*d;
		}
		else
		{
		    //draw 0 digit sliced from texture (25 = width of digit in texture)
			C.DrawTile(Texture'BotPack.HudElements1', hudScale*25, 64*hudScale, 0, 0, 25.0, 64.0);
			C.CurX += 7*hudScale;
		}

        //draw minutes digit
        //draw digit sliced from texture, with X pos based on Minutes*25 (25 = width of digit in texture)
		C.DrawTile(Texture'BotPack.HudElements1', hudScale*25, 64*hudScale, Minutes*25, 0, 25.0, 64.0);
		C.CurX += 7*hudScale;
	} else {
	    //draw 0 digit sliced from texture (25 = width of digit in texture)
		C.DrawTile(Texture'BotPack.HudElements1', hudScale*25, 64*hudScale, 0, 0, 25.0, 64.0);
		C.CurX += 7*hudScale;
	}
	C.CurX -= 4*hudScale;
	//draw the :
	C.DrawTile(Texture'BotPack.HudElements1', hudScale*25, 64*hudScale, 32, 64, 25.0, 64.0);
	C.CurX += 3*hudScale;

    //tens digit
	d = Seconds / 10;
	//draw digit sliced from texture, with X pos based on Seconds*25 (25 = width of digit in texture)
	C.DrawTile(Texture'BotPack.HudElements1', hudScale*25, 64*hudScale, 25*d, 0, 25.0, 64.0);
	C.CurX += 7*hudScale;

    //seconds digit
	Seconds = Seconds - 10 * d;
	C.DrawTile(Texture'BotPack.HudElements1', hudScale*25, 64*hudScale, 25*Seconds, 0, 25.0, 64.0);
	C.CurX += 7*hudScale;

    C.DrawColor = PrevColor;
    C.Style = PrevStyle;
}

defaultproperties {
}
