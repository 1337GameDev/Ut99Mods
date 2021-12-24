//=============================================================================
// HHGameOptionsMenu
//=============================================================================
class HHGameOptionsMenu extends UTRulesCWindow;
	var UWindowCheckBox ShowDroppedSkullIndicatorsCheckbox, ShowPlayersWithSkullThresholdCheckbox;
	var UWindowEditControl SkullCollectIntervalEdit, SkullCarryLimitEdit, SkullThresholdToShowPlayersEdit;

	var string ShowDroppedSkullIndicatorsText, ShowPlayersWithSkullThresholdText, SkullCollectIntervalText, SkullCarryLimitText, SkullThresholdToShowPlayersText;
	var string ShowDroppedSkullIndicatorsHelp, ShowPlayersWithSkullThresholdHelp, SkullCollectIntervalHelp, SkullCarryLimitHelp, SkullThresholdToShowPlayersHelp;

function Created() {
	local int ControlWidth, ControlLeft, ControlRight;
	local int CenterWidth, CenterPos, ButtonWidth, ButtonLeft;

	ControlWidth = WinWidth/2.5;
	ControlLeft = (WinWidth/2 - ControlWidth)/2;
	ControlRight = WinWidth/2 + ControlLeft;

	CenterWidth = (WinWidth/4)*3;
	CenterPos = (WinWidth - CenterWidth)/2;
	ButtonWidth = WinWidth - 140;
	ButtonLeft = WinWidth - ButtonWidth - 40;

	Super.Created();

	ShowDroppedSkullIndicatorsCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlLeft+3, ControlOffset, ControlWidth+85, 1));
	ShowDroppedSkullIndicatorsCheckbox.SetText(ShowDroppedSkullIndicatorsText);
	ShowDroppedSkullIndicatorsCheckbox.SetHelpText(ShowDroppedSkullIndicatorsHelp);
	ShowDroppedSkullIndicatorsCheckbox.SetFont(F_Normal);
	ShowDroppedSkullIndicatorsCheckbox.bChecked = class'HeadHunterGameInfo'.default.ShowDroppedSkullIndicators;
	ShowDroppedSkullIndicatorsCheckbox.Align = TA_Right;
	ControlOffset += 25;

	ShowPlayersWithSkullThresholdCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlLeft+3, ControlOffset, ControlWidth+132, 1));
	ShowPlayersWithSkullThresholdCheckbox.SetText(ShowPlayersWithSkullThresholdText);
	ShowPlayersWithSkullThresholdCheckbox.SetHelpText(ShowPlayersWithSkullThresholdHelp);
	ShowPlayersWithSkullThresholdCheckbox.SetFont(F_Normal);
	ShowPlayersWithSkullThresholdCheckbox.bChecked = class'HeadHunterGameInfo'.default.ShowPlayersWithSkullThreshold;
	ShowPlayersWithSkullThresholdCheckbox.Align = TA_Right;
	ControlOffset += 25;

	SkullThresholdToShowPlayersEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlLeft+3, ControlOffset, ControlWidth+105, 1));
	SkullThresholdToShowPlayersEdit.SetText(SkullThresholdToShowPlayersText);
	SkullThresholdToShowPlayersEdit.SetHelpText(SkullThresholdToShowPlayersHelp);
	SkullThresholdToShowPlayersEdit.SetFont(F_Normal);
	SkullThresholdToShowPlayersEdit.SetNumericOnly(True);
	SkullThresholdToShowPlayersEdit.SetNumericFloat(False);
	SkullThresholdToShowPlayersEdit.SetMaxLength(2);
	SkullThresholdToShowPlayersEdit.Align = TA_Right;
	SkullThresholdToShowPlayersEdit.EditBoxWidth = 25;
	SkullThresholdToShowPlayersEdit.SetValue(String(class'HeadHunterGameInfo'.default.SkullThresholdToShowPlayers));
	ControlOffset += 25;

	SkullCollectIntervalEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlLeft+3, ControlOffset, ControlWidth+78, 1));
	SkullCollectIntervalEdit.SetText(SkullCollectIntervalText);
	SkullCollectIntervalEdit.SetHelpText(SkullCollectIntervalHelp);
	SkullCollectIntervalEdit.SetFont(F_Normal);
	SkullCollectIntervalEdit.SetNumericOnly(True);
	SkullCollectIntervalEdit.SetNumericFloat(False);
	SkullCollectIntervalEdit.SetMaxLength(3);
	SkullCollectIntervalEdit.Align = TA_Right;
	SkullCollectIntervalEdit.EditBoxWidth = 25;
	SkullCollectIntervalEdit.SetValue(String(class'HeadHunterGameInfo'.default.SkullCollectTimeInterval));
	ControlOffset += 25;

	SkullCarryLimitEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlLeft+3, ControlOffset, ControlWidth+30, 1));
	SkullCarryLimitEdit.SetText(SkullCarryLimitText);
	SkullCarryLimitEdit.SetHelpText(SkullCarryLimitHelp);
	SkullCarryLimitEdit.SetFont(F_Normal);
	SkullCarryLimitEdit.SetNumericOnly(True);
	SkullCarryLimitEdit.SetNumericFloat(False);
	SkullCarryLimitEdit.SetMaxLength(2);
	SkullCarryLimitEdit.Align = TA_Right;
	SkullCarryLimitEdit.EditBoxWidth = 25;
	SkullCarryLimitEdit.SetValue(String(class'HeadHunterGameInfo'.default.SkullCarryLimit));
	ControlOffset += 25;
}

