class NameObj extends ValueContainer;

var name Value;

function string ToString(){
    return string(self.Value);
}

static function PushNameOntoLinkedList(LinkedList list, name nameToAdd) {
    local NameObj nameObj;

    if(list == None){
         return;
    }

    nameObj = new class'LGDUtilities.NameObj';
    nameObj.Value = nameToAdd;
    list.Push(nameObj);
}

function bool Equals(ValueContainer OtherValue){
    local NameObj nameObj;

    if(ClassIsChildOf(OtherValue.class, class'LGDUtilities.NameObj')) {
        nameObj = NameObj(OtherValue);

        return Value == nameObj.Value;
    } else {
        return false;
    }
}

function ValueContainer Clone(){
    local NameObj copy;
    copy = new class'LGDUtilities.NameObj';

    copy.Value = self.Value;

    return copy;
}

defaultproperties {
      Value="None"
}
