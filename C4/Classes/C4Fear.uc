//=============================================================================
// C4Fear.
// Creatures will tend to back away when entering this spot
// To be effective, there should also not be any paths going through the area
//=============================================================================
class C4Fear extends Triggers;

var() bool bInitiallyActive;

function Touch(Actor Other) {
	local Bot B;

	if (Other.bIsPawn) {
		B = Bot(Other);
		if ( B == None )
			return;

		if ( B.bNovice )
		{
			if ( FRand() > 0.4 + 0.1 * B.Skill )
				return;
		}
		else if ( FRand() > 0.7 + 0.1 * B.Skill )
			return;
		B.FearThisSpot(self);
		if ( CollisionRadius < 120 )
			Destroy();
		else
			SetCollisionSize(CollisionRadius - 25, CollisionHeight);
	}
}

defaultproperties {
      bInitiallyActive=False
      Physics=PHYS_Trailer
      RemoteRole=ROLE_None
      CollisionRadius=200.000000
}
