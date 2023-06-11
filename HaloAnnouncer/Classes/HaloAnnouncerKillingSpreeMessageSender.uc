//--------------------------------------------------
// A class that's used by HaloAnnouncer and other mods/gametypes to look at tracked data
// THEN trigger LocalMessage class being sent to PlayerPawns.
//--------------------------------------------------
class HaloAnnouncerKillingSpreeMessageSender extends HaloKillingSpreeMessageSender;

function TriggerSendingMessages(HaloStatsPlayerReplicationInfo killerStats, HaloStatsPlayerReplicationInfo victimStats, bool OnlyInvolvedPlayers, bool IsSuicide, bool IsBetrayal, Name DamageType) {
	local IterativeLocalMessageSender localMessageSender;
	local LocalMessageQueue localMessageQ;
	local LocalMessageToSendSettings localMessageSettings;
	local HaloKillingSpreeMessageData localMessageExtraData;
	local PlayerPawn killerPP, victimPP;
	
	//use to store a value fetched from HaloStatsPlayerReplicationInfo
	local int StatValue;
	
	//trigger messages to be shown to players here
	//call: PlayerPawn.ReceiveLocalizedMessage(class'LocalMessage', Num, Victim.PlayerReplicationInfo, Killer.PlayerReplicationInfo );
	
	if(!IsSuicide) {
		if(killerStats != None) {
			killerPP = PlayerPawn(killerStats.PawnOwner);
			
			if(killerPP != None) {
				localMessageSender = class'LGDUtilities.IterativeLocalMessageSender'.static.GetRef(killerPP);
				
				if(localMessageSender != None) {
					localMessageQ = localMessageSender.GetLocalMessageQueueForPlayerPawn(killerPP);
					
					if(localMessageQ != None) {
						localMessageSettings = new class'LocalMessageToSendSettings';
						localMessageSettings.LocalMessageClass = class'HaloAnnouncer.HaloKillingSpreeMessage';
						
						if(victimStats != None) {
							victimPP = PlayerPawn(victimStats.PawnOwner);
							
							if(victimPP != None) {
								localMessageSettings.RelatedPRI_1ToSend = victimPP.PlayerReplicationInfo;
							}
						}
						
						localMessageSettings.RelatedPRI_2ToSend = killerPP.PlayerReplicationInfo;
						
						localMessageExtraData = new class'HaloAnnouncer.HaloKillingSpreeMessageData';
						localMessageExtraData.VictimStats = victimStats;
						localMessageExtraData.KillerStats = killerStats;
						localMessageExtraData.IsSuicide = IsSuicide;
						localMessageExtraData.IsBetrayal = IsBetrayal;
						localMessageExtraData.DamageType = DamageType;
						localMessageExtraData.OnlyInvolvedPlayers = OnlyInvolvedPlayers;
						
						localMessageSettings.OptionalObjectToSend = localMessageExtraData;
					
						if((!IsBetrayal) && (killerStats.CurrentSpreeCount > 0) && (killerStats.CurrentSpreeCount < 30)) {
							localMessageSettings.SwitchValToSend = killerStats.CurrentSpreeCount;
							localMessageQ.AddMessageToQueue(localMessageSettings);
						} else {
							if(IsBetrayal) {
								localMessageSettings.SwitchValToSend = class'HaloAnnouncer.HaloKillingSpreeMessage'.default.SWITCHVAL_BETRAYAL;
								localMessageQ.AddMessageToQueue(localMessageSettings);
								
								//also send one for the betrayed person
								//but only play the sound locally
								
							} else if(IsSuicide) {
								Log("HaloAnnouncerKillingSpreeMessageSender - Adding suicide message to queue");
								localMessageSettings.SwitchValToSend = class'HaloAnnouncer.HaloKillingSpreeMessage'.default.SWITCHVAL_SUICIDE;
								localMessageQ.AddMessageToQueue(localMessageSettings);
							}
						}
						
						//now do unique weapon spree messages
						
						//shotgun
						//only currently have the Infection.PrimaryShotOnlyFlakCannon known -- so use that name
						StatValue = killerStats.GetKillCount("Infection.PrimaryShotOnlyFlakCannon");
						if(StatValue > 4) {
							if(StatValue == 5) {
								//shotgun spree
								
							} else if(StatValue == 10) {
								//open season
								
							} else if(StatValue == 15) {
								//buck wild
							}
						}
						
						//sword
						StatValue = killerStats.GetKillCount("ChaosUT.Sword");
						if(StatValue > 4) {
							if(StatValue == 5) {
								//sword spree
								
							} else if(StatValue == 10) {
								//slice n dice
								
							} else if(StatValue == 15) {
								//cutting crew
								
							}
						}
						
						Log("HaloAnnouncerKillingSpreeMessageSender - Done checking stats for messages to send");
					}
				}
			}
		} else {
			//killerstats is NONE
			//not suicide, but likely environmental trap / forced death
		}
	} else {
		//suicide
		
		victimPP = PlayerPawn(victimStats.PawnOwner);
			
		if(victimPP != None) {
			localMessageSender = class'LGDUtilities.IterativeLocalMessageSender'.static.GetRef(victimPP);
			
			if(localMessageSender != None) {
				localMessageQ = localMessageSender.GetLocalMessageQueueForPlayerPawn(victimPP);
				
				if(localMessageQ != None) {
					localMessageSettings = new class'LocalMessageToSendSettings';
					localMessageSettings.LocalMessageClass = class'HaloAnnouncer.HaloKillingSpreeMessage';
					
					if(killerStats != None) {
						killerPP = PlayerPawn(killerStats.PawnOwner);
						
						if(killerPP != None) {
							localMessageSettings.RelatedPRI_2ToSend = killerPP.PlayerReplicationInfo;
						}
					}
					
					localMessageSettings.RelatedPRI_2ToSend = killerPP.PlayerReplicationInfo;
					
					localMessageExtraData = new class'HaloAnnouncer.HaloKillingSpreeMessageData';
					localMessageExtraData.VictimStats = victimStats;
					localMessageExtraData.KillerStats = killerStats;
					localMessageExtraData.IsSuicide = IsSuicide;
					localMessageExtraData.IsBetrayal = IsBetrayal;
					localMessageExtraData.DamageType = DamageType;
					localMessageExtraData.OnlyInvolvedPlayers = OnlyInvolvedPlayers;
					
					localMessageSettings.OptionalObjectToSend = localMessageExtraData;
					
					localMessageSettings.SwitchValToSend = class'HaloAnnouncer.HaloKillingSpreeMessage'.default.SWITCHVAL_SUICIDE;
					localMessageQ.AddMessageToQueue(localMessageSettings);
					
					//now do unique weapon spree messages
					
				}
			}
		}
	}
	
	
}