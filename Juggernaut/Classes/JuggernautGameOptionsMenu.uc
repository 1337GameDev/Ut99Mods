//=============================================================================
// JuggernautGameOptionsMenu
//=============================================================================
class JuggernautGameOptionsMenu extends UTRulesCWindow;
	var UWindowCheckBox ShowJuggernautIndicatorCheckbox, OnlyCountKillsAsJuggernautCheckbox;
	
	var UWindowEditControl RegenSecondsEdit, ShieldRegenRateEdit, HealthRegenRateEdit, JugJumpModifierEdit, JugMovementMultiplierEdit;

	var string ShowJuggernautIndicatorText, OnlyCountKillsAsJuggernautText, RegenSecondsText, ShieldRegenRateText, HealthRegenRateText, JugJumpModifierText, JugMovementMultiplierText;
	var string ShowJuggernautIndicatorHelp, OnlyCountKillsAsJuggernautHelp, RegenSecondsHelp, ShieldRegenRateHelp, HealthRegenRateHelp, JugJumpModifierHelp, JugMovementMultiplierHelp;

function Created() {
	local int ControlWidth, ControlLeft, ControlRight, ControlOffsetRightSideTop;
	local int CenterWidth, CenterPos, ButtonWidth, ButtonLeft;

	ControlWidth = WinWidth/2.5;
	ControlLeft = (WinWidth/2 - ControlWidth)/2;
	ControlRight = WinWidth/2 + ControlLeft;

	CenterWidth = (WinWidth/4)*3;
	CenterPos = (WinWidth - CenterWidth)/2;
	ButtonWidth = WinWidth - 140;
	ButtonLeft = WinWidth - ButtonWidth - 40;

	Super.Created();
	ControlOffsetRightSideTop = ControlOffset;

	RegenSecondsEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlLeft+3, ControlOffset, ControlWidth+40, 1));
	RegenSecondsEdit.SetText(RegenSecondsText);
	RegenSecondsEdit.SetHelpText(RegenSecondsHelp);
	RegenSecondsEdit.SetFont(F_Normal);
	RegenSecondsEdit.SetNumericOnly(True);
	//RegenSecondsEdit.SetNumericFloat(False);
	RegenSecondsEdit.SetMaxLength(3);
	RegenSecondsEdit.Align = TA_Right;
	RegenSecondsEdit.EditBoxWidth = 25;
	RegenSecondsEdit.SetValue(String(class'JuggernautGameInfo'.default.RegenSeconds));
	ControlOffset += 25;

	ShieldRegenRateEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlLeft+3, ControlOffset, ControlWidth+38, 1));
	ShieldRegenRateEdit.SetText(ShieldRegenRateText);
	ShieldRegenRateEdit.SetHelpText(ShieldRegenRateHelp);
	ShieldRegenRateEdit.SetFont(F_Normal);
	ShieldRegenRateEdit.SetNumericOnly(True);
	//ShieldRegenRateEdit.SetNumericFloat(False);
	ShieldRegenRateEdit.SetMaxLength(3);
	ShieldRegenRateEdit.Align = TA_Right;
	ShieldRegenRateEdit.EditBoxWidth = 25;
	ShieldRegenRateEdit.SetValue(String(class'JuggernautGameInfo'.default.ShieldRegenRate));
	ControlOffset += 25;

	HealthRegenRateEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlLeft+3, ControlOffset, ControlWidth+40, 1));
	HealthRegenRateEdit.SetText(HealthRegenRateText);
	HealthRegenRateEdit.SetHelpText(HealthRegenRateHelp);
	HealthRegenRateEdit.SetFont(F_Normal);
	HealthRegenRateEdit.SetNumericOnly(True);
	//HealthRegenRateEdit.SetNumericFloat(False);
	HealthRegenRateEdit.SetMaxLength(3);
	HealthRegenRateEdit.Align = TA_Right;
	HealthRegenRateEdit.EditBoxWidth = 25;
	HealthRegenRateEdit.SetValue(String(class'JuggernautGameInfo'.default.HealthRegenRate));
	ControlOffset += 25;
	
	ShowJuggernautIndicatorCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlLeft+3, ControlOffset, ControlWidth+40, 1));
	ShowJuggernautIndicatorCheckbox.SetText(ShowJuggernautIndicatorText);
	ShowJuggernautIndicatorCheckbox.SetHelpText(ShowJuggernautIndicatorHelp);
	ShowJuggernautIndicatorCheckbox.SetFont(F_Normal);
	ShowJuggernautIndicatorCheckbox.bChecked = class'JuggernautGameInfo'.default.ShowJuggernautIndicator;
	ShowJuggernautIndicatorCheckbox.Align = TA_Right;
	ControlOffset += 25;

	OnlyCountKillsAsJuggernautCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlLeft+3, ControlOffset, ControlWidth+57, 1));
	OnlyCountKillsAsJuggernautCheckbox.SetText(OnlyCountKillsAsJuggernautText);
	OnlyCountKillsAsJuggernautCheckbox.SetHelpText(OnlyCountKillsAsJuggernautHelp);
	OnlyCountKillsAsJuggernautCheckbox.SetFont(F_Normal);
	OnlyCountKillsAsJuggernautCheckbox.bChecked = class'JuggernautGameInfo'.default.OnlyJuggernautScores;
	OnlyCountKillsAsJuggernautCheckbox.Align = TA_Right;
	ControlOffset += 25;
	
	JugJumpModifierEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlRight+32, ControlOffsetRightSideTop, ControlWidth+55, 1));
	JugJumpModifierEdit.SetText(JugJumpModifierText);
	JugJumpModifierEdit.SetHelpText(JugJumpModifierHelp);
	JugJumpModifierEdit.SetFont(F_Normal);
	JugJumpModifierEdit.SetNumericOnly(True);
	//JugJumpModifierEdit.SetNumericFloat(False);
	JugJumpModifierEdit.SetMaxLength(3);
	JugJumpModifierEdit.Align = TA_Right;
	JugJumpModifierEdit.EditBoxWidth = 25;
	JugJumpModifierEdit.SetValue(String(class'JuggernautGameInfo'.default.JugJumpModifier));
	ControlOffsetRightSideTop += 25;
	
	JugMovementMultiplierEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlRight+32, ControlOffsetRightSideTop, ControlWidth+55, 1));
	JugMovementMultiplierEdit.SetText(JugMovementMultiplierText);
	JugMovementMultiplierEdit.SetHelpText(JugMovementMultiplierHelp);
	JugMovementMultiplierEdit.SetFont(F_Normal);
	JugMovementMultiplierEdit.SetNumericOnly(True);
	//JugMovementMultiplierEdit.SetNumericFloat(False);
	JugMovementMultiplierEdit.SetMaxLength(3);
	JugMovementMultiplierEdit.Align = TA_Right;
	JugMovementMultiplierEdit.EditBoxWidth = 25;
	JugMovementMultiplierEdit.SetValue(String(class'JuggernautGameInfo'.default.JugMovementMultiplier));
	ControlOffsetRightSideTop += 25;
}

