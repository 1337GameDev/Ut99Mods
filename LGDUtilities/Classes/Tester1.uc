class Tester1 extends Tester;

function bool Standup() {
     local RedTrigger rt;
     local GreenTrigger gt;
     local name redTriggerEvent;
     local name greenTriggerEvent;

     if(Super.Standup()) {
         rt = new class'LGDUtilities.RedTrigger';
         gt = new class'LGDUtilities.GreenTrigger';
         redTriggerEvent = class'LGDUtilities.TypeHelper'.Static.StringToName(self, "TriggerRed");
         greenTriggerEvent = class'LGDUtilities.TypeHelper'.Static.StringToName(self, "TriggerGreen");

         class'LGDUtilities.CustomTrigger'.Static.SpawnAndListenForEvent(self, redTriggerEvent, rt);
         class'LGDUtilities.CustomTrigger'.Static.SpawnAndListenForEvent(self, greenTriggerEvent, gt);

         Initialized = true;
         return true;
     } else {
         Log("The Tester base Standup failed. Skipping subclass: "@self.class);
         return false;
     }
}

function bool PreBeginPlayTests() {
     local bool AllTestsPass;
     local PlayerSpawnNotifyCallback playerNotifyCallback;
     local AttachIndicatorHudCallback playerSpawnMutCallback;
     local MatchBeginMutatorCallback matchBeginMutatorCallback;

     local PlayerDeathLocationMutator deathLocMut;

     AllTestsPass = true;

     Log("Test1 - PreBeginPlayTests");

     playerNotifyCallback = new class'LGDUtilities.PlayerSpawnNotifyCallback';
     playerNotifyCallback.Context = self;

     playerSpawnMutCallback = new class'LGDUtilities.AttachIndicatorHudCallback';
     playerSpawnMutCallback.Context = self;
     playerSpawnMutCallback.IsLogin = false;

     matchBeginMutatorCallback = new class'LGDUtilities.MatchBeginMutatorCallback';
     matchBeginMutatorCallback.Context = self;

     if(Super.PreBeginPlayTests()) {
         class'LGDUtilities.PlayerSpawnNotify'.static.RegisterForPlayerSpawnEvent(self, playerNotifyCallback);
         class'LGDUtilities.PlayerSpawnMutator'.static.RegisterToPlayerSpawn(self, playerSpawnMutCallback);
         class'LGDUtilities.MatchBeginMutator'.static.RegisterToMatchBegin(self, matchBeginMutatorCallback);

         deathLocMut = Spawn(class'LGDUtilities.PlayerDeathLocationMutator');
         Level.Game.BaseMutator.AddMutator(deathLocMut);

         AllTestsPass = testLinkedList();
         if(!AllTestsPass){
             Log("TEST FAILED: testLinkedList");
         } else {
             Log("TEST PASSED: testLinkedList");
         }

         AllTestsPass = testIntClassLoading();
         if(!AllTestsPass){
             Log("TEST FAILED: testIntClassLoading");
         } else {
             Log("TEST PASSED: testIntClassLoading");
         }

         AllTestsPass = testVectorClamp();
         if(!AllTestsPass){
             Log("TEST FAILED: testVectorClamp");
         } else {
             Log("TEST PASSED: testVectorClamp");
         }

	 } else {
          Log("Base Tester [PreBeginPlayTests] failed. Skipping subclass: "@self.class);
          AllTestsPass = false;
     }


     Log("Test1 - PreBeginPlayTests - Started Timer");
     SetTimer(1, true);

     return AllTestsPass;
}

function bool BeginPlayTests() {
    if(Super.BeginPlayTests()) {
         return true;
     } else {
          Log("Base Tester [BeginPlayTests] failed. Skipping subclass: "@self.class);
          return false;
     }
}

function bool PostBeginPlayTests() {
    if(Super.PostBeginPlayTests()) {
         return true;
     } else {
          Log("Base Tester [PostBeginPlayTests] failed. Skipping subclass: "@self.class);
          return false;
     }
}

////////////////////////
/**** TEST METHODS ****/
////////////////////////

