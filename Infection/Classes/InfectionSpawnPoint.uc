//=============================================================================
// Player respawn location for Infection.
//=============================================================================
class InfectionSpawnPoint extends SpawnPoint;

var(Infection) bool ZombieSpawn;
var(Infection) bool HumanSpawn;

#exec Texture Import File=Textures\Icons\Inf_S_SpawnP.bmp Name=Inf_S_SpawnP Mips=Off Flags=2

defaultproperties {
      Texture=Texture'Infection.Inf_S_SpawnP'
	  ZombieSpawn=True
	  HumanSpawn=True
}
