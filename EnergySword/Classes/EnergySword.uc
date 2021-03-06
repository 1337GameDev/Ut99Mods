//=============================================================================
// Energy Sword
//=============================================================================
class EnergySword extends TournamentWeapon;

var() bool bIsBlocking;
var() int CurrentBlock;

var name HitAnims[5];
var name BlockBeginAnims[4];
var name BlockStillAnims[4];
var name BlockDownAnims[4];

var sound HitSounds[5];
var sound HitFleshSounds[5];
var sound HitArmSounds[6];
var sound HeadShotSounds[5];

var Texture SwordBloodSkins[6];
var Texture SkullBloodSkins[6];


var PlayerPawn LastHit;
var int Range, Damage;
var Mutator M;

var int SkinNo;
// var bool bHurtEntry;

var int SwordStatus;   // 0 = clean, 1 = bloody, 2 = bloodbath, 3 = super bloodbath :)

function CleanSword()

{
     //MultiSkins[1]=Texture'ChaosUT.JcSwordfov1';
     //MultiSkins[2]=Texture'ChaosUT.JcSwordfov2';
     SwordStatus=0;
}

function BloodySword()

{
     	if (SwordStatus==0) {
		MultiSkins[1]=SwordBloodSkins[Rand(4)];
		MultiSkins[2]=SkullBloodSkins[Rand(4)];
		SwordStatus+=1;
   	}  else if (SwordStatus==1) {
	     	MultiSkins[1]=SwordBloodSkins[4];
    	 	MultiSkins[2]=SkullBloodSkins[4];
		SwordStatus+=1;
	} else if (SwordStatus==2) {
	     	MultiSkins[1]=SwordBloodSkins[5];
    	 	MultiSkins[2]=SkullBloodSkins[5];
		SwordStatus+=1;
	}
}


			
exec function NextSkin()

{
 	if (SkinNo==0) {
	  	MultiSkins[1]=Texture'Chaostex.Sword.csword01_b1';
  	  	MultiSkins[2]=Texture'Chaostex.Sword.csword02_b1';
	} else if (SkinNo==1) {
	  	MultiSkins[1]=Texture'Chaostex.Sword.csword01_b2';
  	  	MultiSkins[2]=Texture'Chaostex.Sword.csword02_b2';
	} else if (SkinNo==2) {
	  	MultiSkins[1]=Texture'Chaostex.Sword.csword01_b3';
  	  	MultiSkins[2]=Texture'Chaostex.Sword.csword02_b3';
	} else if (SkinNo==3) {
	  	MultiSkins[1]=Texture'Chaostex.Sword.csword01_b4';
  	  	MultiSkins[2]=Texture'Chaostex.Sword.csword02_b4';
	} else {
	  	MultiSkins[1]=Texture'Chaostex.Sword.csword01_bb';
  	  	MultiSkins[2]=Texture'Chaostex.Sword.csword02_bb';
		SkinNo=0;
	}
	SkinNo+=1;
}
	

function PostBeginPlay()

{
	/*
	local bool bFoundMut;
    
	// search through mutators to ensure the one we want isn’t already defined
	 bFoundMut=False;

	 for (M = Level.Game.BaseMutator; M != None; M = M.NextMutator)
	 {
	  if (M.class == class'ChaosUT.SwordBlockEffect')
	  {
	   bFoundMut=True;
	   break;
	  }
	 }
 
// If ours isn’t already defined then add it to the list
	if (!bFoundMut) {
	  	log("Adding SwordBlockEffect Mutator");
	  	Level.Game.BaseMutator.AddMutator(Spawn(class'ChaosUT.SwordBlockEffect'));
	}
	*/
 
}

function float RateSelf( out int bUseAltMode )
{
	local float EnemyDist;

	bUseAltMode = 0;

	if ( (Pawn(Owner) == None) || (Pawn(Owner).Enemy == None) )
		return 0;

	EnemyDist = VSize(Pawn(Owner).Enemy.Location - Owner.Location);
	if ( EnemyDist > 400 )
		return -2;

	if ( EnemyDist < 110 )
		bUseAltMode = 0;

	return ( FMin(1.0, 81/(EnemyDist + 1)) );
}

