//=============================================================================
// JuggernautBelt.
//=============================================================================
class JuggernautBelt extends TournamentPickup;

var(Regen) config float RegenDelayAfterDamaged;//resets when player takes damage, as to delay regen while under attack
var(Regen) config bool RegenHealth;
var(Regen) config bool RegenShield;

var(Regen) config float RegenSecs;//how often to regen
var(Regen) config float HealthRegenAmount;
var(Regen) config float ShieldRegenAmount;

var(Movement) config float JumpModifier;
var(Movement) config float NewAirControl;
var(Movement) config float NewGroundSpeed;
var(Movement) config float NewAccelRate;

var float LastRegenTime;

//regen flash params -- Copied from Relics.RelicRegenInventory
var vector InstFog;
var float InstFlash;

//cache old movement values for pawn
var float PrevAirControl;
var float PrevJumpZ;
var float PrevGroundSpeed;
var float PrevAccelRate;

var JuggernautGameInfo JGameInfo;

var BeltItemEffect BeltEffect;

function PreBeginPlay(){
    JGameInfo = JuggernautGameInfo(Level.Game);
    ShowBeltItemEffect();

    if(BeltEffect != None){
        BeltEffect.bHidden = true;
    }
}

event float BotDesireability(Pawn Bot) {
	local inventory Inv;

	for (Inv=Bot.inventory; Inv!=None; Inv=Inv.inventory) {
		if (Inv.IsA('RelicDefenseInventory')){
			return -1; //can't pickup up shieldbelt if have defense relic
		}
    }

	return Super.BotDesireability(Bot);
}

function bool HandlePickupQuery(Inventory Item) {
    if(Item.IsA('JuggernautBelt') || class'InventoryHelper'.static.IsAPowerup(Item, true, true, true)) {
		if(!Owner.IsA('PlayerPawn')){
            Item.SetRespawn();
		}

        return true;
	} else {
	    return Super.HandlePickupQuery(Item);
	}
}

function PickupFunction(Pawn Other) {
    local Inventory inv;
	local Pawn PawnOwner;
	PawnOwner = Pawn(Owner);

    inv = PawnOwner.FindInventoryType(Class'UDamage');
	if(inv != None) {
	    inv.Destroy();
	}

	inv = PawnOwner.FindInventoryType(Class'UT_Jumpboots');
	if(inv != None) {
	    inv.Destroy();
	}

	//delete old shieldbelt
	inv = PawnOwner.FindInventoryType(Class'UT_ShieldBelt');
	if(inv != None) {
	    inv.Destroy();
	}

	inv = GetNewUTShieldBelt();
	if(inv != None) {
	    inv.GiveTo(PawnOwner);
	}

	//cache old values
	PrevAirControl = PawnOwner.AirControl;
	PrevJumpZ = PawnOwner.JumpZ;
    PrevGroundSpeed = PawnOwner.GroundSpeed;
    PrevAccelRate = PawnOwner.AccelRate;

	//change new values
	Other.bCountJumps = True;
    Other.AirControl = NewAirControl;
	Other.JumpZ = Other.Default.JumpZ * JumpModifier;

	Other.GroundSpeed = NewGroundSpeed;
	Other.AccelRate = NewAccelRate;

    LastRegenTime = RegenSecs;
    PawnOwner.Health = Min(199, PawnOwner.Default.Health * 2.0);

    Self.Tag = 'Objective';

    if(BeltEffect != None){
        BeltEffect.bHidden = true;
    }

    Enable('Tick');

    Super.PickupFunction(Other);
}

simulated function Tick(float DeltaTime) {
    LastRegenTime -= DeltaTime;

    if(LastRegenTime <= 0) {
        LastRegenTime = RegenSecs;
	    RegenOwner();
    }
}

