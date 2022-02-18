//=============================================================================
// SkullItem
//=============================================================================
class SkullItem extends Pickup;

#exec MESH IMPORT MESH=Skull ANIVFILE=MODELS\Skull\Skull_a.3D DATAFILE=MODELS\Skull\Skull_d.3D X=0 Y=0 Z=0 LODSTYLE=12
#exec MESHMAP SCALE MESHMAP=Skull X=0.04 Y=0.04 Z=0.08

#exec MESH LODPARAMS MESH=Skull STRENGTH=0.0

#exec MESH ORIGIN MESH=Skull X=0 Y=0 Z=0

#exec TEXTURE IMPORT NAME=SKIN_Skull FILE=Textures\Skull\Skull.bmp GROUP="Skins" FLAGS=2
#exec MESHMAP SETTEXTURE MESHMAP=Skull NUM=1 TEXTURE=SKIN_Skull

#exec TEXTURE IMPORT NAME=I_SkullIcon FILE=Textures\Skull\SkullIcon.bmp GROUP="Icons" MIPS=OFF

#exec AUDIO IMPORT FILE="Sounds\Skull\skull_pickup.wav" NAME="SkullPickup" GROUP="SkullItem"
#exec AUDIO IMPORT FILE="Sounds\Skull\skulls_dropped.wav" NAME="SkullsDropped" GROUP="SkullItem"
#exec AUDIO IMPORT FILE="Sounds\Skull\skull_bounce.wav" NAME="SkullBounce" GROUP="SkullItem"
#exec AUDIO IMPORT FILE="Sounds\Skull\skull_pop.wav" NAME="SkullPop" GROUP="SkullItem"

var Sound SkullsDroppedSound;
var Sound BounceSound;

var int MaxCount;//  The maximum skulls somebody can carry at once
var bool bBroadCastLog;
var bool bLogToGameLogfile;

var bool UseInventoryToolbelt;

var FlameFollower FlameActor;
var float CurrentFlameUpdateTimeInterval;
var float UpdateFlameIntervalSecs;

var float CurrentHUDMutTimeInterval;
var float CheckHUDMutIntervalSecs;

var bool bOnGround;

var HeadHunterGameInfo HHGameInfo;

function DestroyFlame() {
     if(FlameActor != None) {
         FlameActor.Destroy();
     }
}

function CreateFlame() {
     local Vector FlamePos;

     if(FlameActor == None) {
         FlamePos = Self.Location;
         FlamePos.Z += (Self.CollisionHeight / 2.0) - 4;
         FlamePos = FlamePos - Self.Location;//used as an offset, not absolute position

         FlameActor = Spawn(class'HeadHunter.FlameFollower', Self);
         if(FlameActor != None){
             FlameActor.PrePivot = FlamePos;
         }
     }
}

