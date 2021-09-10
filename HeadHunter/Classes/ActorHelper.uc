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

   list = new class'LinkedList';

   foreach context.AllActors(class 'Actor', Temp, ActorTag) {
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
static final function AnnounceAll( Actor Broadcaster, string Msg) {
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

    result = new class'ActorDirectionRelationResult';

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

defaultproperties {

}
