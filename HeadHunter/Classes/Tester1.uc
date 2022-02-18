class Tester1 extends Tester;

function bool Standup() {
     local RedTrigger rt;
     local GreenTrigger gt;
     local name redTriggerEvent;
     local name greenTriggerEvent;

     if(Super.Standup()) {
         rt = new class'RedTrigger';
         gt = new class'GreenTrigger';
         redTriggerEvent = class'TypeHelper'.Static.StringToName(self, "TriggerRed");
         greenTriggerEvent = class'TypeHelper'.Static.StringToName(self, "TriggerGreen");

         class'CustomTrigger'.Static.SpawnAndListenForEvent(self, redTriggerEvent, rt);
         class'CustomTrigger'.Static.SpawnAndListenForEvent(self, greenTriggerEvent, gt);

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

     playerNotifyCallback = new class'PlayerSpawnNotifyCallback';
     playerNotifyCallback.Context = self;

     playerSpawnMutCallback = new class'AttachIndicatorHudCallback';
     playerSpawnMutCallback.Context = self;
     playerSpawnMutCallback.IsLogin = false;

     matchBeginMutatorCallback = new class'MatchBeginMutatorCallback';
     matchBeginMutatorCallback.Context = self;

     if(Super.PreBeginPlayTests()) {
         class'PlayerSpawnNotify'.static.RegisterForPlayerSpawnEvent(self, playerNotifyCallback);
         class'PlayerSpawnMutator'.static.RegisterToPlayerSpawn(self, playerSpawnMutCallback);
         class'MatchBeginMutator'.static.RegisterToMatchBegin(self, matchBeginMutatorCallback);

         deathLocMut = Spawn(class'PlayerDeathLocationMutator');
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
     ll = new class'LinkedList';
     Log("Empty List - Count: "$ll.Count);
     ll.InOrderLog();

     io = new class'IntObj';
     io.Value = 1;
     ll.Push(io);
     Log("After Push(1) - Count: "$ll.Count);
     ll.InOrderLog();

     io = new class'IntObj';
     io.Value = 2;
     ll.Push(io);
     Log("After Push(2) - Count: "$ll.Count);
     ll.InOrderLog();

     io = new class'IntObj';
     io.Value = 3;
     ll.Push(io);
     Log("After Push(3) - Count: "$ll.Count);
     ll.InOrderLog();

     Log("------ string - LinkedList Test 1 (Push/Pop)------");
     //Linked List 2
     ll2 = new class'LinkedList';
     Log("Empty List - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'StringObj';
     so.Value = "Str1";
     ll2.Push(so);
     Log("After Push(Str1) - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'StringObj';
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

     so = new class'StringObj';
     so.Value = "Str1";
     ll2.Enqueue(so);
     Log("After Enqueue(Str1) - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'StringObj';
     so.Value = "Str2";
     ll2.Enqueue(so);
     Log("After Enqueue(Str2) - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'StringObj';
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

     so = new class'StringObj';
     so.Value = "Str1";
     ll2.Push(so);
     Log("Push(Str1) - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'StringObj';
     so.Value = "Str2";
     ll2.Push(so);
     Log("Push(Str2) - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'StringObj';
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
     so = new class'StringObj';
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

     so = new class'StringObj';
     so.Value = "Str4";
     ll2.InsertAt(so, 0);
     Log("After InsertAt(Str4, 0) - Count: "$ll2.Count);
     ll2.InOrderLog();

     so = new class'StringObj';
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

    Success = true;

    AllWeapons = class'ServerHelper'.static.GetClassesLoadedFromIntFiles(self, "Engine.Weapon");
	TestPassed = AllWeapons.Count == 10;
	if(!TestPassed){
		Success = false;
		Log("TEST FAILED: ServerHelper.GetClassesLoadedFromIntFiles - Engine.Weapon");
	} else {
		Log("TEST PASSED: ServerHelper.GetClassesLoadedFromIntFiles - Engine.Weapon");
	}

	AllWeapons = class'ServerHelper'.static.GetAllWeaponClasses(self, true, true);
	TestPassed = AllWeapons.Count == 26;
	if(!TestPassed){
		Success = false;
		Log("TEST FAILED: ServerHelper.GetAllWeaponClasses - OnlyIncludeBaseWeapons - Exclude ChaosUT");
	} else {
		Log("TEST PASSED: ServerHelper.GetAllWeaponClasses - OnlyIncludeBaseWeapons - Exclude ChaosUT");
	}

	AllWeapons = class'ServerHelper'.static.GetAllWeaponClasses(self, true, false);
	TestPassed = AllWeapons.Count == 37;
	if(!TestPassed){
		Success = false;
		Log("TEST FAILED: ServerHelper.GetAllWeaponClasses - OnlyIncludeBaseWeapons - INCLUDE ChaosUT");
	} else {
		Log("TEST PASSED: ServerHelper.GetAllWeaponClasses - OnlyIncludeBaseWeapons - INCLUDE ChaosUT");
	}

	AllWeapons = class'ServerHelper'.static.GetAllWeaponClasses(self, false, false, true);
	Log("Tester1 - PreBeginPlayTests - All weapons in INT files:");
	AllWeapons.InOrderLog();

	return Success;
}

simulated function Timer(){

}

defaultproperties {
}
