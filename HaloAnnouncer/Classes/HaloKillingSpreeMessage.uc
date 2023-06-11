//--------------------------------------------------
// Messages for killing sprees that will be brodcast to all players in game log
//--------------------------------------------------

//
// Switch is the note.
// RelatedPRI_1 is the player on the spree.
//
class HaloKillingSpreeMessage extends CriticalEventLowPlus;

// Sounds
#exec OBJ LOAD FILE=..\Sounds\HaloAnnouncer.uax PACKAGE=HaloAnnouncer.

//killing spree sounds (within 4 seconds)
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\DoubleKill.wav" NAME="DoubleKill" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\TripleKill.wav" NAME="TripleKill" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Overkill.wav" NAME="Overkill" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Killtacular.wav" NAME="Killtacular" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Killtrocity.wav" NAME="Killtrocity" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Killamanjaro.wav" NAME="Killamanjaro" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Killtastrophe.wav" NAME="Killtastrophe" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Killpocalypse.wav" NAME="Killpocalypse" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Killionaire.wav" NAME="Killionaire" GROUP="Announcer"

//consecutive kills without dying
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\KillingSpree.wav" NAME="KillingSpree" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\KillingFrenzy.wav" NAME="KillingFrenzy" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\RunningRiot.wav" NAME="RunningRiot" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Rampage.wav" NAME="Rampage" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Untouchable.wav" NAME="Untouchable" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Invincible.wav" NAME="Invincible" GROUP="Announcer"

//game time sounds
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\10Seconds.wav" NAME="10Seconds" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\30Seconds.wav" NAME="30Seconds" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\OneMinute.wav" NAME="OneMinute" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\RoundOver.wav" NAME="RoundOver" GROUP="Announcer"

//Misc game events
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Extermination.wav" NAME="Extermination" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Suicide.wav" NAME="Suicide" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Betrayal.wav" NAME="Betrayal" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Betrayed.wav" NAME="Betrayed" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Killjoy.wav" NAME="Killjoy" GROUP="Announcer"

//Game status sounds
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\GainedTheLead.wav" NAME="GainedTheLead" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\LostTheLead.wav" NAME="LostTheLead" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\TiedTheLeader.wav" NAME="TiedTheLeader" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\LastMan.wav" NAME="LastMan" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\FirstStrike.wav" NAME="FirstStrike" GROUP="Announcer"

//weapon specific sounds
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\ShotgunSpree.wav" NAME="ShotgunSpree" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\OpenSeason.wav" NAME="OpenSeason" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\BuckWild.wav" NAME="BuckWild" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\SwordSpree.wav" NAME="SwordSpree" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\SliceNDice.wav" NAME="SliceNDice" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\CuttingCrew.wav" NAME="CuttingCrew" GROUP="Announcer"

//gametype specific sounds
//INFECTION
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\NewZombie.wav" NAME="NewZombie" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Infection.wav" NAME="Infection" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Infected.wav" NAME="Infected" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\ZombieSpree.wav" NAME="ZombieSpree" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\HellsJanitor.wav" NAME="HellsJanitor" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\HellsJerome.wav" NAME="HellsJerome" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\InfectionSpree.wav" NAME="InfectionSpree" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\MmmBrains.wav" NAME="MmmBrains" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Thriller.wav" NAME="Thriller" GROUP="Announcer"

//JUGGERNAUT
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Juggernaut.wav" NAME="Juggernaut" GROUP="Announcer"
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\JuggernautSpree.wav" NAME="JuggernautSpree" GROUP="Announcer"

//HEADHUNTER
#exec AUDIO IMPORT FILE="Sounds\HaloAnnouncerTakes\Reduced\Skullamanjaro.wav" NAME="Skullamanjaro" GROUP="Announcer"


var(Messages)	localized string EndSpreeNote, EndSelfSpree, EndFemaleSpree, MultiKillString;

