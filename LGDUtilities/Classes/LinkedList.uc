class LinkedList extends Object;

var ListElement Head;
var ListElement Tail;
var int Count;

function Push(object value) {
    local ListElement le;

    le = ListElement(value);//cast -- to check if value is already a list element

    if(le == None) {//not a list element, so box it up
        le = new class'LGDUtilities.ListElement';
        le.Value = value;
    }

    le.ListOwner = self;

    if(self.Head != None) {
        self.Head.Prev = le;
        le.Next = self.Head;
    }

    self.Head = le;
    self.Count++;

    if(Count == 1) {
        self.Tail = self.Head;
    }
}

function ListElement Pop() {
    local ListElement le;

    if(self.Count > 0) {
        le = self.Head;
        self.Head = self.Head.Next;
        le.Next = None;
        self.Count--;

        if(self.Count == 0) {
            self.Tail = None;
        }

        le.ListOwner = None;
    }

    return le;
}

//Add to end of list
function Enqueue(object value) {
    local ListElement le;
    le = ListElement(value);//cast -- to check if value is already a list element

    if(self.Count == 0) {
        self.Push(value);
    } else {
        if(le == None) {//not a list element, so box it up
            le = new class'LGDUtilities.ListElement';
            le.Value = value;
        }

        le.ListOwner = self;

        self.Tail.Next = le;
        le.Prev = self.Tail;

        self.Tail = le;

        self.Count++;
    }
}

//Remove from front of list
function ListElement Dequeue() {
    return self.Pop();
}

function ListElement GetElementAt(int idx) {
    local ListElement le;
    local int counter;
    local bool foundElement;

    if((idx<0) || (idx > self.Count-1)) {
         return None;
    } else {
         le = self.Head;
         counter = 0;
         foundElement = false;

         While(le != None) {
             if(counter == idx) {
                 foundElement = true;
                 break;
             }

             counter++;
             le = le.Next;
         }

         if(!foundElement) {
             le = None;
         }
    }

    return le;
}

function ListElement GetRandomElement() {
    if(Self.Count > 0){
        return Self.GetElementAt(Rand(Self.Count));
    }

    return None;
}

function bool ContainsValue(object val) {
    return (val != None) && (GetElementByValue(val) != None);
}

function ListElement GetElementByValue(object val) {
    local ListElement le;
    local int counter;
    local bool foundElement;

    if(val == None) {
         return None;
    } else {
         le = self.Head;
         counter = 0;
         foundElement = false;

         While(le != None) {
             if(le.ElementValueEquals(val)) {
                 foundElement = true;
                 break;
             }

             counter++;
             le = le.Next;
         }

         if(!foundElement) {
             le = None;
         }
    }

    return le;
}

function int GetElementIdxByValue(object val) {
    local ListElement le;
    local int counter;
    local bool foundElement;

    if(val == None) {
         return -1;
    } else {
         le = self.Head;
         counter = 0;
         foundElement = false;

         While(le != None) {
             if(le.ElementValueEquals(val)) {
                 foundElement = true;
                 break;
             }

             counter++;
             le = le.Next;
         }

         if(!foundElement) {
             le = None;
             count = -1;
         }
    }

    return counter;
}

function int GetElementIdx(ListElement elementToFind) {
    local ListElement le;
    local int counter;
    local bool foundElement;

    if(elementToFind == None) {
         return -1;
    } else {
         le = self.Head;
         counter = 0;
         foundElement = false;

         While(le != None) {
             if(le == elementToFind) {
                 foundElement = true;
                 break;
             }

             counter++;
             le = le.Next;
         }

         if(!foundElement) {
             le = None;
             counter = -1;
         }
    }

    return counter;
}

function ListElement RemoveAt(int idx) {
    local ListElement le;

    if((idx<0) || (idx > self.Count-1)) {
         return None;
    }

    le = self.GetElementAt(idx);

    le.RemoveFromList();

    return le;
}

