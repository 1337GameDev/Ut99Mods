//=============================================================================
// DogTagItem
//=============================================================================
class DogTagItem extends Pickup;

#exec AUDIO IMPORT FILE="Sounds\DogTags\DogTagsJinglePickup.wav" NAME="DogTagsPickup" GROUP="DogTags"
#exec AUDIO IMPORT FILE="Sounds\Announcer\KillConfirmed.wav" NAME="KillConfirmed" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\Announcer\KillDenied.wav" NAME="KillDenied" GROUP="Announcer"

var bool bLogToGameLogfile;
var DogTagItemVisuals visuals;
var byte DroppedByTeam;
var int DroppedByPlayerID;
var bool IsTeamGame;

function DestroyVisuals() {
     if(visuals != None) {
         visuals.Destroy();
     }
}

simulated function CreateVisuals() {
    if(visuals == None) {		
        visuals = Spawn(class'KillConfirmed.DogTagItemVisuals', Self,, Self.Location);
		visuals.DogTagItemOwner = Self;
		visuals.SetVisualsColor();
    }
}
simulated function SetVisualsNeutral() {
	if(visuals == None) {
		CreateVisuals();
	}
	
	visuals.SetVisualsColorToNeutral();
}
simulated function SetVisualsGreen() {
	if(visuals == None) {
		CreateVisuals();
	}
	
	visuals.SetVisualsColorToGreen();
}
simulated function SetVisualsRed() {
	if(visuals == None) {
		CreateVisuals();
	}
	
	visuals.SetVisualsColorToRed();
}
simulated function SetVisualsYellow() {
	if(visuals == None) {
		CreateVisuals();
	}
	
	visuals.SetVisualsColorToYellow();
}
simulated function SetVisualsBlue() {
	if(visuals == None) {
		CreateVisuals();
	}
	
	visuals.SetVisualsColorToBlue();
}

function PickupFunction(Pawn Other) {
    if(bLogToGameLogfile) {
        Log("DogTagItem: PickupFunction of "@Name);
    }

    Destroy();
}

function Destroyed() {
    DestroyVisuals();
    Super.Destroyed();
}

simulated function PostBeginPlay() {
    Super.PostBeginPlay();

    if (Level.NetMode == NM_DedicatedServer){
        //return;
    }
}

event float BotDesireability(Pawn Bot) {
    return MaxDesireability;
}

defaultproperties {
	bLogToGameLogfile=False
	PickupMessage=""
	ItemName="DogTags"
	MaxDesireability=5.000000
	PickupSound=Sound'KillConfirmed.DogTags.DogTagsPickup'
	bAlwaysRelevant=True
	CollisionRadius=25.000000
	CollisionHeight=25.000000
	bCollideWorld=False
	bBounce=False
	Mass=0.000000
	Physics=PHYS_None
	RemoteRole=ROLE_Authority
	bStatic=False
	DrawType=DT_None
	bCollideActors=True
	bCollideWorld=False
	bBlockActors=False
	bBlockPlayers=False
	Buoyancy=0.000000
}
