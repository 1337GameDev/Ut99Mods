class AttachIndicatorHudCallback extends PlayerSpawnMutatorCallback;

function PlayerSpawnedCallback(){
    local IndicatorHud indicatorHud;
    local Inventory hudTarget2;
    local IndicatorHudTargetListElement listElement;
    local IndicatorSettings indicatorSettings;

    indicatorHud = class'LGDUtilities.IndicatorHud'.static.SpawnAndRegister(Context);

    indicatorHud.PlayerIndicatorTargets = class'LGDUtilities.ActorHelper'.static.FindAllActorsByTag(Context, 'HudTarget1');

    //Add an advanced target
    hudTarget2 = Inventory(class'LGDUtilities.ActorHelper'.static.FindActor(Context, 'UDamage0', 'HudTarget2'));
    listElement = new class'LGDUtilities.IndicatorHudTargetListElement';
	listElement.IndicatorSource = self;
	
    indicatorSettings = new class'LGDUtilities.IndicatorSettings';

    listElement.Value = hudTarget2;
    indicatorSettings.MaxViewDistance = 0;
    indicatorSettings.UseCustomColor = false;
    indicatorSettings.ShowTargetDistanceLabels = false;
    indicatorSettings.ShowIndicatorWhenOffScreen = false;
    indicatorSettings.BlinkIndicator = false;
    indicatorSettings.ShowIndicatorAboveTarget = true;
    indicatorSettings.BuiltinIndicatorTexture = 59; //HUDIndicator_Texture_BuiltIn.HudIndicator_DownArrow_Solid
    indicatorSettings.ShowIndicatorIfInventoryHeld = false;
    indicatorSettings.ShowIndicatorIfInventoryDropped = false;
    indicatorSettings.ShowIndicatorIfInventoryNotHeld = true;
    indicatorSettings.ShowIndicatorIfTargetHidden = false;

    listElement.IndicatorSettings = indicatorSettings;

    indicatorHud.AddAdvancedTarget(
        listElement,
        false,
		false,
		true
    );
}

defaultproperties {
}
