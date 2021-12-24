@ECHO OFF
cd %~dp0\System
del /f HeadHunter.u
del /f Gibber.u
del /f ItemSpawnerWeapon.u
del /f C4.u
del /f Juggernaut.u
del /f UnrealTournament.log
copy NUL UnrealTournament.log
ucc make
cd ..