function RegenOwner(){
    local float MaxHealth, RegenRemainder;//regn remainder is for any leftover "regen" to spill over from health to shields
	local Pawn PawnOwner;
	local bool HasRegened;

	local Inventory inv;
	local UT_ShieldBelt existingBelt;

	PawnOwner = Pawn(Owner);

	//Max health modeled after Botpack.HealthPack.HealingAmount (and it being 2x normal player/bot health)
	//Also evident in Botpack.TournamentHealth.Pickup[State].Touch and the setting of "HealMax"
    MaxHealth = Min(199, PawnOwner.Default.Health * 2.0);

    if(RegenHealth && (PawnOwner.Health < MaxHealth)) {
        RegenRemainder = (PawnOwner.Health + HealthRegenAmount) - MaxHealth;
        PawnOwner.Health = Min(PawnOwner.Health + HealthRegenAmount, MaxHealth);
        HasRegened = true;
    }

	if(RegenShield) {
	    inv = PawnOwner.FindInventoryType(Class'UT_ShieldBelt');
		if(inv != None){
		    existingBelt = UT_ShieldBelt(inv);

			if((existingBelt.Charge < existingBelt.Default.Charge) && (!HasRegened || (RegenRemainder > 0)) ) {
			    if(HasRegened) {
			         existingBelt.Charge = Fmin(existingBelt.Charge + RegenRemainder, existingBelt.Default.Charge);
			    } else {
	                existingBelt.Charge = Fmin(existingBelt.Charge + ShieldRegenAmount, existingBelt.Default.Charge);
				}

                HasRegened = true;
			}
		} else {
		    if(!HasRegened || (RegenRemainder > 0)) {
                existingBelt = GetNewUTShieldBelt();

                if(HasRegened) {
                    existingBelt.Charge = RegenRemainder;
                } else {
                    existingBelt.Charge = ShieldRegenAmount;
                }

			    existingBelt.GiveTo(PawnOwner);
			    HasRegened = true;
			}
		}
	}

	if(HasRegened) {
	    if(PawnOwner.IsA('PlayerPawn')) {
		    PlayerPawn(PawnOwner).ClientInstantFlash(InstFlash, InstFog);
		}
	}
}

function UT_ShieldBelt GetNewUTShieldBelt() {
    local UT_ShieldBelt newBelt;
    newBelt = Spawn(class'JuggernautShieldBelt');

    return newBelt;
}

function Destroyed() {
    RevertEffects();
    if(BeltEffect != None){
        BeltEffect.Destroy();
    }

    Super.Destroyed();
}
function DropFrom(vector StartLocation) {
    local bool isTestMap;//used to indicate a test map is loaded
    isTestMap = class'TesterCache'.static.HasATesterLoaded(self);

    Super.DropFrom(StartLocation);

    //if the player is not dead alread, kill them
    Pawn(Owner).gibbedBy(Self);

    if(!isTestMap && (JGameInfo != None) && (Self.Tag == 'Objective')){
        Destroy();
    }
}
function BecomePickup(){
    local bool isTestMap;//used to indicate a test map is loaded
    isTestMap = class'TesterCache'.static.HasATesterLoaded(self);

	Super.BecomePickup();

    if(!isTestMap && (JGameInfo != None) && (Self.Tag == 'Objective')){
        Destroy();
    }

    Disable('Tick');

    ShowBeltItemEffect();
}

function BecomeItem(){
    Super.BecomeItem();

    if(BeltEffect != None) {
        BeltEffect.bHidden = true;
    }
}

function RevertEffects(){
    local Pawn PawnOwner;
    local Inventory inv;

	//restore cached values
	if(Owner != None){
	    PawnOwner = Pawn(Owner);

	    PawnOwner.bCountJumps = False;
	    PawnOwner.AirControl = PrevAirControl;
	    PawnOwner.JumpZ = PrevJumpZ;
	    PawnOwner.GroundSpeed = PrevGroundSpeed;
		PawnOwner.AccelRate = PrevAccelRate;

		inv = PawnOwner.FindInventoryType(Class'UT_ShieldBelt');
		if(inv != None){
		    inv.Destroy();
        }
	}
}

function GiveTo(Pawn Other) {
	Super.GiveTo(Other);
	PickupFunction(Other);
}

function ShowBeltItemEffect(){
    if(BeltEffect != None){
        BeltEffect = Spawn(class'BeltItemEffect', Self,,Self.Location, Self.Rotation);
    }

    if(BeltEffect != None){
        BeltEffect.bHidden = true;
    }
}

defaultproperties
{
      RegenDelayAfterDamaged=3.000000
      RegenHealth=True
      RegenShield=True
      RegenSecs=1.000000
      HealthRegenAmount=10.000000
      ShieldRegenAmount=10.000000
      JumpModifier=3.000000
      NewAirControl=0.100000
      NewGroundSpeed=640.000000
      NewAccelRate=1000.000000
      LastRegenTime=1.000000
      InstFog=(X=475.000000,Y=325.000000,Z=145.000000)
      InstFlash=-0.400000
      PrevAirControl=0.000000
      PrevJumpZ=0.000000
      PrevGroundSpeed=0.000000
      PrevAccelRate=0.000000
      JGameInfo=None
      BeltEffect=None
      PickupMessage="You got the Juggernaut Shield Belt."
      ItemName="Juggernaut ShieldBelt"
      PickupViewMesh=LodMesh'Botpack.ShieldBeltMeshM'
      PickupSound=Sound'UnrealShare.Pickups.BeltSnd'
      DeActivateSound=Sound'UnrealShare.Pickups.Sbelthe2'
      Icon=Texture'UnrealShare.Icons.I_ShieldBelt'
      bOwnerNoSee=True
      Mesh=LodMesh'Botpack.ShieldBeltMeshM'
}
