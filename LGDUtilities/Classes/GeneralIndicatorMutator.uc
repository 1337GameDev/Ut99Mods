class GeneralIndicatorMutator extends HUDMutator config;
var bool InitiatedPreviously;

var float LastTimeChecked;
var float TimeIntervalToCheck;

var config bool ShowIndicatorsForTeammates;
var config bool ShowIndicatorsForEnemies;
var config bool ShowIndicatorsForObjectives;
var config bool OnlyShowObjectivesWithHighestPriority;
var config bool ShowIndicatorsForPowerWeapons;
var config bool ShowIndicatorsForAllWeapons;
var config bool ShowIndicatorsForAllWeaponsWhenHeld;
var config bool ShowIndicatorsForAllWeaponsWhenDropped;

var config bool ShowIndicatorsForPowerups;
var config bool ShowIndicatorsForHumansOnly;

//control labels
var config bool ShowTeamateLabels;
var config bool ShowEnemyLabels;
var config bool ShowObjectiveLabels;

var config bool ShowWeaponLabels;
var config bool ShowPowerupLabels;
var config bool ShowPowerupsWhenPickedUp;

var IndicatorHud IndicatorHudInstance;

function PreBeginPlay() {
    if(bLogToGameLogfile) {
        Log("GeneralIndicatorMutator: PreBeginPlay");
    }
}

simulated function ModifyPlayer(Pawn Other) {
   local Mutator m;
   local IndicatorHud ih;
   local PlayerPawn p;

   if (Other.IsA('TournamentPlayer') && (Other.PlayerReplicationInfo != None) ) {
       p = PlayerPawn(Other);
       if(P.myHud != None) {
           m = P.myHud.HUDMutator;
       }

       While(m != None) {
           if(m.IsA('IndicatorHud')) {
               ih = IndicatorHud(m);
               break;
           } else {
               m = m.NextHUDMutator;
           }
       }

       if(ih == None) {
           ih = class'LGDUtilities.IndicatorHud'.static.SpawnAndRegister(self);
           InitiatedPreviously = false;
       }

       IndicatorHudInstance = ih;

       //ensure player has been set up with the proper targets
       if(!InitiatedPreviously) {
           PlayerOwner = p;
           AddConfiguredTargets();
           InitiatedPreviously = true;
       }
   }

   if(NextMutator != None) {
        NextMutator.ModifyPlayer(Other);
   }
}

function Tick(float DeltaTime) {
    LastTimeChecked += DeltaTime;

    if(LastTimeChecked >= TimeIntervalToCheck){
       LastTimeChecked = 0.0;

       //execute check to ensure targets are still valid
       if(IndicatorHudInstance != None) {
           IndicatorHudInstance.ResetAllTargetsForSource(self);
           AddConfiguredTargets();
       }
    }
}

