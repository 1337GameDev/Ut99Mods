//=============================================================================
// HHGameOptionsMenu
//=============================================================================
class HHGameOptionsMenu extends UTRulesCWindow;
	var UWindowCheckBox ShowDroppedSkullIndicatorsCheckbox, ShowPlayersWithSkullThresholdCheckbox, UseHaloAnnouncerCheckbox;
	var UWindowEditControl SkullCollectIntervalEdit, SkullCarryLimitEdit, SkullThresholdToShowPlayersEdit;

	var string ShowDroppedSkullIndicatorsText, ShowPlayersWithSkullThresholdText, SkullCollectIntervalText, SkullCarryLimitText, SkullThresholdToShowPlayersText, UseHaloAnnouncerText;
	var string ShowDroppedSkullIndicatorsHelp, ShowPlayersWithSkullThresholdHelp, SkullCollectIntervalHelp, SkullCarryLimitHelp, SkullThresholdToShowPlayersHelp, UseHaloAnnouncerHelp;

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
	ShowDroppedSkullIndicatorsCheckbox.bChecked = class'HeadHunter.HeadHunterGameInfo'.default.ShowDroppedSkullIndicators;
	ShowDroppedSkullIndicatorsCheckbox.Align = TA_Right;
	ControlOffset += 20;

	ShowPlayersWithSkullThresholdCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlLeft+3, ControlOffset, ControlWidth+132, 1));
	ShowPlayersWithSkullThresholdCheckbox.SetText(ShowPlayersWithSkullThresholdText);
	ShowPlayersWithSkullThresholdCheckbox.SetHelpText(ShowPlayersWithSkullThresholdHelp);
	ShowPlayersWithSkullThresholdCheckbox.SetFont(F_Normal);
	ShowPlayersWithSkullThresholdCheckbox.bChecked = class'HeadHunter.HeadHunterGameInfo'.default.ShowPlayersWithSkullThreshold;
	ShowPlayersWithSkullThresholdCheckbox.Align = TA_Right;
	ControlOffset += 20;

	SkullThresholdToShowPlayersEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlLeft+3, ControlOffset, ControlWidth+105, 1));
	SkullThresholdToShowPlayersEdit.SetText(SkullThresholdToShowPlayersText);
	SkullThresholdToShowPlayersEdit.SetHelpText(SkullThresholdToShowPlayersHelp);
	SkullThresholdToShowPlayersEdit.SetFont(F_Normal);
	SkullThresholdToShowPlayersEdit.SetNumericOnly(True);
	SkullThresholdToShowPlayersEdit.SetNumericFloat(False);
	SkullThresholdToShowPlayersEdit.SetMaxLength(2);
	SkullThresholdToShowPlayersEdit.Align = TA_Right;
	SkullThresholdToShowPlayersEdit.EditBoxWidth = 25;
	SkullThresholdToShowPlayersEdit.SetValue(String(class'HeadHunter.HeadHunterGameInfo'.default.SkullThresholdToShowPlayers));
	ControlOffset += 20;

	SkullCollectIntervalEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlLeft+3, ControlOffset, ControlWidth+78, 1));
	SkullCollectIntervalEdit.SetText(SkullCollectIntervalText);
	SkullCollectIntervalEdit.SetHelpText(SkullCollectIntervalHelp);
	SkullCollectIntervalEdit.SetFont(F_Normal);
	SkullCollectIntervalEdit.SetNumericOnly(True);
	SkullCollectIntervalEdit.SetNumericFloat(False);
	SkullCollectIntervalEdit.SetMaxLength(3);
	SkullCollectIntervalEdit.Align = TA_Right;
	SkullCollectIntervalEdit.EditBoxWidth = 25;
	SkullCollectIntervalEdit.SetValue(String(class'HeadHunter.HeadHunterGameInfo'.default.SkullCollectTimeInterval));
	ControlOffset += 20;

	SkullCarryLimitEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlLeft+3, ControlOffset, ControlWidth+30, 1));
	SkullCarryLimitEdit.SetText(SkullCarryLimitText);
	SkullCarryLimitEdit.SetHelpText(SkullCarryLimitHelp);
	SkullCarryLimitEdit.SetFont(F_Normal);
	SkullCarryLimitEdit.SetNumericOnly(True);
	SkullCarryLimitEdit.SetNumericFloat(False);
	SkullCarryLimitEdit.SetMaxLength(2);
	SkullCarryLimitEdit.Align = TA_Right;
	SkullCarryLimitEdit.EditBoxWidth = 25;
	SkullCarryLimitEdit.SetValue(String(class'HeadHunter.HeadHunterGameInfo'.default.SkullCarryLimit));
	ControlOffset += 20;
	
	UseHaloAnnouncerCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlLeft+3, ControlOffset, ControlWidth+40, 1));
	UseHaloAnnouncerCheckbox.SetText(UseHaloAnnouncerText);
	UseHaloAnnouncerCheckbox.SetHelpText(UseHaloAnnouncerHelp);
	UseHaloAnnouncerCheckbox.SetFont(F_Normal);
	UseHaloAnnouncerCheckbox.bChecked = class'HeadHunter.HeadHunterGameInfo'.default.UseHaloAnnouncer;
	UseHaloAnnouncerCheckbox.Align = TA_Right;
	ControlOffset += 20;
	
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
	
	UseHaloAnnouncerCheckbox.bChecked = Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.UseHaloAnnouncer;
}

