//=============================================================================
// C4Weapon - A C4 timed bomb.
//=============================================================================
class C4Weapon extends TournamentWeapon config;

/* Icons */
#exec TEXTURE IMPORT NAME=C4HUDIcon FILE=Textures\Icons\C4HUDIcon.bmp GROUP="Icons" FLAGS=2 MIPS=OFF
/* Sounds */
#exec AUDIO IMPORT FILE="Sounds\C4Throw.wav" NAME="C4Throw" GROUP="Weapon"
/* Textures */
#exec TEXTURE IMPORT NAME=C4Skin FILE=Textures\C4Skin.bmp GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=C4ScreenBlank FILE=Textures\ScreenTemplate.bmp GROUP=Timer FLAGS=2
#exec TEXTURE IMPORT NAME=C4ScreenOn FILE=Textures\ScreenTemplateWithSeperator.bmp GROUP=Timer FLAGS=2
#exec TEXTURE IMPORT NAME=C4ScreenOn_Grey FILE=Textures\ScreenTemplateWithSeperator_Grey.bmp GROUP=Timer FLAGS=2
#exec TEXTURE IMPORT NAME=C4ScreenSeperator FILE=Textures\Seperator.bmp GROUP=Timer FLAGS=2

/* Digits */
#exec TEXTURE IMPORT NAME=C4Timer_Digit0 FILE=Textures\Digits\Digit0.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit1 FILE=Textures\Digits\Digit1.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit2 FILE=Textures\Digits\Digit2.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit3 FILE=Textures\Digits\Digit3.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit4 FILE=Textures\Digits\Digit4.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit5 FILE=Textures\Digits\Digit5.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit6 FILE=Textures\Digits\Digit6.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit7 FILE=Textures\Digits\Digit7.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit8 FILE=Textures\Digits\Digit8.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit9 FILE=Textures\Digits\Digit9.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit_Blank FILE=Textures\Digits\DigitBlank.bmp GROUP=Digits FLAGS=2

/* Grey Digits -- Disarmed Screen */
#exec TEXTURE IMPORT NAME=C4Timer_Digit0_Grey FILE=Textures\Digits\Digit0_Grey.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit1_Grey FILE=Textures\Digits\Digit1_Grey.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit2_Grey FILE=Textures\Digits\Digit2_Grey.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit3_Grey FILE=Textures\Digits\Digit3_Grey.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit4_Grey FILE=Textures\Digits\Digit4_Grey.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit5_Grey FILE=Textures\Digits\Digit5_Grey.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit6_Grey FILE=Textures\Digits\Digit6_Grey.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit7_Grey FILE=Textures\Digits\Digit7_Grey.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit8_Grey FILE=Textures\Digits\Digit8_Grey.bmp GROUP=Digits FLAGS=2
#exec TEXTURE IMPORT NAME=C4Timer_Digit9_Grey FILE=Textures\Digits\Digit9_Grey.bmp GROUP=Digits FLAGS=2

/* Pickup Mesh */
#exec ANIM IMPORT ANIM=C4PickupAnim ANIMFILE=Models\C4Pickup.PSA IMPORTSEQS=1
#exec MESH MODELIMPORT MESH=C4Pickup MODELFILE=Models\C4Pickup.PSK LODSTYLE=12
#exec MESH ORIGIN MESH=C4Pickup X=0 Y=0 Z=0
#exec MESH LODPARAMS MESH=C4Pickup STRENGTH=0.0
#exec MESH DEFAULTANIM MESH=C4Pickup ANIM=C4PickupAnim
#exec MESH SEQUENCE MESH=C4Pickup SEQ=All    STARTFRAME=0  NUMFRAMES=1
#exec MESHMAP SETTEXTURE MESHMAP=C4Pickup NUM=0 TEXTURE=C4Skin
#exec MESHMAP SETTEXTURE MESHMAP=C4Pickup NUM=1 TEXTURE=C4ScreenBlank
#exec MESHMAP SETTEXTURE MESHMAP=C4Pickup NUM=2 TEXTURE=C4Timer_Digit_Blank
#exec MESHMAP SETTEXTURE MESHMAP=C4Pickup NUM=3 TEXTURE=C4Timer_Digit_Blank
#exec MESHMAP SETTEXTURE MESHMAP=C4Pickup NUM=4 TEXTURE=C4Timer_Digit_Blank

