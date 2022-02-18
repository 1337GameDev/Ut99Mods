//=============================================================================
// UT_MaleArm used as a Projectile.
//=============================================================================
class UT_MaleArm_Proj extends UT_MaleArm;

var() float    Damage;
var() int	   MomentumTransfer; // Momentum imparted by impacting other actors.
var() name	   MyDamageType;

var() int      HealAmount;
var() sound    HealSound;

var() bool HasLanded;

var float SpawnedTime;
function PreBeginPlay(){
    SpawnedTime = Level.TimeSeconds;
}

function SetHealingAndDamage(GibberProjectileContext projContext) {
    if(projContext != None){
        Damage = projContext.BaseGibDamage * projContext.SmallGibDamageMultiplier;
        HealAmount = Damage * projContext.BaseGibHealMultiplier;
    }
}

function Touch(Actor Other) {
	local Pawn p;
	local GibberProjectileContext projContext;
    local float DamageToUse, PredictedDamageTaken;
    local float HealingToUse;
    local Vector HitLocationToUse;
    local bool ProjectileHurtOwner;

	p = Pawn(Other);

    if((Other.bHidden) || (p == None)){
        return;
    }

    ProjectileHurtOwner = true;

    projContext = GibberProjectileContext(Self.Inventory);
    if(projContext != None){
        SetHealingAndDamage(projContext);
        ProjectileHurtOwner = projContext.DoesFiringHurtOwner;

        if(projContext.WasFromShotgunBlast && ((Level.TimeSeconds-SpawnedTime) <= projContext.LifetimeThresholdToAddExtraDamage) && (VSize(projContext.Location - Self.Location) <= projContext.DistanceThresholdToAddExtraDamage)) {
            Damage *= projContext.ExtraDamageMultiplier;
        }
    }

    DamageToUse = Damage;
    HealingToUse = HealAmount;

    //account for hitting the owner, or the
    if((Self.Instigator == p) || (Self.Instigator == p.Owner)){
        if(ProjectileHurtOwner) {
            //heal the originator
            if(HealingToUse >= 1){
                class'PawnHelper'.static.HealPawn(Self.Instigator, HealingToUse, Self.HealSound, "You picked up one of your gibs: +"$int(HealingToUse));
            }
            Self.Destroy();
        }
    } else if(Self.Physics != PHYS_None){
        HitLocationToUse = Location + CollisionHeight * vect(0,0,0.5);
		//apply damage, based on prediction if this will kill the target
		PredictedDamageTaken = class'PawnHelper'.static.PredictDamageToPawn(p, DamageToUse, Self.Instigator, HitLocationToUse, (MomentumTransfer * Normal(Velocity)), MyDamageType);

		if(p.Health <= PredictedDamageTaken){
			p.gibbedBy(Self.Instigator);
			Self.Destroy();
		} else {
			p.TakeDamage(
			    DamageToUse,
			    Self.Instigator,
			    HitLocationToUse,
			    (MomentumTransfer * Normal(Velocity) ),
			    MyDamageType
            );
            Self.Destroy();
		}
	} else {
	     //Physics is None (and playerpawn isnt owner), so ignore contact
	     return;
	}
}

simulated function Landed(vector HitNormal) {
    HasLanded = true;
	Super.Landed(HitNormal);
    SetCollision(true, false, false);
}

simulated function HitWall(vector HitNormal, actor Wall) {
	local float speed;
    Super.HitWall(HitNormal, Wall);

	speed = VSize(Velocity);
	if(speed > 120) {
        Velocity = Velocity << class'RotatorHelper'.static.RandomlyVaryRotation(Rot(0,0,0), 3, 3, 3);//yaw, pitch, roll
	}
}

singular event BaseChange() {
    local Pawn PrevInstigator;
    //we store who shot this gib projectile in Self.Instigator, so ensure it isn't removed
    PrevInstigator = Self.Instigator;
    Super.BaseChange();
    Self.Instigator = PrevInstigator;
}

defaultproperties
{
      Damage=0.000000
      MomentumTransfer=10000
      MyDamageType="shredded"
      HealAmount=0
      HealSound=Sound'UnrealShare.Pickups.Health2'
      HasLanded=False
      SpawnedTime=0.000000
      RemoteRole=ROLE_SimulatedProxy
      LifeSpan=240.000000
      bCollideActors=True
}