function bool testLinkedList() {
     //linked list test vars
     local LinkedList ll;
     local IntObj io;

     local LinkedList ll2;
     local StringObj so;

     //test LinkedList
     Log("------ int - LinkedList ------");
     ll = new class'LGDUtilities.LinkedList';
     Log("Empty List - Count: "$ll.Count);
     ll.InOrderLog();

     io = new class'LGDUtilities.IntObj';
     io.Value = 1;
     ll.Push(io);
     Log("After Push(1) - Count: "$ll.Count);
     ll.InOrderLog();

     io = new class'LGDUtilities.IntObj';
     io.Value = 2;
     ll.Push(io);
     Log("After Push(2) - Count: "$ll.Count);
     ll.InOrderLog();

     io = new class'LGDUtilities.IntObj';
     io.Value = 3;
     ll.Push(io);
     Log("After Push(3) - Count: "$ll.Count);
     ll.InOrderLog();

     Log("------ string - LinkedList Test 1 (Push/Pop)------");
     //Linked List 2
     ll2 = new class'LGDUtilities.LinkedList';
     Log("Empty List - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'LGDUtilities.StringObj';
     so.Value = "Str1";
     ll2.Push(so);
     Log("After Push(Str1) - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'LGDUtilities.StringObj';
     so.Value = "Str2";
     ll2.Push(so);
     Log("After Push(Str2) - Count: "$ll2.Count);

     ll2.InOrderLog();
     ll2.Pop();
     Log("After Pop() - Count: "$ll2.Count);
     ll2.InOrderLog();
     ll2.Pop();
     ll2.Pop();
     Log("After Pop() x 2 - Count: "$ll2.Count);
     ll2.InOrderLog();

     Log("------ string - LinkedList Test 2 (Enqueue) ------");
     Log("Current List - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'LGDUtilities.StringObj';
     so.Value = "Str1";
     ll2.Enqueue(so);
     Log("After Enqueue(Str1) - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'LGDUtilities.StringObj';
     so.Value = "Str2";
     ll2.Enqueue(so);
     Log("After Enqueue(Str2) - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'LGDUtilities.StringObj';
     so.Value = "Str3";
     ll2.Enqueue(so);
     Log("After Enqueue(Str3) - Count: "$ll2.Count);
     ll2.InOrderLog();

     ll2.Dequeue();
     Log("After Dequeue() - Count: "$ll2.Count);
     ll2.InOrderLog();
     ll2.Dequeue();
     Log("After Dequeue() - Count: "$ll2.Count);
     ll2.InOrderLog();
     ll2.Dequeue();
     Log("After Dequeue() - Count: "$ll2.Count);
     ll2.InOrderLog();

     Log("------ string - LinkedList Test 3 (InsertAt) ------");
     Log("Current List - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'LGDUtilities.StringObj';
     so.Value = "Str1";
     ll2.Push(so);
     Log("Push(Str1) - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'LGDUtilities.StringObj';
     so.Value = "Str2";
     ll2.Push(so);
     Log("Push(Str2) - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'LGDUtilities.StringObj';
     so.Value = "Str3";
     ll2.InsertAt(so, 1);
     Log("InsertAt(Str3, 1) - Count: "$ll2.Count);
     ll2.InOrderLog();

     Log("------ string - LinkedList Test 3 (ContainsValue [Str3]) ------");
     if(ll2.ContainsValue(so)){
          Log("LinkedList Test 3 - ContainsValue Should Be True: True");
     } else {
          Log("LinkedList Test 3 - ContainsValue Should Be True: False");
     }

     Log("------ string - LinkedList Test 4 (ContainsValue [Str30]) ------");
     Log("Before ContainsValue()");
     ll2.InOrderLog();
     so = new class'LGDUtilities.StringObj';
     so.Value = "Str30";
     if(ll2.ContainsValue(so)){
          Log("LinkedList Test 4 - ContainsValue Should Be False: True");
     } else {
          Log("LinkedList Test 4 - ContainsValue Should Be False: False");
     }
     Log("After ContainsValue()");
     ll2.InOrderLog();

     Log("------ string - LinkedList Test 5 (InsertAt(Str4, 0)) ------");
     Log("Before InsertAt()");
     ll2.InOrderLog();

     so = new class'LGDUtilities.StringObj';
     so.Value = "Str4";
     ll2.InsertAt(so, 0);
     Log("After InsertAt(Str4, 0) - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'LGDUtilities.StringObj';
     so.Value = "Str5";
     ll2.InsertAt(so, 4);
     Log("InsertAt(Str5, 4) - Count: "$ll2.Count);
     ll2.InOrderLog();

     Log("------ string - LinkedList Test 6 (ContainsValue [Str5]) ------");
     if(ll2.ContainsValue(so)){
          Log("LinkedList Test 6 - ContainsValue Should Be True: True");
     } else {
          Log("LinkedList Test 6 - ContainsValue Should Be True: False");
     }

     Log("------ string - LinkedList Test 7 (RemoveAt) ------");
     Log("Current List");
     ll2.InOrderLog();
     ll2.RemoveAt(0);//should remove Str4
     Log("After remove (0) - Tail: "@ll2.Tail.ToString()$" - Count: "$ll2.Count);
     ll2.InOrderLog();

     ll2.RemoveAt(0); //Should remove Str2
     Log("After remove (0) - Tail: "@ll2.Tail.ToString()$" - Count: "$ll2.Count);
     ll2.InOrderLog();

     ll2.RemoveAt(2); //Shouldn't remove anything
     Log("After remove (2) - Tail: "@ll2.Tail.ToString()$" - Count: "$ll2.Count);
     ll2.InOrderLog();

     ll2.RemoveAt(1); //Should remove Str1
     Log("After remove (1) - Tail: "@ll2.Tail.ToString()$" - Count: "$ll2.Count);
     ll2.InOrderLog();

     return true;
}

function bool testIntClassLoading() {
    local bool TestPassed, Success;
    local LinkedList AllWeapons;
    local int BaseWeaponCount, BotpackWeaponCount, ChaosUTWeaponCount;
    BaseWeaponCount = 10;//base weapons -- Unreal1
    BotpackWeaponCount = 15;//Botpack Weapons - UT99 Weapons
    ChaosUTWeaponCount = 11;//ChaosUT weapons
    Success = true;

    AllWeapons = class'LGDUtilities.ServerHelper'.static.GetClassesLoadedFromIntFiles(self, "Engine.Weapon");
	TestPassed = AllWeapons.Count >= BaseWeaponCount;
	if(!TestPassed){
		Success = false;
		Log("TEST FAILED: ServerHelper.GetClassesLoadedFromIntFiles - Engine.Weapon");
	} else {
		Log("TEST PASSED: ServerHelper.GetClassesLoadedFromIntFiles - Engine.Weapon");
	}

	AllWeapons = class'LGDUtilities.ServerHelper'.static.GetAllWeaponClasses(self, true, true);
	TestPassed = AllWeapons.Count >= (BaseWeaponCount + BotpackWeaponCount);
	if(!TestPassed){
		Success = false;
		Log("TEST FAILED: ServerHelper.GetAllWeaponClasses - OnlyIncludeBaseWeapons - Exclude ChaosUT");
	} else {
		Log("TEST PASSED: ServerHelper.GetAllWeaponClasses - OnlyIncludeBaseWeapons - Exclude ChaosUT");
	}

	AllWeapons = class'LGDUtilities.ServerHelper'.static.GetAllWeaponClasses(self, true, false);
	TestPassed = AllWeapons.Count >= (BaseWeaponCount + BotpackWeaponCount + ChaosUTWeaponCount);
	if(!TestPassed){
		Success = false;
		Log("TEST FAILED: ServerHelper.GetAllWeaponClasses - OnlyIncludeBaseWeapons - INCLUDE ChaosUT");
	} else {
		Log("TEST PASSED: ServerHelper.GetAllWeaponClasses - OnlyIncludeBaseWeapons - INCLUDE ChaosUT");
	}

	AllWeapons = class'LGDUtilities.ServerHelper'.static.GetAllWeaponClasses(self, false, false, true);
	Log("Tester1 - PreBeginPlayTests - All weapons in INT files:");
	AllWeapons.InOrderLog();

	return Success;
}

function bool testVectorClamp(){
    local bool Success;
    local Vector VectorToCompareTo, VectorA,VectorB,VectorC,VectorD, VectorAClamped,VectorBClamped,VectorCClamped, AnglesBetweenVectors;

    local Vector VectorOfAngles;
    local Rotator VectorRotator;

    VectorToCompareTo = Vect(0,1, 0);
    VectorA = Vect(0,1, 0);
    VectorB = Vect(0.5,0.5, 0);
    VectorC = Vect(0,-1, 0);

    Log("testVectorClamp - VectorA:"$class'LGDUtilities.VectorHelper'.static.VectorToString(VectorA) );
    Log("testVectorClamp - VectorB:"$class'LGDUtilities.VectorHelper'.static.VectorToString(VectorB) );
    Log("testVectorClamp - VectorC:"$class'LGDUtilities.VectorHelper'.static.VectorToString(VectorC) );

    VectorAClamped = class'LGDUtilities.VectorHelper'.static.ClampNormalVectorAxisAnglesInRelationToAnother(VectorToCompareTo,VectorA, 90,90,90);
    VectorBClamped = class'LGDUtilities.VectorHelper'.static.ClampNormalVectorAxisAnglesInRelationToAnother(VectorToCompareTo,VectorB, 90,90,90);
    VectorCClamped = class'LGDUtilities.VectorHelper'.static.ClampNormalVectorAxisAnglesInRelationToAnother(VectorToCompareTo,VectorC, 90,90,90);

    Log("testVectorClamp - VectorAClamped:"$class'LGDUtilities.VectorHelper'.static.VectorToString(VectorAClamped) );
    Log("testVectorClamp - VectorBClamped:"$class'LGDUtilities.VectorHelper'.static.VectorToString(VectorBClamped) );
    Log("testVectorClamp - VectorCClamped:"$class'LGDUtilities.VectorHelper'.static.VectorToString(VectorCClamped) );

    VectorOfAngles = Vect(0,0,90);
    VectorRotator = class'LGDUtilities.RotatorHelper'.static.RotatorFromVectorOfDegrees(VectorOfAngles);
    VectorD = VectorA << VectorRotator;
    VectorD = class'LGDUtilities.VectorHelper'.static.RoundValuesOfVector(VectorD, 0.899999999999999, 0.000483);

    Log("testVectorClamp - VectorD - Recreated from A and rotated 90* clockwise on Z:"$class'VectorHelper'.static.VectorToString(VectorD) );

    AnglesBetweenVectors = class'LGDUtilities.VectorHelper'.static.GetAnglesBetweenVectorsAsVector(VectorA, VectorB);
    Log("testVectorClamp - AnglesBetweenVectors-(A,B):"$class'LGDUtilities.VectorHelper'.static.VectorToString(AnglesBetweenVectors) );

    AnglesBetweenVectors = class'LGDUtilities.VectorHelper'.static.GetAnglesBetweenVectorsAsVector(VectorA, VectorC);
    Log("testVectorClamp - AnglesBetweenVectors-(A,C): "$class'LGDUtilities.VectorHelper'.static.VectorToString(AnglesBetweenVectors) );

    Log("testVectorClamp - Round 0.000383 (should round DOWN to 0.0): "$class'LGDUtilities.MathHelper'.static.RoundGivenLimits(0.000383, 0.899999999999999, 0.000499999999999) );
    Log("testVectorClamp - Round 0.500383 (should NOT round): "$class'LGDUtilities.MathHelper'.static.RoundGivenLimits(0.500383, 0.899999999999999, 0.000499999999999) );
    Log("testVectorClamp - Round 0.900383 (should round UP to 1.0): "$class'LGDUtilities.MathHelper'.static.RoundGivenLimits(0.900383, 0.899999999999999, 0.000499999999999) );

    Success = true;

    return Success;
}

simulated function Timer(){

}

defaultproperties {
}
