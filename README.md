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
  <summary>Infection (Gametype)</summary>
  
  ## Heading
  1. A numbered
  2. list
     * With some
     * Sub bullets
</details>
