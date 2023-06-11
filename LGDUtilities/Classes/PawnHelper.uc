class PawnHelper extends Actor nousercreate;

//***************************************
//Client-predictable eye height
//***************************************
static final function float GetEyeHeight(Pawn Other) {
	local float ForceEyeHeight;

	if ((Other.Mesh != None) && Other.HasAnim(Other.AnimSequence) ) {
		if ((Other.GetAnimGroup(Other.AnimSequence) == 'Ducking') && (Other.AnimFrame > -0.03)) {
			ForceEyeHeight = (Other.default.BaseEyeHeight+1) * 0.1;
		} else if(InStr(string(Other.AnimSequence),"Dead") != -1 || InStr(string(Other.AnimSequence),"DeathEnd") != -1) {
			ForceEyeHeight = (Other.default.BaseEyeHeight+1) * -0.1;
		}
	}

	if(ForceEyeHeight == 0) {
		ForceEyeHeight = Other.default.BaseEyeHeight;
	}

	return ForceEyeHeight;
}

static final function Vector GetOffsetAbovePawn(Pawn p) {
       local Vector offset, pos;
       pos = p.Location;

       offset = vect(0,0,1)*p.CollisionHeight;

       return offset;
}

static final function Vector GetAbovePawn(Pawn p) {
       local Vector pos;
       pos = p.Location + class'LGDUtilities.PawnHelper'.static.GetOffsetAbovePawn(p);
       return pos;
}

//Copied from Botpack.TournamentHealth[State=Pickup].Touch
static final function HealPawn(Pawn p, int HealingAmount, sound HealSound, string HealMessage){
	local int HealMax;
	local StringObj healStr;

    if(p == None){
		return;
	}

    healStr = new class'LGDUtilities.StringObj';
    healStr.Value = HealMessage;

	HealMax = p.default.health;

	if (p.Health < HealMax){
		p.Health += HealingAmount;

		if (p.Health > HealMax){
		    p.Health = HealMax;
		}

        if(HealingAmount > 0) {
            if((HealMessage != "")){
		        p.ReceiveLocalizedMessage(class'LGDUtilities.HealMessage', 0, None, None, healStr);
		    }

            if(HealSound != None){
		        p.PlaySound(HealSound,,2.5);
		        p.MakeNoise(0.2);
		    }
		}
	}
}

static function bool IsBoss(Pawn p){
    local bool IsBoss;
    local Bot bossBot;
    local PlayerPawn bossPlayer;
    IsBoss = false;

    //Some overlap between checks, but not a big deal (CarcassType, and Mesh)
    //Chose readability over reducing line count
    if(p != None){
        bossPlayer = PlayerPawn(p);

        if(bossPlayer != None){
            IsBoss = (TBoss(bossPlayer) != None);
            IsBoss = IsBoss || bossPlayer.CarcassType == Class'Botpack.TBossCarcass';
            IsBoss = IsBoss || bossPlayer.SpecialMesh == "Botpack.TrophyBoss";
            IsBoss = IsBoss || bossPlayer.MenuName == "Boss";
            IsBoss = IsBoss || bossPlayer.Mesh == LodMesh'Botpack.Boss';
        } else {
            bossBot = Bot(p);

            if(bossBot != None){
                IsBoss = (TBossBot(bossBot) != None);
                IsBoss = IsBoss || bossBot.CarcassType == Class'Botpack.TBossCarcass';
                IsBoss = IsBoss || bossBot.Mesh == LodMesh'Botpack.Boss';
                IsBoss = IsBoss || bossBot.DefaultSkinName == "BossSkins.Boss";
                IsBoss = IsBoss || bossBot.StatusDoll == Texture'Botpack.Icons.BossDoll';
                IsBoss = IsBoss || bossBot.StatusBelt == Texture'Botpack.Icons.BossBelt';
            }
        }
    }

    return IsBoss;
}

