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
       pos = p.Location + class'PawnHelper'.static.GetOffsetAbovePawn(p);
       return pos;
}

//Copied from Botpack.TournamentHealth[State=Pickup].Touch
static final function HealPawn(Pawn p, int HealingAmount, sound HealSound, string HealMessage){
	local int HealMax;
	local StringObj healStr;

    if(p == None){
		return;
	}

    healStr = new class'StringObj';
    healStr.Value = HealMessage;

	HealMax = p.default.health;

	if (p.Health < HealMax){
		p.Health += HealingAmount;

		if (p.Health > HealMax){
		    p.Health = HealMax;
		}

        if(HealingAmount > 0) {
            if((HealMessage != "")){
		        p.ReceiveLocalizedMessage(class'HealMessage', 0, None, None, healStr);
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
//This method has same signature, after input Target pawn
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

static function Pawn GetRandomPlayerPawnOrBot(Actor context, optional LinkedList PlayerIDsToExclude) {
    local int NumChosen;
	local Bot b;
	local PlayerPawn pp;
	local ListElement le;
	local Pawn PawnChosen;
	local LinkedList allPlayersAndBots;
	local bool excludeSomePlayerIDs;
	local IntObj playerIDToCheckInExcludeList;

    excludeSomePlayerIDs = (PlayerIDsToExclude != None) && (PlayerIDsToExclude.Count > 0);
	allPlayersAndBots = new class'LinkedList';
    playerIDToCheckInExcludeList = new class'IntObj';

	foreach context.AllActors(class'PlayerPawn', pp) {
	    if(excludeSomePlayerIDs){
            if(pp.PlayerReplicationInfo != None) {
                playerIDToCheckInExcludeList.Value = pp.PlayerReplicationInfo.PlayerID;

                if(!PlayerIDsToExclude.ContainsValue(playerIDToCheckInExcludeList) ) {
	                allPlayersAndBots.Push(pp);
	            }
	        }
		} else {
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

static function bool IsPawnDead(Pawn p) {
    if(p == None) {
        return false;
    } else {
        return (p.bIsPlayer && p.bHidden && (p.Health <= 0) && p.IsInState('Dying') );
    }
}

defaultproperties
{
}
