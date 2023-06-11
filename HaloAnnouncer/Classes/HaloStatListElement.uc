class HaloStatListElement extends ListElement;

var int Count;

function string ToString() {
    local string str;

    if(ClassIsChildOf(self.Value.class, class'LGDUtilities.ValueContainer')) {
        str = ValueContainer(self.Value).ToString();
    } else {
        str = string(self.Value);
    }

    return str $ ":" $ Count;
}

function ListElement Clone() {
    local HaloStatListElement el;
    local ValueContainer valContainer;

    el = new class'HaloAnnouncer.HaloStatListElement';

    if((Self.Value != None) && ClassIsChildOf(Self.Value.class, class'LGDUtilities.ValueContainer') ) {
        valContainer = ValueContainer(Self.Value);
		
        el.Value = valContainer.Clone();
		el.Count = Self.Count;
    } else {
        el.Value = Self.Value;
    }

    return el;
}

defaultproperties {
      Count=0
}
