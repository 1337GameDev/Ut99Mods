class FloatObj extends ValueContainer;

var float Value;

function string ToString(){
    return string(self.Value);
}

static function PushFloatOntoLinkedList(LinkedList list, float floatToAdd) {
    local FloatObj floatObj;

    if(list == None){
         return;
    }

    floatObj = new class'FloatObj';
    floatObj.Value = floatToAdd;
    list.Push(floatObj);
}

function bool Equals(ValueContainer OtherValue){
    local FloatObj floatObj;

    if(ClassIsChildOf(OtherValue.class, class'FloatObj')) {
        floatObj = FloatObj(OtherValue);

        return Value == floatObj.Value;
    } else {
        return false;
    }
}

function ValueContainer Clone(){
    local FloatObj copy;
    copy = new class'FloatObj';

    copy.Value = self.Value;

    return copy;
}

defaultproperties {
      Value=0.000000
}
