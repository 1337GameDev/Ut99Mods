//--------------------------------------------------
// Data to be used with KillConfirmedGameReplicationInfo.DogTagStats (an LGDUtilities.LinkedList)
//
// Tracks an individual player's tags they've created, scored and denied
//--------------------------------------------------
class DogTagStatsObj extends Object;

var int PlayerID;

var int TagsDropped;//times you've died
var int EnemyTagsCollected;//points scored
var int FriendlyTagsCollected;//points denied for enemy