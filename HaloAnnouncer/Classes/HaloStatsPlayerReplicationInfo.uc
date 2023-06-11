//=============================================================================
// HaloStatsPlayerReplicationInfo.
//=============================================================================
class HaloStatsPlayerReplicationInfo extends ReplicationInfo;

var int PlayerID;
var Pawn PawnOwner;

var int CurrentSpreeCount;//number of kills in this player's spree
var int CurrentSpreeSinceDeath;//number of kills this ENTIRE life for this player -- not neccessarily within a certain time of each other

var int CurrentSpreeCountWithWeapon;//number of kills in this player's spree WITH the weapon indicated by CurrentSpreeWeapon
var Class<Actor> CurrentSpreeWeapon;//weapon or item used in this player's spree

var LinkedList KillCounts;
var LinkedList KilledByCounts;

var int SuicideCount;
var int BetrayalCount;

replication {
	reliable if (Role == ROLE_Authority)
		PlayerID, PawnOwner, CurrentSpreeCount, CurrentSpreeSinceDeath, CurrentSpreeCountWithWeapon, CurrentSpreeWeapon, KillCounts, KilledByCounts, SuicideCount, BetrayalCount;
	
	//replicated on first update -- vars that don't change after initial replication	
	//reliable if ((Role == ROLE_Authority) && bNetInitial)
		
}

function Init() {
	KillCounts = new class'LGDUtilities.LinkedList';
	KilledByCounts = new class'LGDUtilities.LinkedList';
}

function ResetSpree() {
	CurrentSpreeCount = 0;
	CurrentSpreeSinceDeath = 0;
	CurrentSpreeCountWithWeapon = 0;
	CurrentSpreeWeapon = None;
}

function ResetAllCounts() {
	ResetSpree();
	
	if(KillCounts != None) {
		KillCounts.RemoveAll();
	}
	
	if(KilledByCounts != None) {
		KilledByCounts.RemoveAll();
	}
	
	SuicideCount = 0;
	BetrayalCount = 0;
}

//adds to a specific kill count, given a key
//if it doesn't exist, it'll be created
//eg: Kill count of a flak cannon
function int AddToKillCount(string Key, int ValueToAdd) {
	local ListElement le;
	local HaloStatListElement hle;
	local int CurrentCount;
	local StringObj stringObj;
	
	if(Key == "") {
		return 0;
	}
	
	if(KillCounts == None) {
		KillCounts = new class'LGDUtilities.LinkedList';
	}
	
	stringObj = new class'LGDUtilities.StringObj';
	stringObj.Value = Key;
	
	le = KillCounts.GetElementByValue(stringObj);
	if(le != None) {
		hle = HaloStatListElement(le);
		
		if(hle != None) {
			hle.Count += ValueToAdd;
			CurrentCount = hle.Count;
		}
	} else {
		hle = new class'HaloAnnouncer.HaloStatListElement';
		
		hle.Value = stringObj;
		hle.Count = ValueToAdd;
		
		KillCounts.Push(hle);
		
		CurrentCount = hle.Count;
	}
	
	return CurrentCount;
}



//resets a specific kill count, given a key
//if it doesn't exist, it'll be created
//eg: Kill count of a flak cannon
function ResetKillCount(string Key) {
	local ListElement le;
	local HaloStatListElement hle;
	local StringObj stringObj;
	
	if(Key == "") {
		return;
	}
	
	if(KillCounts == None) {
		KillCounts = new class'LGDUtilities.LinkedList';
	}
	
	stringObj = new class'LGDUtilities.StringObj';
	stringObj.Value = Key;
	
	le = KillCounts.GetElementByValue(stringObj);
	if(le != None) {
		hle = HaloStatListElement(le);
		
		if(hle != None) {
			hle.Count = 0;
		}
	} else {
		hle = new class'HaloAnnouncer.HaloStatListElement';
		hle.Value = stringObj;
		hle.Count = 0;
		
		KillCounts.Push(hle);
	}
}