/* Normal Weapon Mesh */
#exec ANIM IMPORT ANIM=C4Anim ANIMFILE=Models\C4.PSA IMPORTSEQS=1
#exec MESH MODELIMPORT MESH=C4 MODELFILE=Models\C4.PSK LODSTYLE=12
#exec MESH ORIGIN MESH=C4 X=0 Y=0 Z=0 Pitch=64
#exec MESH LODPARAMS MESH=C4 STRENGTH=0.0
#exec MESH DEFAULTANIM MESH=C4 ANIM=C4Anim
#exec MESH SEQUENCE MESH=C4 SEQ=All    STARTFRAME=0  NUMFRAMES=1
#exec MESHMAP SETTEXTURE MESHMAP=C4 NUM=0 TEXTURE=C4Skin
#exec MESHMAP SETTEXTURE MESHMAP=C4 NUM=1 TEXTURE=C4ScreenOn

#exec MESHMAP SETTEXTURE MESHMAP=C4 NUM=2 TEXTURE=C4Timer_Digit0
#exec MESHMAP SETTEXTURE MESHMAP=C4 NUM=3 TEXTURE=C4Timer_Digit1
#exec MESHMAP SETTEXTURE MESHMAP=C4 NUM=4 TEXTURE=C4Timer_Digit5

var int UpdateIntervalSecs;
var float CurrentTimeInterval;

var() float MaxPlaceDistance;

var C4WeaponGhost PlaceC4Ghost;
var int TimerSeconds;
var() int TimerIncrementAmount;
var() int MaxTimerSeconds;
var() int MinTimerSeconds;

var Texture TimerDigitTextures[11];
var Texture GreyTimerDigitTextures[11];

var Sound SoundThrow;
var Sound SoundPlaced;
var Sound SoundChangeTimer;

function PreBeginPlay() {
    Disable('Tick');
}

function Fire(float Value) {
    local float SoundVolume;
    SoundVolume = 4;

    if(Owner != None) {
        if(Pawn(Owner) != None){
            SoundVolume *= Pawn(Owner).SoundDampening;
        }

       	if (AmmoType == None) {
            // ammocheck
            GiveAmmo(Pawn(Owner));
            ShowWeapon();
        }

        if (AmmoType.UseAmmo(1)) {
		    UpdateGhostLocation(true);
		    if(AmmoType.AmmoAmount < 1){
		       HideWeapon();
		    }
	    } else {
	        HideWeapon();
	    }
    }
}

function AltFire(float Value) {
    local float SoundVolume;
    SoundVolume = 4;

    if(Owner != None){
        IncrementTimer();
        UpdateTimer(TimerSeconds);

        if(Pawn(Owner) != None){
            SoundVolume *= Pawn(Owner).SoundDampening;
        }

        PlayOwnedSound(SoundChangeTimer, SLOT_Misc, SoundVolume);
    }
}

simulated function C4Proj SpawnC4AtPoint(Vector pos, Vector Normal){
    local C4Proj spawned;
	spawned = Spawn(class'C4.C4Proj',,,pos, Rotator(Normal));

	if(spawned != None) {
		spawned.Countdown = TimerSeconds;
		spawned.StartingCountdown = TimerSeconds;
		spawned.SurfaceNormal = Normal;
        spawned.MakeNoise(0.3);
		spawned.bOnGround = True;
        spawned.GoToState('OnSurface');

		PlayOwnedSound(SoundPlaced, SLOT_Misc, SoundVolume);
	}

    return spawned;
}

