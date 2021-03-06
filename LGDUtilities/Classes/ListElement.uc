class ListElement extends Object;

var Object Value;

var ListElement Next;
var ListElement Prev;
var LinkedList ListOwner;

//does NOT update ListOwner count or other attributes - so be careful
function AddBefore(ListElement el) {
      if(el != None) {
         el.Next = self;
         el.Prev = self.Prev;
         self.Prev = el;

         if(el.Prev != None){
             el.Prev.Next = el;
         }

         self.ListOwner = el.ListOwner;

         if(self.ListOwner.Head == el) {
             self.ListOwner.Head = self;
         }
      }
}

//does NOT update ListOwner count or other attributes - so be careful
function AddAfter(ListElement el) {
      if(el != None) {
         el.Prev = self;
         el.Next = self.Next;
         self.Next = el;

         if(el.Next != None){
             el.Next.Prev = el;
         }

         self.ListOwner = el.ListOwner;

         if(self.ListOwner.Tail == el) {
             self.ListOwner.Tail = self;
         }

         self.ListOwner.Count++;
      }
}

//does NOT update ListOwner count or other attributes - so be careful
function Destroy() {
    self.Prev = None;
    self.Next = None;
    self.ListOwner = None;
    self.Value = None;
}

function ListElement RemoveFromList() {
      if(ListOwner != None) {
          return ListOwner.RemoveElement(self);
      }

      return self;
}

function string ToString() {
    local string str;

    if(ClassIsChildOf(self.Value.class, class'LGDUtilities.ValueContainer')) {
        str = ValueContainer(self.Value).ToString();
    } else {
        str = string(self.Value);
    }

    return str;
}

function bool ElementValueEquals(object objVal) {
    local ValueContainer selfValContainer, valContainerToCompareTo;

    if(ClassIsChildOf(self.Value.class, class'LGDUtilities.ValueContainer')) {
        if((objVal != None) && ClassIsChildOf(objVal.class, class'LGDUtilities.ValueContainer')) {
            selfValContainer = ValueContainer(self.Value);
            valContainerToCompareTo = ValueContainer(objVal);

            return selfValContainer.Equals(valContainerToCompareTo);
        } else {
            return false;
        }
    } else {
        return self.Value == objVal;
    }
}

function ListElement Clone() {
    local ListElement el;
    local ValueContainer valContainer;

    el = new class'LGDUtilities.ListElement';

    if((Self.Value != None) && ClassIsChildOf(Self.Value.class, class'LGDUtilities.ValueContainer') ) {
        valContainer = ValueContainer(Self.Value);
        el.Value = valContainer.Clone();
    } else {
        el.Value = Self.Value;
    }

    return el;
}

final operator(20) LinkedList + (ListElement A, ListElement B) {
    local LinkedList list;
    list = new class'LGDUtilities.LinkedList';

    list.Enqueue(A);
    list.Enqueue(B);

    return list;
}

final operator(24) bool == (ListElement A, ListElement B) {
    return A.ElementValueEquals(B);
}
final operator(24) bool != (ListElement A, ListElement B) {
    return !A.ElementValueEquals(B);
}

defaultproperties {
      Value=None
      Next=None
      Prev=None
      ListOwner=None
}
