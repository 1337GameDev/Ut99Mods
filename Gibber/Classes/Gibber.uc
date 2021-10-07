//=============================================================================
// Gibber.
//=============================================================================
class Gibber extends TournamentWeapon;

#exec TEXTURE IMPORT NAME=Gibber_JPulse3rd_01 FILE=Textures\Gibber_JPulse3rd_01.bmp GROUP="Skins" FLAGS=2 MIPS=OFF
#exec TEXTURE IMPORT NAME=Gibber_JPulseGun_02 FILE=Textures\Gibber_JPulseGun_02.bmp GROUP="Skins" FLAGS=2 MIPS=OFF

var float Angle;
var float Count;
var float TimeWhenLastAltFire;
var float AltFireDelay;
var float AltFireTriggerHoldTime;

var() sound DownSound;
var() Class<UTPlayerChunks> ChunksToFire[16];
var() Class<UTPlayerChunks> BossChunksToFire[8];
var int CurrentChunkIdx;

var() bool DoesFiringHurtOwner;
var() float PrimaryFireProjSpeed;
var() int PrimaryFireHealthCost;
var() float AltFireProjSpeed;
var() int AltFireHealthCost;
var() string GibHealMessage;

var() int ProjectileLifetime;

var Name WielderDamageType;

function HurtOwner(int Damage, Pawn SourceOfDamage){
	local Pawn PawnOwner;
	local int PredictedDamaged;
	local Vector HitLocationToUse;

	PawnOwner = Pawn(Owner);
    if(PawnOwner == None){
        return;
    }

	Damage = Max(Damage, 0) * PawnOwner.DamageScaling;
	HitLocationToUse = Location + CollisionHeight * vect(0,0,0.5);

	//hurt owner
	PredictedDamaged = class'PawnHelper'.static.PredictDamageToPawn(PawnOwner, Damage, SourceOfDamage, HitLocationToUse, Vect(0,0,0), WielderDamageType);

	if(PawnOwner.Health <= PredictedDamaged){
		PawnOwner.gibbedBy(SourceOfDamage);
	} else {
		PawnOwner.TakeDamage(Damage, SourceOfDamage, HitLocationToUse, Vect(0,0,0), WielderDamageType);
	}
}

function SetAmmoFromHealth(){
     local int CurrentHealth;
     if(Owner != None){
         CurrentHealth = Pawn(Owner).Health;
         if(AmmoType == None){
		     // ammocheck
		     GiveAmmo(Pawn(Owner));
	     }

         AmmoType.AmmoAmount = CurrentHealth / Min(PrimaryFireHealthCost, 1);
     }
}

function UTPlayerChunks SpawnNextChunk(Vector Pos, Rotator AimVector, float ChunkInitialSpeed){
     local bool IsOwnerBoss;//use to only shoot "boss" chunks if you're the "Boss" as your character (Xan)
     local int NumberChunksDefined, LoopCounter;
     local class<UTPlayerChunks> ClassToSpawn;
     local UTPlayerChunks SpawnedChunk;
     local Vector X,Y,Z;
     local Pawn PawnOwner;
     local Rotator RandRot;
     local Vector ResultingProjVelocity;
     local GibberProjectileContext ProjectileContext;

     PawnOwner = Pawn(Owner);
     IsOwnerBoss = class'PawnHelper'.static.IsBoss(Pawn(Owner));

     if(IsOwnerBoss){
         NumberChunksDefined = ArrayCount(BossChunksToFire);
     } else {
         NumberChunksDefined = ArrayCount(ChunksToFire);
     }

     if(CurrentChunkIdx > NumberChunksDefined){
         //correct index
         CurrentChunkIdx = NumberChunksDefined-1;
     }

     //find next valid chunk
     While(true){
          CurrentChunkIdx++;
          LoopCounter++;
          CurrentChunkIdx = CurrentChunkIdx % NumberChunksDefined;

          if(IsOwnerBoss){
              ClassToSpawn = BossChunksToFire[CurrentChunkIdx];
          } else {
              ClassToSpawn = ChunksToFire[CurrentChunkIdx];
          }

          //if this chunk is valid, break out of the loop (or we've gone through the array once before)
          if((ClassToSpawn != None) || (LoopCounter > NumberChunksDefined)){
              break;
          }
      }

      //now spawn the class if it's valid
      if(ClassToSpawn != None) {
          AimVector = class'RotatorHelper'.static.RandomlyVaryRotation(AimVector, 25, 25, 25);//yaw, pitch, roll
          SpawnedChunk = Spawn(ClassToSpawn,,'GibberChunk', Pos, AimVector);

          if(SpawnedChunk != None){
			  SpawnedChunk.Instigator = PawnOwner;
			  SpawnedChunk.Initfor(self);
			  ProjectileContext = Spawn(class'GibberProjectileContext');

              if(ProjectileContext != None){
			      ProjectileContext.DamageMultiplier = PawnOwner.DamageScaling;
			      ProjectileContext.DoesFiringHurtOwner = Self.DoesFiringHurtOwner;
			      SpawnedChunk.Inventory = ProjectileContext;
			      ProjectileContext.SetOwner(SpawnedChunk);
			  }

			  SpawnedChunk.LifeSpan = ProjectileLifetime;

			  GetAxes(PawnOwner.ViewRotation, X, Y, Z);
			  ResultingProjVelocity = X * (Instigator.Velocity Dot X)*0.4 + Vector(Rotation) * (ChunkInitialSpeed + FRand() * 600);
			  RandRot = class'RotatorHelper'.static.RandomlyVaryRotation(RandRot, 2, 2, 0);//yaw, pitch, roll
              SpawnedChunk.Velocity = ResultingProjVelocity << RandRot;

			  if(SpawnedChunk.Role == ROLE_Authority) {
                  if(SpawnedChunk.Region.zone.bWaterZone) {
					  SpawnedChunk.Velocity *= 0.65;
				  }
			  }
          }
      }

      return SpawnedChunk;
}

