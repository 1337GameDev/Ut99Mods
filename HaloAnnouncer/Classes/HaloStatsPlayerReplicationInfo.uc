//=============================================================================
// HaloStatsPlayerReplicationInfo.
//=============================================================================
class HaloStatsPlayerReplicationInfo extends ReplicationInfo;

var int PlayerID;
var Pawn PawnOwner;

var int SpreeCount;//number of kills in this player's spree
var float LastKillTime;//last time, from Level.TimeSeconds that the player got a kill

var int ShotgunKillSpreeCount;
var int SwordKillSpreeCount;

var int InfectedKillSpreeCount;
var int HumanKillSpreeCount;

var int JuggernautKillSpreeCount;


//info for client side sound playing
var Sound ClientSoundsToPlay[255];
var int CurrentFreeSoundIndex;
var int CurrentSoundToPlayIndex;

replication {
	reliable if (Role == ROLE_Authority)
		PlayerID, ShotgunKillSpreeCount, SwordKillSpreeCount, InfectedKillSpreeCount, HumanKillSpreeCount, JuggernautKillSpreeCount;
	
	//replicated on first update -- vars that don't change after initial replication	
	//reliable if ((Role == ROLE_Authority) && bNetInitial)
		
}

function ResetAllCounts() {
	SpreeCount = 0;
	LastKillTime = 0;
	ShotgunKillSpreeCount = 0;
	SwordKillSpreeCount = 0;
	InfectedKillSpreeCount = 0;
	HumanKillSpreeCount = 0;
	JuggernautKillSpreeCount = 0;
}

function Timer() {
	local Pawn P;
	local Sound SoundToPlay;
	local float SoundLength;
	
	SoundToPlay = ClientSoundsToPlay[CurrentSoundToPlayIndex];
	
	if(SoundToPlay != None)	{
		SoundLength = GetSoundDuration(SoundToPlay);
		
		For (P=Level.PawnList; P!=None; P=P.NextPawn) {
			if(P.IsA('PlayerPawn')) {
				class'LGDUtilities.SoundHelper'.static.ClientPlaySound(PlayerPawn(P), SoundToPlay, true, true, 100);
			}
		}
		
		CurrentSoundToPlayIndex = (CurrentSoundToPlayIndex++) % 255;
		Enable('Timer');
		SetTimer(SoundLength, False);
	} else {
		Disable('Timer');
		CurrentSoundToPlayIndex = 0;
		CurrentFreeSoundIndex = 0;
	}
}

function PlayClientAnnouncerSound(Sound SoundToPlay) {
	if(SoundToPlay != None) {
		ClientSoundsToPlay[CurrentFreeSoundIndex] = SoundToPlay;
		CurrentFreeSoundIndex = (CurrentFreeSoundIndex++) % 255;
		
		Enable('Timer');
		SetTimer(0.0, False);
	}
}

defaultproperties {
}
