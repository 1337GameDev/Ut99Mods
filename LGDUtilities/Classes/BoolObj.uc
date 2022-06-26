class BoolObj extends ValueContainer;

var bool Value;

function string ToString(){
    return string(self.Value);
}

static function PushBoolOntoLinkedList(LinkedList list, bool boolToAdd) {
    local BoolObj boolObj;

    if(list == None){
         return;
    }

    boolObj = new class'LGDUtilities.BoolObj';
    boolObj.Value = boolToAdd;
    list.Push(boolObj);
}

function bool Equals(ValueContainer OtherValue){
    local BoolObj boolObj;

    if(ClassIsChildOf(OtherValue.class, class'LGDUtilities.BoolObj')) {
        boolObj = BoolObj(OtherValue);

        return Value == boolObj.Value;
    } else {
        return false;
    }
}

function ValueContainer Clone(){
    local BoolObj copy;
    copy = new class'LGDUtilities.BoolObj';

    copy.Value = self.Value;

    return copy;
}

defaultproperties  {
      Value=False
}
