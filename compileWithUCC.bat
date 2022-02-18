@ECHO OFF
cd %~dp0\System
del /f HeadHunter.u
del /f Gibber.u
del /f ItemSpawnerWeapon.u
del /f C4.u
del /f Juggernaut.u
del /f EnergySword.u
del /f Infection.u
del /f GuidedEnergyLance.u
del /f UnrealTournament.log
copy NUL UnrealTournament.log
ucc make
cd ..