//Based on Pawn.TakeDamage
//This method has same signature, after input "Target" pawn param
static function int PredictDamageToPawn(Pawn Target,
    int Damage, Pawn InstigatedBy, Vector HitLocation,
    Vector Momentum, name DamageType){
	    local int ActualDamage;
	    local bool bAlreadyDead;

    if((Target != None) && !Target.bHidden){
		bAlreadyDead = (Target.Health <= 0);
		ActualDamage = Target.Level.Game.ReduceDamage(Damage, DamageType, Target, instigatedBy);

		if(Target.bIsPlayer){
			if(Target.ReducedDamageType == 'All'){ //God mode
				ActualDamage = 0;
			} else if (Target.Inventory != None){ //then check if carrying armor
				ActualDamage = Target.Inventory.ReduceDamage(ActualDamage, DamageType, HitLocation);
			} else {
				ActualDamage = Damage;
			}
		} else if(
                    (InstigatedBy != None) &&
					(InstigatedBy.IsA(Target.Class.Name) ||
                     Target.IsA(InstigatedBy.Class.Name))
        ){
			ActualDamage = ActualDamage * FMin(1 - Target.ReducedDamagePct, 0.35);
		} else if( (Target.ReducedDamageType == 'All') ||
				 ((Target.ReducedDamageType != '') && (Target.ReducedDamageType == DamageType)) ){
			ActualDamage = float(ActualDamage) * (1 - Target.ReducedDamagePct);
		}
	}

    return ActualDamage;
}

static function Pawn GetPawnFromPlayerID(Actor context, int PlayerID) {
    local Pawn p;

	if(PlayerID > -1) {
	    foreach context.AllActors(class'Pawn', p) {
		    if(p.PlayerReplicationInfo != None){
				if(p.PlayerReplicationInfo.PlayerID == PlayerID) {
					return p;
				}
			}
		}
	}

	return p;
}

static function Pawn GetRandomPlayerPawnOrBot(Actor context, optional LinkedList PlayerIDsToExclude, optional bool IncludeSpectators) {
    local int NumChosen;
	local Bot b;
	local PlayerPawn pp;
	local ListElement le;
	local Pawn PawnChosen;
	local LinkedList allPlayersAndBots;
	local bool excludeSomePlayerIDs;
	local IntObj playerIDToCheckInExcludeList;
	local bool IncludeThisAsPossibleToBeSelected;
	
    excludeSomePlayerIDs = (PlayerIDsToExclude != None) && (PlayerIDsToExclude.Count > 0);
	allPlayersAndBots = new class'LGDUtilities.LinkedList';
    playerIDToCheckInExcludeList = new class'LGDUtilities.IntObj';

	foreach context.AllActors(class'PlayerPawn', pp) {
		IncludeThisAsPossibleToBeSelected = false;
		
	    if(excludeSomePlayerIDs){
            if(pp.PlayerReplicationInfo != None) {
                playerIDToCheckInExcludeList.Value = pp.PlayerReplicationInfo.PlayerID;

                if(!PlayerIDsToExclude.ContainsValue(playerIDToCheckInExcludeList) ) {
					IncludeThisAsPossibleToBeSelected = true;
	            }
	        }
		} else {
			IncludeThisAsPossibleToBeSelected = true;
		}
		
		//if we aren't to be excluded
		if(IncludeThisAsPossibleToBeSelected) {
			if(pp.PlayerReplicationInfo != None) {
				//if we are to exclude spectators
				if(IncludeSpectators || !pp.PlayerReplicationInfo.bIsSpectator) {
					IncludeThisAsPossibleToBeSelected = true;
				} else {
					//we don't want to include spectators and the player is marked as a spectator
					IncludeThisAsPossibleToBeSelected = false;
				}
			}
		}
		
		if(IncludeThisAsPossibleToBeSelected) {
			allPlayersAndBots.Push(pp);
		}
	}

	foreach context.AllActors(class'Bot', b) {
	    if(excludeSomePlayerIDs){
            if(b.PlayerReplicationInfo != None) {
                playerIDToCheckInExcludeList.Value = b.PlayerReplicationInfo.PlayerID;

				if(!PlayerIDsToExclude.ContainsValue(playerIDToCheckInExcludeList) ) {
	                allPlayersAndBots.Push(b);
	            }
	        }
		} else {
		    allPlayersAndBots.Push(b);
		}
	}

    if(allPlayersAndBots.Count > 0) {
	    NumChosen = Rand(allPlayersAndBots.Count);

	    le = allPlayersAndBots.GetElementAt(NumChosen);
	    if(le != None) {
	        PawnChosen = Pawn(le.Value);
	    }
	}

	return PawnChosen;
}

