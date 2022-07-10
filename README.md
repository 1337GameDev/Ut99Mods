# <img src="https://github.com/1337GameDev/Ut99Mods/blob/main/Github/Icons/ut_logo.png?raw=true" width="100" height="100" title="Ut99 Logo" alt="Ut99 Logo" height="35px" width="35px"> Ut99Mods <img src="https://github.com/1337GameDev/Ut99Mods/blob/main/Github/Icons/ut_logo.png?raw=true" width="100" height="100" title="Ut99 Logo" alt="Ut99 Logo" height="35px" width="35px">
A collection of my hand-made mods for one of my my favorite games - Unreal Tournament '99!

# Setup :wrench:
To compile, navigate to the ut99 directory with UCC.exe and run `ucc make`.

**Alternatively**

You can set up "doskey" to have macro commands in CMD.
Modify macros.doskey to point to your ut99 directories.

Copy macros.doskey file to a location on C:

Run this:

    reg add "HKCU\Software\Microsoft\Command Processor" /v Autorun /d "doskey /macrofile=\"C:\[doskey file location]\macros.doskey\"" /f

This will force the doskey script to run on every instance of cmd.

Verify in CMD using:

    reg query "HKCU\Software\Microsoft\Command Processor" /v Autorun

**Then**

Add the relevant packages to your **UnrealTournament.ini** in the Ut99/System folder.

Look for the `[Editor.EditorEngine]` section, and the EditPackages entries.

Add the following to the end of them (order matters):

    EditPackages=LGDUtilities
    EditPackages=HaloAnnouncer
    EditPackages=HeadHunter
    EditPackages=Gibber
    EditPackages=ItemSpawnerWeapon
    EditPackages=C4
    EditPackages=Juggernaut
    EditPackages=EnergySword
    EditPackages=Infection
    EditPackages=GuidedEnergyLance

# Useage :video_game:

To merely use the pre-compiled packages and copy the following files:

1. Ut99Mods/System/**.u** and **.int** files to your Ut99/System directory.
2. Ut99Mods/Sounds/**HaloAnnouncer.uax** to your Ut99/Sounds folder
3. Ut99Mods/Maps/**1HH-TestBox-Large.unr** to your Ut99/Maps folder (a demo map)

Then load up the game, and look at the relevant test map, as well as the included mutators.

To use them in your own custom maps, they need to be in **EditPackages** or loaded manually in the editor (or embedded into the map using MyLevel).

Below are sections for various objects, and extra information on them / their usage.

# Extra Documentation :page_facing_up:

<details>
  <summary>Weapons</summary>

  <details>
    <summary>C4 (Weapon)</summary>
    A placeable/throwable explosive weapon with a digital timer that can be changed via secondary fire.

    ## Inventory group: 0 (same as `BotPack.Translocator`)
    <details>
      <summary>Usage</summary>
      1. Primary Fire
        * Does different things based on if you're close to what is being aimed at
        * If **CLOSE** to a wall / actor (with collider), then you can place the C4 (instead of throwing)
        * There is a "ghost" of the C4 of where it'll be placed
        * If **FAR** from a target, the C4 will be thrown and attach to a surface / actor it collides with
        * After placing / landing from a throw, it'll start counting down from the selected time and then explode
      2. Secondary Fire
        * Increments the timer by `C4Weapon.TimerIncrementAmount` (defaults to 10 seconds)
        * The timer value rolls over once `C4Weapon.MaxTimerSeconds` is exceeded
    </details>

    <details>
      <summary>Special Interactions</summary>
      1. Damage type names defined in `C4Proj.DamageTypesToDisarm[]` will disarm the C4 (timer turns off and C4 won't explode)
        * Defaults damage type names: `impact`, `claw`, `cut`, `SpecialDamage`, `slashed`, `Decapitated`, `Corroded`, `Burned`, and `shredded`
      2. C4 will attach to Pawns (but the explosion doesn't follow, so a Pawn can avoid damage if they are moving fast enough)
      3. Explosions, bullets, and other damage inducers will detonate the C4.
      4. The C4 will blink and make noises during countdown
      5. Bots can detect the C4 via a `C4Fear` if they get close enough
    </details>

    <details>
      <summary>Mutators</summary>
      1. C4GiveWeaponMutator
        * Gives each spawning **PLAYER** (Bots won't get one) a C4 to spawn with (sorry, creating new AI behaviors for this weapon is very complicated and could have taken a very long time to test and tweak)
    </details>

    <details>
      <summary>Extra Details</summary>
      1. Created using MilkShape3D with a basic model and different groups for the timer components
        * Timer has a different model group (and texture) for each digit and the ":" separator.
        * Code will update the timer, and then modify each model group's texture for each digit out of the 0-9 digit textures (or a texture the same color as the timer background)
        * Considered having a similar rendered texture to the UT_Eightball ammo counter (via `UT_Eightball.RenderOverlays()`), but that can ONLY be instanced ONCE per camera (and multiple C4 instances would all have the same timer value displayed)
    </details>
  </details>

  <details>
    <summary>The Gibber (Weapon)</summary>
    A weapon that is based around the PulseGun, but instead shoots gibs in a machine gun style or a shotgun shot. Shooting hurts the wielder (if that feature is enabled), and collecting your own gibs will heal you a fraction of the health lost.

    ## Inventory group: 5 (replaces `BotPack.PulseGun`)

    <details>
      <summary>Usage</summary>
      1. Primary Fire
        * Fires a random gib as a projectile, and possibly hurts the wielder
        * The wielder is hurt based on `Gibber.DoesFiringHurtOwner` variable
        * The wielder loses health (if `Gibber.DoesFiringHurtOwner` is **TRUE**) according `Gibber.PrimaryFireHealthCost`'s value (defaults to 2)
      2. Secondary Fire
        * Requires the user to **HOLD** the alt-fire button, for a number of seconds defined by `Gibber.AltFireTriggerHoldTime`
        * After holding, the firing mode is "charged"
        * When the wielder releases the alt-fire button a shotgun blast of 6 gibs are shot
        * The wielder loses health (if `Gibber.DoesFiringHurtOwner` is **TRUE**) according `Gibber.AltFireHealthCost`'s value (defaults to 12)
        * There is then a delay of a number of seconds (defined buy `Gibber.AltFireDelay`), before the alt-fire can be used (to prevent the weapon from being over-powered and spammed)
    </details>

    <details>
      <summary>Healing</summary>
      1. Collecting gibs will heal players (as defined by the `Gibber.BaseGibDamage` and `Gibber.BaseGibHealMultiplier`) (defaults to 10 and 0.1 respectively -- 10 damage and 10% of the gib damage as health returned)
      2. Gib damage can vary if it's a boss, big or small gib (and damage is scaled by `Gibber.BossGibDamageMultiplier` and `Gibber.SmallGibDamageMultiplier` -- with defaults of 1.5 and 0.8 respectively -- and increase of 50% and reduction of 20% from base damage)
      3. Gibs from an alt-fire shotgun blast deal extra damage based on being close enough to the target, defined by `Gibber.ExtraDamageMultiplier` and `Gibber.DistanceThresholdToAddExtraDamage` (with defaults of 10 and 300 -- if enemy is within 300 unreal units they take 10x damage from these gibs)
      4. The extra damage is **NOT** used in the calculation for how much to heal (the idea was to base it off of the damage the wielder took when firing)
      5. UDamage multiplier does **NOT** affect health lost or healing gained
    </details>

    <details>
      <summary>Special Interactions</summary>
      1. You can still pick up the gibs to heal yourself, even if you're not allowed to pickup weapons or other pickups
      2. The gibs handle damage the same as the root gibs, and can exist in danger areas -- to lure players to try and heal
    </details>

    <details>
      <summary>Mutators</summary>
      1. GibberWeaponReplaceMutator
        * Replaces the normal `BotPack.PulseGun` on the map with the Gibber.
        * Also removes the ammo `BotpPack.PAmmo` from the map
      2. GibberArena
        * An **ARENA** mutator that has every player/bot wield The Gibber
    </details>

    <details>
      <summary>Extra Details</summary>
        1. The gib projectiles are created from the gibs defined in BotPack -- original gib classes are subclasses of `BotPack.UTPlayerChunks`
        2. After subclassing, the default properties were overridden:
          * `RemoteRole=ROLE_SimulatedProxy`
          * `LifeSpan=240.000000`
          * `bCollideActors=True`
        3. Then the method `Landed()` was changed to allowed collisions with other actors (as original gibs are essentially decoration-only)
        4. The usage of `LGDUtilities.PawnHelper.PredictDamageToPawn` is used to predict if the damage dealt to a pawn (taking into account armor, reductions, multipliers, etc) would exceed it's health, to determine if the target is **GIBBED**
        5. The weapon has a **custom skin** that is based off the base `BotPack.PulseGun` skin, but blood splatter added
    </details>
  </details>

  <details>
    <summary>Guided Energy Lance (Weapon)</summary>
    An heavy energy-based weapon that shoot projectiles that can be fired in "dumb-fire" or "guided" mode, that can bounce and explode on collision with targets.
    ## Inventory group: 9 (replaces `BotPack.UT_Eightball`)

    <details>
      <summary>Usage</summary>
      1. Primary Fire
        * When this weapon is in a normal firing mode, it shoots energy balls that bounce and explode after hitting an Actor with a collider or a wall (after bouncing a number of times defined by `GuidedEnergyLance.MaxWallHits` -- which defaults to 1)
        * When this weapon is in guiding mode, it shoots energy balls that follow the cursor (max lifetime of 20 seconds)
        * Not instant for the change in projectile direction, but enough to use further away from the target
      2. Secondary Fire
        * When held for a number of seconds (defined by `GuidedEnergyLance.AltRefireRate` -- which defaults to 0.5 seconds) the weapon is set to "guiding mode"
        * The player view is slightly zoomed in to help with the guiding process
        * Also used to coerce the usage of this weapon to be for more long-range encounters
        * AI / Bots don't use the alt-fire mode (sorry, creating new AI behaviors for this weapon is very complicated and could have taken a very long time to test and tweak) -- they use similar firing attitudes as the `BotPack.UT_FlakCannon` alt-fire mode
    </details>

    <details>
      <summary>Mutators</summary>
      1. GuidedEnergyLanceWeaponReplaceMutator
        * Replaces the normal `BotPack.UT_Eightball` on the map with this weapon.
    </details>

    <details>
      <summary>Extra Details</summary>
      1. The weapon was in spired by Halo Infinite's "Cindershot" hardlight grenade-launcher-type weapon
      2. The ammo counter rendering color was changed from **RED** to RGB(199,36,177), a **PURPLE**
      3. The projectile damage type is `jolted`
      4. To achieve the "zoom" effect, the player `DesiredFOV` variable is set to 50.
    </details>
  </details>

  <details>
    <summary>ItemSpawnerWeapon (Weapon)</summary>
    A utility weapon used for testing or fun / random purposes to spawn other Actors.

    ## Inventory group: 0

    <details>
      <summary>Usage</summary>
      1. Primary Fire
        * Spawns the selected object at the given position of the "placement ghost"
        * Uses **DEFAULT** values for spawned actors (most of the time isn't a problem, but some Actors -- such as `BotPack.Bot` expect setup such as team / skins -- but they still work fine, just look odd)
      2. Secondary Fire
        * Selects the next Actor from the `ItemSpawnerWeapon.ItemsToSpawn` array
        * If the object fails to spawn, a message is displayed (Actors with defaults for `bStatic` and `bNoDelete` as **TRUE** cannot be spawned)
        * The array can be populated via **CONFIG** entries in it's generated **INI**
        * A few defaults exist, as examples:
          * `LGDUtilities.PracticeBot`
          * `Botpack.TMale2Bot`
          * `Botpack.TFemale1Bot`
          * `UnrealShare.Chest`
          * `UnrealShare.Candle`
          * `Botpack.Armor2`
          * `Botpack.UT_FlakCannon`
          * `UnrealShare.TorchFlame`
          * `Class'ChaosUT.ch_WarHeadLauncher`
          * `UnrealShare.DispersionPistol`
    </details>

    <details>
      <summary>Mutators</summary>
      1. ItemSpawnerWeaponGiveMutator
        * Gives **PLAYERS** this weapon (be careful, as this weapon is an admin-weapon meant for testing)
        * AI / `BotPack.Bot` cannot be given this weapon or pick it up (if they are given this weapon, it'll destroy itself)
    </details>
  </details>

  <details>
    <summary>WeaponStealingShockRifle (Weapon)</summary>
    A special shock rifle that shoots energy orbs (modeled after the alt-fire of the shock rifle), or a primary fire beam that **STEALS** the targets currently selected weapon.

    ## Inventory group: 0

    <details>
      <summary>Usage</summary>
      1. Primary Fire
        * Fires a shock beam that when hitting a target, will steal the current hit target's weapon.
      2. Secondary Fire
        * Fires a ricochet energy ball, similar to the normal fire of the shock rifle, but this will bounce off walls a number of times defined by `RicochetShockProj.MaxWallHits` (which defaults to 2)
    </details>

    <details>
      <summary>Mutators</summary>
      1. ItemSpawnerWeaponGiveMutator
        * Replaces the normal `BotPack.ShockRifle` on the map with this weapon.
    </details>
  </details>

</details>

<details>
  <summary>Gametypes</summary>

  <details>
    <summary>HeadHunter (Gametype)</summary>

    <details>
      <summary>Custom Map Actors</summary>
        1. SkullItem
          * A flaming skull item used for scoring in HeadHunter
    </details>

    <details>
      <summary>Game Options</summary>
        1. ShowDroppedSkullIndicators
          * Whether to show indicators for dropped skulls. Defaults to **TRUE**
        2. ShowPlayersWithSkullThreshold
          * Whether to show indicators for players with a number of skulls (defined by `HeadHunter.SkullThresholdToShowPlayers`) greater than this. Defaults to **TRUE**
        3. SkullThresholdToShowPlayers
          * The number of skulls to show indicators for players. Defaults to **4**
        4. SkullCarryLimit
          * The number of skulls a player is allowed to carry at once. defaults to **10**
        5. SkullCollectInterval
          * The number of seconds between each skull collection (players score points for skulls they are carrying and then **ALL** skulls are removed / destroyed)
          * Defaults to **180** (3 Minutes)
    </details>

    <details>
      <summary>Extra Details</summary>
      1. Created as a clone of the Halo Reach "Headhunter" game mode.
      2. The skulls are 2 Actors -- a skull actor, and a flame mesh actor that is following the skull.
      3. The flame will rotate around the skull, **OPPOSITE** the velocity of the skull to simulate real flame.
      4. When a skull is stationary, it's a **PICKUP**, but when it needs to "fly out of a killed enemy" a **PROJECTILE** is spawned, so gravity can affect it, and once it lands is swapped with the pickup object.
    </details>
  </details>

  <details>
    <summary>Juggernaut (Gametype)</summary>
    A gametype modeled after the Halo juggernaut gametype. A person is randomly selected to be the juggernaut, a powerful player with regenerating shields and health. Whomever kills the juggernaut becomes the new juggernaut.

    <details>
      <summary>Game Options</summary>
        1. RegenSeconds
          * The number of seconds between each regeneration of the juggernaut
          * Defaults to **5**
        2. ShieldRegenRate
          * The amount of shield points to replenish per regeneration
          * Defaults to **10**
        3. HealthRegenRate
          * The amount of health points to replenish per regeneration
          * Defaults to **10**
        4. ShowJuggernautIndicator
          * Whether to show an indicator to all players of the juggernaut
          * Defaults to **TRUE**
        5. OnlyCountKillsAsJuggernaut
          * Whether kills **ONLY** count when somebody is the juggernaut
          * Defaults to **FALSE**
        6. JugJumpModifier
          * Sets a multiplier for the juggernaut jump height (can be a decimal, including 0)
          * `Botpack.UT_Jumpboots` have a multiplier of 3 (just so you can gauge how much this affects
          * Defaults to **3**
        7. JugMovementMultiplier
          * Sets a multiplier for the juggernaut movement speed (can be a decimal, including 0)
          * Defaults to **3**
    </details>

    <details>
      <summary>Extra Details</summary>
      1. The juggernaut is accomplished via a special inventory item `JuggernautBelt`
        * It will add a special subclass of `BotPack.UT_ShieldBelt` to the player called `JuggernautShieldBelt` (that doesn't generate the shield effect)
        * The `JuggernautBelt` will generate the shield effect itself
    </details>
  </details>

  <details>
    <summary>Infection (Gametype)</summary>
    Modeled after the Halo infection gametype. A minimum number of zombies are selected to begin the game (configurable) and their goal is to kill and infect every human. Humans are to kill a set amount of zombies, or survive until the timer runs out. The game ends if all humans are infected, humans reach a goal amount of kills or survive the timer countdown.

    <details>
      <summary>Weapons</summary>
      1. Headshot Enforcer
        * Inventory group: 2 (Meant to replaces `BotPack.Enforcer` -- but both **CAN** exist at the same time in a player's inventory)
        * A `BotPack.Enforcer` that is capable of headshots, and starts with 60 rounds instead of the normal 30
      2. Primary Shot Only Flak Cannon
        * Inventory group: 8 (Meant to replace `BotPack.UT_FlakCannon` -- but both **CAN** exist at the same time in a player's inventory)
        * A `BotPack.UT_FlakCannon` that can ONLY fire the primary firing mode (no flak grenade) and starts with 30 rounds instead of the normal 10
    </details>

    <details>
      <summary>Custom Map Actors</summary>
      1. Infection Player Start
        * Subclass of `Engine.PlayerStart`
        * Has its own custom UnrealEditor Actor icon, based on PlayerStart with a bio icon.
        * Can be used to specify where humans and zombies start for Infection
        * If not used in a map, normal player start logic is used
        * If placed on a map, and at least 1 viable for when a human/zombie is looking for a start location, the InfectionPlayerStart will be used instead.
      2. Infection Spawn Point
        * Subclass of `UnrealShare.Spawnpoint`
        * Has its own custom UnrealEditor Actor icon, based on Spawnpoint with a bio icon.
        * Can be used to specify where humans and zombies spawn for Infection
        * If not used in a map, normal player spawn logic is used
        * If placed on a map, and at least 1 viable for when a human/zombie is looking for a spawn location, the InfectionSpawnPoint will be used instead.
    </details>

    <details>
      <summary>Game Options</summary>
      1. MinimumZombies
        * Sets the minimum number of zombies that should exist at any point during the match
        * If a zombie player leaves, the gametype will ensure this value is honored and selects a new human to become a zombie randomly (sorry to the human that's unlucky here!)
        * If not enough zombies can exist, then all humans will become zombies, and the game ends (zombies win)
      2. ShowZombieIndicators
        * Sets whether HUD indicators for zombies should be shown for humans
        * If true, zombies will have a red triangle above their heads (visible through walls)
      3. ShowHumanIndicators
        * Sets whether HUD indicators for humans should be shown for zombies
        * If true, humans will have a red triangle above their heads (visible through walls)
      4. ZombieMovementModifier
        * Sets a multiplier for the zombie movement speed (can be a decimal, including 0)
      5. ZombieJumpModifier
        * Sets a multiplier for the zombie jump height (can be a decimal, including 0)
        * `Botpack.UT_Jumpboots` have a multiplier of 3 (just so you can gauge how much this affects jumping)
      5. ZombieDamageMod
        * Sets a multiplier for the zombie damage done by weapons (can be a decimal, including 0)
        * `Botpack.UDamage` have a multiplier of 3 (just so you can gauge how much this affects damage)
      6. HumanDamageMod
        * Sets a multiplier for the human damage done by weapons (can be a decimal, including 0)
        * `Botpack.UDamage` have a multiplier of 3 (just so you can gauge how much this affects damage)
      7. HumansPickupWeapons
        * Whether humans are allowed to pickup items on the map
        * bWeaponStay and bMultiWeaponStay can still override this and disable pickups (for humans AND zombies)
      8. ZombiesPickupWeapons
        * Whether zombies are allowed to pickup items on the map
        * bWeaponStay and bMultiWeaponStay can still override this and disable pickups (for humans AND zombies)
      9. InfiniteAmmo
        * Whether weapons have infinite ammo or not
        * This is done via setting every pawn weapon's `PickupAmmoCount` to be 999 and resetting the current ammo amount every second via `InfectionGameInfo.Timer()`
        * This applies to all weapons, including ones not selected / able to be selected (so some mods could have odd side effects if they rely on hidden weapons and ammo)
      10. AnyDeathInfects
        * This determines whether ANY death of a human will cause them to become a zombie
        * This is mainly used to include deaths via falling out of bounds, lava, being crushed, map traps (such as `DM-Pressure`, `DM-Conveyer`, `DM-Cybrosis][`, `DM-Fractal`, `DM-HealPod][`, `DM-Mojo][`, etc)
        * This relies on `ScoreKill(Pawn Killer, Pawn Other)` and uses the logic of `IsSuicide = (Killer == Other) || (Killer == None);` to determine a suicide / suicide-like death (as Killer is the pawn killed or is None)
    </details>
  </details>

</details>
<details>
  <summary>Extra Mutators</summary>

  <details>
    <summary>Fiesta Map Weapons</summary>
    This mutator will replace weapons on the map with random ones.

    This relies on `LGDUtilities.ServerHelper.GetAllWeaponClasses` to fetch a list of weapons, and returns a LinkedList.
  </details>

  <details>
    <summary>Fiesta Player Weapons</summary>
    This mutator will make players spawn with a random weapon every time they respawn.

    This relies on `LGDUtilities.ServerHelper.GetAllWeaponClasses` to fetch a list of weapons, and returns a LinkedList.
  </details>

  <details>
    <summary>General Indicator Mutator</summary>
    This mutator will add indicators for players, weapons, power weapons, objectives, etc.

    This can be configured via the `GeneralIndicatorMutator.ini` that will be generated when starting a game with this mutator in its default state for the first time.

    <details>
      <summary>Mutator INI Options</summary>

      1. ShowIndicatorsForTeammates
        * Determines whether indicators should be shown for other members of your team (so you can keep track of them on the map)
        * Defaults to **TRUE**
      2. ShowIndicatorsForEnemies
        * Determines whether indicators should be shown for enemy players
        * Defaults to **TRUE**
      3. ShowIndicatorsForHumansOnly
        * Determines if indicators for players should be limited to **ONLY PLAYERS**
        * Defaults to **FALSE**
      4. ShowIndicatorsForObjectives
        * Determines whether indicators should be shown for gametype objectives (EG: assault targets, levers, domination points, flags, etc)
        * Defaults to **TRUE**
      5. OnlyShowObjectivesWithHighestPriority
        * Determines if **ONLY** the highest priority objective should be shown -- EG: During an assault, **ONLY** show the current target, instead of all of them.
        * Defaults to **TRUE**
      6. ShowObjectiveLabels
        * Whether to show objective labels, along with the indicator (such as the objective goal, name, location, etc)
        * Defaults to **TRUE**
      7. ShowIndicatorsForAllWeapons
        * Determines if ALL weapons, regardless of settings for power weapons, being held, etc should be shown
        * Defaults to **TRUE**
      8. ShowIndicatorsForPowerWeapons
        * Whether to show indicators for power weapons on the map
        * Defaults to **TRUE**
      9. ShowIndicatorsForAllWeaponsWhenHeld
        * Whether to show indicators for weapons when they are held by players
        * Defaults to **TRUE**
      10. ShowIndicatorsForAllWeaponsWhenDropped
        * Whether to show indicators for weapons when they are dropped by players
        * Defaults to **TRUE**
      11. ShowWeaponLabels
        * Whether to show labels for weapons along with their indicator
        * Defaults to **TRUE**
      12. ShowIndicatorsForPowerups
        * Whether to show indicators for power-ups on the map (EG: ChaosUT relics, GravBoots, ShieldBelt, UDamage, Invisbility, JumpBoots, HealthPack, etc)
        * Defaults to **TRUE**
      13. ShowPowerupsWhenPickedUp
        * Whether to show power-ups that have been picked up (showing where they will respawn)
        * Defaults to **FALSE**
      14. ShowPowerupLabels
        * Whether to show labels for power-ups, along with their indicators
        * Defaults to **TRUE**
      15. ShowTeamateLabels
        * Whether to show labels for team members (defaults the label to their name)
        * Defaults to **TRUE**
      16. ShowEnemyLabels
        * Whether to show labels for enemies (defaults the label to their name)
        * Defaults to **TRUE**
    </details>
  </details>

  <details>
    <summary>Player Death Location Mutator</summary>
    This mutator will enable an X indicator where a player dies.

    <details>
      <summary>Mutator INI Options</summary>
      1. ShowAllyIndicators
        * Whether to show the death indicator for allies
        * Defaults to **TRUE**
      2. ShowEnemyIndicators
        * Whether to show the death indicator for enemies
        * Defaults to **FALSE**
      3. ShowNeutralIndicators
        * Whether to show the death indicator for neutral players
        * Defaults to **FALSE**
    </details>
  </details>

  <details>
    <summary>Radar HUD Mutator</summary>
    Shows a radar element on the HUD, that shows allies / enemies.

    <details>
      <summary>Mutator INI Options</summary>
      1. RadarDistanceMeters
        * The range of the radar, in **METERS**
        * Defaults to **30**
      2. RadarAlpha
        * The alpha transparency of the radar on the HUD
        * Defaults to **0.4**
      3. RadarCenterDotColor
        * The color of the central dot on the radar
        * Defaults to **RGBA(0,0,0,0)**
      4. RadarGUICircleRadius
        * The radius of the hud circle on the HUD, in **pixels**
        * Defaults to **110**
      5. RadarGUICircleOffsetX
        * The X position offset (from the center of the GUI texture) for the **center** of the radar display
        * Defaults to **0**
      6. RadarGUICircleOffsetY
        * The Y position offset (from the center of the GUI texture) for the **center** of the radar display
        * Defaults to **0**
      7. RadarBlipSize
        * The size of the blips on the radar, in **pixels**
        * Defaults to **15**
      8. ShowAlliesAndEnemiesAsDifferentColors
        * Whether to show allies and enemies with different colored blips
        * Defaults to **TRUE**
      9. RadarHudGuiWidth
        * The width of the entire background of the radar on the HUD, in **pixels**
        * Defaults to **150**
      10. InitiallyPositionAbovePlayerHUDOnLowerLeft
        * Whether to default the position of the radar on the player HUD over the lower left part of the existing HUD (where to calculate position when factoring in offsets)
        * Defaults to **TRUE**
      11. RadarHUDOffsetX
        * The X position offset of the **entire** radar on the HUD
        * Defaults to **0**
      12. RadarHUDOffsetY
        * The Y position offset of the **entire** radar on the HUD
        * Defaults to **0**
      13. RadarVelocityThreshold
        * The velocity magnitude a player has to be moving to show up on the radar, in **unreal units**
        * Defaults to **200** (120 is crouch, and 400 is running for unreal player movement speed defaults)
      14. RadarSameLevelThreshold
        * The threshold a player has to be, vertically, in **unreal units**, to be considered to be on the same level as the radar owner
        * Defaults to **83** (a player is 78 unreal units tall, and can jump 64->72 unreal units)
      15. ShowTargetsIfBelowVelocityThreshold
        * Whether to show targets if they are below the velocity magnitude threshold defined by `RadarVelocityThreshold`
        * Defaults to **FALSE**
      16. ShowTargetsIfCrouching
        * Whether to show targets on radar if they are crouching
        * Defaults to **FALSE**
      17. IndicateTargetOnDifferentLevel
        * Whether to change the blip icon if the target is considered on another level (as defined by `RadarSameLevelThreshold`).
        * The blip texture changes to a "hollow circle" when targets are considered on different levels
        * Defaults to **TRUE**
    </details>
  </details>

</details>

<details>
  <summary>Utility Classes</summary>
  The namespace `LGDUtilities` is used for various helper / utility classes, designed for scripting or adding to maps as actors.

  <details>
    <summary>Scripting Classes</summary>

    <details>
      <summary>ActorHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.ActorHelper'.static.functionName();`

      ## Available Functions
        1. getNetSafeVal(Actor actor, string prop);
          * Returns **string**
          * Get a value from the given actor parameter `actor` and get the property denoted by the parameter `prop` in a network reliable manner (forces the actor to a network authority to get the replicated value)
        2. FindActor(Actor context, name ActorName, optional name ActorTag);
          * Returns **Actor**
          * Finds an actor with the given tag AND name
        3. FindAllActorsByTag(Actor context, name ActorTag);
          * Returns **LGDUtilities.LinkedList**
          * Gets a LinkedList of all actors that match the given tag
        4. HSize(Vector aVec);
          * Returns **float**
          * Gets the **horizontal* size of a given vector (essentially removes the vertical Z component)
        5. InCylinder(Vector aVec, float R, float H);
          * Returns **bool**
          * Returns if the given vector falls within the cylinder given by the height (parameter `H`) and radius (parameter `R`) assuming the cylinder is center at the vector origin
        6. ActorsTouching(Actor A, Actor B);
          * Returns **bool**
          * Returns if 2 given actors are considering touching, based on colliders
        7. ActorsTouchingExt(Actor A, Actor B, float ExtraR, float ExtraH);
          * Returns **bool**
          * Returns if 2 given actors are considering touching, based on colliders
          * Also allows extra radius / height to allow variance in collision checks
        8. AnnounceAll(Actor Broadcaster, string Msg);
          * Calls `Pawn.ClientMessage(string Msg)` on every pawn
          * Uses the `Broadcaster` parameter to just get access to `Actor.ForEach`
        9. GetDirectionRelationOfSourceToTarget(Actor Source, Actor Target, bool ConsiderSourcePawnViewRotation);
          * Returns **LGDUtilities.ActorDirectionRelationResult**
          * Compares `Target` to `Source` and returns an object that describes it's direction
          * Checks the following: Target in front/behind of Source and if the Target to the left/right of Source
        10. CheckActorRelevance(Actor A);
          * Returns **bool**
          * Checks if the given actor is relevant, based on `GameInfo.IsRelevant` and `Actor.bDeleteMe`
        11. CheckSpawnedActorArrayRelevance(Actor context, LinkedList ActorList);
          * Checks a `LGDUtilities.LinkedList` of actors if they are considered relevant
        12. SpawnActor(Actor context, Class<Actor> SpawnClass, optional Actor SpawnOwner, optional Name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation);
          * Returns **Actor**
          * Spawns an actor given the common parameters
        13. ReplaceWith(Actor Other, string aClassName);
          * Replaces an Actor with another given by a class name (uses default values for spawning)
          * Calls `Actor.Level.Game.BaseMutator.ReplaceWith` to perform normal replacement
    </details>

    <details>
      <summary>AssaultHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.AssaultHelper'.static.functionName();`

      ## Available Functions
        1. IsFortNameFriendly(string fortName);
          * Returns **bool**
          * Checks if an Assault fort name has a name that is decent to display (eg: dictates some kind of action for the attackers / defenders)
        2. GetFriendlyFortName(FortStandard fort);
          * Returns **string**
          * Filters a given FortStandard's name, to attempt to display something nice for showing labels and indicators for the objective
    </details>

    <details>
      <summary>AttachIndicatorHudCallback</summary>
      An example subclass of `LGDUtilities.PlayerSpawnMutatorCallback` for using `LGDUtilities.PlayerSpawnMutator` to execute code whenever a player is spawned.
    </details>

    <details>
      <summary>BoolObj</summary>
      A subclass of `LGDUtilities.ValueContainer`, which is a wrapper class for non-object values to be used in `LGDUtilities.LinkedList` and `LGDUtilities.ListElement`. This subclass is for **bool** values.
    </details>

    <details>
      <summary>BotHelper</summary>
      A class with helper functions specific to `Bot` and subclasses.
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.BotHelper'.static.functionName();`

      ## Available Functions
      1. AddBots(Actor context, int N);
        * Adds `N` number of bots, using `Actor.Level.Game.ForceAddBot()`
        * `context` parameter is only for being able to get a reference to `LevelInfo`
    </details>

    <details>
      <summary>ByteObj</summary>
      A subclass of `LGDUtilities.ValueContainer`, which is a wrapper class for non-object values to be used in `LGDUtilities.LinkedList` and `LGDUtilities.ListElement`. This subclass is for **byte** values.
    </details>

    <details>
      <summary>CallbackFnObject</summary>
      An object that is used to represent a callback function (or chain of them). UnrealScript doesn't support anonymous functions (or c#-like delegates / js-like functions as first-class-values) so this object was made to support that.
    </details>

    <details>
      <summary>ChaosWeapons.int</summary>
      An Unreal `int` definition file. Officially registers the `ChaosUT` weapons, so that `Actor.GetNextIntDesc` can be used to include them in loading all weapons UT is aware of.

      ## Weapons Registered
      1. `ChaosUT.ch_WarHeadLauncher`
      2. `ChaosUT.Crossbow`
      3. `ChaosUT.poisoncrossbow`
      4. `ChaosUT.explosivecrossbow`
      5. `ChaosUT.Sniper2`
      6. `ChaosUT.sniper_rpb`
      7. `ChaosUT.Flak2`
      8. `ChaosUT.ProxyArm`
      9. `ChaosUT.Sword`
      10. `ChaosUT.TurretLauncher`
      11. `ChaosUT.VortexArm`
    </details>

    <details>
      <summary>ClassObj</summary>
      A subclass of `LGDUtilities.ValueContainer`, which is a wrapper class for non-object values to be used in `LGDUtilities.LinkedList` and `LGDUtilities.ListElement`. This subclass is for **class** values.
    </details>

    <details>
      <summary>ColorHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.ColorHelper'.static.functionName();`

      ## Available Functions
      1. SColor(Color C,  float S);
        * Returns **Color**
        * Scales a color value by a given float (and clamps each component between 0 - 255)
      2. RColor(float R, float G, float B, optional float A);
        * Returns **Color**
        * Constructs a `Color` struct from **float** values (and clamps each component between 0 - 255)
      3. GetTeamColor(byte TNum);
        * Return **Color**
        * Gets a color value for a given team index (based on the array of `BotPack.TeamGamePlus.Teams[]`)
      4. GetRedColor();
        * Returns **Color**
        * Gets a **RED** color
      5. GetBlueColor();
        * Returns **Color**
        * Gets a **BLUE** color
      6. GetTurqColor();
        * Returns **Color**
        * Gets a **TURQUOISE** color
      7. GetGreenColor();
        * Returns **Color**
        * Gets a **GREEN** color
      8. GetGoldColor();
        * Returns **Color**
        * Gets a **GOLD** color
      9. GetWhiteColor();
        * Returns **Color**
        * Gets a **WHITE** color
      10. GetGrayColor();
        * Returns **Color**
        * Gets a **GRAY** color
      11. hsbToColor(byte hue, byte saturation, byte brightness);
        * Returns **Color**
        * Constructs a `Color` struct from given **HSB** values (Hue, Saturation, and Brightness)
    </details>

    <details>
      <summary>ColorObj</summary>
      A subclass of `LGDUtilities.ValueContainer`, which is a wrapper class for non-object values to be used in `LGDUtilities.LinkedList` and `LGDUtilities.ListElement`. This subclass is for **Color** values.
    </details>

    <details>
      <summary>CustomTrigger</summary>
      A trigger class that is meant to handle trigger events, initiated and "wired up" via script.
      When triggered, this class will invoke the `LGDUtilities.CallbackFnObject` denoted by the variable `CustomTrigger.triggerCallback`.
    </details>

    <details>
      <summary>DroppedInventoryMarkerMutator</summary>
      A mutator class that's loaded by `LGDUtilities.IndicatorHUD` to help facilitate in marking inventory items dropped by a player upon death (using `Inventory.PlayerLastTouched`).
    </details>

    <details>
      <summary>EffectFollower</summary>
      A class used to have an effect follow / attach to another actor and rotate/respond to velocity changes to appear to be "behind" the object -- such as a tail mesh / flame (such as `HeadHunter.SkullItem`).
    </details>

    <details>
      <summary>:x: ExtraUseTriggerBindings :x:</summary>
      A test class to try and add keybindings that the `LGDUtilities.UseTrigger` could be bound to and recieve events to be triggered by a keypress.

      ## :x: This class was a test and is currently unused (unable to get a custom action/key binding in the UT99 control preferences window to show up)  
    </details>

    <details>
      <summary>FlameFollower</summary>
      A class used to have a fire effect follow / attach to another actor and rotate/respond to velocity changes to appear to be "behind" the object (such as `HeadHunter.SkullItem`).
    </details>

    <details>
      <summary>FloatObj</summary>
      A subclass of `LGDUtilities.ValueContainer`, which is a wrapper class for non-object values to be used in `LGDUtilities.LinkedList` and `LGDUtilities.ListElement`. This subclass is for **float** values.
    </details>

    <details>
      <summary>GeometryHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.GeometryHelper'.static.functionName();`

      ## Available Functions
      1. areaOfTriangle(int x1, int y1, int x2, int y2, int x3, int y3);
        * Returns **float**
        * Calculates the area of a triangle given 3 coordinate x/y values.
      2. isInsideTriangle(int vertex1x, int vertex1y, int vertex2x, int vertex2y, int vertex3x, int vertex3y, int testPointX, int testPointY);
        * Returns **bool**
        * Given 3 points of a triangle, and a test point, determines if the test point is contained inside the triangle.
    </details>

    <details>
      <summary>GreenTrigger</summary>
      A test class for demonstrating basic trigger functionality via the `LGDUtilities.CallbackFnObject` class -- used in the `1HH-TestBox-Large.unr` map file included in this collection of mods.
    </details>

    <details>
      <summary>HealMessage</summary>
      A class used to display a message on a player's HUD when they are healed via the function: `LGDUtilities.PawnHelper.HealPawn();`
    </details>

    <details>
      <summary>HUDHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.HUDHelper'.static.functionName();`

      ## Available Functions
      1. getXY(Canvas C, vector location, out int screenX, out int screenY);
        * Given a location in the game world, and output x/y variables, this will transform the position to screen coordinates.
      2. getActorSizeOnHudFromCollider(Canvas C, Actor target, optional bool getMinSize, optional bool showColliderDebugIndicators);
        * Returns **float**
        * Calculates the size of the given `Actor` on a player's screen, based on the given `Canvas`.
        * Defaults to using the **MAXIMUM** dimension of the `Actor`'s collider, unless `getMinSize` is TRUE.
        * Debug can be shown on screen by passing **TRUE** for the parameter `showColliderDebugIndicators`
      3. getActorVerticalSizeOnHudFromCollider(Canvas C, Actor target, optional bool showColliderDebugIndicators);
        * Returns **float**
        * Calculates the size of the given `Actor` on a player's screen, **VERTICALLY**, based on the given `Canvas`.
      4. getActorHorizontalSizeOnHudFromCollider(Canvas C, Actor target, optional bool showColliderDebugIndicators);
        * Returns **float**
        * Calculates the size of the given `Actor` on a player's screen, **HORIZONTALLY**, based on the given `Canvas`.
      5. getActorSizeOnHudFromColliderWithPoints(Canvas C, Actor target, out Vector ActorSidePoint1, out Vector ActorSidePoint2, optional bool getMinSize, optional bool showColliderDebugIndicators);
        * Returns **float**
        * Calculates the size of the given `Actor` on a player's screen, based on the given `Canvas`.
        * Defaults to using the **MAXIMUM** dimension of the `Actor`'s collider, unless `getMinSize` is TRUE.
        * Debug can be shown on screen by passing **TRUE** for the parameter `showColliderDebugIndicators`
        * Extra output parameters `ActorSidePoint1` and `ActorSidePoint2` used to get the sides of the actor for use outside this function
      6. getActorVerticalSizeOnHudFromColliderWithPoints(Canvas C, Actor target, out Vector topOfActor, out Vector bottomOfActor, optional bool showColliderDebugIndicators);
        * Returns **float**
        * Calculates the size of the given `Actor` on a player's screen, **VERTICALLY**, based on the given `Canvas`.
        * Debug can be shown on screen by passing **TRUE** for the parameter `showColliderDebugIndicators`
        * Extra output parameters `topOfActor` and `bottomOfActor` used to get the sides of the actor for use outside this function
      7. getActorHorizontalSizeOnHudFromColliderWithPoints(Canvas C, Actor target, out Vector RSideOfActor, out Vector LSideOfActor, optional bool showColliderDebugIndicators);
        * Returns **float**
        * Calculates the size of the given `Actor` on a player's screen, **HORIZONTALLY**, based on the given `Canvas`.
        * Debug can be shown on screen by passing **TRUE** for the parameter `showColliderDebugIndicators`
        * Extra output parameters `RSideOfActor` and `LSideOfActor` used to get the sides of the actor for use outside this function
      8. IsOffScreen(Canvas C, int screenPosX, int screenPosY, out int offLeft, out int offRight, out int offTop, out int offBottom, optional int margin);
        * Returns **bool**
        * Given a screen position x/y, determine if that point is off the screen, and which side it is off of (using the given output **int** parameters -- because bools cannot be used with the "out" keyword)
        * Also takes into account a screen margin to help with minor edge cases if need be
      9. IsOffScreenNoReturnValues(Canvas C, int screenPosX, int screenPosY, optional int margin);
        * Returns **bool**
        * Effectively the same as `LGDUtilities.HUDHelper.IsOffScreen()` but omits the integer output parameters
        * Given a screen position x/y, determine if that point is off the screen, and which side it is off of (using the given output **int** parameters -- because bools cannot be used with the "out" keyword)
        * Also takes into account a screen margin to help with minor edge cases if need be
      10. DrawTextClipped(Canvas C, int X, int Y, string text, color outline);
        * Draw text on the given `Canvas`, at the coordinates, with the given color outline
      11. DrawLine(Canvas Canvas, int x1, int y1, int x2, int y2);
        * Draw a line on the given `Canvas` with the specified points
      12. DrawLine3D(Canvas C, vector P1, vector P2, float R, float G, float B);
        * Draw a line on screen, in 3d space (translated to 2d screen coordinates), given 2 points and a color
      13. DrawTextureAtXY(Canvas canvas, Texture tex, int screenX, int screenY, float texScale, float playerHudScale, bool centerIcon, optional bool excludePlayerHUDScaleFromOffset);
        * Draws a given `Texture` on the given `Canvas`, with the given texture scale, and player HUD scale
        * Can also **CENTER** the given texture at the x/y coordinates for easier rendering
        * Can also omit the player HUD scale from any centering offsets if `excludePlayerHUDScaleFromOffset` is **TRUE**
      14. DrawTextureAtXY_OutputEdgeCordinates(Canvas canvas, Texture tex, int screenX, int screenY, float texScale, float playerHudScale, bool centerIcon, bool excludePlayerHUDScaleFromOffset, out Vector TopL, out Vector TopR, out Vector BottomL, out Vector BottomR, optional bool IgnoreDrawOnlyOutputCordinates);
        * Similar to `LGDUtilities.HUDHelper.DrawTextureAtXY()` but also outputs the texture edge cordinates for use outside of this function
        * Draws a given `Texture` on the given `Canvas`, with the given texture scale, and player HUD scale
        * Can also **CENTER** the given texture at the x/y coordinates for easier rendering
        * Can also omit the player HUD scale from any centering offsets if `excludePlayerHUDScaleFromOffset` is **TRUE**
        * If `IgnoreDrawOnlyOutputCordinates` is set to **TRUE** then the texture is **NOT** drawn, but coordinates are still calculated -- useful if you want to know where it would be drawn, to simplify other calculations of texture drawing
      15. DrawTextureCenteredAboveAtXY(Canvas canvas, Texture tex, int screenX, int screenY, float texScale, float playerHudScale, optional bool excludePlayerHUDScaleFromOffset);
        * Draws a given `Texture` on the given `Canvas`, with the given texture scale, and player HUD scale
        * Draws a texture **CENTERED** and **ABOVE** the given x/y (the texture will be drawn such that the x/y is on the bottom center of the texture)
        * Can also omit the player HUD scale from any positioning offsets if `excludePlayerHUDScaleFromOffset` is **TRUE**
      16. DrawCircleMidScreenWithWidth(Actor context, Canvas canvas, float wantedWidth, float playerHudScale);
        * Draws a circle in the middle of the screen, given the desired circle width (diameter) and player HUD scale
      17. DrawCircleAtPosWithWidth(Actor context, Canvas canvas, int screenX, int screenY, float wantedWidth, float playerHudScale);
        * Draws a circle at the given x/y position of the screen, given the desired circle width (diameter) and player HUD scale
      18. DrawTextAtXY(Canvas canvas, Actor context, string text, int screenX, int screenY, optional bool centerText);
        * Draw text on screen, at the given x/y coordinates
        * Optionally can **CENTER** the text at the given x/y instead (normally the x/y is the top left coordinate of the text to be drawn)
      19. GetScreenTrianglesPointIsIn(Canvas canvas, int pointX, int pointY, out int inTop_int, out int inBottom_int, out int inLeft_int, out int inRight_int);
        * Returns **bool**
        * Given a model of the screen, where it's divided into 4 triangles, will determine where the given x/y resides in
        * The screen model is similar to:
        `
        ________________
        |\            /|
        |  \        /  |
        |    \   /     |
        |      *       |
        |    /   \     |
        |  /       \   |
        |/____________\|
        `
      20. GetScreenPointOutsideCenterCircle(Canvas canvas, int pointX, int pointY, int centerCircleRadius);
        * Returns **bool**
        * Given a point x/y, and a circle radius, returns whether the point is outside the circle centered in the middle of the screen
      21. getScaleForTextureToGetDesiredWidth(Texture tex, float wantedWidth);
        * Returns **float**
        * Given a texture, and a desired width, calculates the scale needed for the texture to achieve the desired width
      22. getScaleForTextureToGetDesiredHeight(Texture tex, float wantedHeight);
        * Returns **float**
        * Given a texture, and a desired height, calculates the scale needed for the texture to achieve the desired height
      23. getScaleForTextureFromMaxTextureDimension(Texture tex, float wantedMaxDimensionSize);
        * Returns **float**
        * Given a texture, and a desired max dimension, calculates which dimension is the maximum for the texture and what scale is needed to get the size wanted.
        * Useful for fitting an arbitrary texture into a given space on screen, as a constraint for the texture
      24. getValueFromActor(UWindowRootWindow context, Actor actor, string prop);
        * Returns **string**
        * Gets a value from an `Actor`, in a context of rendering an Unreal window, with respect to network replication reliability
      25. PlayerHasHUDMutator(PlayerPawn p, name mutClass);
        * Returns **Mutator**
        * Determines if the given `PlayerPawn` has the given class, by a **NAME** variable
        * Uses `Actor.IsA()` for comparison to avoid needing class references at compile time
      26. RenderLEDTimerToHUD(Canvas c, float xPos, float yPos, Color col, byte drawStyle, float hudScale, int timerSeconds);
        * Renders a LED-Style timer on screen, such as the **ASSAULT** countdown
        * An example of this can be found in `HeadHunter.HeadHunterGameInfo` and `Infection.InfectionGameInfo`
    </details>

    <details>
      <summary>HUDMutator</summary>
      A helper class to assist in managing mutators that are explicitly for modifying the HUD.

      ## Instance Functions

      1. RegisterThisHUDMutator()
        * Used to register the HUD mutator with an active PlayerPawn's HUD so it can be rendered
      2. GetThisHUDMutatorFromAnyPlayerPawn()
        * Returns **Mutator**
        * Finds an instance of this mutator amongst the PlayerPawns in the game scene, and **ONLY** one should be returned as only one has an active HUD per game instance
      3. GetThisHUDMutatorFromPlayerPawn(PlayerPawn p);
        * Returns **Mutator**
        * Gets an instance of this HUD mutator from the given `PlayerPawn`

      ## Static Helper Functions
      **Static Helper Class**
      To access **STATIC** functions in this class use the following syntax:
      `class'LGDUtilities.HUDMutator'.static.functionName();`

      1. GetHUDMutatorFromAnyPlayerPawnByClass(Actor context, class<Mutator> mutClass);
        * Returns **Mutator**
        * Looks through all `PlayerPawns`, and find the given `Mutator` class
      2. GetHUDMutatorFromPlayerPawnByClass(PlayerPawn p, class<Mutator> mutClass);
        * Returns **Mutator**
        * Looks through the given `PlayerPawn`, and find the given `Mutator` class
      3. GetHUDMutatorFromPlayerPawnByClassName(PlayerPawn p, name className);
        * Returns **Mutator**
        * Looks through the given `PlayerPawn`, and a `Mutator` class that matches the given **NAME**
        * Uses `Actor.IsA()` to compare the class name
    </details>

    <details>
      <summary>IndicatorHud</summary>
      A class used to draw indicators on the active player's HUD. Checks a client-side `LGDUtilities.LinkedList` variable, as well as finds the singleton `LGDUtilities.IndicatorHudGlobalTargets` for game-wide **GLOBAL** targets (replicated between clients).

      ## :warning: This class can cause performance issues on very low-end systems due to the number of canvas draw calls, and iterating over targets. On modern systems, this shouldn't be an issue.

      **Static Helper Functions**
      To access **STATIC** functions in this class use the following syntax:
      `class'LGDUtilities.IndicatorHud'.static.functionName();`

      1. GetBuiltinTextureByte(HUDIndicator_Texture_BuiltIn tex);
        * Used to get a `byte` value, which represents an enum value of `LGDUtilities.IndicatorHUD.HUDIndicator_Texture_BuiltIn`
      2. GetCurrentPlayerIndicatorHudInstance(Actor context);
        * Returns **`LGDUtilities.IndicatorHUD`**
        * Returns the active indicator HUD instance for this client (as each client only have 1 HUD active at a time)
      3. SpawnAndRegister();
        * Returns **`LGDUtilities.IndicatorHUD`**
        * Used to instantiate and register the given instance to receive `PostRender` function calls to the current player's HUD

      **Instance Functions**
      These require an instance of IndicatorHUD to be used. This is usually obtained by the following:
        * **static** `LGDUtilities.IndicatorHUD.SpawnAndRegister()`
        * **static** `class'LGDUtilities.HUDMutator'.static.GetHUDMutatorFromAnyPlayerPawnByClass(AnActorInstance, class'LGDUtilities.IndicatorHud');`

      1. AddBasicTarget(Actor target, optional bool globalTarget, optional object SourceToLimit, optional bool replaceExistingTarget);
        * Adds a target to global/client lists to have an indicator -- using **BASIC** settings
        * Can also set an optional bool `replaceExistingTarget` that will look for the target actor, and replace it in the global/client lists (to avoid multiple indicators for the same target)
        * Can also supply an **OBJECT** for `SourceToLimit` that is used for identifying the source that added the target, so your code ONLY removes targets you've added
      2. AddAdvancedTarget(IndicatorHudTargetListElement element, bool globalTarget, optional bool replaceExistingTarget);
        * Adds a target to global/client lists to have an indicator -- using **ADVANCED** settings
        * Settings are configured via the supplied `LGDUtilities.IndicatorHudTargetListElement` parameter
        * Can also set an optional bool `replaceExistingTarget` that will look for the target actor, and replace it in the global/client lists (to avoid multiple indicators for the same target)
        * Can also supply an **OBJECT** for `IndicatorSource` (via the `element.IndicatorSource` parameter value) that is used for identifying the source that added the target, so your code ONLY removes targets you've added
      3. RemoveTarget(Actor targetToRemove, optional object SourceToLimit);
        * Can remove a specified actor target (from global and client lists)
        * Can also conditionally remove the actor target if `SourceToLimit` matches (to ensure you only remove targets added via your own code)
      4. IfTargetInList(Actor targetToFind, optional bool CheckGlobal, optional object SourceToLimit);
        * Returns **bool**
        * Checks in global/client lists (based on `CheckGlobal`) and returns whether the target exists in that list
        * Can also limit the search to actors added with the same `SourceToLimit` object (to check for targets added via your own code)
      5. GetTargetElementFromList(Actor targetToFind, optional bool CheckGlobal, optional object SourceToLimit);
        * Returns **`LGDUtilities.ListElement`**
        * Fetches the list element for a given target
        * This list element can **ACTUALLY** be a `LGDUtilities.IndicatorHudTargetListElement`
        * Used to modify elements / settings and keep existing ones without having to manually set everything again (great for filters)
      6. ResetAllTargets();
        * Returns **int**
        * Removes all targets from all lists, and returns the number removed
        * Useful for init / travel functions
      7. ResetAllTargetsForSource(object SourceToLimit);
        * Returns **int**
        * Removes all targets from all lists, and returns the number removed
        * Limits the removed elements to having the matching `SourceToLimit` value **ONLY**
        * Useful for init / travel functions
        * Useful for resetting targets added by **YOUR** code, or a specified class / context
      8. VerifyTargets();
        * Iterates and verifies each target is still valid (not `None` and doesn't have `Actor.bDeleteMe` set to **true**)
      9. GetTexturesForBuiltInOption(byte wantedBuiltinTex, optional byte offScreenTexDesired);
        * Returns **`LGDUtilities.IndicatorTextureVariations`**
        * A texture variations struct has 6 textures referenced in it -- each for the given target conditions -- on screen, off the top, bottom, left, and right of the screen, and behind the player
        * Returns a texture variations object for a given enum value (from the enum `LGDUtilities.IndicatorHUD.HUDIndicator_Texture_BuiltIn`) and another given enum of type `LGDUtilities.IndicatorHUD.HUDIndicator_Texture_BuiltIn` for the `offScreenTexDesired` parameter
        * Combines both texture variations objects, taking the one found by `wantedBuiltinTex` and adding the off screen textures specified by `offScreenTexDesired`
        * Is a nice and easy way to configure behaviors/visuals for when a target is on screen / off the edge of the screen and textures should vary for the user -- without the calling code needing to know of each and every texture if they don't want to deal with that

      ## :warning: Do **NOT** modify `LGDUtilities.IndicatorHUD.PlayerIndicatorTargets` and `LGDUtilities.IndicatorHUD.GlobalIndicatorTargets` manually unless you take great care -- it's easy to mess up visuals used by other code, as well as adding duplicate targets.

      ## The variables exposed in this class are generally overridden by indicator settings for each target, unless none are specified (eg: a basic target), then defaults are used. If you want to modify the defaults, use this code: `LGDUtilities.IndicatorHUD.default.VariableName = NewValue` to set defaults -- **but be warned** this sets defaults for ALL targets.

      ## If you need to debug different things, you can set `LGDUtilities.IndicatorHUD.bLogToGameLogfile` to **true** and basic debug statements will be output to the `UnrealTournament.log` file (Located in `UT99/System` directory)
    </details>

    <details>
      <summary>IndicatorHudGlobalTargets</summary>
      A **Singleton** class modeled after `LGDUtilities.SingletonActor` that ensures only **ONE** instance of the given actor exists in the game at one time.

      **Static Helper Class**
      To access **STATIC** functions in this class use the following syntax:
      `class'LGDUtilities.IndicatorHudGlobalTargets'.static.functionName();`

      ## Available Functions
      1. GetRef();
        * Returns **`LGDUtilities.IndicatorHudGlobalTargets`**
        * Used to get an instance of this class (or create one if it doesn't exist)
        * Uses a "hack" by spawning an instance, and then setting the **DEFAULT** for that field to the reference spawned (if the default value doesn't contain a reference already)
      2. SetRef();
        * Sets the given **DEFULT** reference field for the singleton
        * :warning: **ONLY** use this if you understand what you're doing -- otherwise let the `GetRef` function manage the instance
    </details>

    <details>
      <summary>IndicatorHudMapTargetHUDMutator</summary>
      A callback of type `LGDUtilities.PlayerSpawnMutatorCallback` and used by the class `LGDUtilities.IndicatorHudMapTarget` to trigger when a player spawns. When a player spawns, an    IndicatorHUD instance is spawned and registered. An IndicatorHUD instance is looked for and if not found, **THEN** is spawned.
    </details>

    <details>
      <summary>IndicatorHudMapTargetModifierFn</summary>
      A class used when setting up `LGDUtilities.IndicatorSettings` to modify settings of indicators during runtime. Used by the class `LGDUtilities.IndicatorHudMapTarget`.
    </details>

    <details>
      <summary>IndicatorHudTargetListElement</summary>
      A class used when adding new targets / indicators. It holds references to `IndicatorSource`, `IndicatorSettings`, and `IndicatorSettingsModifier`.

      A few examples of this class being used:
      1. `LGDUtilities.InfectionGameInfo.AddPlayerIndicator()`
      2. `Juggernaut.JuggernautGameInfo.AddPlayerIndicator()`
      3. `LGDUtilities.GeneralIndicatorMutator.AddConfiguredTargets()`
      4. `LGDUtilities.PlayerDeathLocationMarker.SpawnAtPlayerLocation()`
    </details>

    <details>
      <summary>IndicatorSettings</summary>
      A class used to configure settings to use for a given target / indicator for `LGDUtilities.IndicatorHUD`.

      ## Object Variables
      1. ReplaceExisting
        * Whether to replace an existing element to show an indicator for in client/global lists for `LGDUtilities.IndicatorHUD`.
      2. TextureVariations
        * A `LGDUtilities.IndicatorTextureVariations` object that specifies a set of texture to use for an indicator (on screen, off to left/right/bottom/top, or behind the player).
        * You can use `LGDUtilities.GetTexturesForBuiltInOption()` to get an instance of `LGDUtilities.IndicatorTextureVariations`, by providing a combination of `wantedBuiltinTex` and `offScreenTexDesired`
        * The `byte` value of the enum `LGDUtilities.IndicatorHUD.HUDIndicator_Texture_BuiltIn` can be used for these parameters
      3. DisableIndicator
        * Whether to disable this indicator (such as if it's to be enabled later)
      4. MaxViewDistance
        * The maximum distance the indicator is visible
      5. IndicatorOffsetFromTarget
        * The `Vector` offset of the indicator from the target(s)
      6. UseHUDColorForIndicator
        * Whether to use the player's HUD color for the indicator color
      7. UseCustomColor
        * Whether to use a custom color for the indicator(s)
      8. IndicatorColor
        * The `Color` of the indicator to use, if `UseCustomColor` is **TRUE**
      9. ShowTargetDistanceLabels
        * Whether to show an extra label denoting the distance to the target from the owner of the given HUD
        * Only shown if `ShowIndicatorLabel` is **TRUE**
      10. IndicatorLabel
        * The text of the label for the indicator(s)
      11. ShowIndicatorLabel
        * Whether to show a label for the indicator(s)
        * Only shown if `ShowIndicatorLabel` is **TRUE**
      12. UseTargetNameForLabel
        * When showing a label for the indicator(s), whether to use the target's name
      13. ScaleIndicatorSizeToTarget
        * Whether to scale the indicator(s) to each target's size on the HUD (to have a nice size aligned to the target)
      14. StaticIndicatorPercentOfMinScreenDimension
        * Used to ensure the scale of the indicator is a **STATIC** percentage of the screen's **MINIMUM/SMALLEST** dimension.
        * Only takes affect if `LGDUtilities.IndicatorHudMapTarget.ScaleIndicatorSizeToTarget` is **FALSE**
      15. StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen
        * Used to ensure the scale of the indicator is a **STATIC** percentage of the screen's **MINIMUM/SMALLEST** dimension, when the target is **OFF SCREEN**.
        * Only takes affect if `LGDUtilities.IndicatorHudMapTarget.ScaleIndicatorSizeToTarget` is **FALSE**
      16. ShowIndicatorWhenOffScreen
        * Whether to show the indicator when the target is **OFF SCREEN** or not
      16. ShowIndicatorIfTargetHidden
        * Whether to show the indicator if the target actor is hidden
      17. ShowIndicatorIfInventoryHeld
        * Whether to show the target inventory indicator if a player is holding it
      18. ShowIndicatorIfInventoryNotHeld
        * Whether to show the target inventory indicator if a player is **NOT** holding it (but **NOT** dropped by a player)
      19. ShowIndicatorIfInventoryDropped
        * Whether to show the target inventory indicator if it was **DROPPED** by a player
      20. ShowIndicatorsThatAreObscured
        * Whether to show indicators from targets that are **NOT** in eye-sight of the player
      21. BlinkIndicator
        * Whether to blink the indicator on the player's HUD
      22. BaseAlphaValue
        * The default **ALPHA** value for the given indicator
      23. ShowIndicatorAboveTarget
        * Whether to show the indicator above the target (instead of centered on it)
      24. IndicatorLabelsAboveIndicator
        * Whether to show indicator labels **ABOVE** the indicator (instead of below, the **default**)
    </details>

    <details>
      <summary>IndicatorSettingsModifierFn</summary>
      An object used as a callback for `LGDUtilities.IndicatorHudTargetListElement` for the variable `IndicatorSettingsModifier`. This object has a function that is to be **OVERRIDDEN** in subclasses, and is used to modify `LGDUtilities.IndicatorHudTargetListElement.IndicatorSettings` in realtime for changing what settings an indicator for the given target has.
    </details>

    <details>
      <summary>IndicatorTextureVariations</summary>
      An object that represents a set of textures for an indicator to be drawn on the screen via `LGDUtilities.IndicatorHud`. It includes textures for when the indicator is in view on the player HUD, behind the player, and off to the left,right,top,bottom (and the 4 corners too).

      This object is usually constructed via `LGDUtilities.IndicatorHud.GetTexturesForBuiltInOption()`.
    </details>

    <details>
      <summary>IntObj</summary>
      A subclass of `LGDUtilities.ValueContainer`, which is a wrapper class for non-object values to be used in `LGDUtilities.LinkedList` and `LGDUtilities.ListElement`. This subclass is for **int** values.
    </details>

    <details>
      <summary>InventoryHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.InventoryHelper'.static.functionName();`

      ## Available Functions
      1. GetNiceRelicName(TournamentPickup relic)
        * Returns **string**
        * Gets a nice name for a given relic. This function ONLY applies to `TournamentPickup`s that are of one of the relic classes -- subclasses of `Relic.RelicInventory` -- the standard relic mod that comes with UT99 GOTY.
      2. IsInventoryDropped(Inventory inv)
        * Returns **bool**
        * Checks a given `Inventory` for the variable `inv.bTossedOut` and `inv.PlayerLastTouched == 'Dropped'`
        * :warning: Relies on `LGDUtilities.DroppedInventoryMarkerMutator` having marked inventory items when a player dies.
      3. GetItemCountInInventory(Pawn pawn, bool IncludeCopies)
        * Returns **int**
        * Gets the count of **ALL** copies of **ALL** inventory for a given pawn
        * Can optionally include copies of each inventory object too
      4. GetAllItemsOfTypeInInventory(Pawn pawn, class<Inventory> invClass)
        * Returns **`LGDUtilities.LinkedList`**
        * Gets all items of a given **class** from a pawn's inventory chain
      5. DeleteInventoriesOnGround(Actor context, name invClass)
        * Returns **int**
        * Deletes all inventory items on the ground (not carried and `Actor.Owner` is None), of a given class name
      6. IsAPowerup(Inventory Item, bool includeArmor, bool includeHealth, bool includePowerItems)
        * Returns **bool**
        * Checks if a given `Inventory` is to be considered a power-up or not
    </details>

    <details>
      <summary>:x: InventoryToolbelt :x:</summary>
      A class to show a handful of extra "unique inventory items" on a player's hud, and that they are held and a count of each.

      **EG:** This would be used to show items such as keys / keycards for special cases when a player should know they have them, and how many.

      ## :x: This class is unfinished and is a work in progress.

      **Static Helper Functions**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.InventoryToolbelt'.static.functionName();`

      1. GetCurrentPlayerInventoryToolbeltHudInstance(Actor context, PlayerPawn pp)
        * Returns **`LGDUtilities.InventoryToolbelt`**
        * Finds the current instance of the given `PlayerPawn`'s InventoryToolbelt
      2. SpawnAndRegister(Actor context)
        * Returns **`LGDUtilities.InventoryToolbelt`**
        * Spawns this HUDMutator and registers it to the current client player's HUD

      ## Instance Functions

      1. AddInventoryToToolbelt(object inv)
        * Returns **bool**
        * Adds a given `Inventory` or `LGDUtilities.ToolbeltInvItem` to the current toolbelt instance
        * Returns if the inventory item was successful in adding to the toolbelt (if the provided parameter provided isn't a valid type, it'll fail to be added)
      2. RemoveInventoryFromToolbelt(object inv)
        * Returns **bool**
        * Removes a given `Inventory` or `LGDUtilities.ToolbeltInvItem` from the current toolbelt instance
        * Returns if the inventory item was successful in removing from the toolbelt (if the provided parameter provided isn't a valid type, it'll fail to be added)
    </details>

    <details>
      <summary>LevelHelper</summary>
      **Static Helper Functions**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.LevelHelper'.static.functionName();`

      1. GetDetailMode(LevelInfo Level)
        * Returns **int**
        * Get level detail value, 3 is max, 0 is min
        * Based on player preferences / ini config
    </details>

    <details>
      <summary>LinkedList</summary>
      A classic data structure of linked nodes, in a sequential fashion.

      ## Looping
      To iterate over the list, use the following:
      `
        //given a LinkedList instance -- "theList"
        ListElement le = theList.Head;
        while(le != None) {
          //do something with the current "le" value
          le = le.Next;//forgetting this would result in an infinite loop
        }
      `

      ## Instance Functions
      1. Push(object value)
        * Puts an object at the **BEGINNING** of the list, so `LinkedList.Head` references the new element
        * If the `value` parameter is of type `LGDUtilities.ListElement`, it'll be added to the list
        * If the `value` parameter is **NOT**, it'll be boxed into an element, and then added to the list
      2. Pop()
        * Returns **`LGDUtilities.ListElement`**
        * Removes the head from the list, and returns it
      3. Enqueue(object value)
        * Puts an object at the **END** of the list, so `LinkedList.Head` references the new element
        * If the `value` parameter is of type `LGDUtilities.ListElement`, it'll be added to the list
        * If the `value` parameter is **NOT**, it'll be boxed into an element, and then added to the list
      4. Dequeue()
        * Returns **`LGDUtilities.ListElement`**
        * Removes the head from the list, and returns it (yup, same as `Pop()`)
      5. GetElementAt(int idx)
        * Returns **`LGDUtilities.ListElement`**
        * Gets an element at the given index `idx`
        * If the idx is out of range of the list (< 0 OR >= `LGDUtilities.LinkedList.Count`)
        * This is **NOT** random access to the lsit (like an array), and is linear using a loop from the head of the list (This operates in linear time -- (N) complexity) -- So use this sparingly.
      6. GetRandomElement()
        * Returns **`LGDUtilities.ListElement`**
        * Gets a random element from the list (**WITHOUT** removing it)
        * This is **NOT** random access to the list (like an array), and is linear using a loop from the head of the list (This operates in linear time -- (N) complexity) -- So use this sparingly.
      7. ContainsValue(object val)
        * Returns **bool**
        * Returns whether the list has a given value
        * This is **NOT** random access to the list (like an array), and is linear using a loop from the head of the list (This operates in linear time -- (N) complexity) -- So use this sparingly.
      8. GetElementByValue(object val)
        * Returns **`LGDUtilities.ListElement`**
        * Checks the list for a given value, and returns the element (**WITHOUT** removing it)
        * This is **NOT** random access to the list (like an array), and is linear using a loop from the head of the list (This operates in linear time -- (N) complexity) -- So use this sparingly.
      9. GetElementIdxByValue(object val)
        * Returns **int**
        * Gets the index of an element in the list, with the given value
        * If the object `val` is None or not found, -1 will be returned
        * This is **NOT** random access to the list (like an array), and is linear using a loop from the head of the list (This operates in linear time -- (N) complexity) -- So use this sparingly.
      10. GetElementIdx(ListElement elementToFind)
        * Returns **int**
        * Gets the index of a given element instance, in the list
        * If the element `elementToFind` is None or not found, -1 will be returned
        * This is **NOT** random access to the list (like an array), and is linear using a loop from the head of the list (This operates in linear time -- (N) complexity) -- So use this sparingly.
      11. RemoveAt(int idx)
        * Returns **`LGDUtilities.ListElement`**
        * Removes an element at the given index `idx` from the list, and returns it
      12. RemoveElement(ListElement le)
        * Returns **`LGDUtilities.ListElement`**
        * Removes an element `le` from the list, and returns it (returns the original reference)
      13. RemoveElementByValue(object val)
        * Returns **bool**
        * Removes an element from the list, by the given value
        * Returns whether an element was removed
      14. RemoveAll()
        * Returns **int**
        * Removes **EVERY** element from the list, and returns the number removed
      15. InsertAt(object value, int idx)
        * Returns **`LGDUtilities.ListElement`**
        * Inserts the given value (or element) at the given index `idx` in the list
        * If the index is **<= 0**, then the element is inserted at the beginning of the list
        * If the index is **>= Count** of the list, then the element is inserted at the end of the list
      16. Concat(LinkedList otherList)
        * Returns **`LGDUtilities.LinkedList**
        * Combines **THIS** list with another -- with all elements of `otherList` at the end
        * Order of `otherList` is maintained when adding
        * The list elements of `otherList` are **CLONED** (but their **values** are **NOT**)
      17. Clone()
        * Returns **`LGDUtilities.LinkedList**
        * Clones this list, and returns the copy
        * Each element is **CLONED** (but their **values** are **NOT**)
      18. InOrderLog()
        * Iterates over each element, in order, and calls `Log()` with a basic `string` representation of each

      ## Object Operator Overloads
      1. +
        * [LinkedList A, LinkedList B] Combines 2 lists (put list `B` at the end of `A` in order)
        * [LinkedList A, ListElement B] Adds an element `B` to the end of list `A`
        * [ListElement A, LinkedList B] Adds an element `A` to the beginning of list `B`
      2. -
        * [LinkedList A, ListElement B] Removes the element `B` from list `A`
      3. +=
        * [LinkedList A, ListElement B] Adds an element `B` to the end of list `A`
          * Modifies the original list `A`
        * [LinkedList A, LinkedList B] Combines both lists (put list `B` at the end of `A` in order)
          * Modifies the original list `A`
      4. -=
        * [LinkedList A, ListElement B] Removes the element `B` from list `A`
          * Modifies the original list `A`
        * [LinkedList A, LinkedList B] Removes the elements of `B` from list `A`
          * Modifies the original list `A`
    </details>

    <details>
      <summary>ListElement</summary>
      An element of a `LGDUtilities.LinkedList`.

      1. :warning: AddBefore(ListElement el)
        * Adds the given element `el` **BEFORE** this one by modifying each element's next/previous variables.
        * Changes `el.ListOwner` to `self.ListOwner` (but if el had a prior ListOwner, it will **NOT** modify that list if it was head/tail)
        * Does NOT update `self.ListOwner.Count`
        * :warning: Do **NOT** use this method unless you are careful about modifying the necessary linked lists (this method is mainly a helper for `LGDUtilities.LinkedList`)
      2. :warning: AddAfter(ListElement el)
        * Adds the given element `el` **AFTER** this one by modifying each element's next/previous variables.
        * Changes `el.ListOwner` to `self.ListOwner` (but if el had a prior ListOwner, it will **NOT** modify that list if it was head/tail)
        * Does NOT update `self.ListOwner.Count`
        * :warning: Do **NOT** use this method unless you are careful about modifying the necessary linked lists (this method is mainly a helper for `LGDUtilities.LinkedList`)
      3. :warning: Destroy()
        * This voids all reference variables from this list element
        * :warning: Do **NOT** use this method unless you are careful about modifying the necessary linked lists (this method is mainly a helper for `LGDUtilities.LinkedList`)
      4. RemoveFromList()
        * Returns **`LGDUtilities.ListElement`**
        * Removes this element from the element's `ListOwner`
      5. ToString()
        * Returns **string**
        * Returns a string representation of this element
      6. ElementValueEquals(object objVal)
        * Returns **bool**
        * Checks if this given element's `value` is considered equal to the provided `objVal`
        * If the provided `objVal` and this element's `value` are a subclass of `LGDUtilities.ValueContainer`, then `LGDUtilities.ValueContainer.Equals()` is invoked.
        * If only one is a `LGDUtilities.ValueContainer`, then the comparison is **FALSE**
        * If both are **NOT** a `LGDUtilities.ValueContainer`, then `==` is used
      7. Clone()
        * Returns **`LGDUtilities.ListElement`**
        * Creates a new instance of this element

      ## Object Operator Overloads
      1. +
        * [ListElement A, ListElement B] Combines both elements into a `LGDUtilities.LinkedList` (with `A` before `B`)
      2. ==
        * [ListElement A, ListElement B] Compares if two list elements are **EQUAL** using `A.ElementValueEquals(B)`
      3. !=
        * [ListElement A, ListElement B] Compares if two list elements are **NOT** equal using `!A.ElementValueEquals(B)`
    </details>

    <details>
      <summary>LookTriggerHUDMutator</summary>
      The `HUDMutator` for `LGDUtilities.LookTrigger` being able to show the look target indicator. The trigger will set up this mutator for you, so this shouldn't need to be interacted with.

      **Static Helper Functions**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.LookTriggerHUDMutator'.static.functionName();`

      1. GetCurrentPlayerLookTriggerHudInstance(Actor context, PlayerPawn pp)
        * Returns **`LGDUtilities.LookTriggerHUDMutator`**
        * Used to get the current `LookTriggerHUDMutator` for the given player pawn
      2. SpawnAndRegister(Actor context)
        * Returns **`LGDUtilities.LookTriggerHUDMutator`**
        * Spawns and registers this HUDMutator with the player's HUD (so it receives draw calls)
    </details>

    <details>
      <summary>ManualTrigger</summary>
      A trigger actor that is meant to be subclassed and used for other triggers, and activated programmatically. 

      ## How to subclass
      1. Override `Touch()` and `UnTouch()` to execute code when an `Actor` collides with this trigger and leaves the collider.

      2. Call `ActivateTrigger()` programmatically when you want the trigger activated.
        * This calls `CanActivateTrigger()` before activating

      3. Override `CanActivateTrigger()` to change what logic is used to determine if the trigger can be activated.
        * Call `Super.CanActivateTrigger()` to also check `bTriggerOnceOnly` and `ReTriggerDelay`
      4. Set `CanBeTriggeredExternally` accordingly
        * This determines if external actors can trigger this actor (or if **ONLY** the logic of this trigger can)

      ## Subclasses
      1. ActorNearbyTrigger
      2. InventoryTrigger
      3. LookTrigger
      4. RandomTrigger
      5. UseTrigger
      6. WaitTrigger
    </details>

    <details>
      <summary>MatchBeginMutator</summary>
      A mutator used to register code to execute when a match is considered to have been started. This class is meant to be used with unique subclasses of `LGDUtilities.MatchBeginMutatorCallback`.

      **Static Helper Functions**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.MatchBeginMutator'.static.functionName();`

      1. RegisterToMatchBegin(Actor context, MatchBeginMutatorCallback callback)
        * Returns **`LGSUtilities.MatchBeginMutator`**
        * Registers the mutator, and thr associated `LGDUtilities.MatchBeginMutatorCallback` instance -- a callback object -- to be ran when the match begins
    </details>

    <details>
      <summary>MatchBeginMutatorCallback</summary>
      A callback to be used for executing code when a match begins. Subclass this to create your own function to be passed to `LGDUtilities.MatchBeginMutator.RegisterToMatchBegin()`
    </details>

    <details>
      <summary>MathHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.MathHelper'.static.functionName();`

      ## Available Functions
      1. acos(float x)
        * Returns **float**
        * The math function of arccosine.
      2. asin(float a)
        * Returns **float**
        * The math function of arcsine.
      3. atan2(float y, float x)
        * Returns **float**
        * The math function of atan2.
      4. UUtoMeters(float unrealUnits)
        * Returns **float**
        * Converts a given numeric value of **UnrealUnits**, to real-world **meters**
      5. GetNumberEquadistantPointsAroundCircleCenter(Vector CircleCenter, float Radius, int NumPoints, Vector alignToDir)
        * Returns **'LGDUtilities.LinkedList'**
        * Calculates a circle with given radius, and then positions a set number of points, given by the parameter `NumPoints`, at the circle radius, equally-spaced apart. 
        * The given parameter `alignToDir` will ensure the points get created, with the circle rotated perpindicular to given vector (a vector extending from the circle cneter will point in this direction)
      6. Get3DigitTimerPartsFromSeconds(int TotalSeconds, out int ResultMinutes, out int ResultTens, out int ResultOnes)
        * Calculates 3 parts of a timer (mins, # of tens, and # of ones) given a number of seconds
        * Output variables are used to return these three components
        * These can be used to render a timer that has the format of: [MM]:[ss][s]
      7. GetDigitsOfInteger(int TargetInteger, out int DigitsArray[])
        * Returns the digits of an integer into an array (up to 11 places)
        * Used for formatting or "binning" of an integer
      8. Round(float val, optional float midpoint)
        * Returns **int**
        * Rounds a given float, based on the midpoint (if decimal part of float above/equal, round up, otherwise round down)
        * The midpoint is a float within the range of [0.0 -> 1.0]
      9. RoundGivenLimits(float val, optional float roundUpLimit, optional float roundDownLimit)
        * Returns **int**
        * Rounds a given float, based on each rounding limit (if decimal part of float above/equal to `roundUpLimit` round up, otherwise if below `roundDownLimit` then round down -- if between these, then don't round)
        * Each rounding limit is a float within the range of [0.0 -> 1.0]
        * This is the same as `LGDUtilities.MathHelper.Round()` if you supplied the same value for each limit
      
      ## Useful Conversion Constants
      To use these constants, use this code: `class'LGDUtilities.MathHelper.default.constantName'`.

      These constants convert from one unit to another merely by multiplying them to the source unit value. 

      EG: 100 degrees as radians is: `100 * class'LGDUtilities.MathHelper.default.DegToRad'`

      1. RadToDeg
      2. DegToRad
      3. UnrRotToRad
      4. RadToUnrRot
      5. DegToUnrRot
      6. UnrRotToDeg
      7. UnrSizeToMeters
      8. MetersToUnrSize
    </details>
    
    <details>
      <summary>Matrix3x3</summary>
      Represents a 3x3 matrix of **float** values.

      Supports the * operator between a **Matrix3x3** and a **vector** type.
    </details>

    <details>
      <summary>MutatorHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.MutatorHelper'.static.functionName();`

      ## Available Functions
      1. GetHUDMutatorFromActivePlayerPawnByClass(Actor context, name className)
        * Returns **Mutator**
        * Gets an instance of a mutator, via class name comparison using `Actor.IsA()`
      2. GetGameMutatorByClass(Actor context, class<Mutator> mutatorClass)
        * Returns **Mutator**
        * Gets a mutator from the game mutator chain
        * Uses `Actor.Level.Game.BaseMutator`
      3. GetGameDamageMutatorByClass(Actor context, class<Mutator> mutatorClass)
        * Returns **Mutator**
        * Gets a mutator from the game damage mutator chain
        * Uses `Actor.Level.Game.DamageMutator`
      4. GetGameMessageMutatorByClass(Actor context, class<Mutator> mutatorClass)
        * Returns **Mutator**
        * Gets a mutator from the game message mutator chain
        * Uses `Actor.Level.Game.MessageMutator`
      5. GetMutatorBeforeMutatorInChain(Mutator mut)
        * Returns **Mutator**
        * Gets a mutator that is registered before this one from the game  mutator chain
        * Uses `Actor.Level.Game.BaseMutator`
    </details>

    <details>
      <summary>MyFontsSingleton</summary>
      A singleton class that initializes and caches an instance of `Botpack.FontInfo`.

      ## Static Functions
      To access functions in this class use the following syntax:
      `class'LGDUtilities.MyFontsSingleton'.static.functionName();`

      1. GetRef(Actor referenceToUseForSpawn)
        * Returns **`Botpack.FontInfo`**
        * Gets a singleton reference without instantiating multiple
    </details>

    <details>
      <summary>NameObj</summary>
      A subclass of `LGDUtilities.ValueContainer`, which is a wrapper class for non-object values to be used in `LGDUtilities.LinkedList` and `LGDUtilities.ListElement`. This subclass is for **Name** values.
    </details>

    <details>
      <summary>NetworkHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.NetworkHelper'.static.functionName();`

      ## Available Functions
      1. GetNMT(float f)
        * Returns **float**
        * Used to get NETWORK MOVE TIME for a given mover, given an input amount of time to move a particular mover
        * FETCHED from: https://ut99.org/viewtopic.php?f=15&t=12985&sid=ac656310d36baab639b0fd591518ae17
    </details>

    <details>
      <summary>PawnHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.PawnHelper'.static.functionName();`

      ## Available Functions
      1. GetEyeHeight(Pawn Other)
        * Returns **float**
        * Calculates the eye-height of a given `Pawn`
      2. GetOffsetAbovePawn(Pawn p)
        * Returns **Vector**
        * Calculates the position **ABOVE** a given pawn based on colliders (relative to the pawn location)
      3. GetAbovePawn(Pawn p)
        * Returns **Vector**
        * Calculates the position **ABOVE** a given pawn based on colliders in **global** space
      4. HealPawn(Pawn p, int HealingAmount, sound HealSound, string HealMessage)
        * Heals a given `Pawn` by the given `HealingAmount`, and plays a sound with a given message when healed
        * Based o code from `Botpack.TournamentHealth[State=Pickup].Touch`
      5. IsBoss(Pawn p)
        * Returns **bool**
        * Determines if the given `Pawn` is a considered a **BOSS** by ut99.
        * This is generally used to check for **XAN**
      6. PredictDamageToPawn(Pawn Target,
    int Damage, Pawn InstigatedBy, Vector HitLocation,
    Vector Momentum, name DamageType)
      * Returns **int**
      * Using given variables, will **PREDICT** damage a pawn will take
      * Generally used to see if a particular damage conext will kill a pawn
      * Based on code from `Pawn.TakeDamage()`
    7. GetPawnFromPlayerID(Actor context, int PlayerID)
      * Returns **Pawn**
      * Iterates through all pawns, looking for one with the given PlayerID
    8. GetRandomPlayerPawnOrBot(Actor context, optional LinkedList PlayerIDsToExclude)
      * Returns **Pawn**
      * Randomly selects a pawn / bot amongst all currently in the match
      * Can **EXCLUDE** specific pawns from consideration based on a list of PlayerIDs (denoted by the parameter `PlayerIDsToExclude`)
    9. GetAllPawnsOfTeam(Actor context, byte Team)
      * Returns **`LGDUtilities.LinkedList`**
      * Gets all pawns with a given team byte value (checked using: PlayerReplicationInfo.Team)
    10. GetBestScoringPawnOfTeam(Actor context, byte Team, optional bool limitByIsPlayer)
      * Returns **Pawn**
      * Gets the pawn on a given team, with the highest score
      * Can optionally limit all p[awns by `Pawn.bIsPlayer`
    11. GetAllPlayeIDsOfTeam(Actor context, byte Team)
      * Returns **`LGDUtilities.LinkedList`**
      * Gets every PlayerID of all `Pawns` on a given team (checked using: PlayerReplicationInfo.Team)
    12. IsPawnDead(Pawn p)
      * Returns **bool**
      * Returns whether the pawn is considered dead
      * Is useful for when a pawn isn't deleted, but is hidden / is a spectator
    </details>

    <details>
      <summary>PlayerDeathLocationMarker</summary>
      A class that will be spawned by `LGDUtilities.PlayerDeathLocationMutator` when a player dies.

      This will use `LGDUtilities.IndicatorHUD` to display this marker to others.
    </details>

    <details>
      <summary>PlayerModifier</summary>
      An Actor meant to test modifying player variables during a match / on a map.

      Is a config object used for setting up 'LGDUtilities.TestPlayerModifierMutator'.
    </details>

    <details>
      <summary>PlayerSpawnMutatorCallback</summary>
      A callback object used for `LGDUtilities.PlayerSpawnMutator` to execute code based on login / spawn of a player in a match.

      Is meant to be subclassed. 
    </details>

    <details>
      <summary>PlayerSpawnNotify</summary>
      An actor that is meant to be used programmatically to listen for spawn events of `Engine.PlayerPawn`.

      **Static Fuctions**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.PlayerSpawnNotify'.static.functionName();`

      ## Available Functions
      1. RegisterForPlayerSpawnEvent(Actor context, PlayerSpawnNotifyCallback callback)
        * Registers the given callback object to be executed when a `PlayerPawn` is spawned
    </details>

    <details>
      <summary>PlayerSpawnNotifyCallback</summary>
      A callback for `LGDUtilities.PlayerSpawnNotify` for executing code when a `PlayerPawn` spawns.

      Is meant to be subclassed.
    </details>

    <details>
      <summary>PracticeBot</summary>
      A test bot to be able to spawn with custom behaviors.

      Not much is different from `Botpack.TMale2Bot`.
    </details>

    <details>
      <summary>ProjectileHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.ProjectileHelper'.static.functionName();`

      ## Available Functions
      1. DeleteProjectilesOfClass(Actor context, name projClass)
        * Returns **int**
        * Destroys all projectiles of a given class using `Actor.IsA()`
        * Is generally used for cleanup of projectiles that are not wanted for a weapon
        * Used also for `HeadHunter.HeadHunterGameInfo` to clean up 'HeadHunter.SkullItemProj'
    </details>

    <details>
      <summary>Quat</summary>
      An object that represents a Quaternion.
    </details>

    <details>
      <summary>QuatHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.QuatHelper'.static.functionName();`

      ## Available Functions
      1. RotationToQuat(Vector Axis, float Theta)
        * Returns **`LGDUtilities.Quat`**
        * Converts an UnrealRotation to a Quaternion
    </details>

    <details>
      <summary>RandomHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.RandomHelper'.static.functionName();`

      ## Available Functions
      1. fRandom_Seed(float Scale, out int RandomSeed)
        * Returns **float**
        * Generates a semi random number based on a given seed
        * The seed is updated
        * Range is from -1 to 1
      2. GetRandomRotation()
        * Returns **Rotation**
        * Generates a random UnrealRotation.
      3. GetRandomRotationWithLimits(optional int maxPitch, optional int maxYaw, optional int maxRoll)
        * Returns **Rotation**
        * Generates a random UnrealRotation.
        * Limits the rotation based in given max values for pitch, yaw, and roll
    </details>

    <details>
      <summary>RandomTrigger</summary>
      A custom trigger for randomly activating itself given configured variables for the ratio of `Successes` out of `OutOfTotal`.
    </details>

    <details>
      <summary>:warning: RedTrigger :warning:</summary>
      Is merely a test of `LGDUtilities.CallbackFnObject` for use in the test map `1HH-TestBox-Large.unr`.
    </details>

    <details>
      <summary>RicochetShockProj</summary>
      The alt-fire projectile class of `LGDUtilities.WeaponStealingShockRifle`.
    </details>

    <details>
      <summary>RotatorHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.RotatorHelper'.static.functionName();`

      ## Available Functions
      1. AlphaRotation(Rotator End, Rotator Start, float Alpha)
        * Returns **Rotator**
        * Calculates a mid-point rotation between 2 given rotations
        * The alpha value ranges from 0.0 -> 1.0 and is a blend variable of what percentage to go from `Start` and to `End` (similar to other Lerp functions)
      2. RandomlyVaryRotation(Rotator RotationToVary, float VaryYawByDegrees, float VaryPitchByDegrees, float VaryRollByDegrees)
        * Returns **Rotator**
        * Will randomly vary a given rotation by a certain amount of degrees for each pitch, yaw, and roll
      3. RandomRotationByDegrees(float MaxYawByDegrees, float MaxPitchByDegrees, float MaxRollByDegrees)
        * Returns **Rotator**
        * Creates a random rotation, limited by maximum degrees of pitch, yaw and roll
      4. RotatorToString(Rotator r, optional bool convertToDegrees)
        * Returns **string**
        * Converts a given rotator to a string representation
      5. LerpRotation(Rotator From, Rotator To, float Percent)
        * Returns **Rotator**
        * Linearly Interpolates a given rotator `From` a % closer to `To` based on `Percent`
      6. rTurn(Rotator rHeading, Rotator rTurnAngle)
        * Returns **Rotator**
        * Rotates one rotator by another.
      7. RotateActorUpDownLeftRightByDegrees(Actor Target, int DegreesUp, int DegreesRight)
        * Rotates a given Actor denoted by `Target` up/down by given degrees
      8. RotatorFromVectorOfDegrees(Vector VectorOfDegrees)
        * Returns **Rotator**
        * Constructs a **Rotator** given a **Vector**
        * Uses the vector components in the order of (X, Y, Z) as a Rotators components (Pitch, Roll, and Yaw) -- In that order.

      ## Also defines operators string concatenations of Rotators
        * $=, @=, $ and @
    </details>

    <details>
      <summary>SawtoothFunction</summary>
      A subclass of `LGDUtilities.TimeFunction` for use with `LGDUtilities.PatternLight`.

      This function is a standard sawtooth function: /| /| /|
    </details>

    <details>
      <summary>ServerHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.ServerHelper'.static.functionName();`

      ## Available Functions
      1. IsPackageNameInServerPackages(Actor context, string PackageNameToLookFor)
        * Returns **bool**
        * Checks if a given package name, given by `PackageNameToLookFor` is available in ServerPackages.
      2. GetAllWeaponClasses(Actor context, optional bool OnlyIncludeBaseWeapons, optional bool ExcludeChaosUTWeapons, optional bool bLogToGameLogfile)
        * Returns **`LGDUtilities.LinkedList`**
        * Gets a list of all weapon classes the game is aware of
      3. GetClassesLoadedFromIntFiles(Actor context, string IntMetaClassToCompareTo, optional bool LoadClasses, optional int MaxClassIntNum, optional bool bLogToGameLogfile)
        * Returns **`LGDUtilities.LinkedList`**
        * Gets classes that are defined in Unreal **.int** files
    </details>

    <details>
      <summary>SinFunction</summary>
      A subclass of `LGDUtilities.TimeFunction` for use with `LGDUtilities.PatternLight`.

      This function is a standard sign function
    </details>

    <details>
      <summary>SingletionActor</summary>
      An actor that can be used as a singleton (ensures **ONLY ONE** instance exists at one time).

      This actor takes advantage of a "hack" by modifying the **DEFAULT** value of a variable.

      **Static Methods**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.SingletionActor'.static.functionName();`

      ## Available Functions
      1. GetRef(Actor referenceToUseForSpawn)
        * Returns **`LGDUtilities.SingletionActor`**
        * Gets s reference to this singleton, and ensures only one instance is active at one time.
    </details>

    <details>
      <summary>SoundHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.SoundHelper'.static.functionName();`

      ## Available Functions
      1. DynamicLoadSound (out Sound SoundObj, string SoundPackage, string SoundName)
        * Returns **Sound**
        * Loads a sound given a package name and sound name as a string
      2. ClientPlaySound(PlayerPawn pp, sound ASound, optional bool bInterrupt, optional bool bVolumeControl, optional float VolumeLevel)
        * Play a sound client side (so only client will hear it) -- this is forced due to this function being simulated
      3. GlobalPlaySound(PlayerPawn pp, sound ASound, optional bool bInterrupt, optional bool bVolumeControl, optional float VolumeLevel)
        * Play a sound that can be replicated (so ALL clients will hear it)
    </details>

    <details>
      <summary>SqWaveFunction</summary>
      A subclass of `LGDUtilities.TimeFunction` for use with `LGDUtilities.PatternLight`.

      This function is a square wave function: |-|_|-|_
    </details>

    <details>
      <summary>StealShockBeam</summary>
      A primary-fire projectile for the weapon `LGDUtilities.WeaponStealingShockRifle`.
    </details>

    <details>
      <summary>StringHelper</summary>
      **Static Helper Class**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.StringHelper'.static.functionName();`

      ## Available Functions
      1. ReplaceText(out string Text, string Replace, string With)
        * Replaces text in the given string `Text` that matches `Replace` with the string value of `With`
      2. Split(string str, string div, bool bDiv)
        * Returns **array<string>**
        * Splits a given string along dividers, and conditionally removes the dividers
        * Fetched from: https://wiki.beyondunreal.com/Legacy:Useful_String_Functions
      3. ClearSpaces(string Text)
        * Returns **String**
        * Removes spaces from the given string
        * Fetched from: https://github.com/CacoFFF/SiegeIV-UT99/blob/master/Classes/SiegeStatics.uc
      4. GetPackageNameFromQualifiedClass(string ClassNameStr)
        * Returns **String**
        * Given a fully qualified class name, will return the package name
      5. RemovePackageNameFromQualifiedClass(string ClassNameStr)
        * Returns **String**
        * Given a fully qualified class name, will **REMOVE** the package name
    </details>

    <details>
      <summary>StringObj</summary>
      A subclass of `LGDUtilities.ValueContainer`, which is a wrapper class for non-object values to be used in `LGDUtilities.LinkedList` and `LGDUtilities.ListElement`. This subclass is for **String** values.
    </details>

    <details>
      <summary>StringToNameHelper</summary>
      An `Actor` that is used to convert a **String** value to a **Name** type.

      This uses a "hack" by `Actor.SetPropertyText()` and setting a **Name** type variable of an instance of an **Actor**.
    </details>

    <details>
      <summary>Tester</summary>
      A class to be used for setting up tests, in a test map, for mods, scripts, interactions, etc. 

      Is meant to be subclassed, and invokes tests in the following methods, and in the order:

      1. PreBeginPlay
        * `StandUp()` is executed here
        * `PreBeginPlayTests()` is executed next
      2. BeginPlay
        * `BeginPlayTests()` is executed here
      3. PostBeginPlay
        * `PostBeginPlayTests()` is executed here
      
      ## When **Actor** is destroyed, `Destroyed()` is called and then `Teardown()` is invoked to cleanup tests

    </details>

    <details>
      <summary>Tester1</summary>
      A tester class in use on the mod map `1HH-TestBox-Large.unr` for basic tests. 

      Is meant to demonstrate basic usage of the `LGDUtilities.Tester` class.
    </details>

    <details>
      <summary>TesterCache</summary>
      Is a singleton class meant to cache and be aware of test class instances. Is meant for easy signaling / instance management during testing. 

      **Static Functions**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.TesterCache'.static.functionName();`

      1. GetRef(Actor referenceToUseForSpawn)
        * Returns **`LGDUtilities.TesterCache`**
        * Gets and manages the instance of this classs in a game match
        * Ensures only one instance is available at one time
      2. HasATesterLoaded(Actor context)
        * Returns **bool**
        * Checks if a tester has been found on the map
        * Is meant for logic to check if it's in a testing context (so it can know to avoid certain actions / affect the game state)

    </details>
    
    <details>
      <summary>TestMatchMessage</summary>
      Is the game message class for 'LGDUtilities.TestMatchPlus'.
    </details>

    <details>
      <summary>:warning: TestMatchPlus :warning:</summary>
      A copy of `Botpack.DeathMatchPlus` that is used for testing out different ideas.

      :x: Is not currently different than `Botpack.DeathMatchPlus`, and is meant as a starting point for future testing-oriented gametypes.
    </details>
    
    <details>
      <summary>TestMessagePlus</summary>
      Is the player death message class for `LGDUtilities.TestMatchPlus`.
    </details>

    <details>
      <summary>TestPlayerModifierMutator</summary>
      Is a player mutator for testing purposes. Can modify damage between players, bots and various scenarios.

      Uses an instance of 'LGDUtilities.PlayerModifier' as settings for what behavior to modify about p[layers in the match.

      **Static Functions**
      To access functions in this class use the following syntax:
      `class'LGDUtilities.TestPlayerModifierMutator'.static.functionName();`

      1. SpawnAndRegister(Actor context, PlayerModifier modifierActor)
        * Returns **`LGDUtilities.TestPlayerModifierMutator`**
        * Is to be used programmafically (eg: in a gametype / mutator / in an Actor's `PreBeginPlay()`) to instantiate and register this mutator. 
        * Instantiate `LGDUtilities.PlayerModifier` and change its variables to configure how this mutator behaves.

        ## :warning: Be aware that it can get tricky if you register multiple of this mutator -- **This is NOT a Singleton**
    </details>

    <details>
      <summary>TimeFunction</summary>
      A class meant to be **subclassed** and used with `LGDUtilities.PatternLight`.

      Represents a function, if given an X input, which is represented via a time value, and outputs a Y value.

      The function should be **continuous** or issues can arise.

      ## The time function's output should be in the range of: [0.0, 1.0]. 

      ## :warning: Values outside of this rangfe can yield odd results. Be wary of that when creating functions.
    </details>

    <details>
      <summary></summary>

    </details>

    <details>
      <summary></summary>

    </details>
  </details>

  <details>
    <summary>Map Actors</summary>
    <details>
      <summary>ActorNearbyTrigger</summary>
      Given an actor, a number, and a "comparison" denoted by variable `QuantityComparison` (which is an enum of type `ActorNearbyTrigger.ANT_COMPARISON`), this trigger will use it's collider dimensions to check if the actor exists nearby with the specified quantity comparison (once a second).

      ## Actor Parameters
      1. ActorsNeeded
        * Array of struct `ActorNearbyTrigger.ActorNeeded`
        * Has fields for ActorClass, ActorTag, NumberNeeded, QuantityComparison
    </details>
  </details>

  <details>
    <summary>IndicatorHudMapTarget</summary>
    An `Actor` that can be added to a map to set up a target for `LGDUtilities.IndicatorHUD`.
    Has same variables as `LGDUtilities.IndicatorSettings`.

    ## Actor Variables
    1. ShowIndicatorToHudOwnerTeamNum
      * Whether to show the indicator to player HUDs that are the same team as specified by `LGDUtilities.IndicatorHudMapTarget.IndicatorVisibleToTeamNum`
    2. IndicatorVisibleToTeamNum
      * The team number (Range: 0 - 255) to limit the visibility of the indicator to
    3. TargetsWithGroup
      * The group to find targets to show an indicator for
    4. TargetsWithTag
      * The tag to find targets to show an indicator for
    5. TargetsWithName
      * The name to find targets to show an indicator for
    6. TargetsOfClassType
      * The class to find targets to show an indicator for

    ## The group, tag, name and class type are all combined using **AND** to find targets

    7. GlobalIndicator
      * Whether the indicator for the target(s) is **GLOBAL** or not
    8. BuiltinIndicatorTexture
      * The `byte` value of the enum `LGDUtilities.IndicatorHUD.HUDIndicator_Texture_BuiltIn`
    9. MaxViewDistance
      * The maximum distance the indicator is visible
    10. IndicatorOffsetFromTarget
      * The `Vector` offset of the indicator from the target(s)
    11. UseHUDColorForIndicator
      * Whether to use the player's HUD color for the indicator color
    12. UseCustomColor
      * Whether to use a custom color for the indicator(s)
    13. IndicatorColor
      * The `Color` of the indicator to use, if `UseCustomColor` is **TRUE**
    14. ShowTargetDistanceLabels
      * Whether to show an extra label denoting the distance to the target from the owner of the given HUD
      * Only shown if `ShowIndicatorLabel` is **TRUE**
    15. IndicatorLabel
      * The text of the label for the indicator(s)
    16. ShowIndicatorLabel
      * Whether to show a label for the indicator(s)
      * Only shown if `ShowIndicatorLabel` is **TRUE**
    17. UseTargetNameForLabel
      * When showing a label for the indicator(s), whether to use the target's name
    18. ScaleIndicatorSizeToTarget
      * Whether to scale the indicator(s) to each target's size on the HUD (to have a nice size aligned to the target)
    19. StaticIndicatorPercentOfMinScreenDimension
      * Used to ensure the scale of the indicator is a **STATIC** percentage of the screen's **MINIMUM/SMALLEST** dimension.
      * Only takes affect if `LGDUtilities.IndicatorHudMapTarget.ScaleIndicatorSizeToTarget` is **FALSE**
    20. StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen
      * Used to ensure the scale of the indicator is a **STATIC** percentage of the screen's **MINIMUM/SMALLEST** dimension, when the target is **OFF SCREEN**.
      * Only takes affect if `LGDUtilities.IndicatorHudMapTarget.ScaleIndicatorSizeToTarget` is **FALSE**
    21. ShowIndicatorWhenOffScreen
      * Whether to show the indicator when the target is **OFF SCREEN** or not
    22. ShowIndicatorIfTargetHidden
      * Whether to show the indicator if the target actor is hidden
    23. ShowIndicatorIfInventoryHeld
      * Whether to show the target inventory indicator if a player is holding it
    24. ShowIndicatorIfInventoryNotHeld
      * Whether to show the target inventory indicator if a player is **NOT** holding it (but **NOT** dropped by a player)
    25. ShowIndicatorIfInventoryDropped
      * Whether to show the target inventory indicator if it was **DROPPED** by a player
    26. ShowIndicatorsThatAreObscured
      * Whether to show indicators from targets that are **NOT** in eye-sight of the player
    27. BlinkIndicator
      * Whether to blink the indicator on the player's HUD
    28. BaseAlphaValue
      * The default **ALPHA** value for the given indicator
    29. ShowIndicatorAboveTarget
      * Whether to show the indicator above the target (instead of centered on it)
    30. IndicatorLabelsAboveIndicator
      * Whether to show indicator labels **ABOVE** the indicator (instead of below, the **default**)
  </details>

  <details>
    <summary>InventoryTrigger</summary>
    A trigger actor that when a player/pawn collides with it, it will check their inventory for items/counts (based on a `InventoryObjectsNeeded` parameter).

    ## Actor Custom Enum
    1. IT_COMPARISON
      * IT_EQUALS
    	* IT_LESS_THAN
    	* IT_GREATER_THAN
    	* IT_LESS_THAN_OR_EQUALS
    	* IT_GREATER_THAN_OR_EQUALS

    ## Actor Custom Structs
    1. InventoryObjectNeeded
      * class<Inventory> InvClass
      * int NumberNeeded
      * bool RemoveUponTrigger
      * bool CompareAmmoInstead
        * If a weapon with ammo, how much is needed
      * IT_COMPARISON QuantityComparison
        * How to compare the given item / NumberNeeded

    ## Actor Variables
    1. InventoryObjectsNeeded[32]
      * The config of objects needed for a pawn to activate this trigger
    2. InsufficientCountMessage
      * The message that's displayed when a player doesn't have the necessary items/counts
    3. Message (provided by Trigger super-class)
  </details>

  <details>
    <summary>Key</summary>
    A basic object, with a key mesh. Is made to add unique items to maps, and used in conjunction with the `LGDUtilities.InventoryTrigger`. Also planned to be used with `LGDUtilities.InventoryToolbelt`.
  </details>

  <details>
    <summary>Keycard</summary>
    A basic object, with a keycard mesh. Is made to add unique items to maps, and used in conjunction with the `LGDUtilities.InventoryTrigger`. Also planned to be used with `LGDUtilities.InventoryToolbelt`.
  </details>

  <details>
    <summary>LookTrigger</summary>
    A trigger actor that relies on the user colliding with it to trigger a HUD indicator, for which if looked at for a certain time, will activate the trigger.

    ## Actor Variables
    1. ScaleIndicatorSizeToTarget
      * Whether to scale the look indicator to the target
      * Same as `LGDUtilities.IndicatorSettings.ScaleIndicatorSizeToTarget`
    2. StaticIndicatorPercentOfMinScreenDimension
      * Used to ensure the scale of the indicator is a **STATIC** percentage of the screen's **MINIMUM/SMALLEST** dimension.
      * Same as `LGDUtilities.IndicatorSettings.StaticIndicatorPercentOfMinScreenDimension`
    3. UseHudColorForIndicator
      * Whether to use the player's HUD for the indicator color
    4. ShowIndicatorWhenObscured
      * Whether to show the indicator if the target is not in line of site
    5. IndicatorOffsetFromTriggerActor
      * The offset from the target that the indicator should be displayed
    6. IndicatorColor
      * The color of the indicator (unless overridden by `UseHudColorForIndicator`)
    7. ShowLookMessage
      * Whether to show a message to explain / help the user look at the target
    8. LookMessage
      * The message to show if `ShowLookMessage` is true
    9. ShowTargetLookCircle
      * Show a small circle for the player, so they can use that to center inside the indicator to activate the trigger (like a crosshair / reticle)
    10. ShowTimeLookedAt
      * Show the elapsed time the player has looked at the target
    11. ShowTimeRemaining
      * Show time remaining to look, in order to activate the trigger
    12. ShowTimeCountingDown
      * Show the time remaining as a counter, counting down
    13. ShowMessagesAfterActivated
      * Show the player a message after the trigger is activated
    14. ShowRetriggerCooldownMessage
      * Show a message when the trigger needs to cooldown before attempting to reactivate
    15. ShowCooldownTime
      * Show the time to cooldown, before allowing the trigger to be looked at / trigger activation
    16. ShowCooldownTimeRemaining
      * Show the cooldown time as time remaining
    17. LookTimeToTrigger
      * How long a player needs to look at the indicator to activate the trigger
    18. BaseAlphaValue
      * The base / default alpha value for the indicator the player is supposed to look at
  </details>

  <details>
    <summary>PatternLight</summary>
    An actor that is used to blink a light based upon a pattern specified by a `LGDUtilities.TimeFunction` object.
  </details>

  <details>
    <summary></summary>

  </details>
</details>



<details>
  <summary></summary>
  1.
</details>
