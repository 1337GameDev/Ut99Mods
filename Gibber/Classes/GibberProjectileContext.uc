class GibberProjectileContext extends Inventory nousercreate;

var float BaseGibSpeed;
var bool DoesFiringHurtOwner;

var float BossGibDamageMultiplier;
var float SmallGibDamageMultiplier;
var float BaseGibDamage;

var float BaseGibHealMultiplier;//a multiplier based from the damage it deals, for how much it heals

var float LifetimeThresholdToAddExtraDamage;//if the projectile is less this number of seconds, then extra damage is eligible
var float DistanceThresholdToAddExtraDamage;//if the target is close enough
var float ExtraDamageMultiplier;
var bool WasFromShotgunBlast;

var Pawn SourcePawn;
var UTPlayerChunks ChunkOwner;

function SetInMotion(){
    local Class<Carcass> pawnCarcass;

	ChunkOwner.Velocity = Vector(ChunkOwner.Rotation) * BaseGibSpeed;
	ChunkOwner.SetRotation(class'LGDUtilities.RandomHelper'.static.GetRandomRotation());

	if(ChunkOwner.Region.Zone.bWaterZone) {
		ChunkOwner.Velocity *= 0.5;
	}

	ChunkOwner.bDecorative = false;

	if (ChunkOwner.DrawScale != 1.0) {
		ChunkOwner.SetCollisionSize(ChunkOwner.CollisionRadius * 0.5 * (1 + ChunkOwner.DrawScale), ChunkOwner.CollisionHeight * 0.5 * (1 + ChunkOwner.DrawScale));
	}

    ChunkOwner.RotationRate.Yaw = Rand(200000) - 100000;
	ChunkOwner.RotationRate.Pitch = Rand(200000 - Abs(ChunkOwner.RotationRate.Yaw)) - 0.5 * (200000 - Abs(ChunkOwner.RotationRate.Yaw));

	if (ChunkOwner.TrailSize > 0) {
		if(SourcePawn != None) {
			if(Level.Game.bVeryLowGore) {
				ChunkOwner.bGreenBlood = true;
			} else {
				if(SourcePawn.IsA('PlayerPawn')) {
					pawnCarcass = PlayerPawn(SourcePawn).CarcassType;
				} else if(SourcePawn.IsA('Bot')) {
					pawnCarcass = Bot(SourcePawn).CarcassType;
				}

				if ((pawnCarcass == Class'Botpack.UTHumanCarcass') || (pawnCarcass == Class'Botpack.UTPlayerChunks')) {
					ChunkOwner.bGreenBlood = false;
				} else if (pawnCarcass == Class'Botpack.UTCreatureChunks') {
					ChunkOwner.bGreenBlood = true;
				}
			}
		}

	}

	if (FRand() < 0.3) {
		ChunkOwner.Buoyancy = 1.06 * ChunkOwner.Mass; // float chunk
	} else {
		ChunkOwner.Buoyancy = 0.94 * ChunkOwner.Mass;
	}
}

defaultproperties {
      BaseGibSpeed=1.000000
      DoesFiringHurtOwner=False
      BossGibDamageMultiplier=1.000000
      SmallGibDamageMultiplier=1.000000
      BaseGibDamage=0.000000
      BaseGibHealMultiplier=1.000000
      LifetimeThresholdToAddExtraDamage=0.200000
      DistanceThresholdToAddExtraDamage=0.000000
      ExtraDamageMultiplier=1.000000
      WasFromShotgunBlast=False
      SourcePawn=None
      ChunkOwner=None
      bHidden=True
      Physics=PHYS_Trailer
      AmbientGlow=0
}
