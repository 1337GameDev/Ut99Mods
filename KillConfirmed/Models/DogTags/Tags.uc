class Tags expands Actor;

#exec MESH IMPORT MESH=Tags ANIVFILE=MODELS\Tags_a.3d DATAFILE=MODELS\Tags_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Tags X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Tags SEQ=All STARTFRAME=0 NUMFRAMES=30
//#exec MESH SEQUENCE MESH=Tags SEQ=??? STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP NEW MESHMAP=Tags MESH=Tags
#exec MESHMAP SCALE MESHMAP=Tags X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jtex1 FILE=texture1.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=Jtex1 FILE=texture1.pcx GROUP=Skins PALETTE=Jtex1
#exec MESHMAP SETTEXTURE MESHMAP=Tags NUM=1 TEXTURE=Jtex1

defaultproperties
{
    DrawType=DT_Mesh
    Mesh=Tags
}