function float SuggestAttackStyle()
{
	return 1.0;
}

function float SuggestDefenseStyle()
{
	return -0.7;
}

function bool hasArmor( Pawn P )
{
	local Inventory Inv;

	If (P != None) {
		for( Inv=P.Inventory; Inv!=None; Inv=Inv.Inventory )   
		if ( Inv.bIsAnArmor == True )
			return True;
	}
	return False;
} 


function Hit1 ()
{
	log("AnimNotify called me!");
	TraceFire(0.0);
}

function actor OldTraceShot(out vector HitLocation, out vector HitNormal, vector EndTrace, vector StartTrace)
{
	local vector realHit, traceextents;
	local actor Other;

	TraceExtents=Vect(1.0,64.0,32.0);

	Other = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True,TraceExtents);
	if ( Pawn(Other) != None )
	{
		realHit = HitLocation;
		if ( !Pawn(Other).AdjustHitLocation(HitLocation, EndTrace - StartTrace) )
			Other = Pawn(Other).TraceShot(HitLocation,HitNormal,EndTrace,realHit);
	}
	return Other;
}


function bool MeleeFire()
{
	local vector traceextents, X,Y,Z;
	local vector HitLocation, HitNormal, EndTrace, Start;
	local Actor Other;
	local bool bHitTarget;

	TraceExtents=Vect(1.0,72.0,32.0);
	bHitTarget=False;
	GetAxes(Pawn(owner).ViewRotation, X, Y, Z);
	Start =  Owner.Location + CalcDrawOffset() + FireOffset.Y * Y + FireOffset.Z * Z;
	AdjustedAim = pawn(owner).AdjustAim(1000000, Start, 2 * AimError, False, False);	
	EndTrace= Owner.Location + (10 + Range) * vector(AdjustedAim); 

	foreach TraceActors(class'Actor', Other, HitLocation,HitNormal,EndTrace,Start,TraceExtents) {
		if (Other != Pawn(Owner) && Other.Isa('Pawn'))
		{
		bHitTarget=True;
		log("FoundTarget"@Other);
		if ((AnimSequence == 'Hit1') && ((HitLocation.Z - Other.Location.Z) > (0.62 * Other.CollisionHeight))) {
			Other.PlaySound(HeadShotSounds[Rand(2)], SLOT_None, 100);
			Pawn(Other).TakeDamage(3.5*Damage, Pawn(Owner), HitLocation, 3000.0 * x, 'decapitated');
			BloodySword();
		}
		else {
			
			if (Other.bIsPawn) {
  			   if ( hasArmor(Pawn(Other)) ) {
				Other.PlaySound(HitArmSounds[Rand(6)], SLOT_None, 150);
			   }
			   else {
				Other.PlaySound(HitFleshSounds[Rand(5)], SLOT_None, 150);
			   }	
			   Other.TakeDamage(Damage, Pawn(Owner), HitLocation, 3000.0 * x, 'cut');
			   if ((Pawn(Other).Health < 0) && (Other.Isa('PlayerPawn') || Other.Isa('Bot'))){
		 		BloodySword();
			   } 
			}
		}
			
		}
	} 
	return bHitTarget;
}


function TraceFire(float accuracy)
{
	local vector HitLocation, HitNormal, EndTrace, X, Y, Z, Start;
	local actor Other;
	local int rhit;

	if (!MeleeFire()) {
		rhit=1;
		LastHit = None;
		Owner.MakeNoise(Pawn(Owner).SoundDampening);
		GetAxes(Pawn(owner).ViewRotation, X, Y, Z);
		Start =  Owner.Location + CalcDrawOffset() + FireOffset.Y * Y + FireOffset.Z * Z;
		AdjustedAim = pawn(owner).AdjustAim(1000000, Start, 2 * AimError, False, False);	
		EndTrace= Owner.Location + (30 + Range) * vector(AdjustedAim); 
		Other = Pawn(Owner).TraceShot(HitLocation, HitNormal, EndTrace, Start);
		if ( (Other == None) || (Other == Owner) || (Other == self) )
			return;
// cut there
		if ( !Other.bIsPawn && !Other.IsA('Carcass') ) {
			PlaySound(sound'ChaosSounds.Sword.swordwall1', SLOT_None, 150);
			spawn(class'SawHit',,,HitLocation+HitNormal, Rotator(HitNormal));
		}		
		else if ( !Other.bIsPawn && Other.IsA('Carcass') ) {
			   PlaySound(HitFleshSounds[Rand(5)], SLOT_None, 150);
			   Other.TakeDamage(Damage, Pawn(Owner), HitLocation, 3000.0 * x, 'cut');
        	     } 
	    	else if ( Other.IsA('PlayerPawn') && (Pawn(Other).Health > 0) )
			LastHit = PlayerPawn(Other);
	}
}