simulated event RenderOverlays(canvas Canvas){
	Texture'Ammoled'.NotifyActor = Self;
	Super.RenderOverlays(Canvas);
	Texture'Ammoled'.NotifyActor = None;
}

simulated function Destroyed() {
	Super.Destroyed();
}

simulated function AnimEnd() {
	if((Level.NetMode == NM_Client) && (Mesh != PickupViewMesh)) {
		if(AnimSequence == 'SpinDown') {
			AnimSequence = 'Idle';
		}

        PlayIdleAnim();
	}
}

// set which hand is holding weapon
function setHand(float Hand) {
	if(Hand == 2) {
		FireOffset.Y = 0;
		bHideWeapon = true;
		return;
	} else {
		bHideWeapon = false;
	}

	PlayerViewOffset = Default.PlayerViewOffset * 100;

	if(Hand == 1) {
		FireOffset.Y = Default.FireOffset.Y;
		Mesh = mesh(DynamicLoadObject("Botpack.PulseGunL", class'Mesh'));

	} else {
		FireOffset.Y = -1 * Default.FireOffset.Y;
		Mesh = mesh'PulseGunR';
	}
}

// return delta to combat style
function float SuggestAttackStyle() {
	local float EnemyDist;

	EnemyDist = VSize(Pawn(Owner).Enemy.Location - Owner.Location);

	if(EnemyDist < 1000) {
		return 0.4;
	} else {
		return 0;
	}
}

function float RateSelf(out int bUseAltMode) {
	local Pawn P;

	if(AmmoType.AmmoAmount <=0) {
		return -2;
    }

	P = Pawn(Owner);

	if((P.Enemy == None) || (Owner.IsA('Bot') && Bot(Owner).bQuickFire)) {
		bUseAltMode = 0;
		return AIRating;
	}

	if(P.Enemy.IsA('StationaryPawn')) {
		bUseAltMode = 0;
		return (AIRating + 0.4);
	} else {
		bUseAltMode = int( 700 > VSize(P.Enemy.Location - Owner.Location) );
    }

	AIRating *= FMin(Pawn(Owner).DamageScaling, 1.5);
	return AIRating;
}

simulated function PlayFiring() {
	FlashCount++;
	AmbientSound = FireSound;
	SoundVolume = Pawn(Owner).SoundDampening*255;
	LoopAnim('shootLOOP', 1 + 0.5 * FireAdjust, 0.0);
	bWarnTarget = (FRand() < 0.2);
}

simulated function PlayAltFiring() {
	PlayAnim('boltstart');
}

