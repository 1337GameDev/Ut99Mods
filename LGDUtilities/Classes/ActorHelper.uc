class ActorHelper extends Actor nousercreate;

/*
  Fetched from: https://ut99.org/viewtopic.php?t=13995
*/
simulated function string getNetSafeVal(Actor actor, string prop) {
	local string ret;
	local ENetRole storedRole;

    storedRole = actor.Role;
    actor.Role = actor.ENetRole.ROLE_Authority;
	ret = actor.GetPropertyText(prop);
	actor.Role = storedRole;

	return ret;
}

static final function Actor FindActor(Actor context, name ActorName, optional name ActorTag) {
   local Actor Temp;

   foreach context.AllActors(class 'Actor', Temp, ActorTag) {
      if (Temp.Name == ActorName) {
         return Temp;
      }
   }

   return None;
}

static final function LinkedList FindAllActorsByTag(Actor context, name ActorTag) {
   local Actor Temp;
   local LinkedList list;

   list = new class'LGDUtilities.LinkedList';

   foreach context.AllActors(class'Actor', Temp, ActorTag) {
      list.Push(Temp);
   }

   return list;
}

//*******************************
//Placement and comparison utils
//*******************************
static final function float HSize(Vector aVec) {
	return VSize(aVec * vect(1,1,0));
}

static final function bool InCylinder(Vector aVec, float R, float H) {
	return (Abs(aVec.Z) <= H) && (HSize(aVec) <= R);
}

static final function bool ActorsTouching(Actor A, Actor B) {
	return InCylinder
		( A.Location - B.Location
		, A.CollisionRadius + B.CollisionRadius
		, A.CollisionHeight + B.CollisionHeight);
}

static final function bool ActorsTouchingExt(Actor A, Actor B, float ExtraR, float ExtraH) {
	return InCylinder
		( A.Location - B.Location
		, A.CollisionRadius + B.CollisionRadius + ExtraR
		, A.CollisionHeight + B.CollisionHeight + ExtraH);
}

//**********************************************
//Announce to all player and pseudo-player pawns
//**********************************************
static final function AnnounceAll(Actor Broadcaster, string Msg) {
	local PlayerReplicationInfo PRI;
	local Pawn P;

	if (Broadcaster == none) {
		return;
	}

    ForEach Broadcaster.AllActors(class'PlayerReplicationInfo', PRI) {
		P = Pawn(PRI.Owner);

		if(P != none && (P.bIsPlayer || P.IsA('MessagingSpectator')) ) {
			P.ClientMessage(Msg);
		}
	}
}

static function ActorDirectionRelationResult GetDirectionRelationOfSourceToTarget(Actor Source, Actor Target, bool ConsiderSourcePawnViewRotation) {
    local ActorDirectionRelationResult result;
    local Vector aFacing, aToB;
    local float orientation;

    result = new class'LGDUtilities.ActorDirectionRelationResult';

    if((Source == Target) || (Source == None) || (Target == None)) {
        return result;
    }

    if(ConsiderSourcePawnViewRotation && (Pawn(Source) != None) ){
        //What's the Source's view rotation?
        aFacing = Vector(Pawn(Source).ViewRotation);
        // Get the vector from Target to Source
        aToB = Target.Location - Source.Location;
        orientation = aFacing dot Normal(aToB);
        // > 0.0  Target points forwards in relation to Source (up to 90° apart)
        // = 0.0  Target is perpendicular to Source (exactly 90° between Target and Source)
        // < 0.0  Target points backwards in relation to Source (more than 90° apart)
    } else {
        // What direction is Source facing in?
        aFacing = Normal(Vector(Source.Rotation));
        // Get the vector from Target to Source
        aToB = Target.Location - Source.Location;
        orientation = aFacing dot aToB;
        // > 0.0  Target is in front of Source
        // = 0.0  Target is exactly to the right/left of Source
        // < 0.0  Target is behind Source
    }

    result.SetRelationFromDotResult(orientation);
}

/******************************************************************************
Checks if *A* is relevant and destroys it, if not.
The result of Level.Game.IsRelevant() is returned.
Intended for use with hacked bGameRelevant=True-spawned Actors.
******************************************************************************/
static function bool CheckActorRelevance(Actor A) {
	local bool result;

    if(A == None) {
        return false;
    }

	result = A.Level.Game.IsRelevant(A);

	if (!result && ! A.bDeleteMe) {
		A.Destroy();
	}

	return result;
}

static function CheckSpawnedActorArrayRelevance(Actor context, LinkedList ActorList) {
    local ListElement le;
    local Actor ActorValue;

    if(ActorList != None) {
        le = ActorList.Head;
        ActorValue = Actor(le.Value);

        While(le != None) {
            if(ActorValue != None) {
                Class'LGDUtilities.ActorHelper'.static.CheckActorRelevance(ActorValue);
            }

            le = le.Next;
            ActorValue = Actor(le.Value);
        }
    }
}

/******************************************************************************
Tries to spawn an Actor of the given *SpawnClass* with the properties
bBlockActors=false, bCollideWorld=false to avoid collision while placing and
bGameRelevant = true to avoid passing the new created Actor to the relevance
chain. Always call *CheckActorRelevance()* later to have the Actor passed the
relevance chain.

Changed default properties are reset to their previous values after the actor
has spawned.
Either the new Actor is returned or None if spawn failed.
******************************************************************************/
static function Actor SpawnActor(Actor context, Class<Actor> SpawnClass, optional Actor SpawnOwner, optional Name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation) {
	local Actor result;

	local bool bBlockActorsDefault;
	local bool bGameRelevantDefault;
	local bool bCollideWorldDefault;

	bBlockActorsDefault = SpawnClass.Default.bBlockActors;
	bGameRelevantDefault = SpawnClass.Default.bGameRelevant;
	bCollideWorldDefault = SpawnClass.Default.bCollideWorld;

	SpawnClass.Default.bBlockActors = false;
	SpawnClass.Default.bGameRelevant = true;
	SpawnClass.Default.bCollideWorld = false;

	result = context.Spawn(SpawnClass, SpawnOwner, SpawnTag, SpawnLocation, SpawnRotation);

	SpawnClass.Default.bBlockActors = bBlockActorsDefault;
	SpawnClass.Default.bGameRelevant = bGameRelevantDefault;
	SpawnClass.Default.bCollideWorld = bCollideWorldDefault;

	if (result == None) {
		Log("SpawnActor - could not spawn"@SpawnClass@"at location"@SpawnLocation);
	} else {
		result.SetCollision(result.bCollideActors, SpawnClass.Default.bBlockActors, result.bBlockPlayers);
		result.bGameRelevant = bGameRelevantDefault;
		result.bCollideWorld = bCollideWorldDefault;
	}

	return result;
}

/* ReplaceWith()
Call this function to replace an actor Other with an actor of aClass.
*/
static function bool ReplaceWith(Actor Other, string aClassName) {
	if(Other == None) {
		return false;
	}
	
	return Other.Level.Game.BaseMutator.ReplaceWith(Other, aClassName);
}

defaultproperties {
}
