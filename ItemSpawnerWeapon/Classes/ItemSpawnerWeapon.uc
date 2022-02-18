//=============================================================================
// ItemSpawnerWeapon - A weapon used to spawn other items
//=============================================================================
class ItemSpawnerWeapon extends TournamentWeapon config;

#exec TEXTURE IMPORT NAME=UseSpawner FILE=Textures\Icons\UseSpawner.bmp GROUP="Icons" FLAGS=2 MIPS=OFF

var int UpdateIntervalSecs;
var float CurrentTimeInterval;
var() float MaxGhostDistance;

var ItemSpawnerWeaponGhost SelectedActorGhost;

var int ItemToSpawnIndex;
var float ItemToSpawnCollisionRadius;
var float ItemToSpawnCollisionHeight;

var() config Class<Actor> ItemsToSpawn[32];

simulated function bool SpawnSelectedClass(Class<Actor> classToSpawn, Vector pos, Rotator rot){
     local Actor spawned;
     local StringObj spawnMsg;

     if(classToSpawn != None){
         if(classToSpawn.default.bStatic || classToSpawn.default.bNoDelete){
             spawnMsg = new class'StringObj';
             spawnMsg.Value = "Cannot spawn \""$classToSpawn.name$"\" because bStatic or bNoDelete are true.";
             Pawn(Owner).ReceiveLocalizedMessage(class'CannotSpawnMessage', 0, None, None, spawnMsg);
         } else {
             spawned = Spawn(classToSpawn,,,pos, rot);
             if(spawned == None){
                 spawnMsg = new class'StringObj';
                 spawnMsg.Value = "Cannot spawn \""$classToSpawn.name$"\"";
                 Pawn(Owner).ReceiveLocalizedMessage(class'CannotSpawnMessage', 0, None, None, spawnMsg);
             }
         }
     }

     return (spawned != None);
}

simulated function bool SelectNextClassToSpawn(){
    local int MaxLoopCount;
    ItemToSpawnIndex = (ItemToSpawnIndex+1) % 32;
    MaxLoopCount = 0;

    //get collision proerties from class
    While((MaxLoopCount < 32) && (ItemsToSpawn[ItemToSpawnIndex] == None)){
        ItemToSpawnIndex = (ItemToSpawnIndex+1) % 32;
        MaxLoopCount++;
    }

    if(ItemsToSpawn[ItemToSpawnIndex] != None) {
        UpdateGhostFromSelectedObject();
        return true;
    } else {
        return false;
    }
}

simulated function UpdateGhostFromSelectedObject(){
    if(ItemsToSpawn[ItemToSpawnIndex] != None){
        ItemToSpawnCollisionRadius = ItemsToSpawn[ItemToSpawnIndex].default.CollisionRadius;
        ItemToSpawnCollisionHeight = ItemsToSpawn[ItemToSpawnIndex].default.CollisionHeight;
        SelectedActorGhost.UpdateGhostObject(ItemsToSpawn[ItemToSpawnIndex].default.Mesh, ItemToSpawnCollisionRadius, ItemToSpawnCollisionHeight);
    }

    Pawn(Owner).ReceiveLocalizedMessage(class'SelectItemMessage', 0, None, None, ItemsToSpawn[ItemToSpawnIndex]);
}

simulated function DestroyGhost(){
    if(SelectedActorGhost != None){
        SelectedActorGhost.Destroy();
        SelectedActorGhost = None;
    }
}

simulated function UpdateGhostLocation(){
     local Actor HitActor, HitLevel;
     local Vector HitLocation, HitNormal, StartTrace, EndTrace;
     local Vector NewGhostPos;
     local Rotator NewGhostRot;
     local float ItemToSpawnCollisionSize, HitActorCollisionSize;

     if(SelectedActorGhost == None){
         SelectedActorGhost = Spawn(class'ItemSpawnerWeaponGhost');
         SelectedActorGhost.SpawnerWeapon = Self;
     }
     ItemToSpawnCollisionSize = FMax(ItemToSpawnCollisionRadius, ItemToSpawnCollisionHeight);

     StartTrace = Location + (vect(0,0,1) * PlayerPawn(Owner).BaseEyeHeight);
	 EndTrace = StartTrace + (vector(Rotation) * MaxGhostDistance);

     //cast from our location, and hit geometry or an actor
     HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

     if(HitActor != None){
         HitLevel = LevelInfo(HitActor);

         if(HitLevel != None){
             //hit level geometry
             NewGhostPos = HitLocation - (vector(Rotation) * (ItemToSpawnCollisionSize));
         } else {
             //hit an actor
             HitActorCollisionSize = FMax(HitActor.CollisionRadius,HitActor.CollisionHeight) / 2.0;
             NewGhostPos = HitLocation - (vector(Rotation) * (ItemToSpawnCollisionSize+HitActorCollisionSize) );
         }
     } else {
         //hit nothing, so adjust position based on max distance
         NewGhostPos = EndTrace;
     }

     SelectedActorGhost.SetLocation(NewGhostPos);

     NewGhostRot = Self.Owner.Rotation;
     NewGhostRot.Pitch = 0;
     NewGhostRot.Roll = 0;
     SelectedActorGhost.SetRotation(NewGhostRot);
}

/*
  Object States
*/

