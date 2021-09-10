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

defaultproperties {
     RemoteRole=ROLE_None,
     Mesh=LodMesh'Botpack.BioGelm',
     Skin=Texture'ItemSpawnerWeapon.Skins.GhostTextureChecker',
     Multiskins(1)=Texture'ItemSpawnerWeapon.Skins.GhostTextureChecker',
     bUnlit=true,
     bNoSmooth=true,
     bBounce=false,
     SoundRadius=16,
     CollisionRadius=1,
     CollisionHeight=1,
     bCollideActors=true,
     bCollideWorld=true,

     Mass=1,
     Physics=PHYS_None,
     DrawType=DT_Mesh,
     Style=STY_Translucent,
	 UpdateIntervalSecs=0.1
}

