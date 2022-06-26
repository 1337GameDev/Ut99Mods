//=============================================================================
// BeltItemEffect
//=============================================================================
class BeltItemEffect extends Actor;

var float UpdateIntervalSecs;

function PostBeginPlay() {
	SetTimer(UpdateIntervalSecs, True);
	//Self.SetRotation(class'');
}

simulated function Timer() {
     if((Owner == None) || Owner.bDeleteMe || (Owner.IsA('Inventory') && Inventory(Owner).bCarriedItem)) {
         Self.Destroy();
     } else {
          Self.SetLocation(Self.Owner.Location);
     }
}

defaultproperties {
      UpdateIntervalSecs=0.001000
      AnimRate=2.000000
      DrawType=DT_Mesh
      Mesh=LodMesh'UnrealShare.plasmaM'
      DrawScale=0.150000
      bUnlit=True
      bNoSmooth=True
      CollisionRadius=0.000000
      CollisionHeight=0.000000
      LightEffect=LE_FireWaver
      LightBrightness=40
      LightRadius=32
}
