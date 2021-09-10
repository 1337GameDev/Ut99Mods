//=============================================================================
// Key
//=============================================================================
class Key extends Pickup;
#exec MESH IMPORT MESH=Key ANIVFILE=MODELS\Key\Key_a.3D DATAFILE=MODELS\Key\Key_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Key X=0 Y=0 Z=0

#exec TEXTURE IMPORT NAME=Key1 FILE=Textures\Key\bronze1.bmp GROUP=Skins FLAGS=2

#exec MESHMAP SCALE MESHMAP=Key X=0.02 Y=0.02 Z=0.04
#exec MESHMAP SETTEXTURE MESHMAP=Key NUM=1 TEXTURE=Key1

#exec AUDIO IMPORT FILE="Sounds\Key\KeyPickup.wav" NAME="KeyPickup" GROUP="Key"

function PickupFunction(Pawn Other) {
    BroadCastMessage("Key: PickupFunction");
}

defaultproperties {
     bCanHaveMultipleCopies=true,
     PickupMessage="You picked up a key!",
     RespawnTime=0,
     PickupViewMesh=Mesh'HeadHunter.Key',
     ItemName="Key",
     PickupSound=Sound'HeadHunter.Key.KeyPickup',
     RemoteRole=ROLE_SimulatedProxy,
     Mesh=LodMesh'HeadHunter.Key',
     Skin=Texture'HeadHunter.Skins.Key',
     Icon=Texture'UnrealShare.Icons.ICONSKULL',
     SoundRadius=16,
     CollisionRadius=18.000000,
     CollisionHeight=15.000000,
     Mass=5.000000
}