//get a specified count that denotes how you killed somebody / something based on a "key"
//eg: Kill count of a flak cannon
function int GetKillCount(string Key) {
	local ListElement le;
	local HaloStatListElement hle;
	local int CurrentCount;
	local StringObj stringObj;
	
	if(Key == "") {
		return 0;
	}
	
	if(KillCounts == None) {
		KillCounts = new class'LGDUtilities.LinkedList';
	}
	
	stringObj = new class'LGDUtilities.StringObj';
	stringObj.Value = Key;
	
	le = KillCounts.GetElementByValue(stringObj);
	if(le != None) {
		hle = HaloStatListElement(le);
		
		if(hle != None) {
			CurrentCount = hle.Count;
		}
	}
	
	return CurrentCount;
}

//adds a value to a specified "kill by" count, given by the "key"
//if one doesn't exist, it'll be created
function int AddToKilledByCount(string Key, int ValueToAdd) {
	local ListElement le;
	local HaloStatListElement hle;
	local int CurrentCount;
	local StringObj stringObj;
	
	if(Key == "") {
		return 0;
	}
	
	if(KilledByCounts == None) {
		KilledByCounts = new class'LGDUtilities.LinkedList';
	}
	
	stringObj = new class'LGDUtilities.StringObj';
	stringObj.Value = Key;
	
	le = KilledByCounts.GetElementByValue(stringObj);
	if(le != None) {
		//Log("HaloStatsPlayerReplicationInfo - AddToKilledByCount - Found element for key: "$Key);
	
		hle = HaloStatListElement(le);
		
		if(hle != None) {
			//Log("HaloStatsPlayerReplicationInfo - AddToKilledByCount - Found element was a [HaloStatListElement]");
			
			hle.Count += ValueToAdd;
			CurrentCount = hle.Count;
		}
	} else {
		//Log("HaloStatsPlayerReplicationInfo - AddToKilledByCount - Did NOT find element for key: ["$Key$"] so created new one");
		
		hle = new class'HaloAnnouncer.HaloStatListElement';
		hle.Value = stringObj;
		hle.Count = ValueToAdd;
		KilledByCounts.Push(hle);
		
		CurrentCount = hle.Count;
	}
	
	return CurrentCount;
}

//resets a specified "kill by" count, given by the "key"
//if one doesn't exist, it'll be created
function ResetKilledByCount(string Key) {
	local ListElement le;
	local HaloStatListElement hle;
	local StringObj stringObj;
	
	if(Key == "") {
		return;
	}
	
	if(KilledByCounts == None) {
		KilledByCounts = new class'LGDUtilities.LinkedList';
	}
	
	stringObj = new class'LGDUtilities.StringObj';
	stringObj.Value = Key;
	
	le = KilledByCounts.GetElementByValue(stringObj);
	if(le != None) {
		hle = HaloStatListElement(le);
		
		if(hle != None) {
			//Log("HaloStatsPlayerReplicationInfo - ResetKilledByCount - Reset count for Key:"$Key);
			hle.Count = 0;
		}
	} else {
		hle = new class'HaloAnnouncer.HaloStatListElement';
		hle.Value = stringObj;
		hle.Count = 0;
		KilledByCounts.Push(hle);
	}
}

//get a "killed by" count given a specified "key"
function int GetKilledByCount(string Key) {
	local ListElement le;
	local HaloStatListElement hle;
	local int CurrentCount;
	local StringObj stringObj;
	
	local bool FoundPrevCount;
	
	if(Key == "") {
		return 0;
	}
	
	if(KilledByCounts == None) {
		KilledByCounts = new class'LGDUtilities.LinkedList';
	}
	
	stringObj = new class'LGDUtilities.StringObj';
	stringObj.Value = Key;
	
	le = KilledByCounts.GetElementByValue(stringObj);
	if(le != None) {
		hle = HaloStatListElement(le);
		
		if(hle != None) {
			CurrentCount = hle.Count;
			FoundPrevCount = true;
		}
	}
	
	if(!FoundPrevCount) {
		//Log("HaloStatsPlayerReplicationInfo - GetKilledByCount - Didn't find a previous count entry for key: "$Key);
	}
	
	return CurrentCount;
}

defaultproperties {
	SuicideCount=0,
	BetrayalCount=0,
	CurrentSpreeCount=0,
	CurrentSpreeSinceDeath=0,
	CurrentSpreeCountWithWeapon=0,
	CurrentSpreeWeapon=None,
}
