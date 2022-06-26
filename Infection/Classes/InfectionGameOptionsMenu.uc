//=============================================================================
// InfectionGameOptionsMenu
//=============================================================================
class InfectionGameOptionsMenu extends UTRulesCWindow;

var int MinimumZombies;
var bool ShowZombieIndicators;
var bool ShowHumanIndicators;
var bool ShowSameTeamIndicators;
var float ZombieSpeed;
var float ZombieJumnpHeight;

var float ZombieDamageMod;
var float HumanDamageMod;

var bool HumansPickupWeapons;
var bool ZombiesPickupWeapons;
var bool InfiniteAmmo;
var bool AnyDeathInfects;

var UWindowCheckBox ShowZombieIndicatorCheckbox, ShowHumanIndicatorCheckbox, ShowSameTeamIndicatorsCheckbox, 
		HumansPickupWeaponsCheckbox, ZombiesPickupWeaponsCheckbox, InfiniteAmmoCheckbox, AnyDeathInfectsCheckbox;
		
var UWindowEditControl MinimumZombiesEdit, ZombieJumpModifierEdit, ZombieMovementMultiplierEdit, 
		ZombieDamageModEdit, HumanDamageModEdit;

var string ShowZombieIndicatorText, ShowHumanIndicatorText, ShowSameTeamIndicatorsText, MinimumZombiesText, 
		ZombieJumpModifierText, ZombieMovementMultiplierText, HumansPickupWeaponsText, ZombiesPickupWeaponsText, 
		InfiniteAmmoText, AnyDeathInfectsText, ZombieDamageModText, HumanDamageModText;
		
