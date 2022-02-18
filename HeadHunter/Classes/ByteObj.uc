class ByteObj extends ValueContainer;

var byte Value;

function string ToString(){
    return string(self.Value);
}

static function PushByteOntoLinkedList(LinkedList list, byte byteToAdd) {
    local ByteObj byteObj;

    if(list == None){
         return;
    }

    byteObj = new class'ByteObj';
    byteObj.Value = byteToAdd;
    list.Push(byteObj);
}

function bool Equals(ValueContainer OtherValue){
    local ByteObj byteObj;

    if(ClassIsChildOf(OtherValue.class, class'ByteObj')) {
        byteObj = ByteObj(OtherValue);

        return Value == byteObj.Value;
    } else {
        return false;
    }
}

function ValueContainer Clone(){
    local ByteObj copy;
    copy = new class'ByteObj';

    copy.Value = self.Value;

    return copy;
}

defaultproperties
{
      Value=0
}