function Notify(UWindowDialogControl C, byte E) {
	local bool matchedAControl;
	Super.Notify(C, E);
	matchedAControl = false;

	switch(E) {
		case DE_Change: // the message sent by sliders and checkboxes
			switch(C) {
				case ShowDroppedSkullIndicatorsCheckbox:
					class'HeadHunter.HeadHunterGameInfo'.default.ShowDroppedSkullIndicators = ShowDroppedSkullIndicatorsCheckbox.bChecked;
					matchedAControl = true;
					break;
				case ShowPlayersWithSkullThresholdCheckbox:
					class'HeadHunter.HeadHunterGameInfo'.default.ShowPlayersWithSkullThreshold = ShowPlayersWithSkullThresholdCheckbox.bChecked;
					matchedAControl = true;
					break;
				case SkullThresholdToShowPlayersEdit:
					class'HeadHunter.HeadHunterGameInfo'.default.SkullThresholdToShowPlayers = Int(SkullThresholdToShowPlayersEdit.GetValue());
					matchedAControl = true;
					break;
				case SkullCollectIntervalEdit:
					class'HeadHunter.HeadHunterGameInfo'.default.SkullCollectTimeInterval = Int(SkullCollectIntervalEdit.GetValue());
					matchedAControl = true;
					break;
				case SkullCarryLimitEdit:
					class'HeadHunter.HeadHunterGameInfo'.default.SkullCarryLimit = Int(SkullCarryLimitEdit.GetValue());
					matchedAControl = true;
					break;
				case UseHaloAnnouncerCheckbox:
					class'HeadHunter.HeadHunterGameInfo'.default.UseHaloAnnouncer = UseHaloAnnouncerCheckbox.bChecked;
					matchedAControl = true;
					break;
					
			}
			break;
	}

	if(matchedAControl) {
		class'HeadHunter.HeadHunterGameInfo'.static.StaticSaveConfig();
	}
}

function FragChanged() {
	Class<HeadHunterGameInfo>(BotmatchParent.GameClass).Default.SkullCollectGoal = int(FragEdit.GetValue());
}


//--]]]]----

defaultproperties {
      ShowDroppedSkullIndicatorsCheckbox=None
      ShowPlayersWithSkullThresholdCheckbox=None
      SkullCollectIntervalEdit=None
      SkullCarryLimitEdit=None
      SkullThresholdToShowPlayersEdit=None
      ShowDroppedSkullIndicatorsText="Show Dropped Skull Indicators"
      ShowPlayersWithSkullThresholdText="Show Players With Skulls Over Threshold"
      SkullCollectIntervalText="Skull Collect Interval (secs)"
      SkullCarryLimitText="Skull Carry Limit"
      SkullThresholdToShowPlayersText="Skull Threshold To Show Players"
      UseHaloAnnouncerText="Use Halo Announcer?"
      ShowDroppedSkullIndicatorsHelp="Whether to show indicators on player HUDs for skulls."
      ShowPlayersWithSkullThresholdHelp="Whether to show players that have a certain number of skulls, on other player's HUDs."
      SkullCollectIntervalHelp="The number of seconds between skull collection phases."
      SkullCarryLimitHelp="The max number of skulls a player is allowed to carry."
      SkullThresholdToShowPlayersHelp="The number of skulls in order to show an indicator on other player's HUds, assuming 'ShowPlayersWithSkullThresholdHelp' is enabled."
      UseHaloAnnouncerHelp="Whether to use the Halo announcer instead of the standard UT99 one."
      FragText="Skull Collect Goal"
      FragHelp="Set the number of skulls that are to be collected to win the match. Set it to 0 for no limit."
}
