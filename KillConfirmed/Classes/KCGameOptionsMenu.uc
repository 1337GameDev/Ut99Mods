//=============================================================================
// KCGameOptionsMenu
//=============================================================================
class KCGameOptionsMenu extends UTRulesCWindow;
	var UWindowCheckBox ShowDogTagIndicatorsCheckbox, UseHaloAnnouncerCheckbox;

	var string ShowDogTagIndicatorsText, UseHaloAnnouncerText;
	var string ShowDogTagIndicatorsHelp, UseHaloAnnouncerHelp;

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

	ShowDogTagIndicatorsCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlLeft+3, ControlOffset, ControlWidth+35, 1));
	ShowDogTagIndicatorsCheckbox.SetText(ShowDogTagIndicatorsText);
	ShowDogTagIndicatorsCheckbox.SetHelpText(ShowDogTagIndicatorsHelp);
	ShowDogTagIndicatorsCheckbox.SetFont(F_Normal);
	ShowDogTagIndicatorsCheckbox.bChecked = class'KillConfirmed.KillConfirmedGameInfo'.default.ShowDogTagIndicators;
	ShowDogTagIndicatorsCheckbox.Align = TA_Right;
	ControlOffset += 20;
	
	UseHaloAnnouncerCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlLeft+3, ControlOffset, ControlWidth+40, 1));
	UseHaloAnnouncerCheckbox.SetText(UseHaloAnnouncerText);
	UseHaloAnnouncerCheckbox.SetHelpText(UseHaloAnnouncerHelp);
	UseHaloAnnouncerCheckbox.SetFont(F_Normal);
	UseHaloAnnouncerCheckbox.bChecked = class'KillConfirmed.KillConfirmedGameInfo'.default.UseHaloAnnouncer;
	UseHaloAnnouncerCheckbox.Align = TA_Right;
	ControlOffset += 20;
	
}

function LoadCurrentValues() {
	Super.LoadCurrentValues();

	TimeEdit.SetValue(string(Class<KillConfirmedGameInfo>(BotmatchParent.GameClass).Default.TimeLimit));

	if(MaxPlayersEdit != None) {
		MaxPlayersEdit.SetValue(string(Class<KillConfirmedGameInfo>(BotmatchParent.GameClass).Default.MaxPlayers));
	}

	if(MaxSpectatorsEdit != None) {
		MaxSpectatorsEdit.SetValue(string(Class<KillConfirmedGameInfo>(BotmatchParent.GameClass).Default.MaxSpectators));
	}

	if(BotmatchParent.bNetworkGame) {
		WeaponsCheck.bChecked = Class<KillConfirmedGameInfo>(BotmatchParent.GameClass).Default.bMultiWeaponStay;
	} else {
		WeaponsCheck.bChecked = Class<KillConfirmedGameInfo>(BotmatchParent.GameClass).Default.bCoopWeaponMode;
	}

	FragEdit.SetValue(string(Class<KillConfirmedGameInfo>(BotmatchParent.GameClass).Default.TagCollectGoal));
	TourneyCheck.bChecked = Class<KillConfirmedGameInfo>(BotmatchParent.GameClass).Default.bTournament;

	ShowDogTagIndicatorsCheckbox.bChecked = Class<KillConfirmedGameInfo>(BotmatchParent.GameClass).Default.ShowDogTagIndicators;
	
	UseHaloAnnouncerCheckbox.bChecked = Class<KillConfirmedGameInfo>(BotmatchParent.GameClass).Default.UseHaloAnnouncer;
}

function Notify(UWindowDialogControl C, byte E) {
	local bool matchedAControl;
	Super.Notify(C, E);
	matchedAControl = false;

	switch(E) {
		case DE_Change: // the message sent by sliders and checkboxes
			switch(C) {
				case ShowDogTagIndicatorsCheckbox:
					class'KillConfirmed.KillConfirmedGameInfo'.default.ShowDogTagIndicators = ShowDogTagIndicatorsCheckbox.bChecked;
					matchedAControl = true;
					break;
				case UseHaloAnnouncerCheckbox:
					class'KillConfirmed.KillConfirmedGameInfo'.default.UseHaloAnnouncer = UseHaloAnnouncerCheckbox.bChecked;
					matchedAControl = true;
					break;
					
			}
			break;
	}

	if(matchedAControl) {
		class'KillConfirmed.KillConfirmedGameInfo'.static.StaticSaveConfig();
	}
}

function FragChanged() {
	Class<KillConfirmedGameInfo>(BotmatchParent.GameClass).Default.TagCollectGoal = int(FragEdit.GetValue());
}


//--]]]]----

defaultproperties {
      ShowDogTagIndicatorsCheckbox=None
      ShowDogTagIndicatorsText="Show Tag Indicators"
      UseHaloAnnouncerText="Use Halo Announcer?"
      ShowDogTagIndicatorsHelp="Whether to show indicators on player HUDs for dog tags."
	  UseHaloAnnouncerHelp="Whether to use the Halo announcer instead of the standard UT99 one."
      FragText="Tag Collect Goal"
      FragHelp="Set the number of dog tags that are to be collected to win the match. Set it to 0 for no limit."
}
