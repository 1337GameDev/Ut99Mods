class VectorObj extends ValueContainer;

var Vector Value;

function string ToString(){
    return "(X:"$self.Value.X$", Y:"$self.Value.Y$", Z:"$self.Value.Z$")";
}

static function PushVectorOntoLinkedList(LinkedList list, Vector vectorToAdd) {
    local VectorObj vectorObj;

    if(list == None){
         return;
    }

    vectorObj = new class'LGDUtilities.VectorObj';
    vectorObj.Value = vectorToAdd;
    list.Push(vectorObj);
}

function bool Equals(ValueContainer OtherValue){
    local VectorObj vectorObj;

    if(ClassIsChildOf(OtherValue.class, class'LGDUtilities.VectorObj')) {
        vectorObj = VectorObj(OtherValue);

        return Value == vectorObj.Value;
    } else {
        return false;
    }
}

function ValueContainer Clone(){
    local VectorObj copy;
    copy = new class'LGDUtilities.VectorObj';

    copy.Value = self.Value;

    return copy;
}

defaultproperties {
      Value=(X=0.000000,Y=0.000000,Z=0.000000)
}