//
// Advanced function which lets existing items in a pawn's inventory
// prevent the pawn from picking something up. Return true to abort pickup
// or if item handles the pickup
function bool HandlePickupQuery(Inventory Item) {
    local int collectRemainder; //The remainder after we try to collect the skulls - to see if we would leave any behind
    local SkullItem otherSkull;

    if(bBroadCastLog) {
        BroadCastMessage("SkullItem["$Self.Name$"]: HandlePickupQuery From "@Name);
    }

    if(bLogToGameLogfile) {
        Log("SkullItem["$Self.Name$"]: HandlePickupQuery From: "$Name$" - Other item:"$Item.Name);
    }

    otherSkull = SkullItem(Item);

    if(otherSkull != None){
	    if(bLogToGameLogfile){
            Log("SkullItem["$Self.Name$"] - HandlePickupQuery - Other skull has num copies:"$otherSkull.NumCopies);
        }

		if(otherSkull.NumCopies == 0){
            otherSkull.NumCopies = 1;
        }

        if(bLogToGameLogfile) {
            Log("SkullItem["$Self.Name$"]: HandlePickupQuery-item ["@otherSkull.Name@"] is a skull - NumCopies:"@NumCopies@" Other.NumCopies"@otherSkull.NumCopies@" Max:"@MaxCount);
        }

        if(!CanPickupMore()) {
            if(bLogToGameLogfile) {
                Log("SkullItem["$Self.Name$"]: HandlePickupQuery-We already have the max skulls we can carry - "@NumCopies@" Max:"@MaxCount);
            }

            //Log("SkullItem - HandlePickupQuery - Cannot pickup more skulls");
            Pawn(Owner).ReceiveLocalizedMessage(class'HeadHunterMaxSkullsMessage', 0);
            return true;//if we are at the max skull count
        }

        if(Level.Game.LocalLog != None){
            Level.Game.LocalLog.LogPickup(otherSkull, Pawn(Owner));
        }
        if(Level.Game.WorldLog != None){
            Level.Game.WorldLog.LogPickup(otherSkull, Pawn(Owner));
        }
        if(Item.PickupMessageClass == None){
            Pawn(Owner).ClientMessage(otherSkull.PickupMessage, 'Pickup');
        } else {
            Pawn(Owner).ReceiveLocalizedMessage(Item.PickupMessageClass, 0, None, None, otherSkull.Class);
        }

        otherSkull.PlaySound(item.PickupSound,, 32.0);

        collectRemainder = GetRemainderAfterPickup(otherSkull);
        if(bLogToGameLogfile) {
            Log("SkullItem["$Self.Name$"]: HandlePickupQuery-collectRemainder: "@collectRemainder);
        }

        if(collectRemainder != 0) {//we will collect more than the max
            //there will be a remainder -- we want to NOT pickup the skull, but still transfer up to the max
            //set the other skull to the remainder, and MAX out current skull count
            NumCopies = MaxCount;
            otherSkull.NumCopies = collectRemainder;

            if(bLogToGameLogfile) {
                Log("SkullItem["$Self.Name$"]: HandlePickupQuery-We will collect MORE than max, so leave skull and transfer count");
                Log("SkullItem["$Self.Name$"]: HandlePickupQuery-Other skull remaining count: "@otherSkull.NumCopies);
            }

             //otherSkull.SetRespawn();
            //Log("SkullItem - HandlePickupQuery - Cannot pickup more skulls");
            Pawn(Owner).ReceiveLocalizedMessage(class'HeadHunterMaxSkullsMessage', 0);
            return true;
        } else {
           //collect less than max
		   if(bLogToGameLogfile) {
		       Log("SkullItem["$Self.Name$"] - HandlePickupQuery - collectRemainder==0 - This skull NumCopies: "$NumCopies$" - Other skull NumCopies: "$otherSkull.NumCopies);
		       Log("SkullItem["$Self.Name$"]: HandlePickupQuery - We will collect LESS than max, so pick up the other skull");
		   }

           NumCopies += otherSkull.NumCopies;

           if(bLogToGameLogfile) {
		       Log("SkullItem["$Self.Name$"] - HandlePickupQuery - After adding other skull copies - This skull NumCopies: "$NumCopies$" - Other skull NumCopies: "$otherSkull.NumCopies);
		   }

           otherSkull.Destroy();
           return true;
        }
    } else {
          if(bLogToGameLogfile) {
              Log("SkullItem["$Self.Name$"]: HandlePickupQuery-item wasn't a skull - This skull NumCopies:"@NumCopies);
          }
    }

    if (Inventory == None){
        return false;
    }

    return Inventory.HandlePickupQuery(Item);
}

function PickupFunction(Pawn Other) {
    local InventoryToolbelt toolbelt;
    LightType = LT_None;

    if(bBroadCastLog) {
        BroadCastMessage("SkullItem: PickupFunction");
    }

     if(bLogToGameLogfile) {
         Log("SkullItem: PickupFunction of "@Name);
         Log("SkullItem: PickupFunction - Icon: "@Icon);
     }

     if(NumCopies == 0){
         NumCopies = 1;
     }

     if(NumCopies == 1){
         if(UseInventoryToolbelt) {
             toolbelt = class'InventoryToolbelt'.static.GetCurrentPlayerInventoryToolbeltHudInstance(self, PlayerPawn(Owner));

             if(toolbelt != None){
                 toolbelt.AddInventoryToToolbelt(self);
             }
         }
     }

     DestroyFlame();

     CheckForHUDMutator();
}

