//=============================================================================
// C4Proj.
//=============================================================================
class C4Proj extends Projectile;

var float SmallExplosionDamage;
var float SmallExplosionRadius;
var float SmallExplosionMomentum;
var float BigExplosionDamage;
var float BigExplosionRadius;
var float BigExplosionMomentum;

var Vector SurfaceNormal;
var bool bOnGround;
var float BaseOffset;
var C4Fear MyFear;
var TimerGlow Glow;

var int Countdown;
var int StartingCountdown;

var float CurrentTimeInterval;
var name DamageTypesToDisarm[32];

var Sound SoundLanded;
var Sound TickSound;
var Sound DisarmSound;

var bool IsDisarmed;

Replication {
	UnReliable if(Role == ROLE_Authority)
		MyFear, Glow;
}

function PostBeginPlay() {
	Super.PostbeginPlay();
}

function UpdateTimer(int timerValue){
   local int mins, tens, ones;

   class'MathHelper'.static.Get3DigitTimerPartsFromSeconds(timerValue, mins, tens, ones);
   Self.MultiSkins[2] = class'C4.C4Weapon'.default.TimerDigitTextures[mins];
   Self.MultiSkins[3] = class'C4.C4Weapon'.default.TimerDigitTextures[tens];
   Self.MultiSkins[4] = class'C4.C4Weapon'.default.TimerDigitTextures[ones];
}

function UpdateDisarmedTimer(int timerValue){
   local int mins, tens, ones;

   Self.MultiSkins[1] = Texture'C4.Timer.C4ScreenOn_Grey';

   class'MathHelper'.static.Get3DigitTimerPartsFromSeconds(timerValue, mins, tens, ones);
   Self.MultiSkins[2] = class'C4.C4Weapon'.default.GreyTimerDigitTextures[mins];
   Self.MultiSkins[3] = class'C4.C4Weapon'.default.GreyTimerDigitTextures[tens];
   Self.MultiSkins[4] = class'C4.C4Weapon'.default.GreyTimerDigitTextures[ones];
}

function Destroyed() {
	if(MyFear != None) {
		MyFear.Destroy();
	}

	if(Glow != None){
		Glow.Destroy();
	}

	Super.Destroyed();
}

simulated function SetWall(Vector HitNormal, Actor Wall) {
	SurfaceNormal = HitNormal;

	if(Mover(Wall) != None){
		SetBase(Wall);
	}
}

simulated function AttachToActor(Vector HitLocation, Actor Target) {
    local Vector ActorNormal;
    if(Target == None) {
        return;
    }

    ActorNormal = HitLocation - Target.Location;

	SurfaceNormal = ActorNormal;
	Self.SetOwner(Target);
	Self.SetPhysics(PHYS_Trailer);
	Self.bTrailerPrePivot = true;
	Self.bTrailerSameRotation = false;

	Self.PrePivot = Location - Target.Location;
}

singular function TakeDamage(int NDamage, Pawn instigatedBy, Vector hitlocation, vector momentum, name damageType) {}

singular function Damaged(int NDamage, Pawn InstigatedBy, Vector Hitlocation, int DamageMomentum, name DamageType) {
	if(NDamage > 0) {
		if((Mover(Base) != None) && Mover(Base).bDamageTriggered) {
			Base.TakeDamage(NDamage, InstigatedBy, Location, DamageMomentum * Normal(Velocity), DamageType);
		}

		if(IsDamageTypeToDisarm(DamageType)) {
		    Disarm();
		} else {
			//detonate
			SmallExplode(Location, SurfaceNormal);
		}
	}
}

