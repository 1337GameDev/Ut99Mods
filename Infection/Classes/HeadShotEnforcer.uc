//=============================================================================
// HeadShotEnforcer
//=============================================================================
class HeadShotEnforcer extends Enforcer;

function GiveTo(Pawn Other) {
    local Inventory Inv;
    local Pawn PawnOwner;
    local class<Weapon> EnforcerClass;

	Super.GiveTo(Other);

    PawnOwner = Pawn(Owner);
    EnforcerClass = class'Botpack.Enforcer';

    //delete old enforcer
	for(Inv=PawnOwner.Inventory; Inv!=None; Inv=Inv.Inventory){
		if (Inv.class == EnforcerClass) {
		    //if this pawn's selected weapon is an enforcer (or is going to switch to an enforcer via PendingWeapon)
		    if((PawnOwner.Weapon != None) && ((PawnOwner.Weapon.Class == EnforcerClass)) || ((PawnOwner.PendingWeapon != None) && (PawnOwner.PendingWeapon.Class == EnforcerClass)) ){
                PawnOwner.SwitchToBestWeapon();
            }

            Inv.Destroy();
		}
    }

}

function SetSwitchPriority(Pawn Other) {


	Super.SetSwitchPriority(Other);
}

function bool HandlePickupQuery( inventory Item )
{
	local Pawn P;
	local Inventory Copy;

	if ( (Item.IsA('Enforcer') || Item.IsA('HeadShotEnforcer')) && (SlaveEnforcer == None) )
	{
		P = Pawn(Owner);
		// spawn a double
		Copy = Spawn(self.class, P);
		Copy.BecomeItem();
		ItemName = DoubleName;
		SlaveEnforcer = HeadShotEnforcer(Copy);
		SetTwoHands();
		AIRating = 0.4;
		SlaveEnforcer.SetUpSlave( Pawn(Owner).Weapon == self );
		SlaveEnforcer.SetDisplayProperties(Style, Texture, bUnlit, bMeshEnviromap);
		SetTwoHands();
		P.ReceiveLocalizedMessage( class'PickupMessagePlus', 0, None, None, Self.Class );
		Item.PlaySound(Item.PickupSound);
		if (Level.Game.LocalLog != None)
			Level.Game.LocalLog.LogPickup(Item, Pawn(Owner));
		if (Level.Game.WorldLog != None)
			Level.Game.WorldLog.LogPickup(Item, Pawn(Owner));
		Item.SetRespawn();
		return true;
	}
	return Super.HandlePickupQuery(Item);
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z) {
	local UT_Shellcase s;
	local vector realLoc;
	local Pawn PawnOwner;
	local Inventory inv;

    PawnOwner = Pawn(Owner);

	realLoc = Owner.Location + CalcDrawOffset();

	s = Spawn(class'UT_ShellCase',, '', realLoc + 20 * X + FireOffset.Y * Y + Z);

	if (s != None) {
		s.Eject(((FRand()*0.3+0.4)*X + (FRand()*0.2+0.2)*Y + (FRand()*0.3+1.0) * Z)*160);
	}

	if (Other == Level) {
		if (bIsSlave || (SlaveEnforcer != None)) {
			Spawn(class'UT_LightWallHitEffect',,, HitLocation+HitNormal, Rotator(HitNormal));
		} else {
			Spawn(class'UT_WallHit',,, HitLocation+HitNormal, Rotator(HitNormal));
		}
	} else if ((Other != self) && (Other != Owner) && (Other != None)) {
		if (FRand() < 0.2) {
			X *= 5;
		}

		//check if enemy has shieldbelt, if so, give them protection from headshots
		if(Other.bIsPawn) {
			inv = Pawn(Other).FindInventoryType(Class'UT_ShieldBelt');
		}

		if ((inv == None) && Other.bIsPawn && (HitLocation.Z - Other.Location.Z > 0.62 * Other.CollisionHeight)
					&& (!PawnOwner.IsA('Bot') || !Bot(PawnOwner).bNovice)) {
			Other.TakeDamage(1000, PawnOwner, HitLocation, 3000.0*X, 'decapitated');
		} else	{
			Other.TakeDamage(HitDamage, PawnOwner, HitLocation, 3000.0*X, MyDamageType);
		}
		//Other.TakeDamage(HitDamage, Pawn(Owner), HitLocation, 3000.0*X, MyDamageType);

		if (!Other.bIsPawn && !Other.IsA('Carcass') ) {
			Spawn(class'UT_SpriteSmokePuff',,,HitLocation+HitNormal*9);
		} else {
			Other.PlaySound(Sound 'ChunkHit',, 4.0,,100);
		}
	}
}

defaultproperties
{
      DoubleName="Double HeadShot Enforcer"
      WeaponDescription="Classification: Light PistolnPrimary Fire: Accurate but slow firing instant hit.nSecondary Fire: Sideways, or 'Gangsta' firing mode, shoots twice as fast and half as accurate as the primary fire.nTechniques: Aim for the head with this variant."
      PickupMessage="You picked up another HeadShotEnforcer Enforcer!"
      ItemName="HeadShot Enforcer"
}
