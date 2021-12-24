//-----------------------------------------------------------
// An actor that sets another actor to be an indictaor hud target.
// Place this on a map, with an Actor referenced by "TargetForIndicator" and specify settings for the indicator.
//-----------------------------------------------------------
class IndicatorHudMapTarget extends Actor;

var(IndicatorTarget) Actor TargetForIndicator;
var LinkedList TargetActors;

var(IndicatorTarget) bool ShowIndicatorToHudOwnerTeamNum;
var(IndicatorTarget) byte IndicatorVisibleToTeamNum;//0->255 -- 255 == none (defined in Engine.PlayerReplicationInfo)

var(IndicatorTarget) name TargetsWithGroup;
var(IndicatorTarget) name TargetsWithTag;
var(IndicatorTarget) name TargetsWithName;
var(IndicatorTarget) class<Actor> TargetsOfClassType;

var(IndicatorHUD) bool GlobalIndicator;
//set this var to one defined in IndicatorHud.uc, and it'll set any variations (rotations)
//in the "IndicatorTextureVariations" field above (eg: for edge of screen textures for direction indicators)
var(IndicatorHUD) byte BuiltinIndicatorTexture;//IndicatorHud.HUDIndicator_Texture_BuiltIn
var(IndicatorHUD) float MaxViewDistance;
var(IndicatorHUD) Vector IndicatorOffsetFromTarget;
var(IndicatorHUD) bool UseHUDColorForIndicator;
var(IndicatorHUD) bool UseCustomColor;
var(IndicatorHUD) Color IndicatorColor;
var(IndicatorHUD) bool ShowTargetDistanceLabels;
var(IndicatorHUD) string IndicatorLabel;
var(IndicatorHUD) bool ShowIndicatorLabel;
var(IndicatorHUD) bool UseTargetNameForLabel;
var(IndicatorHUD) bool ScaleIndicatorSizeToTarget;
var(IndicatorHUD) float StaticIndicatorPercentOfMinScreenDimension;
var(IndicatorHUD) float StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen;
var(IndicatorHUD) bool ShowIndicatorWhenOffScreen;
var(IndicatorHUD) bool ShowIndicatorIfTargetHidden;
var(IndicatorHUD) bool ShowIndicatorIfInventoryHeld;
var(IndicatorHUD) bool ShowIndicatorIfInventoryNotHeld;
var(IndicatorHUD) bool ShowIndicatorIfInventoryDropped;
var(IndicatorHUD) bool ShowIndicatorsThatAreObscured;
var(IndicatorHUD) bool BlinkIndicator;
var(IndicatorHUD) float BaseAlphaValue;
var(IndicatorHUD) bool ShowIndicatorAboveTarget;
var(IndicatorHUD) bool IndicatorLabelsAboveIndicator;

function PreBeginPlay() {
    local IndicatorHudTargetListElement hudTargetListElement;
    local IndicatorHudMapTargetModifierFn fn;
    local IndicatorHudMapTargetHUDMutator hudTargetMutCallback;
    local LinkedList targets, targetsFromPrams;
    local ListElement listElementFromParams;

    if(self.TargetForIndicator == None){
        targetsFromPrams = GetTargetsFromParams();
        if(targetsFromPrams.Count == 0){
            return;
        }
    } else {
        targetsFromPrams = new class'LinkedList';
        targetsFromPrams.Push(self.TargetForIndicator);
    }

    fn = new class'IndicatorHudMapTargetModifierFn';
    fn.IndicatorVisibleToTeamNum = IndicatorVisibleToTeamNum;
    fn.ShowIndicatorToHudOwnerTeamNum = ShowIndicatorToHudOwnerTeamNum;

    targets = new class'LinkedList';

    while(targetsFromPrams.Count > 0){
        listElementFromParams = targetsFromPrams.Pop();

        hudTargetListElement = new class'IndicatorHudTargetListElement';
        hudTargetListElement.Value = listElementFromParams.Value;
        hudTargetListElement.IndicatorSettings = self.ConvertToIndicatorSettingsObj();

        if(!self.GlobalIndicator){
            hudTargetListElement.IndicatorSettingsModifier = fn;
        }

        targets.Push(hudTargetListElement);
    }

    hudTargetMutCallback = new class'IndicatorHudMapTargetHUDMutator';
    hudTargetMutCallback.Context = self;
    hudTargetMutCallback.IsLogin = false;

    hudTargetMutCallback.GlobalIndicator = self.GlobalIndicator;
    hudTargetMutCallback.elementsToAdd = targets;
    class'PlayerSpawnMutator'.static.RegisterToPlayerSpawn(self, hudTargetMutCallback);
}