var string ShowZombieIndicatorHelp, ShowHumanIndicatorHelp, ShowSameTeamIndicatorsHelp, MinimumZombiesHelp, 
		ZombieJumpModifierHelp, ZombieMovementMultiplierHelp, HumansPickupWeaponsHelp, ZombiesPickupWeaponsHelp, 
		InfiniteAmmoHelp, AnyDeathInfectsHelp, ZombieDamageModHelp, HumanDamageModHelp;

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
	
	//LEFT SIDE
	MinimumZombiesEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlLeft+3, ControlOffset, ControlWidth+10, 1));
	MinimumZombiesEdit.SetText(MinimumZombiesText);
	MinimumZombiesEdit.SetHelpText(MinimumZombiesHelp);
	MinimumZombiesEdit.SetFont(F_Normal);
	MinimumZombiesEdit.SetNumericOnly(True);
	MinimumZombiesEdit.SetMaxLength(2);
	MinimumZombiesEdit.Align = TA_Right;
	MinimumZombiesEdit.EditBoxWidth = 20;
	MinimumZombiesEdit.SetValue(String(class'Infection.InfectionGameInfo'.default.MinimumZombies));
	ControlOffset += 20;
	
	ShowZombieIndicatorCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlLeft+3, ControlOffset, ControlWidth+35, 1));
	ShowZombieIndicatorCheckbox.SetText(ShowZombieIndicatorText);
	ShowZombieIndicatorCheckbox.SetHelpText(ShowZombieIndicatorHelp);
	ShowZombieIndicatorCheckbox.SetFont(F_Normal);
	ShowZombieIndicatorCheckbox.bChecked = class'Infection.InfectionGameInfo'.default.ShowZombieIndicators;
	ShowZombieIndicatorCheckbox.Align = TA_Right;
	ControlOffset += 20;
	
	ShowHumanIndicatorCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlLeft+3, ControlOffset, ControlWidth+38, 1));
	ShowHumanIndicatorCheckbox.SetText(ShowHumanIndicatorText);
	ShowHumanIndicatorCheckbox.SetHelpText(ShowHumanIndicatorHelp);
	ShowHumanIndicatorCheckbox.SetFont(F_Normal);
	ShowHumanIndicatorCheckbox.bChecked = class'Infection.InfectionGameInfo'.default.ShowHumanIndicators;
	ShowHumanIndicatorCheckbox.Align = TA_Right;
	ControlOffset += 20;
	
	ShowSameTeamIndicatorsCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlLeft+3, ControlOffset, ControlWidth+23, 1));
	ShowSameTeamIndicatorsCheckbox.SetText(ShowSameTeamIndicatorsText);
	ShowSameTeamIndicatorsCheckbox.SetHelpText(ShowSameTeamIndicatorsHelp);
	ShowSameTeamIndicatorsCheckbox.SetFont(F_Normal);
	ShowSameTeamIndicatorsCheckbox.bChecked = class'Infection.InfectionGameInfo'.default.ShowSameTeamIndicators;
	ShowSameTeamIndicatorsCheckbox.Align = TA_Right;
	ControlOffset += 20;
	
	ZombieDamageModEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlLeft+3, ControlOffset, ControlWidth+40, 1));
	ZombieDamageModEdit.SetText(ZombieDamageModText);
	ZombieDamageModEdit.SetHelpText(ZombieDamageModHelp);
	ZombieDamageModEdit.SetFont(F_Normal);
	ZombieDamageModEdit.SetNumericOnly(True);
	ZombieDamageModEdit.SetNumericFloat(True);
	ZombieDamageModEdit.SetMaxLength(3);
	ZombieDamageModEdit.Align = TA_Right;
	ZombieDamageModEdit.EditBoxWidth = 25;
	ZombieDamageModEdit.SetValue(String(class'Infection.InfectionGameInfo'.default.ZombieDamageMod));
	ControlOffset += 20;
	
	HumanDamageModEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlLeft+3, ControlOffset, ControlWidth+40, 1));
	HumanDamageModEdit.SetText(HumanDamageModText);
	HumanDamageModEdit.SetHelpText(HumanDamageModHelp);
	HumanDamageModEdit.SetFont(F_Normal);
	HumanDamageModEdit.SetNumericOnly(True);
	HumanDamageModEdit.SetNumericFloat(True);
	HumanDamageModEdit.SetMaxLength(3);
	HumanDamageModEdit.Align = TA_Right;
	HumanDamageModEdit.EditBoxWidth = 25;	
	HumanDamageModEdit.SetValue(String(class'Infection.InfectionGameInfo'.default.HumanDamageMod));
	
	ControlOffset += 20;
	
	//RIGHT SIDE
	ZombieJumpModifierEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlRight+32, ControlOffsetRightSideTop, ControlWidth+40, 1));
	ZombieJumpModifierEdit.SetText(ZombieJumpModifierText);
	ZombieJumpModifierEdit.SetHelpText(ZombieJumpModifierHelp);
	ZombieJumpModifierEdit.SetFont(F_Normal);
	ZombieJumpModifierEdit.SetNumericOnly(True);
	ZombieJumpModifierEdit.SetNumericFloat(True);
	ZombieJumpModifierEdit.SetMaxLength(3);
	ZombieJumpModifierEdit.Align = TA_Right;
	ZombieJumpModifierEdit.EditBoxWidth = 25;
	ZombieJumpModifierEdit.SetValue(String(class'Infection.InfectionGameInfo'.default.ZombieJumpModifier));
	ControlOffsetRightSideTop += 20;
	
	ZombieMovementMultiplierEdit = UWindowEditControl(CreateControl(class'UWindowEditControl', ControlRight+32, ControlOffsetRightSideTop, ControlWidth+40, 1));
	ZombieMovementMultiplierEdit.SetText(ZombieMovementMultiplierText);
	ZombieMovementMultiplierEdit.SetHelpText(ZombieMovementMultiplierHelp);
	ZombieMovementMultiplierEdit.SetFont(F_Normal);
	ZombieMovementMultiplierEdit.SetNumericOnly(True);
	ZombieMovementMultiplierEdit.SetNumericFloat(True);
	ZombieMovementMultiplierEdit.SetMaxLength(3);
	ZombieMovementMultiplierEdit.Align = TA_Right;
	ZombieMovementMultiplierEdit.EditBoxWidth = 25;
	ZombieMovementMultiplierEdit.SetValue(String(class'Infection.InfectionGameInfo'.default.ZombieMovementModifier));
	ControlOffsetRightSideTop += 20;
	
	HumansPickupWeaponsCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlRight+32, ControlOffsetRightSideTop, ControlWidth+50, 1));
	HumansPickupWeaponsCheckbox.SetText(HumansPickupWeaponsText);
	HumansPickupWeaponsCheckbox.SetHelpText(HumansPickupWeaponsHelp);
	HumansPickupWeaponsCheckbox.SetFont(F_Normal);
	HumansPickupWeaponsCheckbox.bChecked = class'Infection.InfectionGameInfo'.default.HumansPickupWeapons;
	HumansPickupWeaponsCheckbox.Align = TA_Right;
	ControlOffsetRightSideTop += 20;
	
	ZombiesPickupWeaponsCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlRight+32, ControlOffsetRightSideTop, ControlWidth+50, 1));
	ZombiesPickupWeaponsCheckbox.SetText(ZombiesPickupWeaponsText);
	ZombiesPickupWeaponsCheckbox.SetHelpText(ZombiesPickupWeaponsHelp);
	ZombiesPickupWeaponsCheckbox.SetFont(F_Normal);
	ZombiesPickupWeaponsCheckbox.bChecked = class'Infection.InfectionGameInfo'.default.ZombiesPickupWeapons;
	ZombiesPickupWeaponsCheckbox.Align = TA_Right;
	ControlOffsetRightSideTop += 20;
	
	InfiniteAmmoCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlRight+32, ControlOffsetRightSideTop, ControlWidth+13, 1));
	InfiniteAmmoCheckbox.SetText(InfiniteAmmoText);
	InfiniteAmmoCheckbox.SetHelpText(InfiniteAmmoHelp);
	InfiniteAmmoCheckbox.SetFont(F_Normal);
	InfiniteAmmoCheckbox.bChecked = class'Infection.InfectionGameInfo'.default.InfiniteAmmo;
	InfiniteAmmoCheckbox.Align = TA_Right;
	ControlOffsetRightSideTop += 20;
	
	AnyDeathInfectsCheckbox = UWindowCheckBox(CreateControl(class'UWindowCheckBox', ControlRight+32, ControlOffsetRightSideTop, ControlWidth+28, 1));
	AnyDeathInfectsCheckbox.SetText(AnyDeathInfectsText);
	AnyDeathInfectsCheckbox.SetHelpText(AnyDeathInfectsHelp);
	AnyDeathInfectsCheckbox.SetFont(F_Normal);
	AnyDeathInfectsCheckbox.bChecked = class'Infection.InfectionGameInfo'.default.AnyDeathInfects;
	AnyDeathInfectsCheckbox.Align = TA_Right;
	ControlOffsetRightSideTop += 20;
}