function AddConfiguredTargets() {
        local IndicatorHudTargetListElement listElement;
        local IndicatorSettings indicatorSettings;
        local TournamentPlayer tournamentPlayer;
        local Bot bot;
        local Weapon wep;
        local TournamentPickup pickup;
        local bool DoAddTargetIndicator, DoShowLabel, IsEnemy, HasNoTeam, IsPowerWeapon;
        local string LabelText;
        local color IndicatorColor;
        local byte BuiltinIndicatorTextureToUse;

        //objectives
        local int HighestPriority;
        local FortStandard fort;
        local FlagBase flagBase;
        local CTFFlag flag;
        local Pawn flagHolder;
        local ControlPoint point;

        //loop through every player
        if(ShowIndicatorsForTeammates || ShowIndicatorsForEnemies){
            ForEach AllActors(class'TournamentPlayer', tournamentPlayer) {
                DoAddTargetIndicator = false;
                DoShowLabel = false;
                BuiltinIndicatorTextureToUse = 59; //HUDIndicator_Texture_BuiltIn.HudIndicator_DownArrow_Solid

                if(tournamentPlayer != PlayerOwner) {
                    if((PlayerOwner.PlayerReplicationInfo != None) && (tournamentPlayer.PlayerReplicationInfo != None)) {
                        IsEnemy = PlayerOwner.PlayerReplicationInfo.TeamID != tournamentPlayer.PlayerReplicationInfo.TeamID;
                    }

                    if(ShowIndicatorsForTeammates && !IsEnemy){
                        DoAddTargetIndicator = true;
                        DoShowLabel = ShowTeamateLabels;
                        IndicatorColor = class'LGDUtilities.ColorHelper'.default.GreenColor;
                    } else if(ShowIndicatorsForEnemies && IsEnemy) {
                        DoAddTargetIndicator = true;
                        DoShowLabel = ShowEnemyLabels;
                        IndicatorColor = class'LGDUtilities.ColorHelper'.default.RedColor;
                    }

                    if(DoShowLabel){
                        LabelText = "Player";
                        if((tournamentPlayer.PlayerReplicationInfo != None) && (tournamentPlayer.PlayerReplicationInfo.PlayerName != "")) {
                            LabelText = tournamentPlayer.PlayerReplicationInfo.PlayerName;
                        }
                    }
                }

                if(DoAddTargetIndicator) {
                    listElement = new class'LGDUtilities.IndicatorHudTargetListElement';
					          listElement.IndicatorSource = self;
                    indicatorSettings = new class'LGDUtilities.IndicatorSettings';

                    listElement.Value = tournamentPlayer;
                    indicatorSettings.MaxViewDistance = 0;
                    indicatorSettings.UseCustomColor = true;
                    indicatorSettings.IndicatorColor = IndicatorColor;

                    indicatorSettings.ShowTargetDistanceLabels = false;
                    indicatorSettings.IndicatorLabel = LabelText;
                    indicatorSettings.ShowIndicatorLabel = DoShowLabel;
                    indicatorSettings.ShowIndicatorWhenOffScreen = false;
                    indicatorSettings.BlinkIndicator = false;
                    indicatorSettings.ShowIndicatorAboveTarget = true;
                    indicatorSettings.BuiltinIndicatorTexture = BuiltinIndicatorTextureToUse;
                    listElement.IndicatorSettings = indicatorSettings;

                    IndicatorHudInstance.AddAdvancedTarget(
                        listElement,
                        false
                    );
                }
            }


            //loop through each bot
            if(!ShowIndicatorsForHumansOnly){
                ForEach AllActors(class'Bot', bot) {
                    DoAddTargetIndicator = false;
                    DoShowLabel = false;
                    IndicatorColor = IndicatorHudInstance.default.IndicatorColor;
                    BuiltinIndicatorTextureToUse = 59; //HUDIndicator_Texture_BuiltIn.HudIndicator_DownArrow_Solid

                    if((PlayerOwner.PlayerReplicationInfo != None) && (bot.PlayerReplicationInfo != None)) {
                        IsEnemy = PlayerOwner.PlayerReplicationInfo.TeamID != bot.PlayerReplicationInfo.TeamID;
                    }

                    if(ShowIndicatorsForTeammates && !IsEnemy){
                        DoAddTargetIndicator = true;
                        DoShowLabel = ShowTeamateLabels;
                        IndicatorColor = class'LGDUtilities.ColorHelper'.default.GreenColor;
                    } else if(ShowIndicatorsForEnemies && IsEnemy) {
                        DoAddTargetIndicator = true;
                        DoShowLabel = ShowEnemyLabels;
                        IndicatorColor = class'LGDUtilities.ColorHelper'.default.RedColor;
                    }

                    if(DoShowLabel){
                        LabelText = string(bot.Name);
                    }

                    if(DoAddTargetIndicator){
                        listElement = new class'LGDUtilities.IndicatorHudTargetListElement';
						listElement.IndicatorSource = self;
                        indicatorSettings = new class'LGDUtilities.IndicatorSettings';

                        listElement.Value = bot;
                        indicatorSettings.MaxViewDistance = 0;
                        indicatorSettings.UseCustomColor = true;
                        indicatorSettings.IndicatorColor = IndicatorColor;
                        indicatorSettings.ShowTargetDistanceLabels = false;
                        indicatorSettings.IndicatorLabel = LabelText;
                        indicatorSettings.ShowIndicatorLabel = DoShowLabel;
                        indicatorSettings.ShowIndicatorWhenOffScreen = false;
                        indicatorSettings.BlinkIndicator = false;
                        indicatorSettings.ShowIndicatorAboveTarget = true;
                        indicatorSettings.BuiltinIndicatorTexture = BuiltinIndicatorTextureToUse;
                        listElement.IndicatorSettings = indicatorSettings;

						Log("GeneralIndicatorMutator - Adding bot - name:"$bot.Name);

                        IndicatorHudInstance.AddAdvancedTarget(
                            listElement,
                            false
                        );
                    }
                }
            }
        }

        if(ShowIndicatorsForObjectives) {
            DoShowLabel = ShowObjectiveLabels;

            //assault
            if(Level.Game.IsA('Assault')){
                HighestPriority = 0;
                if(OnlyShowObjectivesWithHighestPriority){
                    ForEach AllActors(class'FortStandard', fort) {
                        HighestPriority = Max(HighestPriority, int(fort.DefensePriority));
                    }
                }

                ForEach AllActors(class'FortStandard', fort) {
                    DoAddTargetIndicator = !OnlyShowObjectivesWithHighestPriority || (int(fort.DefensePriority) == HighestPriority);
                    LabelText = "";
                    IndicatorColor = IndicatorHudInstance.default.IndicatorColor;
                    BuiltinIndicatorTextureToUse = 13; //HUDIndicator_Texture_BuiltIn.HudIndicator_Diamond_Closed

                    if((PlayerOwner.PlayerReplicationInfo != None)) {
                        IsEnemy = PlayerOwner.PlayerReplicationInfo.Team != Assault(Level.Game).Defender.TeamIndex;
                        if(IsEnemy){
                            //attacker
                            BuiltinIndicatorTextureToUse = 40; //HUDIndicator_Texture_BuiltIn.HudIndicator_Target
                        } else {
                            BuiltinIndicatorTextureToUse = 38; //HUDIndicator_Texture_BuiltIn.HudIndicator_Shield
                        }
                    }

                    if(DoShowLabel){
                        //In some maps, the fort name is used in the completion messaged, and is composed of non UI friendly text
                        LabelText = class'LGDUtilities.AssaultHelper'.static.GetFriendlyFortName(fort);
                    }

                    if(DoAddTargetIndicator){
                        listElement = new class'LGDUtilities.IndicatorHudTargetListElement';
						listElement.IndicatorSource = self;
                        indicatorSettings = new class'LGDUtilities.IndicatorSettings';

                        listElement.Value = fort;
                        indicatorSettings.MaxViewDistance = 0;
                        indicatorSettings.UseCustomColor = true;
                        indicatorSettings.IndicatorColor = IndicatorColor;
                        indicatorSettings.ShowTargetDistanceLabels = false;
                        indicatorSettings.IndicatorLabel = LabelText;
                        indicatorSettings.ShowIndicatorLabel = DoShowLabel;
                        indicatorSettings.ShowIndicatorWhenOffScreen = false;
                        indicatorSettings.BlinkIndicator = fort.bFlashing;
                        indicatorSettings.ScaleIndicatorSizeToTarget = false;
                        indicatorSettings.BuiltinIndicatorTexture = BuiltinIndicatorTextureToUse;
                        listElement.IndicatorSettings = indicatorSettings;

                        IndicatorHudInstance.AddAdvancedTarget(
                            listElement,
                            false
                        );
                    }
                }
            }

			//ctf
            if(Level.Game.IsA('CTFGame')) {
				ForEach AllActors(class'FlagBase', flagBase) {
					DoAddTargetIndicator = true;//we want to add all flag bases -- but that could vary in the future
					LabelText = "";
					IndicatorColor = IndicatorHudInstance.default.IndicatorColor;
					BuiltinIndicatorTextureToUse = 31; //HUDIndicator_Texture_BuiltIn.HudIndicator_Home
					IsEnemy = false;

					if((PlayerOwner.PlayerReplicationInfo != None)) {
						IsEnemy = PlayerOwner.PlayerReplicationInfo.Team != flagBase.Team;
					}

					if(DoShowLabel){
						if(IsEnemy){
							LabelText = "Enemy Base";
						} else {
							LabelText = "Home Base";
						}
					}

					if(flagBase.Team == 0) {
						IndicatorColor = class'LGDUtilities.ColorHelper'.default.RedColor;//red team
					} else if(flagBase.Team == 1) {
						IndicatorColor = class'LGDUtilities.ColorHelper'.default.BlueColor;//blue team
					}

					if(DoAddTargetIndicator){
						listElement = new class'LGDUtilities.IndicatorHudTargetListElement';
						listElement.IndicatorSource = self;
						indicatorSettings = new class'LGDUtilities.IndicatorSettings';

						listElement.Value = flagBase;
						indicatorSettings.MaxViewDistance = 0;
						indicatorSettings.UseCustomColor = true;
						indicatorSettings.IndicatorColor = IndicatorColor;
						indicatorSettings.ShowTargetDistanceLabels = false;
						indicatorSettings.IndicatorLabel = LabelText;
						indicatorSettings.ShowIndicatorLabel = DoShowLabel;
						indicatorSettings.ShowIndicatorWhenOffScreen = false;
						indicatorSettings.ScaleIndicatorSizeToTarget = false;
						indicatorSettings.BuiltinIndicatorTexture = BuiltinIndicatorTextureToUse;
						listElement.IndicatorSettings = indicatorSettings;

						IndicatorHudInstance.AddAdvancedTarget(
							listElement,
							false
						);
					}
				}

				ForEach AllActors(class'CTFFlag', flag) {
					BuiltinIndicatorTextureToUse = 24; //HUDIndicator_Texture_BuiltIn.HudIndicator_Flag2
					//don't show the flag if it's at home
					flagHolder = None;
					if(flag.bHome) {
						continue;
					} else {
					   flagHolder = flag.Holder;
					}

					DoAddTargetIndicator = true;//we want to add all flags -- but this could vary in the future
					LabelText = "";
					IndicatorColor = IndicatorHudInstance.default.IndicatorColor;

					IsEnemy = false;

					if((PlayerOwner.PlayerReplicationInfo != None)) {
						IsEnemy = PlayerOwner.PlayerReplicationInfo.Team != flag.Team;
					}

					if(DoShowLabel){
						if(IsEnemy){
							LabelText = "Enemy Flag";
						} else {
							LabelText = "Our Flag";
						}
					}

					switch(flag.Team) {
						case 0:
							IndicatorColor = class'LGDUtilities.ColorHelper'.default.RedColor;//red team
							break;
						case 1:
							IndicatorColor = class'LGDUtilities.ColorHelper'.default.BlueColor;//blue team
							break;
						case 2:
							IndicatorColor = class'LGDUtilities.ColorHelper'.default.GreenColor;//green team
							break;
						case 3:
							IndicatorColor = class'LGDUtilities.ColorHelper'.default.GoldColor;//yellow team
							break;
					}

					if(DoAddTargetIndicator){
						listElement = new class'LGDUtilities.IndicatorHudTargetListElement';
						listElement.IndicatorSource = self;
						indicatorSettings = new class'LGDUtilities.IndicatorSettings';

						if(flag.bHome || flag.Holder == None) {
							listElement.Value = flag;
						} else {
						   listElement.Value = flagHolder;
						}

						indicatorSettings.MaxViewDistance = 0;
						indicatorSettings.UseCustomColor = true;
						indicatorSettings.IndicatorColor = IndicatorColor;
						indicatorSettings.ShowTargetDistanceLabels = false;
						indicatorSettings.IndicatorLabel = LabelText;
						indicatorSettings.ShowIndicatorLabel = DoShowLabel;
						indicatorSettings.ShowIndicatorWhenOffScreen = false;
						indicatorSettings.BlinkIndicator = true;
						indicatorSettings.BuiltinIndicatorTexture = BuiltinIndicatorTextureToUse;
						listElement.IndicatorSettings = indicatorSettings;

						IndicatorHudInstance.AddAdvancedTarget(
							listElement,
							false
						);
					}
				}
            }

            //domination
            if(Level.Game.IsA('Domination')) {
				ForEach AllActors(class'ControlPoint', point) {
					DoAddTargetIndicator = true;//we want to add all flags -- but this could vary in the future
					LabelText = "";
					IndicatorColor = IndicatorHudInstance.default.IndicatorColor;
					BuiltinIndicatorTextureToUse = 52; //HUDIndicator_Texture_BuiltIn.HudIndicator_Logo_NoTeam
					IsEnemy = true;

					IndicatorColor = class'LGDUtilities.ColorHelper'.default.GrayColor;//Grey - No Team - The default

					if(point.ControllingTeam != None) {
						switch(point.ControllingTeam.TeamIndex) {
							case 0:
								IndicatorColor = class'LGDUtilities.ColorHelper'.default.RedColor;//red team
								BuiltinIndicatorTextureToUse = 53; //HUDIndicator_Texture_BuiltIn.HudIndicator_Logo_RedTeam
								break;
							case 1:
								IndicatorColor = class'LGDUtilities.ColorHelper'.default.BlueColor;//blue team
								BuiltinIndicatorTextureToUse = 50; //HUDIndicator_Texture_BuiltIn.HudIndicator_Logo_BlueTeam
								break;
							case 2:
								IndicatorColor = class'LGDUtilities.ColorHelper'.default.GreenColor;//green team
								BuiltinIndicatorTextureToUse = 51; //HUDIndicator_Texture_BuiltIn.HudIndicator_Logo_GreenTeam
								break;
							case 3:
								IndicatorColor = class'LGDUtilities.ColorHelper'.default.GoldColor;//yellow team
								BuiltinIndicatorTextureToUse = 54; //HUDIndicator_Texture_BuiltIn.HudIndicator_Logo_YellowTeam
								break;
						}

						if((PlayerOwner.PlayerReplicationInfo != None)) {
							IsEnemy = PlayerOwner.PlayerReplicationInfo.Team != point.ControllingTeam.TeamIndex;
						}
					} else {
					   HasNoTeam = true;
					}

					if(DoShowLabel){
						if(IsEnemy){
							LabelText = "Capture "$point.PointName$"!";
						} else {
							LabelText = "Defend "$point.PointName$"!";
						}
					}

					if(DoAddTargetIndicator){
						listElement = new class'LGDUtilities.IndicatorHudTargetListElement';
						listElement.IndicatorSource = self;
						indicatorSettings = new class'LGDUtilities.IndicatorSettings';

						listElement.Value = point;
						indicatorSettings.MaxViewDistance = 0;
						indicatorSettings.UseCustomColor = true;
						indicatorSettings.IndicatorColor = IndicatorColor;
						indicatorSettings.ShowTargetDistanceLabels = true;
						indicatorSettings.IndicatorLabel = LabelText;
						indicatorSettings.ShowIndicatorLabel = DoShowLabel;
						indicatorSettings.ShowIndicatorWhenOffScreen = false;
						indicatorSettings.BlinkIndicator = IsEnemy;
						indicatorSettings.BuiltinIndicatorTexture = BuiltinIndicatorTextureToUse;
						listElement.IndicatorSettings = indicatorSettings;

						IndicatorHudInstance.AddAdvancedTarget(
							listElement,
							false
						);
					}
				}
            }
        }

        if(ShowIndicatorsForPowerWeapons || ShowIndicatorsForAllWeapons) {
            DoShowLabel = ShowWeaponLabels;

            ForEach AllActors(class'Weapon', wep) {
                DoAddTargetIndicator = false;
                IsPowerWeapon = false;
                LabelText = string(wep.Class);
                IndicatorColor = IndicatorHudInstance.default.IndicatorColor;
                BuiltinIndicatorTextureToUse = 10;//HUDIndicator_Texture_BuiltIn.HudIndicator_Enforcer;

                if(!wep.bHidden){
                    //regular power weapons
                    IsPowerWeapon = IsPowerWeapon || wep.IsA('WarHeadLauncher') || wep.IsA('SniperRifle');
                    //chaosUT power weapons
                    IsPowerWeapon = IsPowerWeapon || wep.IsA('ch_WarHeadLauncher') || wep.IsA('TurretLauncher') || wep.IsA('VortexArm') || wep.IsA('Sniper2');

                    if(ShowIndicatorsForAllWeapons) {
                        DoAddTargetIndicator = true;
                    } else if(IsPowerWeapon && ShowIndicatorsForPowerWeapons){
                        //show indicator?
                        DoAddTargetIndicator = true;
                    }

                    //show label?
                    if(DoShowLabel) {
                        //format weapon labels
                        LabelText = wep.ItemName;
                    }
                }

                if(DoAddTargetIndicator){
                    listElement = new class'LGDUtilities.IndicatorHudTargetListElement';
					listElement.IndicatorSource = self;
                    indicatorSettings = new class'LGDUtilities.IndicatorSettings';

                    listElement.Value = wep;
                    indicatorSettings.MaxViewDistance = 1000;
                    indicatorSettings.UseCustomColor = true;
                    indicatorSettings.IndicatorColor = IndicatorColor;
                    indicatorSettings.ShowTargetDistanceLabels = false;
                    indicatorSettings.IndicatorLabel = LabelText;
                    indicatorSettings.ShowIndicatorLabel = DoShowLabel;
                    indicatorSettings.ShowIndicatorWhenOffScreen = false;
                    indicatorSettings.ShowIndicatorIfInventoryHeld = ShowIndicatorsForAllWeaponsWhenHeld;
                    indicatorSettings.ShowIndicatorIfInventoryNotHeld = true;
                    indicatorSettings.ShowIndicatorIfInventoryDropped = ShowIndicatorsForAllWeaponsWhenDropped;
                    indicatorSettings.ShowIndicatorsThatAreObscured = false;
                    indicatorSettings.BaseAlphaValue = 0.4;
                    indicatorSettings.ScaleIndicatorSizeToTarget = false;
                    indicatorSettings.BuiltinIndicatorTexture = BuiltinIndicatorTextureToUse;
                    listElement.IndicatorSettings = indicatorSettings;

                    IndicatorHudInstance.AddAdvancedTarget(
                        listElement,
                        false
                    );
                }
            }
        }

        if(ShowIndicatorsForPowerups) {
           DoShowLabel = ShowPowerupLabels;

           ForEach AllActors(class'TournamentPickup', pickup) {
                if(pickup.bCarriedItem || pickup.bActive || pickup.bHeldItem || pickup.bHidden || pickup.bTossedOut) {
                    continue;
                }

                DoAddTargetIndicator = false;
                IndicatorColor = IndicatorHudInstance.default.IndicatorColor;
                BuiltinIndicatorTextureToUse = 1;//HUDIndicator_Texture_BuiltIn.HudIndicator_Bolt;
                LabelText = string(pickup.Class);

                if(pickup.IsA('RelicInventory') || pickup.IsA('UDamage') || pickup.IsA('UT_Invisibility') || pickup.IsA('UT_JumpBoots') || pickup.IsA('UT_ShieldBelt') || pickup.IsA('SCUBAGear') || pickup.IsA('UT_Stealth') || pickup.IsA('HealthPack') || pickup.IsA('GravBelt')){
                   DoAddTargetIndicator = true;
                }

                if(DoShowLabel) {
                    if(pickup.IsA('RelicInventory')){
                        LabelText = class'LGDUtilities.InventoryHelper'.static.GetNiceRelicName(pickup);
                    } else {
                        LabelText = pickup.ItemName;
                    }
                } else {
                    LabelText = "";
                }

                if(DoAddTargetIndicator){
                    listElement = new class'LGDUtilities.IndicatorHudTargetListElement';
					listElement.IndicatorSource = self;
                    indicatorSettings = new class'LGDUtilities.IndicatorSettings';

                    listElement.Value = pickup;
                    indicatorSettings.MaxViewDistance = 0;
                    indicatorSettings.UseCustomColor = true;
                    indicatorSettings.IndicatorColor = IndicatorColor;
                    indicatorSettings.ShowTargetDistanceLabels = false;
                    indicatorSettings.IndicatorLabel = LabelText;
                    indicatorSettings.ShowIndicatorLabel = DoShowLabel;
                    indicatorSettings.ShowIndicatorWhenOffScreen = false;
                    indicatorSettings.ShowIndicatorIfInventoryHeld = ShowPowerupsWhenPickedUp;
                    indicatorSettings.ShowIndicatorIfInventoryNotHeld = true;
                    indicatorSettings.BaseAlphaValue = 0.4;
                    indicatorSettings.ScaleIndicatorSizeToTarget = false;
                    indicatorSettings.BuiltinIndicatorTexture = BuiltinIndicatorTextureToUse;
                    listElement.IndicatorSettings = indicatorSettings;

                    IndicatorHudInstance.AddAdvancedTarget(
                        listElement,
                        false
                    );
                }
            }
        }
}

defaultproperties {
      InitiatedPreviously=False
      LastTimeChecked=0.000000
      TimeIntervalToCheck=1.0000
      ShowIndicatorsForTeammates=True
      ShowIndicatorsForEnemies=True
      ShowIndicatorsForObjectives=True
      OnlyShowObjectivesWithHighestPriority=True
      ShowIndicatorsForPowerWeapons=True
      ShowIndicatorsForAllWeapons=True
      ShowIndicatorsForAllWeaponsWhenHeld=True
      ShowIndicatorsForAllWeaponsWhenDropped=True
      ShowIndicatorsForPowerups=True
      ShowIndicatorsForHumansOnly=False
      ShowTeamateLabels=True
      ShowEnemyLabels=True
      ShowObjectiveLabels=True
      ShowWeaponLabels=True
      ShowPowerupLabels=True
      ShowPowerupsWhenPickedUp=False
      IndicatorHudInstance=None
}
