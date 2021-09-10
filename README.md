# Ut99Mods
A collection of my hand-made mods for one of my my favorite games - Unreal Tournament '99! 

# Setup
To compile, navigate to the ut99 directory with UCC.exe and run `ucc make`.

**Alternatively** 

You can set up "doskey" to have macro commands in CMD. 
Modify macros.doskey to point to your ut99 directories.

Copy macros.doskey file to a location on C:

Run this:

    reg add "HKCU\Software\Microsoft\Command Processor" /v Autorun /d "doskey /macrofile=\"C:\doskey\macros.doskey\"" /f

This will force the doskey script to run on every instance of cmd.

Verify using:

    reg query "HKCU\Software\Microsoft\Command Processor" /v Autorun

**Then**

Add the relevant packages to your **UnrealTournament.ini** in the Ut99/System folder.

Look for the `[Editor.EditorEngine]` section, and the EditPackages entries. 

Add the following to the end of them:

    EditPackages=HeadHunter
    EditPackages=Gibber
    EditPackages=ItemSpawnerWeapon
    EditPackages=C4

# Useage

To merely use the pre-compiled packages, look in the System folder, and copy the **.u** and **.int** files to your Ut99/System directory. 

Then load up the game, and look at the relevant test map, as well as the included mutators. 

To use them in your own custom maps, they need to be in **EditPackages** or loaded manually in the editor.
