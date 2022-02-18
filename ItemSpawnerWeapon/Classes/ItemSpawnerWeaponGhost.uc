//=============================================================================
// ItemSpawnerWeaponGhost - The ghost mesh indicator for where an item will spawn
//=============================================================================
class ItemSpawnerWeaponGhost extends Actor nousercreate;

var ItemSpawnerWeapon SpawnerWeapon;
var float UpdateIntervalSecs;
var float CurrentTimeInterval;

#exec TEXTURE IMPORT NAME=GhostTextureChecker FILE=Textures\GhostTextureChecker.bmp GROUP="Skins" FLAGS=2 MIPS=OFF

function Destroyed(){
	Super.Destroyed();
    SpawnerWeapon = None;
}

simulated function UpdateGhostObject(Mesh mesh, float NewCollisionRadius, float NewCollisionHeight){
    Self.Mesh = mesh;
    Self.SetCollisionSize(FMax(1,NewCollisionRadius), FMax(1,NewCollisionHeight));
}

simulated function Tick(float DeltaTime) {
	CurrentTimeInterval += DeltaTime;

	if(CurrentTimeInterval >= UpdateIntervalSecs) {
		CurrentTimeInterval = 0;

		if((SpawnerWeapon == None) || SpawnerWeapon.bDeleteMe){
			Destroy();
		} else if(!SpawnerWeapon.bCarriedItem || SpawnerWeapon.Owner == None){
		    SpawnerWeapon.DestroyGhost();
		}
	}
}

defaultproperties
{
      SpawnerWeapon=None
      UpdateIntervalSecs=0.100000
      CurrentTimeInterval=0.000000
      RemoteRole=ROLE_None
      DrawType=DT_Mesh
      Style=STY_Translucent
      Skin=Texture'ItemSpawnerWeapon.Skins.GhostTextureChecker'
      Mesh=LodMesh'Botpack.BioGelm'
      bUnlit=True
      bNoSmooth=True
      MultiSkins(1)=Texture'ItemSpawnerWeapon.Skins.GhostTextureChecker'
      SoundRadius=16
      CollisionRadius=1.000000
      CollisionHeight=1.000000
      bCollideActors=True
      bCollideWorld=True
      Mass=1.000000
}
