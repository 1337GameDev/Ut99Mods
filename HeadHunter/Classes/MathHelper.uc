// ============================================================
// MathHelper
// ============================================================

class MathHelper extends Object;

var const float RadToDeg;
var const float DegToRad;
var const float UnrRotToRad;
var const float RadToUnrRot;
var const float DegToUnrRot;
var const float UnrRotToDeg;
var const float UnrSizeToMeters;
var const float MetersToUnrSize;

// Fetched from: https://stackoverflow.com/questions/3380628/fast-arc-cos-algorithm/20914630
// A fast ACOS, using approximation to get a semi-precise result
// Absolute error <= 6.7e-5
static final function float acos(float x){
  local float negate, ret;

  negate = float(x < 0);
  x = abs(x);
  ret = -0.0187293;
  ret = ret * x;
  ret = ret + 0.0742610;
  ret = ret * x;
  ret = ret - 0.2121144;
  ret = ret * x;
  ret = ret + 1.5707288;
  ret = ret * sqrt(1.0 - x);
  ret = ret - 2 * negate * ret;

  return negate * pi + ret;
}

static final function float asin(float a) {
   if((a > 1) || (a < -1)) {
       return 0;
   }

   if(a == 1) {
       return pi / 2;
   }

   if(a == -1){
       return -pi / 2;
   }

   return atan(a / sqrt(1 - square(a)) );
}

//converts Unreal Units (UU) to meters
static final function float UUtoMeters(float unrealUnits){
     return unrealUnits / 52.5;
}

static final function LinkedList GetNumberEquadistantPointsAroundCircleCenter(Vector CircleCenter, float Radius, int NumPoints, Vector alignToDir){
      local LinkedList PointsList, RotatedPointsList;
      local VectorObj VectObj;
      local Vector NewPoint;

      local int i;
      local float RadianFraction;
      local float NumRadians;

      local Vector OriginalDir;

      local Rotator RotationToAlign;

      OriginalDir = Vect(0,0,1);
      alignToDir = Normal(alignToDir);
      RotationToAlign = Rotator(OriginalDir) - Rotator(alignToDir);

      PointsList = new class'LinkedList';
      RotatedPointsList = new class'LinkedList';

	  for(i=0; i<NumPoints; i++) {
		  NewPoint = Vect(0,0,0);
		  VectObj = new class'VectorObj';
		  RadianFraction = i / float(NumPoints);
		  NumRadians = 2.0 * pi * RadianFraction;

		  NewPoint.X = CircleCenter.X + (Radius * Cos(NumRadians));
		  NewPoint.Y = CircleCenter.Y + (Radius * Sin(NumRadians));

		  VectObj.Value = NewPoint;
		  PointsList.Push(VectObj);

		  //rotated form
		  VectObj = new class'VectorObj';
		  VectObj.Value = NewPoint >> RotationToAlign;
		  RotatedPointsList.Push(VectObj);
	 }

      return RotatedPointsList;//if NumPoints == 0, this will be empty, which is fine
}

//Given a number of seconds, will return (using the OUT variables passed in) the representation on a 3 digit timer.
//The MAX seconds that can be passed in are 599, as that'll be 9:59 on the timer, anything greater will be 9:99, and less than 0 will be 0:00
//The timer format is: Minutes:seconds
static function Get3DigitTimerPartsFromSeconds(int TotalSeconds, out int ResultMinutes, out int ResultTens, out int ResultOnes){
    if(TotalSeconds > 599){//if the timer would read 999 or more
        ResultMinutes = 9;
        ResultTens = 9;
        ResultOnes = 9;
        return;
    } else if(TotalSeconds < 0) {
        ResultMinutes = 0;
        ResultTens = 0;
        ResultOnes = 0;
    } else {
        //get the minutes count
        ResultMinutes = TotalSeconds / 60;
        TotalSeconds = TotalSeconds % 60;
        //get the number of tens
        ResultTens = TotalSeconds / 10;
        TotalSeconds = TotalSeconds % 10;
        //the remainder is the ones place
        ResultOnes = TotalSeconds;
    }
}

//gets the digits of an integers, and stores them in an array (usually used for packed data, number display, or doing math with the different digits)
//the largest integer in UT is 32^2 (or 2147483647) which is 10 bits, but then a -1 or 1 is at the front for a sign bit indicator
//The array will be in order of most significant, to least significant (sign being in index 0) and will be size 11.
static function GetDigitsOfInteger(int TargetInteger, out int DigitsArray[]){
    local int digits[11], CurrentDigitValue, i;

    if(TargetInteger < 0){
        TargetInteger *= -1;
        digits[0] = -1;
    } else {
        digits[0] = 1;
    }

    //loop to find the 10 digits, starting on the left side of the number
    CurrentDigitValue = 1000000000;
    for(i=1; i<11; i++){//loop through indices 1->10
        digits[i] = TargetInteger / CurrentDigitValue;
        TargetInteger = TargetInteger % CurrentDigitValue;
        CurrentDigitValue = CurrentDigitValue / 10;
    }
}

defaultproperties
{
      RadToDeg=57.295780
      DegToRad=0.017453
      UnrRotToRad=0.000096
      RadToUnrRot=10430.377930
      DegToUnrRot=182.044403
      UnrRotToDeg=0.005493
      UnrSizeToMeters=0.019048
      MetersToUnrSize=52.500000
}