function Fire( float Value )
{
	Enable('Tick');
	SoundVolume = 255*Pawn(Owner).SoundDampening;
	Pawn(Owner).PlayRecoil(FiringSpeed);
	bCanClientFire = true;
	bPointing=True;
	ClientFire(value);
	GotoState('NormalFire');
}


function OldMeleeFire()

{
	local vector x,y,z, HitLocation;
	local actor Victims;

	GetAxes(Pawn(Owner).ViewRotation, x, y, z);

//	if( bHurtEntry )
//		return;

//	bHurtEntry = true;
	log("Started Melee Fire, Owner is"@Owner);

	foreach RadiusActors(class'Actor', Victims, range, Owner.Location)
//	foreach Owner.VisibleActors( class 'Actor', Victims, 120, HitLocation )
	{
		HitLocation=Victims.Location;
		log("Checking target"@Victims);
		if( (Victims != self) && Victims.Isa('Pawn') && ((Victims.Location - Owner.Location) Dot X > 0))
		{
		log("FoundTarget"@Victims);
		if ((AnimSequence == 'Hit1') && ((HitLocation.Z - Victims.Location.Z) > (0.62 * Victims.CollisionHeight))) {
			Victims.PlaySound(HeadShotSounds[Rand(2)], SLOT_None, 100);
			Victims.TakeDamage(3.5*Damage, Pawn(Owner), HitLocation, 3000.0 * x, 'decapitated');
			BloodySword();
		}
		else {
			
			if (Victims.bIsPawn) {
  			   if ( hasArmor(Pawn(Victims)) ) {
				Victims.PlaySound(HitArmSounds[Rand(6)], SLOT_None, 150);
			   }
			   else {
				Victims.PlaySound(HitFleshSounds[Rand(5)], SLOT_None, 150);
			   }	
			   Victims.TakeDamage(Damage, Pawn(Owner), HitLocation, 3000.0 * x, 'cut');
			   if ((Pawn(Victims).Health < 0) && (Victims.Isa('PlayerPawn') || Victims.Isa('Bot'))){
		 		BloodySword();
			   } 
			}
		}
			
		} 
	}
	bHurtEntry = false;
}

function AltFire( float Value )
{
	log("Entered AltFire Function");
	Enable('Tick');
	bIsBlocking=True;
	bPointing=True;
	bCanClientFire = true;
	ClientAltFire(value);	
	GoToState('AltFiring');		
}

simulated function bool ClientAltFire( float Value )
{
	if ( bCanClientFire && ((Role == ROLE_Authority) || (AmmoType == None) || (AmmoType.AmmoAmount > 0)) )
	{
		if ( (PlayerPawn(Owner) != None) 
			&& ((Level.NetMode == NM_Standalone) || PlayerPawn(Owner).Player.IsA('ViewPort')) )
		{
			if ( InstFlash != 0.0 )
				PlayerPawn(Owner).ClientInstantFlash( InstFlash, InstFog);
			PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
		}
		if ( Affector != None )
			Affector.FireEffect();
//		PlayAltFiring();
		ClientPlayBlockBegin();
		if ( Role < ROLE_Authority )
			GotoState('ClientAltFiring');
		return true;
	}
	return false;
}