function int GetRemainderAfterPickup(SkullItem OtherSkull) {
    //Get the combined total, and then get the remainder that's greater than the MaxCount
    return GetRemainderAfterPickupNumber(OtherSkull.NumCopies);
}

function int GetRemainderAfterPickupNumber(int skullCount) {
    //Get the combined total, and then get the remainder that's greater than the MaxCount
    return Max(0, (NumCopies + skullCount) - MaxCount);
}

function bool CanPickupMore() {
    //Determine if we can collect more skulls
    return NumCopies < MaxCount;
}

function Destroyed() {
    DestroyFlame();

    if(HHGameInfo != None) {
        HHGameInfo.RemoveSkullItemIndicator(self);
    }

    Super.Destroyed();
}

function BecomePickup(){
    Super.BecomePickup();
    CreateFlame();
}

function BecomeItem(){
    Super.BecomeItem();
    DestroyFlame();

    if(HHGameInfo != None) {
        HHGameInfo.RemoveSkullItemIndicator(self);
    }
}

function DropFrom(vector StartLocation) {
    Super.DropFrom(StartLocation);
    CreateFlame();
}

//
// Give this inventory item to a pawn.
//
function GiveTo(Pawn Other) {
    local SkullItem skull;
    skull = SkullItem(Other.FindInventoryType(class'HeadHunter.SkullItem') );

	Instigator = Other;
	BecomeItem();

	if(skull == None){
	    Other.AddInventory(Self);
	} else {
	    skull.NumCopies = Min(skull.NumCopies+Self.NumCopies, skull.MaxCount);
	}

	GotoState('Idle2');
    //invoke normal pickup logic
    PickupFunction(Other);
}

function PreBeginPlay() {
    CreateFlame();
    HHGameInfo = HeadHunterGameInfo(Level.Game);
    Self.NumCopies = Max(Self.NumCopies, 1);
}

simulated function PostBeginPlay() {
    Super.PostBeginPlay();

    if(Self.Mesh == None){
        Self.Mesh = LodMesh'Botpack.Diamond';
    }

    if (Level.NetMode == NM_DedicatedServer){
        return;
    }

    if(HHGameInfo != None){
        MaxCount = HHGameInfo.SkullCarryLimit;
    }
}

simulated function CheckForHUDMutator() {
    local Mutator M;
    local SkullItemHud SIH;
    local PlayerPawn P;

    ForEach AllActors(class'PlayerPawn', P) {
        if(P.myHUD != None) {
            // check if it already has a SkullItemHud
            M = P.myHud.HUDMutator;

            While(M != None) {
                if(M.IsA('SkullItemHud')) {
                    return;
                }

                M = M.NextHUDMutator;
            }

            SIH = Spawn(class'SkullItemHud');
            SIH.RegisterThisHUDMutator();

            if(SIH.bHUDMutator) {
                return;
            } else {
                SIH.Destroy();
            }
        }
    }
}

event float BotDesireability(Pawn Bot) {
    local Inventory Inv;
    local SkullItem skull;
    local float desirability, PercentageTimeToCollection;

    // If we already have the max Skulls, we don't want another one.
    desirability = MaxDesireability;
    Inv = Bot.FindInventoryType(class'SkullItem');

    if(Inv != None) {
        skull = SkullItem(Inv);

        if(skull.NumCopies >= skull.MaxCount) {
            desirability = -1;
        }
    }

    if(HHGameInfo != None && (desirability > 0)){
        if(HHGameInfo.SkullsCollectedCountdown > 0){
            //calculate distance to skull in proportion to time remaining to pickup

            PercentageTimeToCollection = HHGameInfo.SkullsCollectedCountdown / HHGameInfo.SkullCollectTimeInterval;
            desirability = FClamp(PercentageTimeToCollection*MaxDesireability, 2, MaxDesireability);

            desirability = MaxDesireability;
        }
    }

    return desirability;
}