function BigExplode(Vector ExplodeLocation, Vector ExplodeNormal) {
	local C4ShockWave shockwave;
    if (Role < ROLE_Authority) {
		return;
	}

	HurtRadius(Damage, BigExplosionRadius, MyDamageType, MomentumTransfer, ExplodeLocation);
	shockwave = Spawn(class'C4.C4ShockWave',,,ExplodeLocation + (ExplodeNormal*16) );
	if(shockwave != None){
	    shockwave.MaxDamage = BigExplosionDamage;
        shockwave.ShockwaveMaxSize = BigExplosionRadius;
        shockwave.MaxMomentum = BigExplosionMomentum;
	}

	Spawn(class'Botpack.BlastMark',,,, Rotator(ExplodeNormal));
	RemoteRole = ROLE_SimulatedProxy;
	Destroy();
}
function SmallExplode(Vector ExplodeLocation, Vector ExplodeNormal) {
    local C4ShockWave shockwave;
	if (Role < ROLE_Authority) {
		return;
	}

	HurtRadius(SmallExplosionDamage, SmallExplosionRadius, MyDamageType, MomentumTransfer, ExplodeLocation);
	shockwave = Spawn(class'C4.C4ShockWave',,,ExplodeLocation + (ExplodeNormal*16) );

	if(shockwave != None){
	    shockwave.MaxDamage = SmallExplosionDamage;
        shockwave.ShockwaveMaxSize = SmallExplosionRadius;
        shockwave.MaxMomentum = SmallExplosionMomentum;
	}

	Spawn(class'Botpack.BlastMark',,,, Rotator(ExplodeNormal));
	RemoteRole = ROLE_SimulatedProxy;
	Destroy();
}

function Disarm(){
	if (Role < ROLE_Authority) {
		return;
	}

	UpdateDisarmedTimer(Countdown);

    IsDisarmed = true;

	Spawn(class'UT_Spark',,,Location + (6 * SurfaceNormal));
	PlaySound(DisarmSound,,2.0);
	RemoteRole = ROLE_SimulatedProxy;

	if(Glow != None){
	    Glow.Destroy();
	}

	if(MyFear != None){
	    MyFear.Destroy();
	}
}
function bool IsDamageTypeToDisarm(name DmgType) {
    local int NumTypesToCheck, i;
	local bool matched;

	if(DmgType == '') {
		return false;
	}

	NumTypesToCheck = ArrayCount(DamageTypesToDisarm);

	for(i=0;i<NumTypesToCheck;i++) {
	    matched = DamageTypesToDisarm[i] == DmgType;

		if(matched) {
			break;
		}
	}

	return matched;
}

/*
Object States
*/

auto state Flying {
	function ProcessTouch (Actor Touched, Vector HitLocation) {
	    local Pawn touchedPawn;
		local Projectile proj;

		touchedPawn = Pawn(Touched);

        if(touchedPawn == None) {
			//hit something else
			proj = Projectile(Touched);

			if(proj != None) {
				Global.Damaged(proj.Damage,
                    proj.Instigator,
                    HitLocation,
                    proj.MomentumTransfer,
                    proj.MyDamageType
                );
			}
		} else {//hit pawn
			if (touchedPawn != Instigator && !bOnGround){
				//attach to what was hit
				AttachToActor(HitLocation, Touched);

				MakeNoise(0.3);
				bOnGround = True;
				PlaySound(SoundLanded);

				GoToState('OnSurface');
			}
		}
	}

	simulated function HitWall(Vector HitNormal, Actor Wall) {
		SetPhysics(PHYS_None);
		MakeNoise(0.3);
		bOnGround = True;
		PlaySound(SoundLanded);
		SetWall(HitNormal, Wall);

		GoToState('OnSurface');
	}
	function Landed(Vector HitNormal) {
		SetPhysics(PHYS_None);
		MakeNoise(0.3);
		bOnGround = True;
		PlaySound(SoundLanded);
		SurfaceNormal = HitNormal;

		GoToState('OnSurface');
	}

	simulated function ZoneChange(Zoneinfo NewZone) {
		local waterring w;

		if (!NewZone.bWaterZone) {
			return;
	    }

		if (!bOnGround) {
			w = Spawn(class'WaterRing',,,,rot(16384,0,0));
			w.DrawScale = 0.1;
		}

		bOnGround = True;
		Velocity = 0.1 * Velocity;
	}

	function BeginState() {
		if (Role == ROLE_Authority) {
			Velocity = Vector(Rotation) * Speed;
			Velocity.z += 120;

			if(Region.zone.bWaterZone) {
				Velocity = Velocity*0.7;
			}
		}

		bOnGround = False;
		UpdateTimer(Countdown);
	}

	singular function TakeDamage(int NDamage, Pawn instigatedBy, Vector hitlocation, vector momentum, name damageType) {
		Global.Damaged(NDamage, instigatedBy, hitlocation, VSize(momentum), damageType);
	}
}

