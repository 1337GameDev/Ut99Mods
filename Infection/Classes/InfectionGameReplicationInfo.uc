//=============================================================================
// InfectionGameReplicationInfo.
//=============================================================================
class InfectionGameReplicationInfo extends TournamentGameReplicationInfo;

replication {
	//reliable if (Role == ROLE_Authority)
	//	Teams, FragLimit, TimeLimit, GoalTeamScore;
		
	//reliable if ((Role == ROLE_Authority) && bNetInitial)
	//	TotalGames, TotalFrags, TotalDeaths, BestPlayers, BestFPHs, BestRecordDate,
	//	TotalFlags;
}

simulated function PostBeginPlay() {
	local int i;
	local InfectionGameInfo infGameInfo;

	Super.PostBeginPlay();

	if (TournamentGameInfo(Level.Game) != None) {
		TotalGames = TournamentGameInfo(Level.Game).EndStatsClass.Default.TotalGames;
		TotalFrags = TournamentGameInfo(Level.Game).EndStatsClass.Default.TotalFrags;
		TotalDeaths = TournamentGameInfo(Level.Game).EndStatsClass.Default.TotalDeaths;
		TotalFlags = TournamentGameInfo(Level.Game).EndStatsClass.Default.TotalFlags;
		
		for (i=0; i<3; i++) {
			BestPlayers[2-i] = TournamentGameInfo(Level.Game).EndStatsClass.Default.BestPlayers[i];
			BestFPHs[2-i] = TournamentGameInfo(Level.Game).EndStatsClass.Default.BestFPHs[i];
			BestRecordDate[2-i] = TournamentGameInfo(Level.Game).EndStatsClass.Default.BestRecordDate[i];
		}
	}
	
	infGameInfo = InfectionGameInfo(Level.Game);
	
	if(infGameInfo != None) {

	}
}

simulated function string GetOrderString(PlayerReplicationInfo PRI) {
	local BotReplicationInfo BRI;

	BRI = BotReplicationInfo(PRI);
	
	if (BRI == None) {
		if (PRI.bIsSpectator && !PRI.bWaitingPlayer) {
			return CommanderString;
		}
		
		return HumanString;
	}
	
	if (BRI.RealOrders == 'follow') {
		return SupportString@BRI.RealOrderGiverPRI.PlayerName@SupportStringTrailer;
	}
	
	if (BRI.RealOrders == 'defend') {
		if ((BRI.OrderObject != None)
			&& (BRI.OrderObject.IsA('ControlPoint') || BRI.OrderObject.IsA('FortStandard')) ) {
			return DefendString@BRI.OrderObject.GetHumanName();
		}
		
		return DefendString;
	}
	
	if (BRI.RealOrders	== 'freelance') {
		return FreelanceString;
	}
	
	if (BRI.RealOrders	== 'attack') {
		if ( (BRI.OrderObject != None)
			&& (BRI.OrderObject.IsA('ControlPoint') || BRI.OrderObject.IsA('FortStandard')) ) {
			return AttackString@BRI.OrderObject.GetHumanName();
		}	
		
		return AttackString;
	}
	
	if (BRI.RealOrders == 'hold') {
		return HoldString;
	}
}

defaultproperties
{
}
