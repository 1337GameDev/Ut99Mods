//=============================================================================
// InfectionGameReplicationInfo.
//=============================================================================
class InfectionGameReplicationInfo extends TournamentGameReplicationInfo;

//The minimum number of zombies to have in the game, such as round start / a zombie leaving the game
var int MinimumZombies;
var bool ShowZombieIndicators;
var bool ShowHumanIndicators;
var bool ShowSameTeamIndicators;
var float ZombieMovementModifier;
var float ZombieJumpModifier;

var float ZombieDamageMod;
var float HumanDamageMod;

var bool HumansPickupWeapons;
var bool ZombiesPickupWeapons;
var bool InfiniteAmmo;
var bool AnyDeathInfects;

//both based on TeamInfo.TeamIndex
//Based on enums provided in TeamGamePlus
//TEAM_Red=0
//TEAM_Blue=1
//TEAM_Green=2
//TEAM_Gold=3

var byte ZombieTeam;
var byte HumanTeam;
var byte NeutralTeam;

var LinkedList ExtraPRIList;

var bool bHasInitAnyHUDMutators;
var bool bHasPlayedIntro;
var bool GameStarted;

replication {
	reliable if (Role == ROLE_Authority)
		ExtraPRIList;
	
	//replicated on first update -- vars that don't change after initial replication	
	reliable if ((Role == ROLE_Authority) && bNetInitial)
		MinimumZombies, ShowZombieIndicators, ShowHumanIndicators, ShowSameTeamIndicators, ZombieMovementModifier, ZombieJumpModifier, ZombieTeam, HumanTeam, NeutralTeam, ZombieDamageMod, HumanDamageMod, HumansPickupWeapons, ZombiesPickupWeapons, InfiniteAmmo, AnyDeathInfects;
}

simulated function PostBeginPlay() {
	local InfectionGameInfo infGameInfo;

	Super.PostBeginPlay();
	
	infGameInfo = InfectionGameInfo(Level.Game);
	
	if(infGameInfo != None) {

	}
}

defaultproperties {
	MinimumZombies=1
	ShowZombieIndicators=true
	ShowHumanIndicators=false
	ShowSameTeamIndicators=true
	ZombieMovementModifier=3.0
	ZombieJumpModifier=3.0
	
	ZombieDamageMod=3.0
	HumanDamageMod=0.75
	
	HumansPickupWeapons=false,
	ZombiesPickupWeapons=false,
	InfiniteAmmo=true,
	AnyDeathInfects=true,
	
	ZombieTeam=2//green
	HumanTeam=1//blue
	NeutralTeam=3//gold
	
	bHasInitAnyHUDMutators=false,
	bHasPlayedIntro=false,
	GameStarted=false

}
