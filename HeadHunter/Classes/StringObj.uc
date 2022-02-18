class StringObj extends ValueContainer;

var string Value;

function string ToString(){
    return self.Value;
}

static function PushStringOntoLinkedList(LinkedList list, string stringToAdd) {
    local StringObj stringObj;

    if(list == None){
         return;
    }

    stringObj = new class'StringObj';
    stringObj.Value = stringToAdd;
    list.Push(stringObj);
}

function bool Equals(ValueContainer OtherValue){
    local StringObj stringObj;

    if(ClassIsChildOf(OtherValue.class, class'StringObj')) {
        stringObj = StringObj(OtherValue);

        return Value == stringObj.Value;
    } else {
        return false;
    }
}

function ValueContainer Clone(){
    local StringObj copy;
    copy = new class'StringObj';

    copy.Value = self.Value;

    return copy;
}

defaultproperties
{
      Value=""
}