function LoadCurrentValues() {
	Super.LoadCurrentValues();

	TimeEdit.SetValue(string(Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.TimeLimit));

	if(MaxPlayersEdit != None) {
		MaxPlayersEdit.SetValue(string(Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.MaxPlayers));
	}

	if(MaxSpectatorsEdit != None) {
		MaxSpectatorsEdit.SetValue(string(Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.MaxSpectators));
	}

	if(BotmatchParent.bNetworkGame) {
		WeaponsCheck.bChecked = Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.bMultiWeaponStay;
	} else {
		WeaponsCheck.bChecked = Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.bCoopWeaponMode;
	}

	FragEdit.SetValue(string(Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.FragLimit));
	TourneyCheck.bChecked = Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.bTournament;

	ShowZombieIndicatorCheckbox.bChecked = Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.ShowZombieIndicators;
	ShowHumanIndicatorCheckbox.bChecked = Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.ShowHumanIndicators;
	ShowSameTeamIndicatorsCheckbox.bChecked = Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.ShowSameTeamIndicators;

	MinimumZombiesEdit.SetValue(string(Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.MinimumZombies));
	ZombieJumpModifierEdit.SetValue(string(Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.ZombieJumpModifier));
	ZombieMovementMultiplierEdit.SetValue(string(Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.ZombieMovementModifier));
	
	HumansPickupWeaponsCheckbox.bChecked = Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.HumansPickupWeapons;
	ZombiesPickupWeaponsCheckbox.bChecked = Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.ZombiesPickupWeapons;
	InfiniteAmmoCheckbox.bChecked = Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.InfiniteAmmo;
	
	AnyDeathInfectsCheckbox.bChecked = Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.AnyDeathInfects;
	
	ZombieDamageModEdit.SetValue(string(Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.ZombieDamageMod));	
	HumanDamageModEdit.SetValue(string(Class<InfectionGameInfo>(BotmatchParent.GameClass).Default.HumanDamageMod));
	
}

