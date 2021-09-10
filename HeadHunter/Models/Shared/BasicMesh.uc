class BasicMesh expands Actor;

#exec MESH IMPORT MESH=BasicMesh ANIVFILE=MODELS\BasicMesh_a.3d DATAFILE=MODELS\BasicMesh_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=BasicMesh X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=BasicMesh SEQ=All STARTFRAME=0 NUMFRAMES=30
//#exec MESH SEQUENCE MESH=BasicMesh SEQ=??? STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP NEW MESHMAP=BasicMesh MESH=BasicMesh
#exec MESHMAP SCALE MESHMAP=BasicMesh X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jtex1 FILE=texture1.pcx GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=Jtex1 FILE=texture1.pcx GROUP=Skins PALETTE=Jtex1
#exec MESHMAP SETTEXTURE MESHMAP=BasicMesh NUM=1 TEXTURE=Jtex1

defaultproperties
{
    DrawType=DT_Mesh
    Mesh=BasicMesh
}
