class WeaponStealingShockBeam expands Actor;

#exec MESH IMPORT MESH=WeaponStealingShockBeam ANIVFILE=MODELS\WeaponStealingShockBeam_a.3d DATAFILE=MODELS\WeaponStealingShockBeam_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=WeaponStealingShockBeam X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=WeaponStealingShockBeam SEQ=All STARTFRAME=0 NUMFRAMES=30
//#exec MESH SEQUENCE MESH=WeaponStealingShockBeam SEQ=??? STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP NEW MESHMAP=WeaponStealingShockBeam MESH=WeaponStealingShockBeam
#exec MESHMAP SCALE MESHMAP=WeaponStealingShockBeam X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jtex1 FILE=texture1.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=Jtex1 FILE=texture1.pcx GROUP=Skins PALETTE=Jtex1
#exec MESHMAP SETTEXTURE MESHMAP=WeaponStealingShockBeam NUM=1 TEXTURE=Jtex1

defaultproperties
{
    DrawType=DT_Mesh
    Mesh=WeaponStealingShockBeam
}
