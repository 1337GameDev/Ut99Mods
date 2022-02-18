class ColorObj extends ValueContainer;

var Color Value;

function string ToString(){
    return "(R:"$self.Value.R$", G:"$self.Value.G$", B:"$self.Value.B$", A:"$self.Value.A$")";
}

static function PushColorOntoLinkedList(LinkedList list, Color colorToAdd) {
    local ColorObj colorObj;

    if(list == None){
         return;
    }

    colorObj = new class'ColorObj';
    colorObj.Value = colorToAdd;
    list.Push(colorObj);
}

function bool Equals(ValueContainer OtherValue){
    local ColorObj colorObj;

    if(ClassIsChildOf(OtherValue.class, class'ColorObj')) {
        colorObj = ColorObj(OtherValue);

        return Value == colorObj.Value;
    } else {
        return false;
    }
}

function ValueContainer Clone(){
    local ColorObj copy;
    copy = new class'ColorObj';

    copy.Value = self.Value;

    return copy;
}

defaultproperties {
      Value=(R=0,G=0,B=0,A=0)
}