//kills each within 4 seconds of each other
var(Messages)	localized string SpreeNote[32];
var(Messages)	sound SpreeSound[32];//kills within 4 seconds

//kills in a row without dying
var(Messages)	localized string NoDyingSpreeNote[32];
var(Messages)	sound NoDyingSpreeSound[32];

var(Messages)	localized string EndSpreeNoteTrailer;
 
var(Messages)	localized string WeaponSpecificSpreeNote[8];
var(Messages)	sound WeaponSpecificSpreeSound[8];

var(Messages)	localized string JuggernautSpreeNote[8];
var(Messages)	sound JuggernautSpreeSound[8];

var(Messages)	localized string InfectionSpreeNote[8];
var(Messages)	sound InfectionSpreeSound[8];

var(Messages)	localized string HeadHunterSpreeNote[8];
var(Messages)	sound HeadHunterSpreeSound[8];

var(Messages)	localized string GameStatusText[8];
var(Messages)	sound GameStatusSound[8];

var(Messages)	localized string GameTimeText[8];
var(Messages)	sound GameTimeSound[8];

var(Messages)	localized string MiscEventText[8];
var(Messages)	sound MiscEventSound[8];

var int SWITCHVAL_SUICIDE;
var int SWITCHVAL_BETRAYAL;
var int SWITCHVAL_BETRAYED;

//================================================
// Switch is [1-30 = kill spree, 0 = invalid, >30 = misc]
// RelatedPRI_1 is VICTIM
// RelatedPRI_2 is KILLER
// OptionalObject is 'HaloAnnouncer.HaloKillingSpreeMessageData'
//================================================
static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{ 
	if ((RelatedPRI_1 == None) || (RelatedPRI_2 == None)) {
		return "";
	} else if((Switch >= 0) && (Switch < 2)) {
	
	} else if(Switch < 11) {
		//normal sprees
		
	} else {
		switch(Switch) {
			case class'HaloAnnouncer.HaloKillingSpreeMessage'.default.SWITCHVAL_BETRAYAL:
				return class'HaloAnnouncer.HaloKillingSpreeMessage'.default.MiscEventText[2];
				break;
			case class'HaloAnnouncer.HaloKillingSpreeMessage'.default.SWITCHVAL_BETRAYED:
				return class'HaloAnnouncer.HaloKillingSpreeMessage'.default.MiscEventText[3];
				break;
			case class'HaloAnnouncer.HaloKillingSpreeMessage'.default.SWITCHVAL_SUICIDE:
				return class'HaloAnnouncer.HaloKillingSpreeMessage'.default.MiscEventText[1];;
				break;
		}
	}
		
	
	
	return "";
}

static simulated function ClientReceive( 
	PlayerPawn P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	
	if (RelatedPRI_1 != P.PlayerReplicationInfo) {
		//P.PlaySound(sound'SpreeSound',, 4.0);
		return;
	}
	
	//if only client should hear it
	//P.ClientPlaySound(Default.SpreeSound[Switch],, true);
		
	switch(Switch) {
		case 0:
			return;
			break;
		case 1:
			return;
			break;
	}
}