function LoadCurrentValues() {
	Super.LoadCurrentValues();

	TimeEdit.SetValue(string(Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.TimeLimit));

	if(MaxPlayersEdit != None) {
		MaxPlayersEdit.SetValue(string(Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.MaxPlayers));
	}

	if(MaxSpectatorsEdit != None) {
		MaxSpectatorsEdit.SetValue(string(Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.MaxSpectators));
	}

	if(BotmatchParent.bNetworkGame) {
		WeaponsCheck.bChecked = Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.bMultiWeaponStay;
	} else {
		WeaponsCheck.bChecked = Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.bCoopWeaponMode;
	}

	FragEdit.SetValue(string(Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.SkullCollectGoal));
	TourneyCheck.bChecked = Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.bTournament;

	ShowDroppedSkullIndicatorsCheckbox.bChecked = Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.ShowDroppedSkullIndicators;
	ShowPlayersWithSkullThresholdCheckbox.bChecked = Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.ShowPlayersWithSkullThreshold;

	SkullThresholdToShowPlayersEdit.SetValue(string(Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.SkullThresholdToShowPlayers));
	SkullCollectIntervalEdit.SetValue(string(Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.SkullCollectTimeInterval));
	SkullCarryLimitEdit.SetValue(string(Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.SkullCarryLimit));

}

function Notify(UWindowDialogControl C, byte E) {
	local bool matchedAControl;
	Super.Notify(C, E);
	matchedAControl = false;

	switch(E) {
		case DE_Change: // the message sent by sliders and checkboxes
			switch(C) {
				case ShowDroppedSkullIndicatorsCheckbox:
					class'HeadHunterGameInfo'.default.ShowDroppedSkullIndicators = ShowDroppedSkullIndicatorsCheckbox.bChecked;
					matchedAControl = true;
					break;
				case ShowPlayersWithSkullThresholdCheckbox:
					class'HeadHunterGameInfo'.default.ShowPlayersWithSkullThreshold = ShowPlayersWithSkullThresholdCheckbox.bChecked;
					matchedAControl = true;
					break;
				case SkullThresholdToShowPlayersEdit:
					class'HeadHunterGameInfo'.default.SkullThresholdToShowPlayers = Int(SkullThresholdToShowPlayersEdit.GetValue());
					matchedAControl = true;
					break;
				case SkullCollectIntervalEdit:
					class'HeadHunterGameInfo'.default.SkullCollectTimeInterval = Int(SkullCollectIntervalEdit.GetValue());
					matchedAControl = true;
					break;
				case SkullCarryLimitEdit:
					class'HeadHunterGameInfo'.default.SkullCarryLimit = Int(SkullCarryLimitEdit.GetValue());
					matchedAControl = true;
					break;
			}
			break;
	}

	if(matchedAControl) {
		class'HeadHunterGameInfo'.static.StaticSaveConfig();
	}
}

function FragChanged() {
	Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.SkullCollectGoal = int(FragEdit.GetValue());
}

defaultproperties {
     FragText="Skull Collect Goal",
     FragHelp="Set the number of skulls that are to be collected to win the match. Set it to 0 for no limit.",
     ShowDroppedSkullIndicatorsText="Show Dropped Skull Indicators",
	 ShowDroppedSkullIndicatorsHelp="Whether to show indicators on player HUDs for skulls.",
	 ShowPlayersWithSkullThresholdText="Show Players With Skulls Over Threshold",
	 ShowPlayersWithSkullThresholdHelp="Whether to show players that have a certain number of skulls, on other player's HUDs.",
	 SkullCollectIntervalText="Skull Collect Interval (secs)",
	 SkullCollectIntervalHelp="The number of seconds between skull collection phases.",
	 SkullCarryLimitText="Skull Carry Limit",
	 SkullCarryLimitHelp="The max number of skulls a player is allowed to carry.",
	 SkullThresholdToShowPlayersText="Skull Threshold To Show Players"
	 SkullThresholdToShowPlayersHelp="The number of skulls in order to show an indicator on other player's HUds, assuming 'ShowPlayersWithSkullThresholdHelp' is enabled."
}

//--]]]]----