state OnSurface {
    ignores ProcessTouch, Touch;

	function Timer() {
	    if(IsDisarmed){
	        Disable('Timer');
	    } else {
			Countdown--;
			PlaySound(TickSound,,2.0);
			Glow.StartBlink();
			UpdateTimer(Countdown);

			if(Countdown <= 0) {
				BigExplode(Location, SurfaceNormal);
			}
		}
	}

	singular function TakeDamage(int NDamage, Pawn instigatedBy, Vector hitlocation, vector momentum, name damageType) {
		Global.Damaged(NDamage, instigatedBy, hitlocation, VSize(momentum), damageType);
	}

	function BeginState() {
	    SetRotation(Rotator(-SurfaceNormal));

        if(!IsDisarmed){
            SetTimer(1.0, True);
		    UpdateTimer(Countdown);
		    Glow = Spawn(class'C4.TimerGlow', Self);
		    MyFear = Spawn(class'HeadHunter.C4Fear', Self);
        }

		if (Mover(Base) != None) {
			BaseOffset = VSize(Location - Base.Location);
		}
	}
}

defaultproperties
{
      SmallExplosionDamage=25.000000
      SmallExplosionRadius=2.000000
      SmallExplosionMomentum=500.000000
      BigExplosionDamage=400.000000
      BigExplosionRadius=7.000000
      BigExplosionMomentum=400.000000
      SurfaceNormal=(X=0.000000,Y=0.000000,Z=0.000000)
      bOnGround=False
      BaseOffset=0.000000
      MyFear=None
      Glow=None
      CountDown=0
      StartingCountdown=0
      CurrentTimeInterval=0.000000
      DamageTypesToDisarm(0)="impact"
      DamageTypesToDisarm(1)="claw"
      DamageTypesToDisarm(2)="cut"
      DamageTypesToDisarm(3)="SpecialDamage"
      DamageTypesToDisarm(4)="slashed"
      DamageTypesToDisarm(5)="Decapitated"
      DamageTypesToDisarm(6)="Corroded"
      DamageTypesToDisarm(7)="Burned"
      DamageTypesToDisarm(8)="shredded"
      DamageTypesToDisarm(9)="None"
      DamageTypesToDisarm(10)="None"
      DamageTypesToDisarm(11)="None"
      DamageTypesToDisarm(12)="None"
      DamageTypesToDisarm(13)="None"
      DamageTypesToDisarm(14)="None"
      DamageTypesToDisarm(15)="None"
      DamageTypesToDisarm(16)="None"
      DamageTypesToDisarm(17)="None"
      DamageTypesToDisarm(18)="None"
      DamageTypesToDisarm(19)="None"
      DamageTypesToDisarm(20)="None"
      DamageTypesToDisarm(21)="None"
      DamageTypesToDisarm(22)="None"
      DamageTypesToDisarm(23)="None"
      DamageTypesToDisarm(24)="None"
      DamageTypesToDisarm(25)="None"
      DamageTypesToDisarm(26)="None"
      DamageTypesToDisarm(27)="None"
      DamageTypesToDisarm(28)="None"
      DamageTypesToDisarm(29)="None"
      DamageTypesToDisarm(30)="None"
      DamageTypesToDisarm(31)="None"
      SoundLanded=Sound'UnrealI.flak.Click'
      TickSound=Sound'UMenu.LittleSelect'
      DisarmSound=Sound'Botpack.Translocator.TDisrupt'
      IsDisarmed=False
      speed=900.000000
      MaxSpeed=1800.000000
      Damage=5.000000
      MomentumTransfer=200
      MyDamageType="RocketDeath"
      bNetTemporary=False
      Physics=PHYS_None
      LifeSpan=0.000000
      Mesh=SkeletalMesh'C4.C4'
      CollisionRadius=14.000000
      CollisionHeight=7.500000
      bProjTarget=True
      Buoyancy=170.000000
}