simulated function C4Proj ThrowC4(){
    local Rotator R;
	local vector Start, X, Y, Z;
	local C4Proj spawned;

	GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
	R = Owner.Rotation;

	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	spawned = Spawn(class'C4.C4Proj',,, Start,R);

	if(spawned != None) {
        spawned.SetPhysics(PHYS_Falling);
		spawned.Countdown = TimerSeconds;
		spawned.StartingCountdown = TimerSeconds;
        spawned.UpdateTimer(TimerSeconds);
		PlayOwnedSound(SoundThrow, SLOT_Misc, SoundVolume);
	}

    return spawned;
}

simulated function IncrementTimer(){
	local StringObj spawnMsg;

	TimerSeconds = Max(MinTimerSeconds, (TimerSeconds+TimerIncrementAmount) % MaxTimerSeconds);
	spawnMsg = new class'StringObj';
	spawnMsg.Value = "Timer set to \""$TimerSeconds$"\" seconds.";
	Pawn(Owner).ReceiveLocalizedMessage(class'C4.C4TimerMessage', 0, None, None, spawnMsg);
}
function UpdateTimer(int timerValue){
   local int mins, tens, ones;
   class'MathHelper'.static.Get3DigitTimerPartsFromSeconds(timerValue, mins, tens, ones);

   Self.MultiSkins[2] = class'C4.C4Weapon'.default.TimerDigitTextures[mins];
   Self.MultiSkins[3] = class'C4.C4Weapon'.default.TimerDigitTextures[tens];
   Self.MultiSkins[4] = class'C4.C4Weapon'.default.TimerDigitTextures[ones];
}

simulated function DestroyGhost(){
    if(PlaceC4Ghost != None){
        PlaceC4Ghost.Destroy();
        PlaceC4Ghost = None;
    }
}

simulated function UpdateGhostLocation(bool bFiring){
     local Actor HitActor, HitLevel;
     local Vector HitLocation, HitNormal, StartTrace, EndTrace;
     local Vector NewGhostPos;
     local float HitActorCollisionSize, C4CollisionSize;
     local C4Proj c4Projectile;

     if(PlaceC4Ghost == None){
         PlaceC4Ghost = Spawn(class'C4.C4WeaponGhost');
         PlaceC4Ghost.C4WeaponOwner = Self;
     }

     if(!bFiring){//if we aren't firing, check ammo and short circuit
         if((AmmoType != None) && (AmmoType.AmmoAmount > 0)){
	         ShowWeapon();
         } else {
             HideWeapon();
             PlaceC4Ghost.HideGhost();
             return;
         }
     }

	 C4CollisionSize = FMax(CollisionRadius, CollisionHeight);

     StartTrace = Location + (Vect(0,0,1) * PlayerPawn(Owner).BaseEyeHeight);
	 EndTrace = StartTrace + (Vector(Rotation) * MaxPlaceDistance);

     //cast from our location, and hit geometry or an actor
     HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

     if(HitActor != None){
	     //ensure ghost is viisble
		 PlaceC4Ghost.ShowGhost();
		 HideWeapon();

         HitLevel = LevelInfo(HitActor);

         if(HitLevel != None){
             //hit level geometry
             NewGhostPos = HitLocation - (Vector(Rotation) * (C4CollisionSize));
         } else {
             //hit an actor
             HitActorCollisionSize = FMax(HitActor.CollisionRadius, HitActor.CollisionHeight) / 2.0;
             //Use hit position, and current weapon rotation to "walk back" a distance the length of the collider size
             NewGhostPos = HitLocation - (Vector(Rotation) * (C4CollisionSize + HitActorCollisionSize) );
         }

		 PlaceC4Ghost.SetRotation(Rotator(-HitNormal));

		 if(bFiring) {
		    //ensure we aren't colliding with our "ghost" - and if so, ignore the placement
		    if(!HitActor.IsA('C4WeaponGhost') ){
			    c4Projectile = SpawnC4AtPoint(NewGhostPos, HitNormal);

                //if we are placing on another actor, then attach it to that actor
			    if(HitLevel == None){
                    c4Projectile.AttachToActor(HitLocation, HitActor);
			    }
			}
		 }
     } else {
         //hit nothing, so hide ghost
		 PlaceC4Ghost.HideGhost();
		 ShowWeapon();

		 if(bFiring) {
			c4Projectile = ThrowC4();
		 }
     }

     PlaceC4Ghost.SetLocation(NewGhostPos);
     PlaceC4Ghost.UpdateTimer(TimerSeconds);
}

