//=============================================================================
// DogTagItemVisuals
//=============================================================================
class DogTagItemVisuals extends Decoration;

//LODSTYLE=12
#exec MESH IMPORT MESH=DogTag ANIVFILE=Models\DogTags\Tags_a.3D DATAFILE=Models\DogTags\Tags_d.3D X=0 Y=0 Z=0 LODSTYLE=12
#exec MESH LODPARAMS MESH=DogTag STRENGTH=0.0
#exec MESHMAP SCALE MESHMAP=DogTag X=0.2 Y=0.2 Z=0.4

#exec MESH ORIGIN MESH=DogTag X=0 Y=0 Z=0

#exec TEXTURE IMPORT NAME=DogTags FILE=Textures\DogTags\DogTags.bmp GROUP="DogTags" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=DogTagsGreen FILE=Textures\DogTags\DogTags_Green.bmp GROUP="DogTags" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=DogTagsRed FILE=Textures\DogTags\DogTags_Red.bmp GROUP="DogTags" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=DogTagsBlue FILE=Textures\DogTags\DogTags_Blue.bmp GROUP="DogTags" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=DogTagsYellow FILE=Textures\DogTags\DogTags_Yellow.bmp GROUP="DogTags" FLAGS=2 MIPS=OFF
#exec MESHMAP SETTEXTURE MESHMAP=DogTag NUM=1 TEXTURE=DogTags

var bool bLogToGameLogfile;
var Texture DogTagsNeutralTexture;
var Texture DogTagsGreenTexture;
var Texture DogTagsRedTexture;
var Texture DogTagsYellowTexture;
var Texture DogTagsBlueTexture;

var DogTagItem DogTagItemOwner;

simulated function SetVisualsColor() {
	local PlayerPawn pp;
	local bool IsEnemyTag;
	
	if(bLogToGameLogfile) {
		Log("DogTagItemVisuals: SetVisualsColor of "@Name);
	}
	
	//get the "active" player
	pp = class'LGDUtilities.PawnHelper'.static.GetActivePlayerPawn(self);
	
	if(pp != None) {
		if(bLogToGameLogfile) {
			Log("DogTagItemVisuals: SetVisualsColor - active player pawn found");
			Log("DogTagItemVisuals: SetVisualsColor - comparing team numbers: player:"$pp.PlayerReplicationInfo.Team$" - dog tag team:"$DogTagItemOwner.DroppedByTeam);
		}
		
		if(DogTagItemOwner.IsTeamGame) {
			IsEnemyTag = (pp.PlayerReplicationInfo.Team != DogTagItemOwner.DroppedByTeam);
		} else {
			IsEnemyTag = (pp.PlayerReplicationInfo.PlayerID != DogTagItemOwner.DroppedByPlayerID);
		}
		
		if(IsEnemyTag) {
			//team is diff, so set as red
			SetVisualsColorToRed();
		} else {
			//team is the same, so set to blue
			SetVisualsColorToBlue();
		}
	}
}

simulated function SetVisualsColorToNeutral(){
	Multiskins[1] = DogTagsNeutralTexture;
}

simulated function SetVisualsColorToGreen(){
	Multiskins[1] = DogTagsGreenTexture;
}

simulated function SetVisualsColorToRed(){
	Multiskins[1] = DogTagsRedTexture;
}

simulated function SetVisualsColorToYellow(){
	Multiskins[1] = DogTagsYellowTexture;
}

simulated function SetVisualsColorToBlue(){
	Multiskins[1] = DogTagsBlueTexture;
}

defaultproperties {
	bLogToGameLogfile=False
	bAlwaysRelevant=True
	LODBias=8.000000
	Mesh=LodMesh'KillConfirmed.DogTag'
	DogTagsNeutralTexture=Texture'KillConfirmed.DogTags.DogTags'
	DogTagsGreenTexture=Texture'KillConfirmed.DogTags.DogTagsGreen'
	DogTagsRedTexture=Texture'KillConfirmed.DogTags.DogTagsRed'
	DogTagsYellowTexture=Texture'KillConfirmed.DogTags.DogTagsYellow'
	DogTagsBlueTexture=Texture'KillConfirmed.DogTags.DogTagsBlue'
	
	bNoSmooth=False
	bUnlit=True
	LightEffect=LE_NonIncidence
	LightBrightness=255
	LightHue=170
	LightSaturation=255
	LightRadius=2
	LightPeriod=64
	LightPhase=255
	AmbientGlow=255	
	bBounce=False
	Mass=0.000000
	Physics=PHYS_None
	RemoteRole=ROLE_SimulatedProxy
	bPushable=False
	bStatic=False
	DrawType=DT_Mesh
	bCollideActors=False
	bCollideWorld=False
	bBlockActors=False
	bBlockPlayers=False
	Buoyancy=0.000000
}