function LinkedList GetTargetsFromParams(){
     local LinkedList targetsFound;
     local Actor a;
     local bool includeThisActor;

     targetsFound = new class'LinkedList';

     if(self.TargetForIndicator == None){
         if(self.TargetsOfClassType == None){
             self.TargetsOfClassType = Class'Actor';
         }

         foreach AllActors(self.TargetsOfClassType, a, self.TargetsWithTag) {
             includeThisActor = false;

             if((self.TargetsWithName != '') && (a.Name == self.TargetsWithName)){
                 includeThisActor = true;
             }

             if(includeThisActor && (self.TargetsWithGroup != '') && (a.Group == self.TargetsWithGroup)){
                 includeThisActor = true;
             }

             if(includeThisActor){
                 targetsFound.Push(a);
             }
         }
     }

     return targetsFound;
}

function IndicatorSettings ConvertToIndicatorSettingsObj(){
    local IndicatorSettings settings;
    settings = new class'IndicatorSettings';

    settings.MaxViewDistance = self.MaxViewDistance;
    settings.IndicatorLabelsAboveIndicator = self.IndicatorLabelsAboveIndicator;
    settings.IndicatorOffsetFromTarget = self.IndicatorOffsetFromTarget;
    settings.UseHUDColorForIndicator = self.UseHUDColorForIndicator;
    settings.UseCustomColor = self.UseCustomColor;
    settings.ShowTargetDistanceLabels = self.ShowTargetDistanceLabels;
    settings.IndicatorColor = self.IndicatorColor;
    settings.IndicatorLabel = self.IndicatorLabel;
    settings.ShowIndicatorLabel = self.ShowIndicatorLabel;
    settings.ShowIndicatorAboveTarget = self.ShowIndicatorAboveTarget;
    settings.UseTargetNameForLabel = self.UseTargetNameForLabel;
    settings.ScaleIndicatorSizeToTarget = self.ScaleIndicatorSizeToTarget;
    settings.StaticIndicatorPercentOfMinScreenDimension = self.StaticIndicatorPercentOfMinScreenDimension;
    settings.StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen = self.StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen;

    settings.ShowIndicatorWhenOffScreen = self.ShowIndicatorWhenOffScreen;
    settings.ShowIndicatorIfTargetHidden = self.ShowIndicatorIfTargetHidden;
    settings.ShowIndicatorIfInventoryHeld = self.ShowIndicatorIfInventoryHeld;
    settings.ShowIndicatorIfInventoryNotHeld = self.ShowIndicatorIfInventoryNotHeld;
    settings.ShowIndicatorIfInventoryDropped = self.ShowIndicatorIfInventoryDropped;
    settings.ShowIndicatorsThatAreObscured = self.ShowIndicatorsThatAreObscured;
    settings.BlinkIndicator = self.BlinkIndicator;
    settings.BaseAlphaValue = self.BaseAlphaValue;

    return settings;
}

DefaultProperties {
    GlobalIndicator=true,
    ShowIndicatorToHudOwnerTeamNum=true,
    IndicatorVisibleToTeamNum=255,//represents "No Team"

    //these will be ANDED together to find targets (if not empty -- which means that Actors with these fields as empty cannot be 'looked' for)
    TargetsWithGroup='',
    TargetsWithTag='',
    TargetsWithName='',
    TargetsOfClassType=class'Actor',

    MaxViewDistance=0.0,
    IndicatorLabelsAboveIndicator=true,
    IndicatorOffsetFromTarget=Vect(0,0,0),
    UseHUDColorForIndicator=false,
    UseCustomColor=false,
    ShowTargetDistanceLabels=false,
    IndicatorColor=(R=255),//red
    IndicatorLabel="",
    ShowIndicatorLabel=false,
    ShowIndicatorAboveTarget=false,
    UseTargetNameForLabel=false,
    ScaleIndicatorSizeToTarget=true,
    StaticIndicatorPercentOfMinScreenDimension=0.05,
    StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen=0.05,
    ShowIndicatorWhenOffScreen=true,
    ShowIndicatorIfTargetHidden=true,
    ShowIndicatorIfInventoryHeld=false,
    ShowIndicatorIfInventoryNotHeld=true,
    ShowIndicatorIfInventoryDropped=true,
    ShowIndicatorsThatAreObscured=true,
    BlinkIndicator=false,
    BaseAlphaValue=1.0,
    BuiltinIndicatorTexture=Empty
}
