class Skull expands Actor;

#exec MESH IMPORT MESH=Skull ANIVFILE=MODELS\Skull_a.3d DATAFILE=MODELS\Skull_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Skull X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Skull SEQ=All STARTFRAME=0 NUMFRAMES=30
//#exec MESH SEQUENCE MESH=Skull SEQ=??? STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP NEW MESHMAP=Skull MESH=Skull
#exec MESHMAP SCALE MESHMAP=Skull X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jtex1 FILE=texture1.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=Jtex1 FILE=texture1.pcx GROUP=Skins PALETTE=Jtex1
#exec MESHMAP SETTEXTURE MESHMAP=Skull NUM=1 TEXTURE=Jtex1

defaultproperties
{
    DrawType=DT_Mesh
    Mesh=Skull
}
