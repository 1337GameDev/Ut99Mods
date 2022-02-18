class ClassObj extends ValueContainer;

var class Value;

//this may or may not be filled in, depending on use case
var string ClassQualifiedName;

function string ToString(){
    if(self.ClassQualifiedName != "") {
	    return self.ClassQualifiedName;
	} else if(self.Value == None) {
        return "None";
	} else {
	    return string(self.Value.Name);
	}
}

static function PushClassOntoLinkedList(LinkedList list, class classToAdd, optional string QualifiedName) {
    local ClassObj classObj;

    if(list == None){
         return;
    }

    classObj = new class'ClassObj';
    classObj.Value = classToAdd;
    classObj.ClassQualifiedName = QualifiedName;
    list.Push(classObj);
}

function bool Equals(ValueContainer OtherValue){
    local ClassObj classObj;

    if(ClassIsChildOf(OtherValue.class, class'ClassObj')) {
        classObj = ClassObj(OtherValue);

        return (Value == classObj.Value) && (ClassQualifiedName == classObj.ClassQualifiedName);
    } else {
        return false;
    }
}

function ValueContainer Clone(){
    local ClassObj copy;
    copy = new class'ClassObj';

    copy.Value = self.Value;
    copy.ClassQualifiedName = self.ClassQualifiedName;

    return copy;
}

function bool LoadClassFromQualifiedName() {
    if(self.ClassQualifiedName != "") {
        self.Value = class<Weapon>(DynamicLoadObject(self.ClassQualifiedName, class'Class'));
    } else {
        self.Value = None;
    }

    return (self.Value != None);
}

defaultproperties {
      Value=None,
      ClassQualifiedName=""
}