simulated function TweenDown()
{
	if ( IsAnimating() && (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
		TweenAnim( AnimSequence, AnimFrame * 0.4 );
	else {

		PlayAnim('Down', 1.0, 0.05);
		Owner.PlaySound(Sound'ChaosSounds.Sword.swordaway', SLOT_Misc, Pawn(Owner).SoundDampening);
	}
}

simulated function PlayFiring()
{
local int rhit;

//	log("Entered Sword PlayFiring function");
	rhit = Rand(5);
	Owner.PlaySound(HitSounds[rhit], SLOT_None, Pawn(Owner).SoundDampening*3.0);
	PlayAnim(HitAnims[rhit], 1.25);
}


simulated function ClientPlayBlockBegin()

{
	CurrentBlock=Rand(4);
//	log ("Entered ClientPlayBlockBegin, current block is "@CurrentBlock);
	PlayAnim(BlockBeginAnims[CurrentBlock]);
}

simulated function ClientPlayBlockStill()

{
//	log ("Entered ClientPlayBlockStill, current block is "@CurrentBlock);
	LoopAnim(BlockStillAnims[CurrentBlock]);
}

simulated function ClientPlayBlockDown()

{
//	log ("Entered ClientPlayBlockDown, current block is "@CurrentBlock);
	PlayAnim(BlockDownAnims[CurrentBlock]);
}


simulated function PlayUnwind()
{
//	log("Entered PlayUnwind");
	if ( Owner != None )
	{
		ClientPlayBlockDown();
	}
}

state NormalFire
{
ignores Fire, AltFire;

Begin:
//        PlayFiring();
	Sleep(0.50);
	TraceFire(0.0);
	FinishAnim();
	GotoState('Idle');
}


////////////////////////////////////////////////////////

state ClientAltFiring
{
	simulated function AltFire(float Value)
	{
	}
	simulated function AnimEnd()
	{
		if ( (Pawn(Owner) == None)  )
		{
			PlayUnwind();
			GotoState('');
		}
		else if ( !bCanClientFire )
			GotoState('');
		else if ( Pawn(Owner).bAltFire == 0 )
		{
//			PlayUnwind();
			GotoState('ClientFinishAltFire');
	}
		else GotoState('ClientBlocking');
	}
Begin:
//	log("Entered State ClientAltFiring");
	FinishAnim();
}


state ClientBlocking
{
	simulated function AltFire(float Value)
	{
	}
	simulated function BeginState()
	{
		ClientPlayBlockStill();
	}

	simulated function AnimEnd()
	{
		if ( (Pawn(Owner) == None)  )
		{
			PlayUnwind();
			GotoState('');
		}
		else if ( !bCanClientFire )
			GotoState('');
		else if ( Pawn(Owner).bAltFire == 0 )
		{
			PlayUnwind();
			GotoState('ClientFinishAltFire');
		}
		else ClientPlayBlockStill();
	}
Begin:
//	log("Entered Client Blocking State");
}

state Blocking

{
	function Tick(float DeltaTime)
	{
		if (pawn(Owner).bAltFire==0)  
			GoToState('FinishAltFire');
	}	
Begin:
//	log("Entered Blocking State");

}

state ClientFinishAltFire
{
	simulated function BeginState()
	{
//		log("Entered ClientFinishAltFire");
		PlayUnwind();
	}
}

state FinishAltFire
{
	function BeginState()
	{
		bIsBlocking = False;
	}
Begin:
//	log("Entered FinishAltFire State");

	if (Level.NetMode == NM_Standalone)
	   PlayUnwind();

	FinishAnim();
//	CurrentBlock = 0;
	GotoState('Idle');
}


state AltFiring
{
ignores Fire, AltFire;

	function AnimEnd()
	{
		if (Owner==None) 
		{
			AmbientSound = None;
			GotoState('Pickup');
		}			
		if (pawn(Owner).bAltFire==0)  
			GoToState('FinishAltFire');
		else
			GoToState('Blocking');
	}
Begin:
//	log("Entered AltFire State");
	FinishAnim();
	GotoState('Blocking');
}

///////////////////////////////////////////////////////////
state Idle
{

Begin:
//	log("Entered Idle State ");
	if (Pawn(Owner).bFire!=0)  Fire(0.0);
	if (Pawn(Owner).bAltFire!=0) AltFire(0.0);	
	LoopAnim('Still');
	bPointing=False;
	if ( (AmmoType != None) && (AmmoType.AmmoAmount<=0) ) 
		Pawn(Owner).SwitchToBestWeapon();  //Goto Weapon that has Ammo
}

defaultproperties {
      bIsBlocking=False
      CurrentBlock=0
      HitAnims(0)="Hit1"
      HitAnims(1)="Hit2"
      HitAnims(2)="Hit3"
      HitAnims(3)="HIT4"
      HitAnims(4)="Hit5"
      BlockBeginAnims(0)="BLOCKBEGIN1"
      BlockBeginAnims(1)="BLOCKBEGIN2"
      BlockBeginAnims(2)="BLOCKBEGIN3"
      BlockBeginAnims(3)="BLOCKBEGIN4"
      BlockStillAnims(0)="BLOCKSTILL1"
      BlockStillAnims(1)="BLOCKSTILL2"
      BlockStillAnims(2)="BLOCKSTILL3"
      BlockStillAnims(3)="BLOCKSTILL4"
      BlockDownAnims(0)="BLOCKDOWN1"
      BlockDownAnims(1)="BLOCKDOWN2"
      BlockDownAnims(2)="BLOCKDOWN3"
      BlockDownAnims(3)="BLOCKDOWN4"
      HitSounds(0)=None
      HitSounds(1)=None
      HitSounds(2)=None
      HitSounds(3)=None
      HitSounds(4)=None
      HitFleshSounds(0)=None
      HitFleshSounds(1)=None
      HitFleshSounds(2)=None
      HitFleshSounds(3)=None
      HitFleshSounds(4)=None
      HitArmSounds(0)=None
      HitArmSounds(1)=None
      HitArmSounds(2)=None
      HitArmSounds(3)=None
      HitArmSounds(4)=None
      HitArmSounds(5)=None
      HeadShotSounds(0)=None
      HeadShotSounds(1)=None
      HeadShotSounds(2)=None
      HeadShotSounds(3)=None
      HeadShotSounds(4)=None
      SwordBloodSkins(0)=Texture'Chaostex.sword.csword01_b1'
      SwordBloodSkins(1)=Texture'Chaostex.sword.csword01_b2'
      SwordBloodSkins(2)=Texture'Chaostex.sword.csword01_b3'
      SwordBloodSkins(3)=Texture'Chaostex.sword.csword01_b4'
      SwordBloodSkins(4)=Texture'Chaostex.sword.csword01_bb'
      SwordBloodSkins(5)=None
      SkullBloodSkins(0)=Texture'Chaostex.sword.csword02_b1'
      SkullBloodSkins(1)=Texture'Chaostex.sword.csword02_b2'
      SkullBloodSkins(2)=Texture'Chaostex.sword.csword02_b3'
      SkullBloodSkins(3)=Texture'Chaostex.sword.csword02_b4'
      SkullBloodSkins(4)=Texture'Chaostex.sword.csword02_bb'
      SkullBloodSkins(5)=None
      LastHit=None
      Range=120
      Damage=50
      M=None
      SkinNo=0
      SwordStatus=0
      WeaponDescription="Classification: Energy Sword"
      bInstantHit=True
      bMeleeWeapon=True
      MyDamageType="cut"
      AIRating=0.730000
      RefireRate=0.990000
      AltRefireRate=0.990000
      DeathMessage="%o was sliced and diced by %k's %w."
      NameColor=(B=0)
      AutoSwitchPriority=2
      InventoryGroup=2
      PickupMessage="You got the Energy Sword."
      ItemName="Sword"
      PlayerViewOffset=(X=2.125000,Z=-1.125000)
      PlayerViewScale=0.080000
      BobDamping=0.975000
      Icon=None
      bNoSmooth=False
      SoundRadius=96
      SoundVolume=255
      CollisionRadius=8.000000
      CollisionHeight=34.000000
      Mass=15.000000
}
