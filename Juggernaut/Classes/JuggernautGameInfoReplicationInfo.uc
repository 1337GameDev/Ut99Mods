//=============================================================================
// JuggernautGameInfoReplicationInfo.
//=============================================================================
class JuggernautGameInfoReplicationInfo extends TournamentGameReplicationInfo;

var bool ShowJuggernautIndicator;
var bool OnlyJuggernautScores;

var int RegenSeconds;//how many seconds between each juggernaut regen
var int ShieldRegenRate;//how much shield to regen
var int HealthRegenRate;//how much health to regen
var float JugJumpModifier;//the multiplier for the jump height of the juggernaut (3 is same as JumpBoots)
var float JugMovementMultiplier;//the multiplier for movement properties for the juggernaut

var bool UseHaloAnnouncer;

var bool bHasInitAnyHUDMutators;
var bool bHasPlayedIntro;

var int PreviousJuggernautPlayerID;
var int CurrentJuggernautPlayerID;
var float LastJuggernautChangeTime;

replication {
	reliable if(Role == ROLE_Authority)
		ShowJuggernautIndicator, RegenSeconds, ShieldRegenRate, HealthRegenRate, JugJumpModifier, JugMovementMultiplier, bHasInitAnyHUDMutators, bHasPlayedIntro, CurrentJuggernautPlayerID, PreviousJuggernautPlayerID, LastJuggernautChangeTime, UseHaloAnnouncer;
}

simulated function PostBeginPlay() {
	Super.PostBeginPlay();

    if(JuggernautGameInfo(Level.Game) != None){

	}

}

defaultproperties {
      ShowJuggernautIndicator=True
      OnlyJuggernautScores=False
      RegenSeconds=5
      ShieldRegenRate=10
      HealthRegenRate=10
      JugJumpModifier=3.000000
      JugMovementMultiplier=3.000000
      bHasInitAnyHUDMutators=False
      bHasPlayedIntro=False
      PreviousJuggernautPlayerID=-1
      CurrentJuggernautPlayerID=-1
      LastJuggernautChangeTime=0.000000
	  UseHaloAnnouncer=True
}