/* Included to avoid exception - as the C4 model does not have a 'Select' animation. */
simulated function PlaySelect() {
	bForceFire = false;
	bForceAltFire = false;
	bCanClientFire = false;
	//if ( !IsAnimating() || (AnimSequence != 'Select') )
	//	PlayAnim('Select',1.0,0.0);
	Owner.PlaySound(SelectSound, SLOT_Misc, Pawn(Owner).SoundDampening);
}
simulated function TweenDown() {
	//if (IsAnimating() && (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select')) {
	//	TweenAnim(AnimSequence, AnimFrame * 0.4);
	//} else {
	//	PlayAnim('Down', 1.0, 0.05);
	//}
    DestroyGhost();
    Disable('Tick');
}

simulated function Tick(float DeltaTime) {
	CurrentTimeInterval += DeltaTime;

	if(Owner.IsA('Bot')){
	    Destroy();
	} else {
		if(CurrentTimeInterval >= UpdateIntervalSecs) {
			CurrentTimeInterval = 0;
			//perform timed action
			//update visibility based on ammo
			if((AmmoType != None) && (AmmoType.AmmoAmount > 0)){
				ShowWeapon();
				//update location of the selected item mesh
				UpdateGhostLocation(false);
			} else {
				HideWeapon();
				if(PlaceC4Ghost != None){
					PlaceC4Ghost.HideGhost();
				}
			}
		}
	}
}

function BringUp() {
    if(Owner.IsA('Bot')){
	    Destroy();
	} else {
	    Super.BringUp();
        Enable('Tick');

        CurrentTimeInterval = 0;
        TimerSeconds = Max(MinTimerSeconds, TimerSeconds);
        UpdateTimer(TimerSeconds);
    }
}

function Destroyed(){
	Super.Destroyed();
    DestroyGhost();
}
function DropFrom(vector StartLocation) {
    Super.DropFrom(StartLocation);
    Disable('Tick');
    DestroyGhost();
}
function BecomePickup(){
	Super.BecomePickup();
	Disable('Tick');
	DestroyGhost();
}
function HideWeapon(){
    if(Owner.IsA('Bot')){
	    Destroy();
	} else {
        Self.bHidden = true;
        Self.DrawType = DT_None;
    }
}
function ShowWeapon(){
    if(Owner.IsA('Bot')){
	    Destroy();
	} else {
        Self.bHidden = false;
        Self.DrawType = DT_Mesh;
    }
}
function bool HandlePickupQuery(Inventory Item) {
	local bool WillBePickedUp;
	local Ammo c4Ammo;

	WillBePickedUp = Super.HandlePickupQuery(Item);

	if(Item.IsA('C4Ammo')){
	    c4Ammo = Ammo(Item);

	    if(AmmoType == None){
	        GiveAmmo(Pawn(Owner));
	    }

	    if(WillBePickedUp && (c4Ammo.AmmoAmount + AmmoType.AmmoAmount) > 0) {
	        ShowWeapon();
	    } else {
	        HideWeapon();
	    }
	}

	return WillBePickedUp;
}

//
// Give this inventory item to a pawn.
//
function GiveTo(Pawn Other) {
    if(!Other.IsA('Bot')){
	    Super.GiveTo(Other);
	    Disable('Tick');
	} else {
	    Destroy();
    }
}

function float RateSelf(out int bUseAltMode) {
	return -2;//give max negative rating so bots don't pick this up
}
event float BotDesireability(Pawn Bot){
    return -1;//bots don't want this weapon
}

