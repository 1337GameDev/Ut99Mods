//
// Switch is the note.
// RelatedPRI_1 is the player on the spree.
//
class HaloKillingSpreeMessage extends CriticalEventLowPlus;

// Sounds
#exec OBJ LOAD FILE=..\Sounds\HaloAnnouncer.uax PACKAGE=HaloAnnouncer.Infection

var(Messages)	localized string EndSpreeNote, EndSelfSpree, EndFemaleSpree, MultiKillString;
var(Messages)	localized string SpreeNote[11];
var(Messages)	sound SpreeSound[11];
var(Messages)	localized string EndSpreeNoteTrailer;
 
static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{ 
	if (RelatedPRI_2 == None) {
		if (RelatedPRI_1 == None) {
			return "";
		}
		
		if (RelatedPRI_1.PlayerName != "") {
			return RelatedPRI_1.PlayerName@Default.SpreeNote[Switch];
		}
	} else {
		if (RelatedPRI_1 == None) {
			if (RelatedPRI_2.PlayerName != "") {
				if (RelatedPRI_2.bIsFemale) {
					return RelatedPRI_2.PlayerName@Default.EndFemaleSpree;
				} else {
					return RelatedPRI_2.PlayerName@Default.EndSelfSpree;
				}
			}
		} else {
			return RelatedPRI_1.PlayerName$Default.EndSpreeNote@RelatedPRI_2.PlayerName@Default.EndSpreeNoteTrailer;
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

	if (RelatedPRI_2 != None) {
		return;
	}
	
	if (RelatedPRI_1 != P.PlayerReplicationInfo) {
		P.PlaySound(sound'SpreeSound',, 4.0);
		return;
	}
	
	P.ClientPlaySound(Default.SpreeSound[Switch],, true);

}

defaultproperties {
      EndSpreeNote="'s killing spree was ended by"
      EndSelfSpree="was looking good till he killed himself!"
      EndFemaleSpree="was looking good till she killed herself!"
      MultiKillString=""
	  
      spreenote(0)="is on a killing spree!"
      spreenote(1)="is on a rampage!"
      spreenote(2)="is dominating!"
      spreenote(3)="is unstoppable!"
      spreenote(4)="is Godlike!"
      spreenote(5)="is on a zombie killing spree!",
      spreenote(6)="is Hell's Janitor!",
      spreenote(7)="is Hell's Jerome!",
      spreenote(8)="is on an infection spree!",
      spreenote(9)="is... Mmmm... Brains",
	  spreenote(10)="is... a THRILLER!",
	  
	  
	  
      SpreeSound(0)=Sound'HaloAnnouncer.Announcer.doublekill'
      SpreeSound(0)=Sound'HaloAnnouncer.Announcer.triplekill'
      SpreeSound(0)=Sound'HaloAnnouncer.Announcer.overkill'//spree - 4
      SpreeSound(0)=Sound'HaloAnnouncer.Announcer.Killtacular'//spree - 5
      SpreeSound(0)=Sound'HaloAnnouncer.Announcer.Killtrocity'//spree - 6
      SpreeSound(0)=Sound'HaloAnnouncer.Announcer.Killamanjaro'//spree - 7
      SpreeSound(0)=Sound'HaloAnnouncer.Announcer.Killtastrophe'//spree - 8
      SpreeSound(0)=Sound'HaloAnnouncer.Announcer.Killpocalypse'//spree - 9
      SpreeSound(0)=Sound'HaloAnnouncer.Announcer.Killionaire'//spree - 10
	  
	  /* Infection Specific Sounds */
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.ShotgunSpree',//shotgun spree 5
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.OpenSeason',//shotgun spree 10
      SpreeSound(5)=Sound'HaloAnnouncer.Announcer.BuckWild',//shotgun spree 15
      SpreeSound(5)=Sound'HaloAnnouncer.Announcer.NewZombie',
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.SwordSpree',//spree - 5 with energy sword
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.SliceNDice',//spree - 10 with energy sword
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.CuttingCrew',//spree - 15 with energy sword
	  
      SpreeSound(5)=Sound'HaloAnnouncer.Announcer.ZombieSpree',//spree - 5 zombies 
      SpreeSound(6)=Sound'HaloAnnouncer.Announcer.HellsJanitor',//spree - 10 zombies
      SpreeSound(7)=Sound'HaloAnnouncer.Announcer.HellsJerome',//spree - 15 zombies
      SpreeSound(8)=Sound'HaloAnnouncer.Announcer.InfectionSpree',//spree - infect 5
      SpreeSound(9)=Sound'HaloAnnouncer.Announcer.MmmBrains',//spree - infect 10
	  SpreeSound(10)=Sound'HaloAnnouncer.Announcer.Thriller',//spree - infect 15
	  
	  SpreeSound(10)=Sound'HaloAnnouncer.Announcer.10Seconds',
	  SpreeSound(10)=Sound'HaloAnnouncer.Announcer.30Seconds',
	  SpreeSound(10)=Sound'HaloAnnouncer.Announcer.OneMinute',
	  SpreeSound(10)=Sound'HaloAnnouncer.Announcer.RoundOver',
	  
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.killingspree',// spree - 5
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.KillingFrenzy',//spree - 10
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.RunningRiot',//spree - 15
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.rampage',//spree - 20
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.Untouchable',//spree - 25
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.Invincible',//spree - 30
	  
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.Extermination',
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.Suicide',
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.Betrayal',
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.Betrayed',
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.Killjoy',
	  
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.GainedTheLead',
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.LostTheLead',
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.TiedTheLeader',
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.LastMan',
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.FirstStrike',
	  
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.Juggernaut',
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.JuggernautSpree',
	  
	  SpreeSound(5)=Sound'HaloAnnouncer.Announcer.Skullamanjaro',
	  
	  
	  
      EndSpreeNoteTrailer=""
      bBeep=False
}