function LoadCurrentValues() {
	Super.LoadCurrentValues();

	TimeEdit.SetValue(string(Class<JuggernautGameInfo>(BotmatchParent.GameClass).Default.TimeLimit));

	if(MaxPlayersEdit != None) {
		MaxPlayersEdit.SetValue(string(Class<JuggernautGameInfo>(BotmatchParent.GameClass).Default.MaxPlayers));
	}

	if(MaxSpectatorsEdit != None) {
		MaxSpectatorsEdit.SetValue(string(Class<JuggernautGameInfo>(BotmatchParent.GameClass).Default.MaxSpectators));
	}

	if(BotmatchParent.bNetworkGame) {
		WeaponsCheck.bChecked = Class<JuggernautGameInfo>(BotmatchParent.GameClass).Default.bMultiWeaponStay;
	} else {
		WeaponsCheck.bChecked = Class<JuggernautGameInfo>(BotmatchParent.GameClass).Default.bCoopWeaponMode;
	}

	FragEdit.SetValue(string(Class<JuggernautGameInfo>(BotmatchParent.GameClass).Default.FragLimit));
	TourneyCheck.bChecked = Class<JuggernautGameInfo>(BotmatchParent.GameClass).Default.bTournament;

	ShowJuggernautIndicatorCheckbox.bChecked = Class<JuggernautGameInfo>(BotmatchParent.GameClass).Default.ShowJuggernautIndicator;
	OnlyCountKillsAsJuggernautCheckbox.bChecked = Class<JuggernautGameInfo>(BotmatchParent.GameClass).Default.OnlyJuggernautScores;

	RegenSecondsEdit.SetValue(string(Class<JuggernautGameInfo>(BotmatchParent.GameClass).Default.RegenSeconds));
	ShieldRegenRateEdit.SetValue(string(Class<JuggernautGameInfo>(BotmatchParent.GameClass).Default.ShieldRegenRate));
	HealthRegenRateEdit.SetValue(string(Class<JuggernautGameInfo>(BotmatchParent.GameClass).Default.HealthRegenRate));
	JugJumpModifierEdit.SetValue(string(Class<JuggernautGameInfo>(BotmatchParent.GameClass).Default.JugJumpModifier));
	JugMovementMultiplierEdit.SetValue(string(Class<JuggernautGameInfo>(BotmatchParent.GameClass).Default.JugMovementMultiplier));
}

