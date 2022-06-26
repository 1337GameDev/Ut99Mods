//=============================================================================
// Key
//=============================================================================
class Keycard extends Pickup;
#exec MESH IMPORT MESH=Keycard ANIVFILE=MODELS\Keycard\Keycard_a.3D DATAFILE=MODELS\Keycard\Keycard_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Keycard X=0 Y=0 Z=0

#exec TEXTURE IMPORT NAME=Keycard FILE=Textures\Keycard\keycard.bmp GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=KeycardIcon FILE=Textures\Keycard\KeycardIcon.bmp GROUP=Icons FLAGS=2

#exec MESHMAP SCALE MESHMAP=Keycard X=0.02 Y=0.02 Z=0.04
#exec MESHMAP SETTEXTURE MESHMAP=Keycard NUM=1 TEXTURE=Keycard

#exec AUDIO IMPORT FILE="Sounds\Keycard\beep1.wav" NAME="KeycardPickup" GROUP="Keycard"

function PickupFunction(Pawn Other) {
    BroadCastMessage("Keycard: PickupFunction");
}

defaultproperties {
      bCanHaveMultipleCopies=True
      PickupMessage="You picked up a keycard!"
      ItemName="Keycard"
      PickupViewMesh=LodMesh'LGDUtilities.Keycard'
      PickupSound=Sound'LGDUtilities.Keycard.KeycardPickup'
      Icon=Texture'LGDUtilities.Icons.KeycardIcon'
      Skin=Texture'LGDUtilities.Skins.Keycard'
      Mesh=LodMesh'LGDUtilities.Keycard'
      SoundRadius=16
      CollisionRadius=18.000000
      CollisionHeight=15.000000
      Mass=5.000000
}