static function LinkedList GetAllPawnsOfTeam(Actor context, byte Team, optional bool IncludeSpectators) {
	local Pawn P;
	local LinkedList ll;
	ll = new class'LGDUtilities.LinkedList';
	
	For (P=context.Level.PawnList; P!=None; P=P.NextPawn) {
		if((P.PlayerReplicationInfo != None) && (P.PlayerReplicationInfo.Team == Team) && (IncludeSpectators || !P.PlayerReplicationInfo.bIsSpectator)) {
			ll.Push(P);
		}
	}
	
	return ll;
}

static function Pawn GetBestScoringPawnOfTeam(Actor context, byte Team, optional bool limitByIsPlayer) {
	local Pawn P, Best;
	
	For (P=context.Level.PawnList; P!=None; P=P.NextPawn) {
		if(!limitByIsPlayer || P.bIsPlayer) {
			if((P.PlayerReplicationInfo != None) && (P.PlayerReplicationInfo.Team == Team)) {
				if(Best == None) {
					Best = P;
				} else if(P.PlayerReplicationInfo.Score > Best.PlayerReplicationInfo.Score) {
					Best = P;
				}
			}
		}
	}
	
	return Best;
}

static function LinkedList GetBestScoringPawns(Actor context, optional bool limitByIsPlayer) {
	return class'PawnHelper'.static.GetBestScoringPawnsInScoreRange(context, limitByIsPlayer, -1, -1);
}

static function LinkedList GetBestScoringPawnsInScoreRange(Actor context, bool limitByIsPlayer, int minimumScore, int maximumScore) {
	local LinkedList pawnList;
	local Pawn P;
	local int BestScore;
	
	BestScore = -1;
	pawnList = new class'LGDUtilities.LinkedList';
	
	//find best score within range
	For (P=context.Level.PawnList; P!=None; P=P.NextPawn) {
		if(!limitByIsPlayer || P.bIsPlayer) {
			if((minimumScore == -1) || (P.PlayerReplicationInfo.Score >= minimumScore)) {
				if((maximumScore == -1) || (P.PlayerReplicationInfo.Score <= maximumScore)) {
					if((BestScore == -1) || (P.PlayerReplicationInfo.Score >= BestScore)) {
						BestScore = P.PlayerReplicationInfo.Score;
					}
				}
			}
		}
	}
	
	//now add all pawns with this score to the list (if they match the isPlayer check)
	For (P=context.Level.PawnList; P!=None; P=P.NextPawn) {
		if(!limitByIsPlayer || P.bIsPlayer) {
			if(P.PlayerReplicationInfo.Score == BestScore) {
				pawnList.Push(P);
			}
		}
	}
	
	return pawnList;
}

static function LinkedList GetAllPlayeIDsOfTeam(Actor context, byte Team, optional bool IncludeSpectators) {
	local Pawn P;
	local LinkedList ll;
	ll = new class'LGDUtilities.LinkedList';
	
	For (P=context.Level.PawnList; P!=None; P=P.NextPawn) {
		if((P.PlayerReplicationInfo != None) && (P.PlayerReplicationInfo.Team == Team) && (!IncludeSpectators || !P.PlayerReplicationInfo.bIsSpectator)) {
			class'LGDUtilities.IntObj'.static.PushIntOntoLinkedList(ll, p.PlayerReplicationInfo.PlayerID);
		}
	}
	
	return ll;
}

static function bool IsPawnDead(Pawn p) {
    if(p == None) {
        return false;
    } else {
        return (p.bIsPlayer && p.bHidden && (p.Health <= 0) && p.IsInState('Dying') );
    }
}

simulated static function PlayerPawn GetActivePlayerPawn(Actor context){
    local PlayerPawn P;

    ForEach context.AllActors(class'PlayerPawn', P) {
        if (P.myHUD != None) {
            return P;
        }
    }

    return None;
}

defaultproperties {
}