function AltFire(float Value) {
    Log("Gibber - AltFire - Level.TimeSeconds:"$Level.TimeSeconds$" - TimeWhenLastAltFire:"$TimeWhenLastAltFire$" - AltFireDelay:"$AltFireDelay);
    if((Level.TimeSeconds - TimeWhenLastAltFire) < AltFireDelay){
        return;
    }

	if(AmmoType == None){
		// ammocheck
		GiveAmmo(Pawn(Owner));
	}

	GotoState('AltFiring');
	bCanClientFire = true;
	bPointing=True;
	Pawn(Owner).PlayRecoil(FiringSpeed);
	ClientAltFire(value);
}

function Projectile ShotgunFire() {
	local Vector Start, X,Y,Z;
	local UTPlayerChunks ChunkFired;
	local Pawn PawnOwner;
	local bool SpawnedChunks;
    SpawnedChunks = false;

	PawnOwner = Pawn(Owner);

	Owner.MakeNoise(PawnOwner.SoundDampening);
	GetAxes(PawnOwner.ViewRotation,X,Y,Z);

	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	AdjustedAim = PawnOwner.AdjustAim(AltFireProjSpeed, Start, AimError, True, bAltWarnTarget);
	Start = Start - Sin(0)*Y*4 + (Cos(0)*4 - 10.78)*Z;

	ChunkFired = SpawnNextChunk(Start, AdjustedAim, AltFireProjSpeed);
	SpawnedChunks = (ChunkFired != None);

    ChunkFired = SpawnNextChunk(Start - (Z*1.2), AdjustedAim, AltFireProjSpeed);
    SpawnedChunks = SpawnedChunks && (ChunkFired != None);
    ChunkFired = SpawnNextChunk(Start + 2 * Y + Z, AdjustedAim, AltFireProjSpeed);
    SpawnedChunks = SpawnedChunks && (ChunkFired != None);
    ChunkFired = SpawnNextChunk(Start - (Y*1.2), AdjustedAim, AltFireProjSpeed);
    SpawnedChunks = SpawnedChunks && (ChunkFired != None);
    ChunkFired = SpawnNextChunk(Start + 2 * Y - Z, AdjustedAim, AltFireProjSpeed);
    SpawnedChunks = SpawnedChunks && (ChunkFired != None);
    ChunkFired = SpawnNextChunk(Start + Y - Z, AdjustedAim, AltFireProjSpeed);
    SpawnedChunks = SpawnedChunks && (ChunkFired != None);

    if(SpawnedChunks && Self.DoesFiringHurtOwner){
        HurtOwner(AltFireHealthCost, PawnOwner);
        SetAmmoFromHealth();
    }

	return None;
}

simulated event RenderTexture(ScriptedTexture Tex){
	local Color C;
	local string Temp;
	local Pawn ownerPawn;
    ownerPawn = Pawn(Owner);

    Temp = String(ownerPawn.Health);

	while(Len(Temp) < 3){
        Temp = "0"$Temp;
	}

	if(ownerPawn.Health < 25) {
		C.R = 255;
		C.G = 0;
		C.B = 0;
	} else {
		C.R = 0;
		C.G = 0;
		C.B = 255;
	}

	Tex.DrawColoredText(56, 14, Temp, Font'LEDFont', C);
}

///////////////////////////////////////////////////////
state NormalFire {
	ignores AnimEnd;

	function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn) {
		local Vector Start, X,Y,Z;
		local UTPlayerChunks ChunkFired;
		local Pawn PawnOwner;

        PawnOwner = Pawn(Owner);
		Owner.MakeNoise(PawnOwner.SoundDampening);
		GetAxes(PawnOwner.ViewRotation,X,Y,Z);
		Start = PawnOwner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
		AdjustedAim = PawnOwner.AdjustAim(PrimaryFireProjSpeed, Start, AimError, True, bWarnTarget);
		Start = Start - Sin(Angle)*Y*4 + (Cos(Angle)*4 - 10.78)*Z;

        ChunkFired = SpawnNextChunk(Start, AdjustedAim, PrimaryFireProjSpeed);

		if(Self.DoesFiringHurtOwner && (ChunkFired != None)){
            HurtOwner(PrimaryFireHealthCost, PawnOwner);
            SetAmmoFromHealth();
        }

        return None;
	}

	function Tick(float DeltaTime) {
		if (Owner==None) {
			GotoState('Pickup');
		} else {
		    SetAmmoFromHealth();
		}
	}

	function BeginState() {
		Super.BeginState();
		Angle = 0;
		AmbientGlow = 200;
		SetAmmoFromHealth();
	}

	function EndState() {
		PlaySpinDown();
		AmbientSound = None;
		AmbientGlow = 0;
		OldFlashCount = FlashCount;
		SetAmmoFromHealth();

		Super.EndState();
	}

