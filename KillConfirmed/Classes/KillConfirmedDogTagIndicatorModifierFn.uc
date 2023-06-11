class KillConfirmedDogTagIndicatorModifierFn extends IndicatorSettingsModifierFn;

function IndicatorSettings ModifierFunc(IndicatorHudTargetListElement indicatorListElement, IndicatorHud indicatorHud) {
    local DogTagItem thisDogTag;
    local PlayerPawn activePlayer;
    local KillConfirmedGameInfo kcGameInfo;
    local bool IsEnemyDogTag;

    thisDogTag = DogTagItem(indicatorListElement.Value);
   
    if(thisDogTag != None){
        kcGameInfo = KillConfirmedGameInfo(Self.Context);
				
        if(kcGameInfo != None){
			activePlayer = indicatorHud.PlayerOwner;
			
            if(!thisDogTag.bHidden && kcGameInfo.ShowDogTagIndicators){
                indicatorListElement.IndicatorSettings.DisableIndicator = false;
			   
			    //now set color
				if(thisDogTag.IsTeamGame) {
					IsEnemyDogTag = (activePlayer.PlayerReplicationInfo.Team != thisDogTag.DroppedByTeam);
				} else {
					IsEnemyDogTag = (activePlayer.PlayerReplicationInfo.PlayerID != thisDogTag.DroppedByPlayerID);
				}
				
				if(IsEnemyDogTag) {
					//team is diff, so set as red
					thisDogTag.SetVisualsRed();
					indicatorListElement.IndicatorSettings.IndicatorColor = class'LGDUtilities.ColorHelper'.default.RedColor;
				} else {
					//team is the same, so set to blue
					thisDogTag.SetVisualsBlue();
					indicatorListElement.IndicatorSettings.IndicatorColor = class'LGDUtilities.ColorHelper'.default.BlueColor;
				}
            } else {
                indicatorListElement.IndicatorSettings.DisableIndicator = true;
            }
        }
    }
    return indicatorListElement.IndicatorSettings;
}

defaultproperties {}
