//=============================================================================
// InfectionGameInfo.
//=============================================================================
class InfectionGameInfo extends TeamGamePlus
	config;

//#exec AUDIO IMPORT FILE="Sounds\JuggernautIntro.wav" NAME="JuggernautIntro" GROUP="Announcer"
//#exec AUDIO IMPORT FILE="Sounds\NewJuggernaut.wav" NAME="NewJuggernaut" GROUP="Announcer"

//var Sound IntroSound;
//var Sound NewJuggernautSound;

var string ZombieStartUpMessage;
var string HumansStartUpMessage;

var bool bHasPlayedIntro;
var bool bHasInitAnyHUDMutators;

var IndicatorHudGlobalTargets GlobalIndicatorTargets;

//cached cast from GameReplicationInfo class
var InfectionGameReplicationInfo InfRepInfo;

function PreCacheReferences() {
	//never called - here to force precaching of meshes
	spawn(class'TMale1');
	spawn(class'TMale2');
	spawn(class'TFemale1');
	spawn(class'TFemale2');
	spawn(class'ImpactHammer');
	spawn(class'Translocator');
	spawn(class'Enforcer');
	spawn(class'UT_Biorifle');
	spawn(class'ShockRifle');
	spawn(class'PulseGun');
	spawn(class'Ripper');
	spawn(class'Minigun2');
	spawn(class'UT_FlakCannon');
	spawn(class'UT_Eightball');
	spawn(class'SniperRifle');
	spawn(class'WarheadLauncher');

	spawn(class'Juggernaut.JuggernautBelt');
}

//called at end of DeathMatchPlus.PreBeginPlay
function InitGameReplicationInfo() {
	Super.InitGameReplicationInfo();

    InfRepInfo = InfectionGameReplicationInfo(GameReplicationInfo);

}

function PreBeginPlay() {
    //local PlayerSpawnNotifyForJuggernautCallback playerSpawnCallback;
	Super.PreBeginPlay();

    GlobalIndicatorTargets = class'IndicatorHudGlobalTargets'.static.GetRef(self);
	//playerSpawnCallback = new class'PlayerSpawnNotifyForJuggernautCallback';

	//class'PlayerSpawnMutator'.static.RegisterToPlayerSpawn(self, playerSpawnCallback);
}

//
// Initialize the game.
//warning: this is called before actors' PreBeginPlay (so game replication info is not initialized yet).
//
event InitGame(string Options, out string Error) {
    //local string InOpt;
	Super.InitGame(Options, Error);


}

//------------------------------------------------------------------------------
//adds an indictaor to every player / bot that gets passed to this
function AddPlayerIndicator(Pawn player){
    local IndicatorHudTargetListElement le;
    local IndicatorSettings settings;
    //local JuggernautPlayerIndicatorModifierFn indicatorMod;

    if((player == None) || !(player.IsA('Bot') || player.IsA('PlayerPawn')) ){
        return;
    }

    le = new class'IndicatorHudTargetListElement';
    //indicatorMod = new class'JuggernautPlayerIndicatorModifierFn';
    //indicatorMod.Player = player;
    //indicatorMod.Context = Self;

    settings = new class'IndicatorSettings';
    settings.UseCustomColor = true;
    settings.IndicatorColor = class'ColorHelper'.default.RedColor;
    settings.ShowIndicatorAboveTarget = true;
    settings.ScaleIndicatorSizeToTarget = false;
    settings.ShowIndicatorLabel = false;

    //settings.TextureVariations = class'IndicatorHud'.static.GetTexturesForBuiltInOption(64);//HudIndicator_DownTriangle_Solid
    settings.TextureVariations = class'IndicatorHud'.static.GetTexturesForBuiltInOption(74);//HudIndicator_Crown
    settings.TextureVariations.BehindViewTex = None;
    settings.ShowTargetDistanceLabels = false;
    settings.MaxViewDistance = 0;
    settings.ShowIndicatorWhenOffScreen = true;

    le.IndicatorSettings = settings;
    //le.IndicatorSettingsModifier = indicatorMod;
    le.Value = player;

    //should exist at this stage as we init the reference at the earlier stage of game execution
    GlobalIndicatorTargets.GlobalIndicatorTargets.Push(le);
}

function RemovePlayerIndicator(Pawn player) {
    if(player != None){
        //should exist at this stage as we init the reference at the earlier stage of game execution
        GlobalIndicatorTargets.GlobalIndicatorTargets.RemoveElementByValue(player);
    }
}

//------------------------------------------------------------------------------
// Game Querying.
function string GetRules() {
	local string ResultSet;
	ResultSet = Super(TournamentGameInfo).GetRules();

	ResultSet = ResultSet$"\\timelimit\\"$TimeLimit;
	ResultSet = ResultSet$"\\goalteamscore\\"$int(GoalTeamScore);
	Resultset = ResultSet$"\\minplayers\\"$MinPlayers;
	Resultset = ResultSet$"\\changelevels\\"$bChangeLevels;
	ResultSet = ResultSet$"\\maxteams\\"$MaxTeams;
	ResultSet = ResultSet$"\\balanceteams\\"$bBalanceTeams;
	ResultSet = ResultSet$"\\playersbalanceteams\\"$bPlayersBalanceTeams;
	ResultSet = ResultSet$"\\friendlyfire\\"$int(FriendlyFireScale*100)$"%";
	Resultset = ResultSet$"\\tournament\\"$bTournament;
	if(bMegaSpeed)
		Resultset = ResultSet$"\\gamestyle\\Turbo";
	else
	if(bHardcoreMode)
		Resultset = ResultSet$"\\gamestyle\\Hardcore";
	else
		Resultset = ResultSet$"\\gamestyle\\Classic";

	if(MinPlayers > 0)
		Resultset = ResultSet$"\\botskill\\"$class'ChallengeBotInfo'.default.Skills[Difficulty];

	return ResultSet;
}

defaultproperties
{
      ZombieStartUpMessage="Infect all humans!"
      HumansStartUpMessage="Survive against the zombies!"
      bHasPlayedIntro=False
      bHasInitAnyHUDMutators=False
      GlobalIndicatorTargets=None
      InfRepInfo=None
      MaxAllowedTeams=2
      TeamChangeMessage="No team changing is allowed!"
      StartUpMessage="Infection!"
      BeaconName="Inf"
      GameName="Infection"
      GameReplicationInfoClass=Class'Infection.InfectionGameReplicationInfo'
	  MutatorClass=Class'Infection.InfectionGameTypeMutator'
}
