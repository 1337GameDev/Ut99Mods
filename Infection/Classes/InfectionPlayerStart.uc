//=============================================================================
// Player start location for Infection.
//=============================================================================
class InfectionPlayerStart extends PlayerStart;

var(Infection) bool ZombieSpawn;
var(Infection) bool HumanSpawn;

#exec Texture Import File=Textures\Icons\Inf_S_Player.bmp Name=Inf_S_Player Mips=Off Flags=2

defaultproperties {
    Texture=Texture'Infection.Inf_S_Player'
	  ZombieSpawn=True
	  HumanSpawn=True
}
