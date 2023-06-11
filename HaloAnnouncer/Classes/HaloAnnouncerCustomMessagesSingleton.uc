//=============================================================================
// HaloAnnouncerCustomMessagesSingleton.
//
// A singleton for managing custom trackers, multikill messages, killing spree messages, or victim messages
//=============================================================================
class HaloAnnouncerCustomMessagesSingleton extends Actor nousercreate;

var private HaloAnnouncerCustomMessagesSingleton Ref;

//--------------------------------------------------
// Custom Stat Trackers
//        Stat trackers used to add new values to provided HaloStatsPlayerReplicationInfo instances.
//	List element VALUES are 'HaloAnnouncer.HaloStatsTrackerCallbackFn'
//--------------------------------------------------
var LinkedList CustomStatTrackers;

//--------------------------------------------------
// Multi Kill HUD messages
//        Shows messages for kill sprees a killer gets
//  List element VALUES are 'LocalMessagePlus'
//--------------------------------------------------
var LinkedList CustomMultiKillMessages;

//--------------------------------------------------
// Killing spree global messages
//        Shows messages to ALL players for a player's spree
//  List element VALUES are 'LocalMessagePlus'
//--------------------------------------------------
var LinkedList CustomKillingSpreeMessageSenders;

//--------------------------------------------------
// Victim messages
//        Shows messages to a player who WAS killed
//  List element VALUES are 'LocalMessagePlus'
//--------------------------------------------------
var LinkedList CustomVictimMessages;

replication {
	reliable if(Role == ROLE_Authority)
		Ref, CustomStatTrackers, CustomMultiKillMessages, CustomKillingSpreeMessageSenders, CustomVictimMessages;
}

final static function HaloAnnouncerCustomMessagesSingleton GetRef(Actor referenceToUseForSpawn) {
    local HaloAnnouncerCustomMessagesSingleton singleton;

    if(default.Ref == None) {
        singleton = referenceToUseForSpawn.Spawn(class'HaloAnnouncer.HaloAnnouncerCustomMessagesSingleton');
        default.Ref = singleton;
    }

    return default.Ref;
}


function AddCustomStatTracker(HaloStatsTrackerCallbackFn tracker) {	
	if(CustomStatTrackers == None) {
	    CustomStatTrackers = new class'LGDUtilities.LinkedList';
	}
	
	if(tracker != None) {
		CustomStatTrackers.Push(tracker);
	}
}

function AddCustomMultiKillMessage(class<LocalMessagePlus> messageClass) {	
	if(CustomMultiKillMessages == None) {
	    CustomMultiKillMessages = new class'LGDUtilities.LinkedList';
	}
	
	if(messageClass != None) {
		CustomMultiKillMessages.Push(messageClass);
	}
}

function AddCustomKillingSpreeMessageSender(HaloKillingSpreeMessageSender killingSpreeMessageSender) {	
	if(CustomKillingSpreeMessageSenders == None) {
	    CustomKillingSpreeMessageSenders = new class'LGDUtilities.LinkedList';
	}
	
	if(killingSpreeMessageSender != None) {
		CustomKillingSpreeMessageSenders.Push(killingSpreeMessageSender);
	}
}

function AddCustomCustomVictimMessages(class<HaloAnnouncerVictimMessage> victimMessage) {
	if(CustomVictimMessages == None) {
	    CustomVictimMessages = new class'LGDUtilities.LinkedList';
	}
	
	if(victimMessage != None) {
		CustomVictimMessages.Push(victimMessage);
	}
}

defaultproperties {
      Ref=None
}