function Notify(UWindowDialogControl C, byte E) {
	local bool matchedAControl;
	Super.Notify(C, E);
	matchedAControl = false;

	switch(E) {
		case DE_Change: // the message sent by sliders and checkboxes
			switch(C) {
				case ShowJuggernautIndicatorCheckbox:
					class'JuggernautGameInfo'.default.ShowJuggernautIndicator = ShowJuggernautIndicatorCheckbox.bChecked;
					matchedAControl = true;
					break;
				case OnlyCountKillsAsJuggernautCheckbox:
					class'JuggernautGameInfo'.default.OnlyJuggernautScores = OnlyCountKillsAsJuggernautCheckbox.bChecked;
					matchedAControl = true;
					break;
				case RegenSecondsEdit:
					class'JuggernautGameInfo'.default.RegenSeconds = Int(RegenSecondsEdit.GetValue());
					matchedAControl = true;
					break;
				case ShieldRegenRateEdit:
					class'JuggernautGameInfo'.default.ShieldRegenRate = Int(ShieldRegenRateEdit.GetValue());
					matchedAControl = true;
					break;
				case HealthRegenRateEdit:
					class'JuggernautGameInfo'.default.HealthRegenRate = Int(HealthRegenRateEdit.GetValue());
					matchedAControl = true;
					break;
				case JugJumpModifierEdit:
					class'JuggernautGameInfo'.default.JugJumpModifier = Int(JugJumpModifierEdit.GetValue());
					matchedAControl = true;
					break;
				case JugMovementMultiplierEdit:
					class'JuggernautGameInfo'.default.JugMovementMultiplier = Int(JugMovementMultiplierEdit.GetValue());
					matchedAControl = true;
					break;
			}
			break;
	}

	if(matchedAControl) {
		class'JuggernautGameInfo'.static.StaticSaveConfig();
	}
}


//--]]]]----

defaultproperties
{
      ShowJuggernautIndicatorCheckbox=None
      OnlyCountKillsAsJuggernautCheckbox=None
      RegenSecondsEdit=None
      ShieldRegenRateEdit=None
      HealthRegenRateEdit=None
      JugJumpModifierEdit=None
      JugMovementMultiplierEdit=None
      ShowJuggernautIndicatorText="Juggernaut Indicator"
      OnlyCountKillsAsJuggernautText="Only Juggernaut Scores?"
      RegenSecondsText="Regen Time (secs)"
      ShieldRegenRateText="Shield Regen Rate"
      HealthRegenRateText="Health Regen Rate"
      JugJumpModifierText="Juggernaut Jump Mod"
      JugMovementMultiplierText="Juggernaut Move Mod"
      ShowJuggernautIndicatorHelp="Whether to show an indicator (for all to see) of the current juggernaut."
      OnlyCountKillsAsJuggernautHelp="Whether kills ONLY count for the juggernaut or not."
      RegenSecondsHelp="How many seconds between each juggernaut regen."
      ShieldRegenRateHelp="How many shield points to regen."
      HealthRegenRateHelp="How many health points to regen."
      JugJumpModifierHelp="The multiplier for the juggernaut related to jumping. (3 = Jump Boots)"
      JugMovementMultiplierHelp="The multiplier for movement speed of the juggernaut."
      FragHelp="The number of kills to win the game."
}
