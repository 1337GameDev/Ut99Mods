//=============================================================================
// JuggernautBelt.
//=============================================================================
class JuggernautBelt extends UT_ShieldBelt config;

var(Regen) config float RegenDelayAfterDamaged;//resets when player takes damage, as to delay regen while under attack
var(Regen) config bool RegenHealth;
var(Regen) config bool RegenShield;

var(Regen) config float RegenSecs;
var(Regen) config float HealthRegenAmount;
var(Regen) config float ShieldRegenAmount;

var(Gravity) config float JumpModifier;

var float LastRegenTime;

//regen flash params -- Copied from Relics.RelicRegenInventory
var vector InstFog;
var float InstFlash;

//cache old jump values for pawn
var float PrevAirControl;
var float PrevJumpZ;

//var JuggernautGameInfo JGameInfo;

event float BotDesireability( pawn Bot )
{
	local inventory Inv;

	for ( Inv=Bot.inventory; Inv!=None; Inv=Inv.inventory )
		if ( Inv.IsA('RelicDefenseInventory') )
			return -1; //can't pickup up shieldbelt if have defense relic

	return Super.BotDesireability(Bot);
}

function bool HandlePickupQuery(Inventory Item) {
    local bool CanPickup;

	CanPickup = !Super.HandlePickupQuery(Item);

	if(CanPickup && (Item.IsA('JuggernautBelt') || Item.IsA('UT_Jumpboots') || Item.IsA('UDamage') || Item.IsA('UT_Invisibility') || Item.IsA('UT_ShieldBelt') || Item.bIsAnArmor) ) {
		CanPickup = False;
	}

	return !CanPickup;
}

function PickupFunction(Pawn Other) {
    local Inventory inv;
    local UT_Jumpboots existingBoots;
	local UT_ShieldBelt existingBelt;
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);

	Super.PickupFunction(Other);

	inv = Pawn(Owner).FindInventoryType(Class'UT_Jumpboots');
	if(inv != None) {
	    existingBoots = UT_Jumpboots(inv);
	    existingBoots.Charge = 0;
		existingBoots.GoToState('DeActivated');
	    existingBoots.Destroy();
	}

	inv = Pawn(Owner).FindInventoryType(Class'UT_ShieldBelt');
	if(inv != None) {
	    existingBelt = UT_ShieldBelt(inv);
	    existingBelt.Destroy();
	}

	//cache old values
	PrevAirControl = Other.AirControl;
	PrevJumpZ = Other.JumpZ;

	//change new values
	Other.bCountJumps = True;
	Other.AirControl = 1.0;
	Other.JumpZ = Other.Default.JumpZ * JumpModifier;

	Pawn(Owner).ReceiveLocalizedMessage(class'JuggernautMessage', 0, Pawn(Owner).PlayerReplicationInfo);
}

function int ReduceDamage(int Damage, name DamageType, vector HitLocation) {

	return Super.ReduceDamage(Damage, DamageType, HitLocation);
}

function int ArmorAbsorbDamage(int Damage, name DamageType, vector HitLocation) {

	return Super.ArmorAbsorbDamage(Damage, DamageType, HitLocation);
}

simulated function Tick(float DeltaTime) {
    LastRegenTime -= DeltaTime;


    if(LastRegenTime <= 0) {
        LastRegenTime = RegenSecs;
	    RegenOwner();
    }
}

function RegenOwner(){
    local float MaxHealth;
	local Pawn PawnOwner;
	local bool HasRegened;

	PawnOwner = Pawn(Owner);

    if(RegenHealth){
		MaxHealth = Min(199, PawnOwner.default.Health * 2.0);
	    PawnOwner.Health = Min(PawnOwner.Health + HealthRegenAmount, MaxHealth);
		HasRegened = true;
	}

	if(RegenShield){
	    Charge += Fmin(Charge + ShieldRegenAmount, Default.Charge);
	    HasRegened = true;
	}

	if(HasRegened) {
	    if(PawnOwner.IsA('PlayerPawn')) {
		    PlayerPawn(PawnOwner).ClientInstantFlash(InstFlash, InstFog);
		}
	}
}

function Destroyed() {
    Super.Destroyed();

	RevertEffects();
}
function DropFrom(vector StartLocation) {
    Super.DropFrom(StartLocation);
    Destroy();
}
function BecomePickup(){
	Super.BecomePickup();
    Destroy();
}

function RevertEffects(){
	//restore cached values
	Pawn(Owner).bCountJumps = False;
	Pawn(Owner).AirControl = PrevAirControl;
	Pawn(Owner).JumpZ = PrevJumpZ;
}

defaultproperties {
     PickupMessage="You got the Juggernaut Shield Belt.",
     ItemName="Juggernaut ShieldBelt",
     Icon=Texture'UnrealShare.Icons.I_ShieldBelt',
	 Charge=200,
     ArmorAbsorption=100,

	 //regen flash params -- Copied from Relics.RelicRegenInventory
	 InstFog=(X=475.000000,Y=325.000000,Z=145.000000),
     InstFlash=-0.400000,
}