defaultproperties {
      EndSpreeNote="'s killing spree was ended by"
      EndSelfSpree="was looking good till he killed himself!"
      EndFemaleSpree="was looking good till she killed herself!"
      MultiKillString=""
	  
      
	  
      SpreeSound(2)=Sound'HaloAnnouncer.Announcer.doublekill'//spree - 2
      SpreeNote(2)="got a double kill!"
      SpreeSound(3)=Sound'HaloAnnouncer.Announcer.triplekill'//spree - 3
	  SpreeNote(2)="got a triple kill!"
      SpreeSound(4)=Sound'HaloAnnouncer.Announcer.overkill'//spree - 4
	  SpreeNote(2)="got an overkill!"
      SpreeSound(5)=Sound'HaloAnnouncer.Announcer.Killtacular'//spree - 5
	  SpreeNote(2)="got a killtacular!"
      SpreeSound(6)=Sound'HaloAnnouncer.Announcer.Killtrocity'//spree - 6
	  SpreeNote(2)="got a killtrocity!"
      SpreeSound(7)=Sound'HaloAnnouncer.Announcer.Killamanjaro'//spree - 7
	  SpreeNote(2)="got a killamanjaro!"
      SpreeSound(8)=Sound'HaloAnnouncer.Announcer.Killtastrophe'//spree - 8
	  SpreeNote(2)="got a killtastrophe!"
      SpreeSound(9)=Sound'HaloAnnouncer.Announcer.Killpocalypse'//spree - 9
	  SpreeNote(2)="got a killpocalypse!"
      SpreeSound(10)=Sound'HaloAnnouncer.Announcer.Killionaire'//spree - 10
	  SpreeNote(2)="got a killionaire!"
	  
	  /* Weapon Specific Sounds */
	  WeaponSpecificSpreeSound(0)=Sound'HaloAnnouncer.Announcer.ShotgunSpree',//shotgun spree 5
	  WeaponSpecificSpreeSound(1)=Sound'HaloAnnouncer.Announcer.OpenSeason',//shotgun spree 10
      WeaponSpecificSpreeSound(2)=Sound'HaloAnnouncer.Announcer.BuckWild',//shotgun spree 15
	  WeaponSpecificSpreeSound(3)=Sound'HaloAnnouncer.Announcer.SwordSpree',//spree - 5 with energy sword
	  WeaponSpecificSpreeSound(4)=Sound'HaloAnnouncer.Announcer.SliceNDice',//spree - 10 with energy sword
	  WeaponSpecificSpreeSound(5)=Sound'HaloAnnouncer.Announcer.CuttingCrew',//spree - 15 with energy sword
	  
	  /* Infection Specific Sounds */
	  InfectionSpreeSound(0)=Sound'HaloAnnouncer.Announcer.NewZombie',
	  InfectionSpreeNote(0)="was infected by",//assuming they weren't chosen by the game itself -- eg: start of match/zombie left
      InfectionSpreeSound(1)=Sound'HaloAnnouncer.Announcer.ZombieSpree',//spree - 5 zombies 
	  InfectionSpreeNote(1)="is on a zombie killing spree!",
      InfectionSpreeSound(2)=Sound'HaloAnnouncer.Announcer.HellsJanitor',//spree - 10 zombies
	  InfectionSpreeNote(2)="is Hell's Janitor!",
      InfectionSpreeSound(3)=Sound'HaloAnnouncer.Announcer.HellsJerome',//spree - 15 zombies
	  InfectionSpreeNote(3)="is Hell's Jerome!",
      InfectionSpreeSound(4)=Sound'HaloAnnouncer.Announcer.InfectionSpree',//spree - infect 5
	  InfectionSpreeNote(4)="is on an infection spree!",
      InfectionSpreeSound(5)=Sound'HaloAnnouncer.Announcer.MmmBrains',//spree - infect 10
	  InfectionSpreeNote(5)="Mmmmm... Brains...",
	  InfectionSpreeSound(6)=Sound'HaloAnnouncer.Announcer.Thriller',//spree - infect 15
	  InfectionSpreeNote(6)="THRILLER!",
	  
	  /* Game Time Sounds */
	  GameTimeSound(0)=Sound'HaloAnnouncer.Announcer.10Seconds',
	  GameTimeSound(1)=Sound'HaloAnnouncer.Announcer.30Seconds',
	  GameTimeSound(2)=Sound'HaloAnnouncer.Announcer.OneMinute',
	  GameTimeSound(3)=Sound'HaloAnnouncer.Announcer.RoundOver',
	  
	  //consecutive kills without dying
	  NoDyingSpreeSound(0)=Sound'HaloAnnouncer.Announcer.killingspree',// spree - 5
	  NoDyingSpreeNote(0)="is on a killing spree!",
	  NoDyingSpreeSound(1)=Sound'HaloAnnouncer.Announcer.KillingFrenzy',//spree - 10
	  NoDyingSpreeNote(1)="is on a killing frenzy!",
	  NoDyingSpreeSound(2)=Sound'HaloAnnouncer.Announcer.RunningRiot',//spree - 15
	  NoDyingSpreeNote(2)="is on a running riot!",
	  NoDyingSpreeSound(3)=Sound'HaloAnnouncer.Announcer.rampage',//spree - 20
	  NoDyingSpreeNote(3)="is on a rampage!",
	  NoDyingSpreeSound(4)=Sound'HaloAnnouncer.Announcer.Untouchable',//spree - 25
	  NoDyingSpreeNote(4)="is untouchable!",
	  NoDyingSpreeSound(5)=Sound'HaloAnnouncer.Announcer.Invincible',//spree - 30
	  NoDyingSpreeNote(5)="is invincible!",
	  //NoDyingSpreeSound(6)=Sound'HaloAnnouncer.Announcer.Inconceivable,//spree - 35
	  //NoDyingSpreeNote(6)="is inconceivable!",
	  //NoDyingSpreeSound(7)=Sound'HaloAnnouncer.Announcer.Unfrigginbelievable,//spree - 40
	  //NoDyingSpreeNote(7)="is unfrigginbelievable!",
	  
	  
	  //Misc game sounds
	  MiscEventSound(0)=Sound'HaloAnnouncer.Announcer.Extermination',//entire team is dead, with at least an overkill (4 kills within 4 seconds of each other)
	  MiscEventText(0)="exterminated the opposing team!",
	  MiscEventSound(1)=Sound'HaloAnnouncer.Announcer.Suicide',
	  MiscEventText(1)="was looking good till they killed theirself!",
	  MiscEventSound(2)=Sound'HaloAnnouncer.Announcer.Betrayal',
	  MiscEventText(2)="betrayed",
	  MiscEventSound(3)=Sound'HaloAnnouncer.Announcer.Betrayed',
	  MiscEventText(3)="was betrayed by",
	  MiscEventSound(4)=Sound'HaloAnnouncer.Announcer.Killjoy',
	  MiscEventText(4)="",
	  //MiscEventSound(5)=Sound'HaloAnnouncer.Announcer.FromTheGrave',
	  //MiscEventText(5)="was killed from the grave!",
	  
	  //game status sounds
	  GameStatusSound(0)=Sound'HaloAnnouncer.Announcer.GainedTheLead',
	  GameStatusSound(1)=Sound'HaloAnnouncer.Announcer.LostTheLead',
	  GameStatusSound(2)=Sound'HaloAnnouncer.Announcer.TiedTheLeader',
	  GameStatusSound(3)=Sound'HaloAnnouncer.Announcer.LastMan',
	  GameStatusSound(4)=Sound'HaloAnnouncer.Announcer.FirstStrike',
	  
	  JuggernautSpreeSound(0)=Sound'HaloAnnouncer.Announcer.Juggernaut',
	  JuggernautSpreeSound(1)=Sound'HaloAnnouncer.Announcer.NewJuggernaut',
	  JuggernautSpreeSound(2)=Sound'HaloAnnouncer.Announcer.JuggernautSpree',//5 kills as a juggernaut without dying
	  //JuggernautSpreeSound(3)=Sound'HaloAnnouncer.Announcer.JuggernautUnstoppable',//15 kills as a juggernaut without dying
	  
	  HeadHunterSpreeSound(0)=Sound'HaloAnnouncer.Announcer.Skullamanjaro',//collect 10 skulls at once
	  
	  
	  
      EndSpreeNoteTrailer=""
      bBeep=False,
	  
	  //Misc Switch Values
	  SWITCHVAL_SUICIDE=31,
	  SWITCHVAL_BETRAYAL=32
}