Begin:
	Sleep(0.18);
	Finish();
}

simulated function PlaySpinDown() {
	if((Mesh != PickupViewMesh) && (Owner != None)) {
		PlayAnim('Spindown', 1.0, 0.0);
		Owner.PlayOwnedSound(DownSound, SLOT_None,1.0*Pawn(Owner).SoundDampening);
	}
}

state ClientFiring {
	simulated function Tick(float DeltaTime) {
		if((Pawn(Owner) != None) && (Pawn(Owner).bFire != 0) ) {
			SetAmmoFromHealth();
		} else {
			AmbientSound = None;
		}
	}

	simulated function AnimEnd() {
		if ((AmmoType != None) && (AmmoType.AmmoAmount <= 0)) {
			PlaySpinDown();
			GotoState('');
		} else if(!bCanClientFire) {
			GotoState('');
		} else if(Pawn(Owner) == None) {
			PlaySpinDown();
			GotoState('');
		} else if(Pawn(Owner).bFire != 0) {
			Global.ClientFire(0);
		} else if(Pawn(Owner).bAltFire != 0) {
			Global.ClientAltFire(0);
		} else {
			PlaySpinDown();
			GotoState('');
		}
	}
}

///////////////////////////////////////////////////////////////
state ClientAltFiring {
	simulated function AnimEnd() {
		if (AmmoType.AmmoAmount <= 0) {
			PlayIdleAnim();
			GotoState('');
		} else if(!bCanClientFire) {
			GotoState('');
		} else if(Pawn(Owner) == None) {
			PlayIdleAnim();
			GotoState('');
		} else if(Pawn(Owner).bFire != 0) {
			Global.ClientFire(0);
		} else {
			PlayIdleAnim();
			GotoState('');
		}
	}
}

state AltFiring {
	ignores AnimEnd;

	function Tick(float DeltaTime) {
		local Pawn P;

		P = Pawn(Owner);

        if(P == None) {
			GotoState('Pickup');
			return;
		}
		if((P.bAltFire == 0) || (P.IsA('Bot')
            && ((P.Enemy == None) || (Level.TimeSeconds - Bot(P).LastSeenTime > 5))) )
		{
			P.bAltFire = 0;
			Finish();
			return;
		}

		Count += Deltatime;

		if(Count >= AltFireTriggerHoldTime){
			if(Owner.IsA('PlayerPawn')){
				PlayerPawn(Owner).ClientInstantFlash(InstFlash,InstFog);
			}
			if(Affector != None){
				Affector.FireEffect();
			}

			ShotgunFire();
			TimeWhenLastAltFire = Level.TimeSeconds;

			Count = 0;
			SetAmmoFromHealth();
			Finish();
			TweenAnim('Idle', 0.1);
			GotoState('');
		}
	}

	function EndState() {
		AmbientGlow = 0;
		AmbientSound = None;
        GotoState('');
        SetAmmoFromHealth();
		Super.EndState();
	}

Begin:
    Owner.PlayOwnedSound(AltFireSound, SLOT_None, Pawn(Owner).SoundDampening);
	AmbientGlow = 200;
	SetAmmoFromHealth();
	FinishAnim();
	Count = 0;
}

state Idle {
Begin:
	bPointing=False;
	if ((AmmoType != None) && (AmmoType.AmmoAmount<=0) ){
		Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
	}
    if(Pawn(Owner).bFire!=0 ) {
        Fire(0.0);
    }
	if(Pawn(Owner).bAltFire!=0 ) {
        AltFire(0.0);
    }

	Disable('AnimEnd');
	PlayIdleAnim();
	SetAmmoFromHealth();
}

///////////////////////////////////////////////////////////
simulated function PlayIdleAnim() {
	if(Mesh == PickupViewMesh) {
		return;
    }

	if((AnimSequence == 'BoltLoop') || (AnimSequence == 'BoltStart')) {
		PlayAnim('BoltEnd');
	} else if(AnimSequence != 'SpinDown') {
		TweenAnim('Idle', 0.1);
	}
}

