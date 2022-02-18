class StringHelper extends Actor nousercreate;

final function ReplaceText(out string Text, string Replace, string With) {
    local int i;
	local string Input;

	Input = Text;
	Text = "";
	i = InStr(Input, Replace);

    While(i != -1) {
		Text = Text $ Left(Input, i) $ With;
		Input = Mid(Input, i + Len(Replace));
		i = InStr(Input, Replace);
	}

	Text = Text $ Input;
}

/**
Parameters -
str = input string
div = divider
bDiv = true to keep dividers, false to remove dividers.

Fetched from: https://wiki.beyondunreal.com/Legacy:Useful_String_Functions
**/
function array<string> Split(string str, string div, bool bDiv) {
   local array<string> temp;
   local bool bEOL;
   local string tempChar;
   local int precount, curcount, wordcount, strLength;
   strLength = len(str);
   bEOL = false;
   precount = 0;
   curcount = 0;
   wordcount = 0;

   while(!bEOL) {
      tempChar = Mid(str, curcount, 1); //go up by 1 count

      if(tempChar != div) {
         curcount++;
      } else if(tempChar == div) {
         temp[wordcount] = Mid(str, precount, curcount-precount);
         wordcount++;

         if(bDiv) {
            precount = curcount; //leaves the divider
         } else {
            precount = curcount + 1; //removes the divider.
         }

         curcount++;
      }

      if(curcount == strLength){//end of string, flush out the final word.
         temp[wordcount] = Mid(str, precount, curcount);
         bEOL = true;
      }
   }

   return temp;
}

//***********************************
// Remove initial spaces from a string
// Fetched from: https://github.com/CacoFFF/SiegeIV-UT99/blob/master/Classes/SiegeStatics.uc
//***********************************
static final function string ClearSpaces(string Text) {
	local int i;

	i = InStr(Text, " ");
	while(i == 0) {
		Text = Right(Text, Len(Text) - 1);
		i = InStr(Text, " ");
	}

	return Text;
}

static function string GetPackageNameFromQualifiedClass(string ClassNameStr){
    local string PackageName;
    local int PeriodIndex;

    if(ClassNameStr != "") {
        PeriodIndex = Instr(ClassNameStr, ".");

	    if (PeriodIndex > -1) {
		    PackageName = Left(ClassNameStr, PeriodIndex);
	    }
	}

    return PackageName;
}

static function string RemovePackageNameFromQualifiedClass(string ClassNameStr){
    local string ClassName;
    local int PeriodIndex;

    if(ClassNameStr != "") {
        PeriodIndex = Instr(ClassNameStr, ".");

	    if (PeriodIndex > -1) {
		    ClassName = Right(ClassNameStr, Len(ClassNameStr) - (PeriodIndex+1));
	    }
    }

    return ClassName;
}

defaultproperties {
}
