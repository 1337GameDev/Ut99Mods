// ============================================================
// InventoryHelper
// ============================================================

class TypeHelper extends Object;

/*
 * Return:
 * -1 - if firstClass is not relationed to secondClass
 * 0 - if firstClass is the same class as secondClass
 * 1 - if firstClass is a child of secondClass
 * 2 - if firstClass is a parent of secondClass
 */
 static function int classIsRelatedTo(class firstClass, class secondClass, optional bool bNoSubClass) {
	//Log(firstClass@secondClass@firstClass == secondClass);
	if(firstClass == secondClass) {
		return 0;
	}

	if(!bNoSubClass) {
		if(classIsChildOf(firstClass, secondClass)) {
			return 1;
		} else if(classIsChildOf(secondClass, firstClass)) {
			return 2;
		}
	}

	return -1;
}

//whatever actor calls this method, pass a reference of "self" in for "context"
static function name StringToName(Actor context, string str) {
  local name result;
  local StringToNameHelper helper;

  helper = context.Spawn(class'StringToNameHelper');
  result = helper.StringToName(str);
  helper.Destroy();

  return result;
}

defaultproperties
{
}