simulated function TweenDown() {
	if (IsAnimating() && (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select')) {
		TweenAnim( AnimSequence, AnimFrame * 0.4 );
	} else {
		TweenAnim('Down', 0.26);
	}
}

defaultproperties {
     DownSound=Sound'Botpack.PulseGun.PulseDown'
     WeaponDescription="Classification: Gib Rifle\n\nPrimary Fire: \n\nSecondary Fire: \n\nTechniques: "
     InstFlash=-0.150000
     InstFog=(X=139.000000,Y=218.000000,Z=72.000000)
     AmmoName=Class'Botpack.PAmmo'
     PickupAmmoCount=100
     bRapidFire=True
     FireOffset=(X=15.000000,Y=-15.000000,Z=2.000000)
     ProjectileClass=None
     AltProjectileClass=None
     shakemag=50.000000
     shakevert=5.000000
     AIRating=0.700000
     RefireRate=0.950000
     AltRefireRate=0.990000
     FireSound=Sound'Botpack.Male.MLand3'
     AltFireSound=Sound'UnrealShare.Gibs.Gib4'
     SelectSound=Sound'Botpack.PulseGun.PulsePickup'
     MessageNoAmmo=" has no gibs."
     DeathMessage="%o ate %k's bloody gibby death."
     NameColor=(R=128,B=128)
     FlashLength=0.020000
     AutoSwitchPriority=5
     InventoryGroup=5
     PickupMessage="You got the Gibber."
     GibHealMessage="You picked up one of your gibs:"
     ItemName="Gibber"
     PlayerViewOffset=(X=1.500000,Z=-2.000000)
     PlayerViewMesh=LodMesh'Botpack.PulseGunR'
     PickupViewMesh=LodMesh'Botpack.PulsePickup'
     ThirdPersonMesh=LodMesh'Botpack.PulseGun3rd'
     ThirdPersonScale=0.400000
     StatusIcon=Texture'Botpack.Icons.UsePulse'
     bMuzzleFlashParticles=True
     MuzzleFlashStyle=STY_Translucent
     MuzzleFlashMesh=LodMesh'Botpack.muzzPF3'
     MuzzleFlashScale=0.400000
     MuzzleFlashTexture=Texture'Botpack.Skins.MuzzyPulse'
     PickupSound=Sound'UnrealShare.Pickups.WeaponPickup'
     Icon=Texture'Botpack.Icons.UsePulse'
     Mesh=LodMesh'Botpack.PulsePickup'
     bNoSmooth=False
     SoundRadius=64
     SoundVolume=255
     CollisionRadius=32.000000
     PrimaryFireProjSpeed=1800

     DoesFiringHurtOwner=true
     PrimaryFireHealthCost=2
     AltFireProjSpeed=1450
     AltFireHealthCost=12
     ProjectileLifetime=240

     AltFireTriggerHoldTime=0.25,
     AltFireDelay=1.0,
     TimeWhenLastAltFire=0,

     Skin=Texture'Gibber.Gibber_JPulseGun_02'
     Multiskins(1)=Texture'Gibber.Gibber_JPulseGun_02',

     WielderDamageType='shredded'

     BossChunksToFire(0)=Class'Gibber.UT_MaleFoot_Proj'
     BossChunksToFire(1)=Class'Gibber.UT_bosshead_Proj'
     BossChunksToFire(2)=Class'Gibber.UT_Liver_Proj'
     BossChunksToFire(3)=Class'Gibber.UT_bossarm_Proj'
     BossChunksToFire(4)=Class'Gibber.UT_Stomach_Proj'
     BossChunksToFire(5)=Class'Gibber.UT_bossthigh_Proj'
     BossChunksToFire(6)=Class'Gibber.UT_Heart_Proj'

     ChunksToFire(0)=Class'Gibber.UT_Heart_Proj'
     ChunksToFire(1)=Class'Gibber.UT_Liver_Proj'
     ChunksToFire(2)=Class'Gibber.UT_Stomach_Proj'
     ChunksToFire(3)=Class'Gibber.UT_FemaleArm_Proj'
     ChunksToFire(4)=Class'Gibber.UT_FemaleFoot_Proj'
     ChunksToFire(5)=Class'Gibber.UT_FemaleTorso_Proj'
     ChunksToFire(6)=Class'Gibber.UT_MaleArm_Proj'
     ChunksToFire(7)=Class'Gibber.UT_MaleFoot_Proj'
     ChunksToFire(8)=Class'Gibber.UT_MaleTorso_Proj'
     ChunksToFire(9)=Class'Gibber.UT_Thigh_Proj'
     ChunksToFire(10)=Class'Gibber.UT_HeadFemale_Proj'
     ChunksToFire(11)=Class'Gibber.UT_HeadMale_Proj'
}
