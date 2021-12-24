class IndicatorHudMapTargetHUDMutator extends PlayerSpawnMutatorCallback;

var LinkedList elementsToAdd;
var bool GlobalIndicator;

function PlayerSpawnedCallback(){
    local IndicatorHud ih;
    local ListElement el;
    local IndicatorHudTargetListElement hudTargetListEl;

    ih = class'IndicatorHud'.static.SpawnAndRegister(Context);

    //if we have an IndicatorHud
    if(ih != None) {
        if((elementsToAdd != None) && elementsToAdd.Count > 0){
            el = elementsToAdd.Pop();

            while(el != None){
                hudTargetListEl = IndicatorHudTargetListElement(el);

                if(hudTargetListEl != None){
                    ih.AddAdvancedTarget(hudTargetListEl, self.GlobalIndicator);
                }
                el = elementsToAdd.Pop();
            }
        }
    }
}

DefaultProperties {
}
