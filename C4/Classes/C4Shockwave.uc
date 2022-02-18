//=============================================================================
// ShockWave for a C4 bomb.
//=============================================================================
class C4ShockWave extends ShockWave;

//#exec MESH IMPORT MESH=ShockWavem ANIVFILE=MODELS\SW_a.3D DATAFILE=MODELS\SW_d.3D X=0 Y=0 Z=0
//#exec MESH ORIGIN MESH=ShockWavem X=0 Y=0 Z=0 YAW=0 PITCH=64
//#exec MESH SEQUENCE MESH=ShockWavem SEQ=All       STARTFRAME=0   NUMFRAMES=2
//#exec MESH SEQUENCE MESH=ShockWavem SEQ=Explosion STARTFRAME=0   NUMFRAMES=2
//#exec MESH SEQUENCE MESH=ShockWavem SEQ=Implode   STARTFRAME=0   NUMFRAMES=1
//#exec TEXTURE IMPORT NAME=Shockt1 FILE=MODELS\shockw.PCX GROUP="Skins"
//#exec MESHMAP SCALE MESHMAP=ShockWavem X=1.0 Y=1.0 Z=2.0
//#exec MESHMAP SETTEXTURE MESHMAP=ShockWavem NUM=1 TEXTURE=Shockt1

var float ShockwaveMaxSize;
var float MaxDamage;
var float MaxMomentum;

simulated function Tick(float DeltaTime) {
	if (Level.NetMode != NM_DedicatedServer) {
		ShockSize =  ShockwaveMaxSize * (Default.LifeSpan - LifeSpan) + 3.5/(LifeSpan/Default.LifeSpan+0.05);
		ScaleGlow = Lifespan;
		AmbientGlow = ScaleGlow * 255;
		DrawScale = ShockSize;
	}
}

simulated function Timer() {
	local actor Victims;
	local float dist, MoScale;
	local vector dir;

	ShockSize = ShockwaveMaxSize * (Default.LifeSpan - LifeSpan) + 3.5/(LifeSpan / Default.LifeSpan+0.05);

	if(Level.NetMode != NM_DedicatedServer) {
		if(ICount == 4){
            Spawn(class'WarExplosion2',,,Location);
        }

		ICount++;

		if(Level.NetMode == NM_Client) {
			foreach VisibleCollidingActors(class'Actor', Victims, ShockSize*29, Location) {
				if(Victims.Role == ROLE_Authority) {
					dir = Victims.Location - Location;
					dist = FMax(1,VSize(dir));
					dir = dir/dist + vect(0,0,0.3);

					if((dist> OldShockDistance) || (dir dot Victims.Velocity <= 0)) {
						MoScale = FMax(0, MaxDamage - 1.1 * Dist);
						Victims.Velocity = Victims.Velocity + dir * (MoScale + 20);
						Victims.TakeDamage
						(
							FMin(MoScale, MaxDamage),
							Instigator,
							Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
							(MaxMomentum * dir),
							'RocketDeath'
						);
					}
				}
            }

			return;
		}
	}//end of code for dedicated server

	foreach VisibleCollidingActors(class 'Actor', Victims, ShockSize*29, Location) {
		dir = Victims.Location - Location;
		dist = FMax(1,VSize(dir));
		dir = dir/dist + vect(0,0,0.3);

		if (dist> OldShockDistance || (dir dot Victims.Velocity < 0)) {
			MoScale = FMax(0, MaxDamage - 1.1 * Dist);

			if(Victims.bIsPawn) {
				Pawn(Victims).AddVelocity(dir * (MoScale + 20));
			} else {
				Victims.Velocity = Victims.Velocity + dir * (MoScale + 20);
			}

			Victims.TakeDamage
			(
				FMin(MoScale, MaxDamage),
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(MaxMomentum * dir),
				'RocketDeath'
			);
		}
	}

	OldShockDistance = ShockSize*29;
}

simulated function PostBeginPlay() {
	local Pawn P;

	if(Role == ROLE_Authority) {
		for(P=Level.PawnList; P!=None; P=P.NextPawn) {
			if (P.IsA('PlayerPawn') && (VSize(P.Location - Location) < 3000)) {
				PlayerPawn(P).ShakeView(0.5, 600000.0/VSize(P.Location - Location), 10);
			}
        }

		if(Instigator != None) {
			MakeNoise(10.0);
		}
	}

	SetTimer(0.1, True);

	if(Level.NetMode != NM_DedicatedServer) {
		SpawnEffects();
	}
}

simulated function SpawnEffects() {
	 local WarExplosion W;

	 PlaySound(Sound'Expl03', SLOT_Interface, 16.0);
	 PlaySound(Sound'Expl03', SLOT_None, 16.0);
	 PlaySound(Sound'Expl03', SLOT_Misc, 16.0);
	 PlaySound(Sound'Expl03', SLOT_Talk, 16.0);
	 W = Spawn(class'WarExplosion',,,Location);

	 W.RemoteRole = ROLE_None;
}

defaultproperties
{
      ShockwaveMaxSize=13.000000
      MaxDamage=1000.000000
      MaxMomentum=1100.000000
}