defaultproperties {
    WeaponDescription="Classification: Timed Bomb\n\nPrimary Fire: Place / Throw C4 \n\nSecondary Fire: Increment the timer.",
    AIRating=0.0,
    MaxDesireability=-1
    PickupMessage="You got the C4.",
    ItemName="C4",
    UpdateIntervalSecs=0.1,
    MaxPlaceDistance=400.0,
	SoundThrow=Sound'C4.Weapon.C4Throw',
	SoundPlaced=Sound'UnrealShare.Pickups.VoiceSnd',
	SoundChangeTimer=Sound'UnrealI.flak.Click',
    TimerSeconds=3,
    MinTimerSeconds=3,
    MaxTimerSeconds=90,
    TimerIncrementAmount=10,

    AmmoName=Class'C4.C4Ammo'
    PickupAmmoCount=1,

    FiringSpeed=1.000000,
    FireOffset=(X=15.000000,Y=-13.000000,Z=-7.000000),
    FireSound=None,
    AltFireSound=None,
    DeathMessage="%k blew up %o!",
    AutoSwitchPriority=0,
    RespawnTime=0.000000,
    PlayerViewMesh=LodMesh'C4.C4',
    PlayerViewOffset=(X=2.000000,Y=0.000000,Z=-1.000000),
    PlayerViewScale=0.020000
    StatusIcon=Texture'C4.Icons.C4HUDIcon',
    Icon=Texture'C4.Icons.C4HUDIcon',
    bRotatingPickup=false
    bUnlit=false

    PickupViewMesh=LodMesh'C4.C4Pickup',
    PickupSound=Sound'UnrealShare.Pickups.GenPickSnd',
    ThirdPersonMesh=LodMesh'C4.C4',
    Mesh=LodMesh'C4.C4',
    bNoSmooth=true,
    CollisionRadius=10.000000,
    CollisionHeight=7.000000,
    Mass=10.000000,

    //Timer Digit Textures
    TimerDigitTextures(0)=Texture'C4.Digits.C4Timer_Digit0'
    TimerDigitTextures(1)=Texture'C4.Digits.C4Timer_Digit1'
    TimerDigitTextures(2)=Texture'C4.Digits.C4Timer_Digit2'
    TimerDigitTextures(3)=Texture'C4.Digits.C4Timer_Digit3'
    TimerDigitTextures(4)=Texture'C4.Digits.C4Timer_Digit4'
    TimerDigitTextures(5)=Texture'C4.Digits.C4Timer_Digit5'
    TimerDigitTextures(6)=Texture'C4.Digits.C4Timer_Digit6'
    TimerDigitTextures(7)=Texture'C4.Digits.C4Timer_Digit7'
    TimerDigitTextures(8)=Texture'C4.Digits.C4Timer_Digit8'
    TimerDigitTextures(9)=Texture'C4.Digits.C4Timer_Digit9'
    TimerDigitTextures(10)=Texture'C4.Digits.C4Timer_Digit_Blank'

    GreyTimerDigitTextures(0)=Texture'C4.Digits.C4Timer_Digit0_Grey'
    GreyTimerDigitTextures(1)=Texture'C4.Digits.C4Timer_Digit1_Grey'
    GreyTimerDigitTextures(2)=Texture'C4.Digits.C4Timer_Digit2_Grey'
    GreyTimerDigitTextures(3)=Texture'C4.Digits.C4Timer_Digit3_Grey'
    GreyTimerDigitTextures(4)=Texture'C4.Digits.C4Timer_Digit4_Grey'
    GreyTimerDigitTextures(5)=Texture'C4.Digits.C4Timer_Digit5_Grey'
    GreyTimerDigitTextures(6)=Texture'C4.Digits.C4Timer_Digit6_Grey'
    GreyTimerDigitTextures(7)=Texture'C4.Digits.C4Timer_Digit7_Grey'
    GreyTimerDigitTextures(8)=Texture'C4.Digits.C4Timer_Digit8_Grey'
    GreyTimerDigitTextures(9)=Texture'C4.Digits.C4Timer_Digit9_Grey'
}
