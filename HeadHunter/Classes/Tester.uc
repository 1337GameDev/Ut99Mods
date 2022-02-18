class Tester extends Actor nousercreate;

var bool Initialized;
var TesterCache cache;//caches every Tester class instance or easy access

function PreBeginPlay() {
      cache = class'TesterCache'.static.GetRef(self);
      cache.AllTesters.Push(self);

      if(!Initialized) {
         Standup();
      }

      if(!Initialized) {
          Log(self.class@" - The class hasn't been initialized before running pre begin play tests.");
          return;
      }

      PreBeginPlayTests();
}
function BeginPlay(){
    if(!Initialized) {
        Log(self.class@" - The class hasn't been initialized before running begin play tests.");
        return;
    }

    BeginPlayTests();
}
function PostBeginPlay() {
    if(!Initialized) {
        Log(self.class@" - The class hasn't been initialized before running post begin play tests.");
        return;
    }

    PostBeginPlayTests();
}
function Destroyed() {
	 if(!Teardown()) {
	     Log("Teardown of Tester did not succeed.");
	 }
}






function bool Standup() {
     if(Initialized) {
         return false;
     }

     //it is up to the caller to set "Initialized" to true to indicate standup is done
     return true;
}

function bool Teardown() {
    Initialized = false;

    return true;
}

function bool PreBeginPlayTests() {
    return true;
}

function bool BeginPlayTests() {
   return true;
}

function bool PostBeginPlayTests() {
    return true;
}

defaultproperties
{
      Initialized=False
      cache=None
}
