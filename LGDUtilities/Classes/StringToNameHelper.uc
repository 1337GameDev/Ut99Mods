class StringToNameHelper extends Actor nousercreate;

var name NameConversionHack;

function name StringToName(string str) {
  SetPropertyText("NameConversionHack", str);
  return NameConversionHack;
}

defaultproperties {
      NameConversionHack="None"
}
