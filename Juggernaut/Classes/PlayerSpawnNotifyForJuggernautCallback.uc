//************************************//
// Class used as a callback for a player spawning (initial spawn + death respawn). This ensures the player who is assigned as the current juggernaut is given the proper items to be the juggernaut role
//************************************//
class PlayerSpawnNotifyForJuggernautCallback extends PlayerSpawnMutatorCallback;

function PlayerSpawnedCallback() {
    local JuggernautGameInfo gameInfo;
	gameInfo = JuggernautGameInfo(Self.Context);

	if((gameInfo != None) && (gameInfo.JugRepInfo != None) && (SpawnedPlayer.PlayerReplicationInfo != None) && (SpawnedPlayer.PlayerReplicationInfo.PlayerID == gameInfo.JugRepInfo.CurrentJuggernautPlayerID)) {
	    gameInfo.PrepareAssignedJuggernaut();
	}
}

defaultproperties {
}