function Notify(UWindowDialogControl C, byte E) {
	local bool matchedAControl;
	Super.Notify(C, E);
	matchedAControl = false;
	
	switch(E) {
		case DE_Change: // the message sent by sliders and checkboxes
			switch(C) {
				case ShowZombieIndicatorCheckbox:
					class'Infection.InfectionGameInfo'.default.ShowZombieIndicators = ShowZombieIndicatorCheckbox.bChecked;
					matchedAControl = true;
					break;
				case ShowHumanIndicatorCheckbox:
					class'Infection.InfectionGameInfo'.default.ShowHumanIndicators = ShowHumanIndicatorCheckbox.bChecked;
					matchedAControl = true;
					break;
				case ShowSameTeamIndicatorsCheckbox:
					class'Infection.InfectionGameInfo'.default.ShowSameTeamIndicators = ShowSameTeamIndicatorsCheckbox.bChecked;
					matchedAControl = true;
					break;
				case MinimumZombiesEdit:
					class'Infection.InfectionGameInfo'.default.MinimumZombies = Int(MinimumZombiesEdit.GetValue());
					matchedAControl = true;
					break;
				case ZombieJumpModifierEdit:
					class'Infection.InfectionGameInfo'.default.ZombieJumpModifier = Float(ZombieJumpModifierEdit.GetValue());
					matchedAControl = true;
					break;
				case ZombieMovementMultiplierEdit:
					class'Infection.InfectionGameInfo'.default.ZombieMovementModifier = Float(ZombieMovementMultiplierEdit.GetValue());
					matchedAControl = true;
					break;
				case HumansPickupWeaponsCheckbox:
					class'Infection.InfectionGameInfo'.default.HumansPickupWeapons = HumansPickupWeaponsCheckbox.bChecked;
					matchedAControl = true;
					break;
				case ZombiesPickupWeaponsCheckbox:
					class'Infection.InfectionGameInfo'.default.ZombiesPickupWeapons = ZombiesPickupWeaponsCheckbox.bChecked;
					matchedAControl = true;
					break;
				case InfiniteAmmoCheckbox:
					class'Infection.InfectionGameInfo'.default.InfiniteAmmo = InfiniteAmmoCheckbox.bChecked;
					matchedAControl = true;
					break;
				case AnyDeathInfectsCheckbox:
					class'Infection.InfectionGameInfo'.default.AnyDeathInfects = AnyDeathInfectsCheckbox.bChecked;
					matchedAControl = true;
					break;	
				case ZombieDamageModEdit:
					class'Infection.InfectionGameInfo'.default.ZombieDamageMod = Float(ZombieDamageModEdit.GetValue());
					matchedAControl = true;
					break;
				case HumanDamageModEdit:
					class'Infection.InfectionGameInfo'.default.HumanDamageMod = Float(HumanDamageModEdit.GetValue());
					matchedAControl = true;
					
					break;
			}
			break;
	}

	if(matchedAControl) {
		class'Infection.InfectionGameInfo'.static.StaticSaveConfig();
	}
}


//--]]]]----

defaultproperties {
      ShowZombieIndicatorCheckbox=None
	  ShowHumanIndicatorCheckbox=None
	  
      MinimumZombiesEdit=None

      ZombieJumpModifierEdit=None
      ZombieMovementMultiplierEdit=None
	  
      ShowZombieIndicatorText="Zombie Indicator?"
      ShowHumanIndicatorText="Human Indicators?"
	  ShowSameTeamIndicatorsText="Ally Indicators?"
      MinimumZombiesText="Min Zombies"
      ZombieJumpModifierText="Zombie Jump Mod"
      ZombieMovementMultiplierText="Zombie Move Mod"
	  HumansPickupWeaponsText="Human Weapon Pickup?"
	  ZombiesPickupWeaponsText="Zombie Weapon Pickup?"
	  InfiniteAmmoText="Infinite Ammo?"
	  ZombieDamageModText="Zombie Dmg Mod"
	  HumanDamageModText="Human Dmg Mod"
	  AnyDeathInfectsText="Any Death Infects?"
	  
	  ZombieDamageMod=3.0,
	  HumanDamageMod=0.75,
	  
      ShowZombieIndicatorHelp="Whether to show an indicator (for all to see) of the zombies."
      ShowHumanIndicatorHelp="Whether to show an indicator (for all to see) of the humans."
      ShowSameTeamIndicatorsHelp="Whether to show an indicator for allies."
      MinimumZombiesHelp="Minimum number of zombies to start the game with"
      ZombieJumpModifierHelp="The multiplier for the zombies related to jumping. (3 = Jump Boots)"
      ZombieMovementMultiplierHelp="The multiplier for movement speed of the zombies."
	  HumansPickupWeaponsHelp="Whether humans can pick up weapons."
	  ZombiesPickupWeaponsHelp="Whether zombies can pick up weapons."
	  InfiniteAmmoHelp="Do weapons have infinite ammo?"
	  AnyDeathInfectsHelp="Does any human death cause them to become a zombie? (eg: suicide, trap on map, etc)"
	  ZombieDamageModHelp="The damage multiplier for zombies."
	  HumanDamageModHelp="The damage multiplier for humans."
	  
      FragHelp="The number of kills to win the game."
}