function ListElement RemoveElement(ListElement le) {
    if(le != None) {
        if(le == self.Head) {
           self.Head = le.Next;
        }

        if(le == self.Tail) {
           self.Tail = le.Prev;
        }

        if(le.Prev != None) {
            le.Prev.Next = le.Next;
        }

        if(le.Next != None) {
            le.Next.Prev = le.Prev;
        }

        self.Count--;
        le.ListOwner = None;
    }

    return le;
}

function bool RemoveElementByValue(object val) {
    local ListElement listElement;
    if(val != None){
        listElement = GetElementByValue(val);
		
        if(listElement != None){
            listElement.RemoveFromList();
        }
    }

    return false;
}

function int RemoveAll(){
   local int numRemoved;
   local ListElement removed;
   
   if(self.Count > 0) {
       While(self.Head != None){
           removed = self.Pop();
           removed.Destroy();
           numRemoved++;
       }
   }

   return numRemoved;
}

function ListElement InsertAt(object value, int idx) {
    local ListElement newElement;
    local ListElement le;

    newElement = ListElement(value);//cast -- to check if value is already a list element
    if(newElement == None){//not a list element, so box it up
        newElement = new class'LGDUtilities.ListElement';
        newElement.Value = value;
    }

    newElement.ListOwner = self;

    if(idx <= 0) {
        self.Push(value);
        return self.Head;
    } else if(idx > self.Count-1) {
        self.Enqueue(value);
        return self.Tail;
    }

    le = self.GetElementAt(idx);

    if(le != None) {
        le.AddBefore(newElement);
    }

    if(self.Head == None) {
        self.Head = newElement;
    }

    self.Count++;

    return newElement;
}

function Concat(LinkedList otherList){
    local ListElement el, newEl;

    if((otherList != None) && (otherList.Count > 0)) {
        el = OtherList.Head;

        while(el != None) {
            newEl = el.Clone();
            Self.Enqueue(newEl);

            el = el.Next;
        }
    }
}

function LinkedList Clone(){
    local LinkedList list;
    local ListElement el, newEl;
    list = new class'LGDUtilities.LinkedList';

    el = Self.Head;

    while(el != None) {
        newEl = el.Clone();
        list.Enqueue(newEl);

        el = el.Next;
    }

    return list;
}

//inorder traversal and log
function InOrderLog(){
    local ListElement le;

    le = self.Head;
    Log("[");

    While(le != None) {
        Log("    ["@le.ToString()@"]");
        le = le.Next;
    }

    Log("]");
}

//inorder traversal and return as a string
function string InOrderLogAsString() {
	local string result;
    local ListElement le;

    le = self.Head;
    result = "[\\n";

    While(le != None) {
        result $= "    ["@le.ToString()@"]\\n";
        le = le.Next;
    }

    result $= "]";
	
	return result;
}

final operator(20) LinkedList + (LinkedList A, LinkedList B) {
    local LinkedList list;
    if(A != None) {
      A.Concat(B);
    }

    return list;
}
final operator(20) LinkedList + (LinkedList A, ListElement B) {
    local LinkedList list;
    list = A.Clone();
    list.Enqueue(B);

    return list;
}
final operator(20) LinkedList + (ListElement A, LinkedList B) {
    local LinkedList list;
    list = B.Clone();
    list.Push(A);

    return list;
}
final operator(20) LinkedList - (LinkedList A, ListElement B) {
    local LinkedList list;
    list = A.Clone();
    list.RemoveElement(B);

    return list;
}

final operator(34) LinkedList += (out LinkedList A, ListElement B) {
    A.Push(B);
    return A;
}
final operator(34) LinkedList -= (out LinkedList A, ListElement B) {
    A.RemoveElement(B);
    return A;
}

final operator(34) LinkedList += (out LinkedList A, LinkedList B) {
    A.Concat(B);
    return A;
}
final operator(34) LinkedList -= (out LinkedList A, LinkedList B) {
    local ListElement el;
    el = B.Head;
    while(el != None){
        A.RemoveElement(el);
        el = el.Next;
    }

    return A;
}

defaultproperties {
      Head=None
      Tail=None
      Count=0
}
