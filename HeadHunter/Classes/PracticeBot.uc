class PracticeBot extends TMale2Bot;//MaleBotPlus

var bool ForceDefaultMovement;

function PreBeginPlay() {
	Super.PreBeginPlay();

	Enable('Tick');
}

function eAttitude AttitudeTo(Pawn Other) {
    return ATTITUDE_Ignore;
}

function bool CanFireAtEnemy() {
	return false;
}

function Tick(float DeltaTime) {
    if(ForceDefaultMovement) {
        SetDefaults();
    }
}

function SetDefaults() {
    Aggressiveness = Self.Default.Aggressiveness;
	BaseAggressiveness = Self.Default.BaseAggressiveness;
	GroundSpeed = Self.Default.GroundSpeed;
    AirSpeed = Self.Default.AirSpeed;
    AccelRate = Self.Default.AccelRate;
    AirControl = Self.Default.AirControl;
}

defaultproperties
{
      ForceDefaultMovement=True
      Aggressiveness=0.000000
      BaseAggressiveness=0.000000
      GroundSpeed=200.000000
      AirSpeed=200.000000
      AccelRate=900.000000
}
