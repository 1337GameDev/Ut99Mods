class IntObj extends ValueContainer;

var int Value;

function string ToString(){
    return string(self.Value);
}

static function PushIntOntoLinkedList(LinkedList list, int intToAdd) {
    local IntObj intObj;

    if(list == None){
         return;
    }

    intObj = new class'IntObj';
    intObj.Value = intToAdd;
    list.Push(intObj);
}

function bool Equals(ValueContainer OtherValue){
    local IntObj intObj;

    if(ClassIsChildOf(OtherValue.class, class'IntObj')) {
        intObj = IntObj(OtherValue);

        return Value == intObj.Value;
    } else {
        return false;
    }
}

function ValueContainer Clone(){
    local IntObj copy;
    copy = new class'IntObj';

    copy.Value = self.Value;

    return copy;
}

defaultproperties {
      Value=0
}