simulated function Timer() {
    Super.Timer();

    if(Role == ROLE_SimulatedProxy) {
        CheckForHUDMutator();
    }
}
simulated function Tick(float DeltaTime) {
	CurrentFlameUpdateTimeInterval += DeltaTime;
    CurrentHUDMutTimeInterval += DeltaTime;

	if(CurrentFlameUpdateTimeInterval >= UpdateFlameIntervalSecs) {
		CurrentFlameUpdateTimeInterval = 0;

        if(Self.bOnlyOwnerSee || Self.bCarriedItem) {
            DestroyFlame();
        } else {
            CreateFlame();
        }
	}

    if(Role == ROLE_SimulatedProxy) {
        if(CurrentHUDMutTimeInterval >= CheckHUDMutIntervalSecs) {
			CurrentHUDMutTimeInterval = 0;

			CheckForHUDMutator();
		}
    }
}

//given a point, number of skulls to spawn, and a starting velocity for each skull -- will spawn skulls in a number of equadistant points around the given central point
//returns the number spawned
static function int SpawnNumberFromPoint(Actor context, Vector point, int numberOfSkulls, Vector startingVelocity){
   local LinkedList PointsToSpawnAt;
   local ListElement le;
   local VectorObj vObj;
   local SkullItemProj skull;

   local HeadHunterGameInfo hhGameInfo;

   local Vector skullDir;
   local int numberSkullsSpawned;

   PointsToSpawnAt = class'MathHelper'.static.GetNumberEquadistantPointsAroundCircleCenter(Vect(0,0,0), 50.0, numberOfSkulls, Vect(0,0,1));
   if(PointsToSpawnAt != None){
       hhGameInfo = HeadHunterGameInfo(context.Level.Game);
       le = PointsToSpawnAt.Head;

       while(le != None){
           vObj = VectorObj(le.Value);
           skullDir = Normal(vObj.Value);

           skull = context.Spawn(
              class'Headhunter.SkullItemProj',,,
              point,
              Rot(0,0,0)
           );


           if(skull != None){
               numberSkullsSpawned++;

               skull.Velocity = (skullDir * 200);
               skull.Velocity.Z += 275;
               skull.Velocity = skull.Velocity >> class'RotatorHelper'.static.RandomRotationByDegrees(15, 15, 15);
               skull.Speed = VSize(skull.Velocity);
           }

           if((hhGameInfo != None) && (hhGameInfo.HHRepInfo != None)) {
               if(hhGameInfo.HHRepInfo.ShowDroppedSkullIndicators){
                   hhGameInfo.AddSkullItemProjIndicator(skull);
               }
           }

           le = le.Next;
       }

       if(numberSkullsSpawned > 0){
           context.PlaySound(class'Headhunter.SkullItem'.default.SkullsDroppedSound,, 32.0);
       }
   }

   return numberSkullsSpawned;
}

defaultproperties
{
      SkullsDroppedSound=Sound'HeadHunter.SkullItem.SkullPop'
      BounceSound=Sound'HeadHunter.SkullItem.SkullBounce'
      MaxCount=2
      bBroadCastLog=False
      bLogToGameLogfile=False
      UseInventoryToolbelt=False
      FlameActor=None
      CurrentFlameUpdateTimeInterval=0.000000
      UpdateFlameIntervalSecs=0.100000
      CurrentHUDMutTimeInterval=0.000000
      CheckHUDMutIntervalSecs=0.250000
      bOnGround=False
      HHGameInfo=None
      bCanHaveMultipleCopies=True
      PickupMessage="You picked up a skull!"
      ItemName="SkullItem"
      PickupViewMesh=LodMesh'HeadHunter.Skull'
      MaxDesireability=5.000000
      PickupSound=Sound'HeadHunter.SkullItem.SkullPickup'
      Icon=Texture'UnrealShare.Icons.IconSkull'
      bAlwaysRelevant=True
      LODBias=8.000000
      Mesh=LodMesh'HeadHunter.Skull'
      bUnlit=True
      SoundRadius=16
      CollisionRadius=25.000000
      CollisionHeight=25.000000
      bCollideWorld=True
      LightEffect=LE_NonIncidence
      LightBrightness=255
      LightHue=170
      LightSaturation=255
      LightRadius=2
      LightPeriod=64
      LightPhase=255
      bBounce=True
      Mass=3.000000
}