//active / down states
state Active {
	ignores animend, DropFrom;

    function Fire(float Value) {
        local float SoundVolume;
        SoundVolume = 4;

        if(Owner != None) {
            SpawnSelectedClass(ItemsToSpawn[ItemToSpawnIndex], SelectedActorGhost.Location, SelectedActorGhost.Rotation);
            if(Pawn(Owner) != None){
                SoundVolume *= Pawn(Owner).SoundDampening;
            }

            PlayOwnedSound(FireSound, SLOT_Misc, SoundVolume);
        } else {
            GotoState('');
        }
    }

    function AltFire(float Value) {
        local float SoundVolume;
        SoundVolume = 4;

        if(Owner != None){
            SelectNextClassToSpawn();
            UpdateGhostFromSelectedObject();
            if(Pawn(Owner) != None){
                SoundVolume *= Pawn(Owner).SoundDampening;
            }

            PlayOwnedSound(AltFireSound, SLOT_Misc, SoundVolume);
        } else {
            GotoState('');
        }
    }

    function BeginState() {
        if(Owner == None) {
            GotoState('');
            return;
        }

        //ensure ONLY players can pick up this weapon, and if one does equip it
        //destroy and remove it from their inventory
		if(PlayerPawn(Owner) == None){
		     DropFrom(Self.Location);
		     Destroy();
		     if(Pawn(Owner) != None){
		         Pawn(Owner).SwitchToBestWeapon();
		     }
		}

		//Enable the trace routine that shows the object to spawn
		CurrentTimeInterval = 0;

		UpdateGhostLocation();
		UpdateGhostFromSelectedObject();

        Enable('Tick');
	}

	simulated function Tick(float DeltaTime) {
		local TournamentPlayer T;

        if(Owner == None){
            GotoState('');
        }

        CurrentTimeInterval += DeltaTime;
        if(CurrentTimeInterval >= UpdateIntervalSecs) {
            CurrentTimeInterval = 0;

            //perform timed action
            T = TournamentPlayer(Owner);
            if(T != None){
                //update location of the selected item mesh
                UpdateGhostLocation();
            } else {
                DropFrom(Self.Location);
                Destroy();
                if(Pawn(Owner) != None){
                    Pawn(Owner).SwitchToBestWeapon();
                }
            }
        }
	}

	function EndState(){
        DestroyGhost();
        Disable('Tick');
    }

Begin:
	LoopAnim('Idle', 0.4);
}

State ClientActive {
	simulated function AnimEnd() {}
	simulated function BeginState() {}
	simulated function EndState() {}
}

State ClientDown {
	simulated function ForceClientFire() {
		//Global.ClientFire(0);
	}

	simulated function ForceClientAltFire() {
		//Global.ClientAltFire(0);
	}

	simulated function bool ClientFire(float Value) {
		return false;
	}

	simulated function bool ClientAltFire(float Value) {
		return false;
	}
}

State DownWeapon {
    ignores Fire, AltFire, AnimEnd;

	function BeginState() {
		Super.BeginState();
        CurrentTimeInterval = 0;
	}
}

function Destroyed(){
	Super.Destroyed();
    DestroyGhost();
}
function DropFrom(vector StartLocation) {
    Super.DropFrom(StartLocation);
    DestroyGhost();
}
function BecomePickup(){
	Super.BecomePickup();
	DestroyGhost();
}

function float RateSelf(out int bUseAltMode) {
	return -2;//give max negative rating so bots don't pick this up
}
event float BotDesireability(Pawn Bot){
    return 0;//bots don't want this weapon
}

defaultproperties {
      UpdateIntervalSecs=0
      CurrentTimeInterval=0.000000
      MaxGhostDistance=300.000000
      SelectedActorGhost=None
      ItemToSpawnIndex=0
      ItemToSpawnCollisionRadius=1.000000
      ItemToSpawnCollisionHeight=1.000000
      ItemsToSpawn(0)=Class'HeadHunter.PracticeBot'
      ItemsToSpawn(1)=Class'Botpack.TMale2Bot'
      ItemsToSpawn(2)=Class'Botpack.TFemale1Bot'
      ItemsToSpawn(3)=Class'UnrealShare.Chest'
      ItemsToSpawn(4)=Class'UnrealShare.Candle'
      ItemsToSpawn(5)=Class'Botpack.Armor2'
      ItemsToSpawn(6)=Class'Botpack.UT_FlakCannon'
      ItemsToSpawn(7)=Class'UnrealShare.TorchFlame'
      ItemsToSpawn(8)=Class'ChaosUT.ch_WarHeadLauncher'
      ItemsToSpawn(8)=Class'UnrealShare.DispersionPistol'

      WeaponDescription="Classification: SpawnernPrimary Fire: Spawn the selected item. nSecondary Fire: Advance the selected item."
      PickupAmmoCount=1
      FiringSpeed=1.000000
      FireOffset=(X=15.000000,Y=-13.000000,Z=-7.000000)
      AIRating=0.000000
      FireSound=Sound'Botpack.Translocator.ThrowTarget'
      AltFireSound=Sound'UnrealShare.Menu.Updown3'
      DeathMessage="%k spawnfragged %o!"
      AutoSwitchPriority=0
      bTossedOut=True
      PickupMessage="You got the Item Spawner."
      ItemName="Item Spawner"
      RespawnTime=0.000000
      PlayerViewOffset=(X=5.000000,Y=-4.200000,Z=-7.000000)
      PlayerViewMesh=LodMesh'Botpack.Transloc'
      PickupViewMesh=LodMesh'Botpack.Trans3loc'
      ThirdPersonMesh=LodMesh'Botpack.Trans3loc'
      StatusIcon=Texture'ItemSpawnerWeapon.Icons.UseSpawner'
      Icon=Texture'ItemSpawnerWeapon.Icons.UseSpawner'
      Mesh=LodMesh'Botpack.Trans3loc'
      bNoSmooth=False
      CollisionRadius=8.000000
      CollisionHeight=3.000000
      Mass=10.000000
}
