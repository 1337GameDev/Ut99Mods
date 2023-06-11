//=============================================================================
// PrimaryShotOnlyFlakCannon.
//=============================================================================
class PrimaryShotOnlyFlakCannon extends UT_FlakCannon;

function GiveTo(Pawn Other) {
    local Inventory Inv;
    local Pawn PawnOwner;
    local class<Weapon> FlakClass;

	Super.GiveTo(Other);

    PawnOwner = Pawn(Owner);
    FlakClass = class'Botpack.UT_FlakCannon';

    //delete old flak cannon
	for(Inv=PawnOwner.Inventory; Inv!=None; Inv=Inv.Inventory){
		if (Inv.class == FlakClass) {
		    //if this pawn's selected weapon is an enforcer (or is going to switch to an enforcer via PendingWeapon)
		    if((PawnOwner.Weapon != None) && ((PawnOwner.Weapon.Class == FlakClass)) || ((PawnOwner.PendingWeapon != None) && (PawnOwner.PendingWeapon.Class == FlakClass)) ){
                PawnOwner.SwitchToBestWeapon();
            }

            Inv.Destroy();
		}
    }
}

function float RateSelf(out int bUseAltMode) {
	local float EnemyDist, rating;
	local vector EnemyDir;

	bUseAltMode = 0;

	if ( AmmoType.AmmoAmount <=0 )
		return -2;
	if ( Pawn(Owner).Enemy == None )
	{
		return AIRating;
	}
	EnemyDir = Pawn(Owner).Enemy.Location - Owner.Location;
	EnemyDist = VSize(EnemyDir);
	rating = FClamp(AIRating - (EnemyDist - 450) * 0.001, 0.2, AIRating);
	if ( Pawn(Owner).Enemy.IsA('StationaryPawn') )
	{
		return AIRating + 0.3;
	}
	if ( EnemyDist > 900 )
	{
		if ( EnemyDist > 2000 )
		{
			if ( EnemyDist > 3500 )
				return 0.2;
			return (AIRating - 0.3);
		}
		if ( EnemyDir.Z < -0.5 * EnemyDist )
		{
			return (AIRating - 0.3);
		}
	}
	else if ( (EnemyDist < 750) && (Pawn(Owner).Enemy.Weapon != None) && Pawn(Owner).Enemy.Weapon.bMeleeWeapon )
	{
		return (AIRating + 0.3);
	}
	else if ( (EnemyDist < 340) || (EnemyDir.Z > 30) )
	{
		return (AIRating + 0.2);
	}

	return rating;
}

function AltFire(float Value) {
	if ( AmmoType == None )
	{
		// ammocheck
		GiveAmmo(Pawn(Owner));
	}
}

defaultproperties {
      WeaponDescription="Classification: Heavy Shrapnel\\nPrimary Fire: White hot chunks of scrap metal are sprayed forth, shotgun style.\\nSecondary Fire: DISABLED \\nTechniques: The Primary Only Flak Cannon is the same as the original except it cannot ALT-FIRE."
      PickupMessage="You got the Primary Only Flak Cannon."
      ItemName="Flak Cannon (Primary Fire Only)"
	    PickupAmmoCount=30,//2x more than normal flak cannon
}
