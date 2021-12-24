class IndicatorHud extends HUDMutator nousercreate;

//represents all options of textures to use as indicators
enum HUDIndicator_Texture_BuiltIn {
    /*0*/ Empty,
    /*1*/ HudIndicator_Bolt,
    /*2*/ HudIndicator_Bomb,
    /*3*/ HudIndicator_Bullets,
    /*4*/ HudIndicator_Lever,
    /*5*/ HudIndicator_Explosion,
    /*6*/ HudIndicator_Gun,
    /*7*/ HudIndicator_Poison,
    /*8*/ HudIndicator_Rocket,
    /*9*/ HudIndicator_Watch,
    /*10*/ HudIndicator_Enforcer,
    /*11*/ HudIndicator_CircleX_Closed,
    /*12*/ HudIndicator_CircleX_Open,
    /*13*/ HudIndicator_Diamond_Closed,
    /*14*/ HudIndicator_Diamond_Open,
    /*15*/ HudIndicator_Door1,
    /*16*/ HudIndicator_Door2,
    /*17*/ HudIndicator_Dot,
    /*18*/ HudIndicator_Exclaim_Circle_Closed,
    /*19*/ HudIndicator_Exclaim_Circle_Open,
    /*20*/ HudIndicator_Exclaim_Triangle_Open,
    /*21*/ HudIndicator_Exclaim_Triangle_Closed,
    /*22*/ HudIndicator_Fire,
    /*23*/ HudIndicator_Flag,
    /*24*/ HudIndicator_Flag2,
    /*25*/ HudIndicator_Flag3,
    /*26*/ HudIndicator_Forward_Closed,
    /*27*/ HudIndicator_Forward_Open,
    /*28*/ HudIndicator_Gear,
    /*29*/ HudIndicator_Hammer,
    /*30*/ HudIndicator_Hand,
    /*31*/ HudIndicator_Home,
    /*32*/ HudIndicator_Key,
    /*33*/ HudIndicator_Lock,
    /*34*/ HudIndicator_Play,
    /*35*/ HudIndicator_Question_Open,
    /*36*/ HudIndicator_Question_Solid,
    /*37*/ HudIndicator_Reticle,
    /*38*/ HudIndicator_Shield,
    /*39*/ HudIndicator_Speech,
    /*40*/ HudIndicator_Target,
    /*41*/ HudIndicator_Water,
    /*42*/ HudIndicator_Waypoint,
    /*43*/ HudIndicator_Waypoint2,
    /*44*/ HudIndicator_Waypoint3,
    /*45*/ HudIndicator_Wrench,
    /*46*/ HudIndicator_WrenchCircle,
    /*47*/ HudIndicator_Wrenches,
    /*48*/ HudIndicator_X,
    /*49*/ HudIndicator_Knight,
    /*50*/ HudIndicator_Logo_BlueTeam,
    /*51*/ HudIndicator_Logo_GreenTeam,
    /*52*/ HudIndicator_Logo_NoTeam,
    /*53*/ HudIndicator_Logo_RedTeam,
    /*54*/ HudIndicator_Logo_YellowTeam,
    /*55*/ HudIndicator_Logo_UT,

    /*56*/ HudElement_Ring,
    /*57*/ HudElement_Ring_B,
    /*58*/ HudIndicator_DownArrow_Open,
    /*59*/ HudIndicator_DownArrow_Solid,
    /*60*/ HudIndicator_DownClassicArrow_Solid,
    /*61*/ HudIndicator_DownTab_Closed,
    /*62*/ HudIndicator_DownTab_Open,
    /*63*/ HudIndicator_DownTriangle_Open,
    /*64*/ HudIndicator_DownTriangle_Solid,
    /*65*/ HudIndicator_DownWedge,
    /*66*/ HudIndicator_Nav_Closed,
    /*67*/ HudIndicator_Nav_Open,
    /*68*/ HudIndicator_SelectionBox,
    /*69*/ HudIndicator_SelectionBox2,
    /*70*/ HudIndicator_Square_Open,

    //extra icons added later
    /*71*/ HudIndicator_SkullAndBones,
    /*72*/ HudIndicator_Bones,
    /*73*/ HudIndicator_Skull
};

//Indicators
#exec texture IMPORT NAME=HudElement_Ring FILE=Textures\Indicators\HudIndicator_Ring.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudElement_Ring_B FILE=Textures\Indicators\HudIndicator_Ring_B.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownArrow_Open FILE=Textures\Indicators\HudIndicator_DownArrow_Open.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownArrow_Solid FILE=Textures\Indicators\HudIndicator_DownArrow_Solid.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownClassicArrow_Solid FILE=Textures\Indicators\HudIndicator_DownClassicArrow_Solid.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTab_Closed FILE=Textures\Indicators\HudIndicator_DownTab_Closed.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTab_Open FILE=Textures\Indicators\HudIndicator_DownTab_Open.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTriangle_Open FILE=Textures\Indicators\HudIndicator_DownTriangle_Open.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTriangle_Solid FILE=Textures\Indicators\HudIndicator_DownTriangle_Solid.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownWedge FILE=Textures\Indicators\HudIndicator_DownWedge.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Nav_Closed FILE=Textures\Indicators\HudIndicator_Nav_Closed.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Nav_Open FILE=Textures\Indicators\HudIndicator_Nav_Open.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_SelectionBox FILE=Textures\Indicators\HudIndicator_SelectionBox.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_SelectionBox2 FILE=Textures\Indicators\HudIndicator_SelectionBox2.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Square_Open FILE=Textures\Indicators\HudIndicator_Square_Open.bmp FLAGS=2 MIPS=OFF
//Indicator Rotations
#exec texture IMPORT NAME=HudIndicator_DownArrow_Open_U FILE=Textures\Indicators\Rotations\HudIndicator_DownArrow_Open_U.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownArrow_Open_UL FILE=Textures\Indicators\Rotations\HudIndicator_DownArrow_Open_UL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownArrow_Open_UR FILE=Textures\Indicators\Rotations\HudIndicator_DownArrow_Open_UR.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownArrow_Open_L FILE=Textures\Indicators\Rotations\HudIndicator_DownArrow_Open_L.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownArrow_Open_R FILE=Textures\Indicators\Rotations\HudIndicator_DownArrow_Open_R.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownArrow_Open_BL FILE=Textures\Indicators\Rotations\HudIndicator_DownArrow_Open_BL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownArrow_Open_BR FILE=Textures\Indicators\Rotations\HudIndicator_DownArrow_Open_BR.bmp FLAGS=2 MIPS=OFF

#exec texture IMPORT NAME=HudIndicator_DownArrow_Solid_U FILE=Textures\Indicators\Rotations\HudIndicator_DownArrow_Solid_U.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownArrow_Solid_UL FILE=Textures\Indicators\Rotations\HudIndicator_DownArrow_Solid_UL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownArrow_Solid_UR FILE=Textures\Indicators\Rotations\HudIndicator_DownArrow_Solid_UR.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownArrow_Solid_L FILE=Textures\Indicators\Rotations\HudIndicator_DownArrow_Solid_L.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownArrow_Solid_R FILE=Textures\Indicators\Rotations\HudIndicator_DownArrow_Solid_R.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownArrow_Solid_BL FILE=Textures\Indicators\Rotations\HudIndicator_DownArrow_Solid_BL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownArrow_Solid_BR FILE=Textures\Indicators\Rotations\HudIndicator_DownArrow_Solid_BR.bmp FLAGS=2 MIPS=OFF

#exec texture IMPORT NAME=HudIndicator_DownClassicArrow_Solid_U FILE=Textures\Indicators\Rotations\HudIndicator_DownClassicArrow_Solid_U.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownClassicArrow_Solid_UL FILE=Textures\Indicators\Rotations\HudIndicator_DownClassicArrow_Solid_UL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownClassicArrow_Solid_UR FILE=Textures\Indicators\Rotations\HudIndicator_DownClassicArrow_Solid_UR.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownClassicArrow_Solid_L FILE=Textures\Indicators\Rotations\HudIndicator_DownClassicArrow_Solid_L.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownClassicArrow_Solid_R FILE=Textures\Indicators\Rotations\HudIndicator_DownClassicArrow_Solid_R.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownClassicArrow_Solid_BL FILE=Textures\Indicators\Rotations\HudIndicator_DownClassicArrow_Solid_BL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownClassicArrow_Solid_BR FILE=Textures\Indicators\Rotations\HudIndicator_DownClassicArrow_Solid_BR.bmp FLAGS=2 MIPS=OFF

#exec texture IMPORT NAME=HudIndicator_DownTab_Closed_U FILE=Textures\Indicators\Rotations\HudIndicator_DownTab_Closed_U.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTab_Closed_UL FILE=Textures\Indicators\Rotations\HudIndicator_DownTab_Closed_UL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTab_Closed_UR FILE=Textures\Indicators\Rotations\HudIndicator_DownTab_Closed_UR.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTab_Closed_L FILE=Textures\Indicators\Rotations\HudIndicator_DownTab_Closed_L.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTab_Closed_R FILE=Textures\Indicators\Rotations\HudIndicator_DownTab_Closed_R.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTab_Closed_BL FILE=Textures\Indicators\Rotations\HudIndicator_DownTab_Closed_BL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTab_Closed_BR FILE=Textures\Indicators\Rotations\HudIndicator_DownTab_Closed_BR.bmp FLAGS=2 MIPS=OFF

#exec texture IMPORT NAME=HudIndicator_DownTab_Open_U FILE=Textures\Indicators\Rotations\HudIndicator_DownTab_Open_U.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTab_Open_UL FILE=Textures\Indicators\Rotations\HudIndicator_DownTab_Open_UL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTab_Open_UR FILE=Textures\Indicators\Rotations\HudIndicator_DownTab_Open_UR.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTab_Open_L FILE=Textures\Indicators\Rotations\HudIndicator_DownTab_Open_L.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTab_Open_R FILE=Textures\Indicators\Rotations\HudIndicator_DownTab_Open_R.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTab_Open_BL FILE=Textures\Indicators\Rotations\HudIndicator_DownTab_Open_BL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTab_Open_BR FILE=Textures\Indicators\Rotations\HudIndicator_DownTab_Open_BR.bmp FLAGS=2 MIPS=OFF

#exec texture IMPORT NAME=HudIndicator_DownTriangle_Open_U FILE=Textures\Indicators\Rotations\HudIndicator_DownTriangle_Open_U.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTriangle_Open_UL FILE=Textures\Indicators\Rotations\HudIndicator_DownTriangle_Open_UL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTriangle_Open_UR FILE=Textures\Indicators\Rotations\HudIndicator_DownTriangle_Open_UR.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTriangle_Open_L FILE=Textures\Indicators\Rotations\HudIndicator_DownTriangle_Open_L.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTriangle_Open_R FILE=Textures\Indicators\Rotations\HudIndicator_DownTriangle_Open_R.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTriangle_Open_BL FILE=Textures\Indicators\Rotations\HudIndicator_DownTriangle_Open_BL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTriangle_Open_BR FILE=Textures\Indicators\Rotations\HudIndicator_DownTriangle_Open_BR.bmp FLAGS=2 MIPS=OFF

#exec texture IMPORT NAME=HudIndicator_DownTriangle_Solid_U FILE=Textures\Indicators\Rotations\HudIndicator_DownTriangle_Solid_U.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTriangle_Solid_UL FILE=Textures\Indicators\Rotations\HudIndicator_DownTriangle_Solid_UL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTriangle_Solid_UR FILE=Textures\Indicators\Rotations\HudIndicator_DownTriangle_Solid_UR.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTriangle_Solid_L FILE=Textures\Indicators\Rotations\HudIndicator_DownTriangle_Solid_L.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTriangle_Solid_R FILE=Textures\Indicators\Rotations\HudIndicator_DownTriangle_Solid_R.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTriangle_Solid_BL FILE=Textures\Indicators\Rotations\HudIndicator_DownTriangle_Solid_BL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownTriangle_Solid_BR FILE=Textures\Indicators\Rotations\HudIndicator_DownTriangle_Solid_BR.bmp FLAGS=2 MIPS=OFF

#exec texture IMPORT NAME=HudIndicator_DownWedge_U FILE=Textures\Indicators\Rotations\HudIndicator_DownWedge_U.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownWedge_UL FILE=Textures\Indicators\Rotations\HudIndicator_DownWedge_UL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownWedge_UR FILE=Textures\Indicators\Rotations\HudIndicator_DownWedge_UR.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownWedge_L FILE=Textures\Indicators\Rotations\HudIndicator_DownWedge_L.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownWedge_R FILE=Textures\Indicators\Rotations\HudIndicator_DownWedge_R.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownWedge_BL FILE=Textures\Indicators\Rotations\HudIndicator_DownWedge_BL.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_DownWedge_BR FILE=Textures\Indicators\Rotations\HudIndicator_DownWedge_BR.bmp FLAGS=2 MIPS=OFF

//Icons
#exec texture IMPORT NAME=HudIndicator_Bolt FILE=Textures\Icons\HudIndicator_Bolt.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Bomb FILE=Textures\Icons\HudIndicator_Bomb.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Bullets FILE=Textures\Icons\HudIndicator_Bullets.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Lever FILE=Textures\Icons\HudIndicator_Lever.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Explosion FILE=Textures\Icons\HudIndicator_Explosion.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Gun FILE=Textures\Icons\HudIndicator_Gun.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Poison FILE=Textures\Icons\HudIndicator_Poison.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Rocket FILE=Textures\Icons\HudIndicator_Rocket.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Watch FILE=Textures\Icons\HudIndicator_Watch.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Enforcer FILE=Textures\Icons\HudIndicator_Enforcer.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_CircleX_Closed FILE=Textures\Icons\HudIndicator_CircleX_Closed.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_CircleX_Open FILE=Textures\Icons\HudIndicator_CircleX_Open.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Diamond_Closed FILE=Textures\Icons\HudIndicator_Diamond_Closed.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Diamond_Open FILE=Textures\Icons\HudIndicator_Diamond_Open.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Door1 FILE=Textures\Icons\HudIndicator_Door1.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Door2 FILE=Textures\Icons\HudIndicator_Door2.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Dot FILE=Textures\Icons\HudIndicator_Dot.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Exclaim_Circle_Closed FILE=Textures\Icons\HudIndicator_Exclaim_Circle_Closed.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Exclaim_Circle_Open FILE=Textures\Icons\HudIndicator_Exclaim_Circle_Open.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Exclaim_Triangle_Open FILE=Textures\Icons\HudIndicator_Exclaim_Triangle_Open.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Exclaim_Triangle_Closed FILE=Textures\Icons\HudIndicator_Exclaim_Triangle_Closed.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Fire FILE=Textures\Icons\HudIndicator_Fire.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Flag FILE=Textures\Icons\HudIndicator_Flag.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Flag2 FILE=Textures\Icons\HudIndicator_Flag2.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Flag3 FILE=Textures\Icons\HudIndicator_Flag3.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Forward_Closed FILE=Textures\Icons\HudIndicator_Forward_Closed.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Forward_Open FILE=Textures\Icons\HudIndicator_Forward_Open.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Gear FILE=Textures\Icons\HudIndicator_Gear.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Hammer FILE=Textures\Icons\HudIndicator_Hammer.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Hand FILE=Textures\Icons\HudIndicator_Hand.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Home FILE=Textures\Icons\HudIndicator_Home.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Key FILE=Textures\Icons\HudIndicator_Key.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Lock FILE=Textures\Icons\HudIndicator_Lock.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Play FILE=Textures\Icons\HudIndicator_Play.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Question_Open FILE=Textures\Icons\HudIndicator_Question_Open.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Question_Solid FILE=Textures\Icons\HudIndicator_Question_Solid.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Reticle FILE=Textures\Icons\HudIndicator_Reticle.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Shield FILE=Textures\Icons\HudIndicator_Shield.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Speech FILE=Textures\Icons\HudIndicator_Speech.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Target FILE=Textures\Icons\HudIndicator_Target.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Water FILE=Textures\Icons\HudIndicator_Water.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Waypoint FILE=Textures\Icons\HudIndicator_Waypoint.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Waypoint2 FILE=Textures\Icons\HudIndicator_Waypoint2.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Waypoint3 FILE=Textures\Icons\HudIndicator_Waypoint3.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Wrench FILE=Textures\Icons\HudIndicator_Wrench.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_WrenchCircle FILE=Textures\Icons\HudIndicator_WrenchCircle.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Wrenches FILE=Textures\Icons\HudIndicator_Wrenches.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_X FILE=Textures\Icons\HudIndicator_X.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Knight FILE=Textures\Icons\HudIndicator_Knight.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Logo_UT FILE=Textures\Icons\HudIndicator_Logo_UT.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Logo_BlueTeam FILE=Textures\Icons\HudIndicator_Logo_BlueTeam.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Logo_GreenTeam FILE=Textures\Icons\HudIndicator_Logo_GreenTeam.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Logo_NoTeam FILE=Textures\Icons\HudIndicator_Logo_NoTeam.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Logo_RedTeam FILE=Textures\Icons\HudIndicator_Logo_RedTeam.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Logo_YellowTeam FILE=Textures\Icons\HudIndicator_Logo_YellowTeam.bmp FLAGS=2 MIPS=OFF

#exec texture IMPORT NAME=HudIndicator_SkullAndBones FILE=Textures\Icons\HudIndicator_SkullAndBones.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Bones FILE=Textures\Icons\HudIndicator_Bones.bmp FLAGS=2 MIPS=OFF
#exec texture IMPORT NAME=HudIndicator_Skull FILE=Textures\Icons\HudIndicator_Skull.bmp FLAGS=2 MIPS=OFF


var LinkedList PlayerIndicatorTargets;
var IndicatorHudGlobalTargets GlobalIndicatorTargets;

var float StaticIndicatorPercentOfMinScreenDimension;//if 'ScaleIndicatorSizeToTarget' is false, then use the static size value, which is a % of the screen width / height (whichever is smallest)

//this is purely for displaying when the target is behind the player, regardless of 'ScaleIndicatorSizeToTarget'
var float StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen;

var bool ScaleIndicatorSizeToTarget;
var() bool UseHudColorForIndicators;
var bool UseTextOnlyIndicators;
var bool ShowTargetDistanceLabels;
var bool ShowIndicatorWhenOffScreen;
var bool ShowIndicatorIfTargetHidden;
var bool ShowIndicatorIfInventoryHeld;
var bool ShowIndicatorIfInventoryNotHeld;
var bool ShowIndicatorIfInventoryDropped;

var bool ShowIndicatorsThatAreObscured;

var FontInfo MyFonts;

var float MaxTargetIndicatorViewDistance;

var int IndicatorLabelMargin;
var bool IndicatorLabelsAboveIndicator;
var Vector IndicatorOffsetFromTarget;
var() color IndicatorColor;
var() string IndicatorLabel;
var() bool ShowIndicatorLabel;
var bool UseTargetNameForLabel;

var bool ShowIndicatorAboveTarget;

var() texture IndicatorTexture;//the normal indicator texture when the target is in view
//textures for different conditions of the target in relation to the player
var texture BehindViewTexture;//when it is within the "screen" as the target is behind he player

var bool UseTriangleQuadrantsForOffScreen;
var texture OffTopLeftViewTexture;
var texture OffLeftViewTexture;
var texture OffBottomLeftViewTexture;
var texture OffBottomViewTexture;
var texture OffBottomRightViewTexture;
var texture OffRightViewTexture;
var texture OffTopRightViewTexture;
var texture OffTopViewTexture;

//data used for blinking all indicators (as each indicator doesn't have their own data to keep track of their blinking state)
var() bool BlinkIndicator;
var() float BaseAlphaValue;
var() float CurrentBlinkTime;
var() bool BlinkingIsFadingIn;//whether the indicator is fading in / fading out (CurrentBlinkTime going up, or going down)
var() float BlinkRate;//# of times to blink per second
var() float LastDeltaTime;//the last saved deltatime to ensure we blink indicators using the last frame's timing
var float BlinkAlphaValue;//the current alpha value to blend with the indicator color

//value conversion functions
static function byte GetBuiltinTextureByte(HUDIndicator_Texture_BuiltIn tex){
    local byte output;
    output = tex;

    return output;
}

function PreBeginPlay() {
    local Mutator markerMut;
    if(bLogToGameLogfile) {
        Log("IndicatorHud: PreBeginPlay");
    }

    MyFonts = class'MyFontsSingleton'.static.GetRef(self);

    markerMut = class'MutatorHelper'.static.GetGameMutatorByClass(self, class'DroppedInventoryMarkerMutator');
    if(markerMut == None){
        class'DroppedInventoryMarkerMutator'.static.RegisterMutator(self);
    }
}

simulated function PostRender(Canvas C) {
    Super.PostRender(C);

    if(PlayerOwner == ChallengeHUD(PlayerOwner.myHUD).PawnOwner) {
        //verify target lists here, and remove any that have been destroyed
        VerifyTargets();

        //validate parameters set for indicator fields/properties, and return if they are invalid
        //return here if invalid properties set
        if(IndicatorTexture == None) {
            //invalid
            IndicatorTexture = self.default.IndicatorTexture;
        }

        //set any values that should only update ONCE per render of indicators
        //set the blink time - otherwise it is set once per indicator
        if(BlinkingIsFadingIn) {
            CurrentBlinkTime += LastDeltaTime;
            if(CurrentBlinkTime >= BlinkRate) {
                 BlinkingIsFadingIn = !BlinkingIsFadingIn;
                 CurrentBlinkTime = BlinkRate;
             }
        } else {
            CurrentBlinkTime -= LastDeltaTime;
            if(CurrentBlinkTime <= 0) {
                 BlinkingIsFadingIn = !BlinkingIsFadingIn;
                 CurrentBlinkTime = 0;
             }
        }

        BlinkAlphaValue = (CurrentBlinkTime / BlinkRate);

        //draw the player specific indicators
        DrawIndicatorLocations(C, PlayerOwner, self.PlayerIndicatorTargets);

        //draw the global target indicators
        if(GlobalIndicatorTargets == None){
           GlobalIndicatorTargets = class'IndicatorHudGlobalTargets'.static.GetRef(self);
        }

        //Log("IndicatorHud - PostRender - draw global indicators with length ["$self.GlobalIndicatorTargets.GlobalIndicatorTargets.Count$"]");
        DrawIndicatorLocations(C, PlayerOwner, self.GlobalIndicatorTargets.GlobalIndicatorTargets);
    } else if(PlayerOwner == None){
          Destroy();
    }
}

simulated final function AddBasicTarget(Actor target, optional bool globalTarget){
    local IndicatorHudGlobalTargets globalTargets;

    if(target == None){
        return;
    }

    if(PlayerIndicatorTargets == None){
       PlayerIndicatorTargets = new class'LinkedList';
    }

    if(globalTarget) {
        globalTargets = class'IndicatorHudGlobalTargets'.static.GetRef(self);

        globalTargets.GlobalIndicatorTargets.Enqueue(target);
        class'IndicatorHudGlobalTargets'.static.SetRef(globalTargets);
    } else {
        PlayerIndicatorTargets.Enqueue(target);
    }
}

simulated final function AddAdvancedTarget(IndicatorHudTargetListElement element, bool globalTarget){
    local IndicatorHudGlobalTargets globalTargets;

    if((element == None) || (Actor(element.Value) == None)) {
        return;
    }

    if(PlayerIndicatorTargets == None){
       PlayerIndicatorTargets = new class'LinkedList';
    }

    if(globalTarget) {
        globalTargets = class'IndicatorHudGlobalTargets'.static.GetRef(self);

        globalTargets.GlobalIndicatorTargets.Enqueue(element);
        class'IndicatorHudGlobalTargets'.static.SetRef(globalTargets);
    } else {
        PlayerIndicatorTargets.Enqueue(element);
    }
}

simulated final function RemoveTarget(Actor targetToRemove) {
   local ListElement element, nextElement;
   local Actor listTarget;

   if(targetToRemove == None){
       return;
   }

   if((PlayerIndicatorTargets != None) && (PlayerIndicatorTargets.Count > 0)){
      element = PlayerIndicatorTargets.Head;

      While(element != None) {
          listTarget = Actor(Element.Value);

          if(listTarget == targetToRemove) {
             nextElement = element.Next;
             element.RemoveFromList();
             element = nextElement;
          } else {
             element = element.Next;
          }
      }
   }

   if((GlobalIndicatorTargets != None) && (GlobalIndicatorTargets.GlobalIndicatorTargets != None) && GlobalIndicatorTargets.GlobalIndicatorTargets.Count > 0){
      element = GlobalIndicatorTargets.GlobalIndicatorTargets.Head;

      While(element != None) {
          listTarget = Actor(Element.Value);

          if(listTarget == targetToRemove) {
               nextElement = element.Next;
               element.RemoveFromList();
               element = nextElement;
          } else {
             element = element.Next;
          }
      }
   }
}

function ResetAllTargets() {
    local int countRemoved;

    if((PlayerIndicatorTargets != None) && (PlayerIndicatorTargets.Count > 0)){
        countRemoved = PlayerIndicatorTargets.RemoveAll();
    }

    if((GlobalIndicatorTargets != None) && (GlobalIndicatorTargets.GlobalIndicatorTargets != None) && GlobalIndicatorTargets.GlobalIndicatorTargets.Count > 0){
        countRemoved = GlobalIndicatorTargets.GlobalIndicatorTargets.RemoveAll();;
    }
}

//=============================================================================
// DrawIndicatorLocations.
//
// The main function for drawing a list of targets' indictaors.
//=============================================================================
simulated final function DrawIndicatorLocations(Canvas C, PlayerPawn Player, LinkedList Targets) {
      local bool ShowIndicator;
      local ChallengeHUD PlayerHUD;
      local texture IndicatorTextureToDisplay;
      local int targetScreenXPos, targetScreenYPos, drawAtScreenX, drawAtScreenY, screenMiddleX, screenMiddleY, screenSmallestDimension, screenLargestDimension;

      local float FinalIndicatorScale, PlayerHUDScale, IndicatorWidth, IndicatorHeight;
      local float CurrentTargetDistance;

      local ListElement element;
      local IndicatorHudTargetListElement IndicatorListElement;
      local IndicatorSettings indicatorSettings;

      local Actor target;
      local Inventory targetAsInv;
      local Vector targetPos, targetBottomPos, targetTopPos;
      local Color ColorForIndicator;

      local vector CamLoc, camX, camY, camZ;
      local rotator CamRot;
      local Actor Camera;

      //ints to use at 'out' parameters to a function
      local int offLeft_int, offRight_int, offTop_int, offBottom_int;
      local bool offLeft;
      local bool offRight;
      local bool offTop;
      local bool offBottom;
      local bool targetIsBehind;
      local bool isOffScreen;

      local int topTri_int, bottomTri_int, leftTri_int, rightTri_int;
      local bool isInAnyTri;
      local bool isInTopTri;
      local bool isInBottomTri;
      local bool isInLeftTri;
      local bool isInRightTri;

      local float IndicatorLabelXPos, IndicatorLabelYPos, IndicatorLabelSizeX, IndicatorLabelSizeY;

      local string textIndicator;

      local float targetHudSize;//the original hud size, as well as the intended hud size for an indicator

      local float IndicatorXLimitMargin;//the margin on the right hand side of the screen, to limit the indicator to not go past
      local float IndicatorYLimitMargin;//the margin on the bottom part side of the screen, to limit the indicator to not go past

      local float DistanceAsMeters, DistanceLabelXPos, DistanceLabelYPos, DistLabelSizeX, DistLabelSizeY;

      local string DistLabelText;

      local Vector OffsetFromIndicatorPos;//offset used for placing other UI elements based on the indicator position

      if((Player != None) && (Targets != None) && (Targets.Count > 0)){
          element = Targets.Head;

          PlayerHUD = ChallengeHUD(Player.myHUD);
          C.ViewPort.Actor.PlayerCalcView(Camera, CamLoc, CamRot);
          GetAxes(CamRot, camX, camY, camZ);

          PlayerHUDScale = PlayerHUD.Scale;
          IndicatorLabelMargin *= PlayerHUDScale;
          screenMiddleX = C.ClipX / 2.0;
          screenMiddleY = C.ClipY / 2.0;
          screenSmallestDimension = Min(C.ClipX, C.ClipY);
          screenLargestDimension =  Max(C.ClipX, C.ClipY);

          While(element!=None && element.Value != None) {
              ShowIndicator = true;
              targetBottomPos = Vect(0,0,0);
              targetTopPos = Vect(0,0,0);
              target = Actor(element.Value);

              BehindViewTexture = default.BehindViewTexture;
              OffTopLeftViewTexture = default.OffTopLeftViewTexture;
              OffLeftViewTexture = default.OffLeftViewTexture;
              OffBottomLeftViewTexture = default.OffBottomLeftViewTexture;
              OffBottomViewTexture = default.OffBottomViewTexture;
              OffBottomRightViewTexture = default.OffBottomRightViewTexture;
              OffRightViewTexture = default.OffRightViewTexture;
              OffTopRightViewTexture = default.OffTopRightViewTexture;
              OffTopViewTexture = default.OffTopViewTexture;
              IndicatorTexture = default.IndicatorTexture;
              MaxTargetIndicatorViewDistance = default.MaxTargetIndicatorViewDistance;
              ColorForIndicator = default.IndicatorColor;
              IndicatorLabel = default.IndicatorLabel;
              ShowIndicatorLabel = default.ShowIndicatorLabel;
              UseTargetNameForLabel = default.UseTargetNameForLabel;
              ShowTargetDistanceLabels = default.ShowTargetDistanceLabels;
              ShowIndicatorAboveTarget = default.ShowIndicatorAboveTarget;
              ScaleIndicatorSizeToTarget = default.ScaleIndicatorSizeToTarget;
              StaticIndicatorPercentOfMinScreenDimension = default.StaticIndicatorPercentOfMinScreenDimension;
              StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen = default.StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen;
              IndicatorOffsetFromTarget = default.IndicatorOffsetFromTarget;
              ShowIndicatorWhenOffScreen = default.ShowIndicatorWhenOffScreen;
              ShowIndicatorIfTargetHidden = default.ShowIndicatorIfTargetHidden;
              ShowIndicatorsThatAreObscured = default.ShowIndicatorsThatAreObscured;
              ShowIndicatorIfInventoryHeld = default.ShowIndicatorIfInventoryHeld;
              ShowIndicatorIfInventoryNotHeld = default.ShowIndicatorIfInventoryNotHeld;
              ShowIndicatorIfInventoryDropped = default.ShowIndicatorIfInventoryDropped;
              BlinkIndicator = default.BlinkIndicator;
              BaseAlphaValue = default.BaseAlphaValue;

              IndicatorListElement = IndicatorHudTargetListElement(element);

              if(IndicatorListElement != None) {
                  //we need to apply the modifier function, and then fetch the settings
                  IndicatorListElement.ApplyModifierFunction(self);

                  indicatorSettings = IndicatorListElement.IndicatorSettings;
                  ShowIndicator = !indicatorSettings.DisableIndicator;

                  if(bLogToGameLogfile){
                      Log("IndicatorHud ----------------------- target is:"@target.Name);
                  }

                  if(ShowIndicator){
					  MaxTargetIndicatorViewDistance = indicatorSettings.MaxViewDistance;
					  ShowTargetDistanceLabels = indicatorSettings.ShowTargetDistanceLabels;
					  IndicatorLabel = indicatorSettings.IndicatorLabel;
					  ShowIndicatorLabel = indicatorSettings.ShowIndicatorLabel;
					  UseTargetNameForLabel = indicatorSettings.UseTargetNameForLabel;
					  ScaleIndicatorSizeToTarget = indicatorSettings.ScaleIndicatorSizeToTarget;
					  StaticIndicatorPercentOfMinScreenDimension = indicatorSettings.StaticIndicatorPercentOfMinScreenDimension;
					  StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen = indicatorSettings.StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen;
                      ShowIndicatorWhenOffScreen = indicatorSettings.ShowIndicatorWhenOffScreen;
					  ShowIndicatorIfTargetHidden = indicatorSettings.ShowIndicatorIfTargetHidden;
					  ShowIndicatorIfInventoryHeld = indicatorSettings.ShowIndicatorIfInventoryHeld;
					  ShowIndicatorIfInventoryNotHeld = indicatorSettings.ShowIndicatorIfInventoryNotHeld;
					  ShowIndicatorIfInventoryDropped = indicatorSettings.ShowIndicatorIfInventoryDropped;

                      ShowIndicatorsThatAreObscured = indicatorSettings.ShowIndicatorsThatAreObscured;
					  ShowIndicatorAboveTarget = indicatorSettings.ShowIndicatorAboveTarget;
					  IndicatorLabelsAboveIndicator = indicatorSettings.IndicatorLabelsAboveIndicator;
					  BlinkIndicator = indicatorSettings.BlinkIndicator;
					  BaseAlphaValue = indicatorSettings.BaseAlphaValue;

					  //if we havent provided our own texture variations, AND the built-in texture isn't empty
					  //then load the default texture variations
                      if((indicatorSettings.TextureVariations == None) && (indicatorSettings.BuiltinIndicatorTexture != HUDIndicator_Texture_BuiltIn.Empty)) {
						 if(bLogToGameLogfile) {
						     Log("IndicatorHud - Show indicator - setting texture variations - setting defaults for target:"$target.Name);
						 }
						 indicatorSettings.TextureVariations = GetTexturesForBuiltInOption(indicatorSettings.BuiltinIndicatorTexture);
					  }

					  if(indicatorSettings.TextureVariations != None) {//if texture variations were provided / found (either by default, or we provided none)
						  indicatorSettings.TextureVariations.SetTextures(
							  OffTopLeftViewTexture,
							  OffLeftViewTexture,
							  OffBottomLeftViewTexture,
							  OffBottomViewTexture,
							  OffBottomRightViewTexture,
							  OffRightViewTexture,
							  OffTopRightViewTexture,
							  OffTopViewTexture,
							  BehindViewTexture,
							  IndicatorTexture,
							  ShowIndicatorWhenOffScreen
						  );

						  if(indicatorSettings.TextureVariations != None){
						       if(bLogToGameLogfile){
						           Log("IndicatorHud - tex variations not empty");
                               }

					           if(indicatorSettings.TextureVariations.InViewTex != None){
					                if(bLogToGameLogfile){
                                        Log("IndicatorHud - indicatorSettings.TextureVariations.InViewTex:"$indicatorSettings.TextureVariations.InViewTex.Name);
                                        Log("IndicatorHud - IndicatorTexture:"$IndicatorTexture.Name);
                                    }
						       } else {
						            if(bLogToGameLogfile){
						                Log("IndicatorHud - indicatorSettings.TextureVariations.InViewTex is NONE");
						            }
						       }

						       if(indicatorSettings.TextureVariations.BehindViewTex != None){
						            if(bLogToGameLogfile){
                                        Log("IndicatorHud - indicatorSettings.TextureVariations.BehindViewTex:"$indicatorSettings.TextureVariations.BehindViewTex.Name);
                                        Log("IndicatorHud - BehindViewTexture:"$BehindViewTexture.Name);
						            }
                               } else {
                                    if(bLogToGameLogfile){
						                Log("IndicatorHud - indicatorSettings.TextureVariations.BehindViewTex is NONE");
						            }
                               }
						  }
					  }

					  if(indicatorSettings.UseCustomColor) {
						  ColorForIndicator = indicatorSettings.IndicatorColor;
					  } else if(indicatorSettings.UseHUDColorForIndicator) {
						  ColorForIndicator = PlayerHUD.HUDColor;
					  } else {
						  ColorForIndicator = IndicatorColor;
					  }
                  } else {
                      if(bLogToGameLogfile){
                          Log("IndicatorHud - skipping target as indicator hud isn't to be shown from settings");
                      }

                      //the target is obscured by world geometry, so ignore this target
                      element = element.Next;
                      continue;
                  }
              } else {//use standard logic, as dictated by this mutator
                if(UseHudColorForIndicators) {
                    ColorForIndicator = PlayerHUD.HUDColor;
                } else {
                    ColorForIndicator = IndicatorColor;
                }
              }

              if(bLogToGameLogfile){
                  Log("IndicatorHud - target is: "@target.Name);
                  Log("IndicatorHud - Show indicator? "$ShowIndicator);
              }

              ShowIndicator = ShowIndicator && (ShowIndicatorsThatAreObscured || FastTrace(PlayerOwner.Location, target.Location));
              ShowIndicator = ShowIndicator && (ShowIndicatorIfTargetHidden || !target.bHidden);

              if(target.IsA('Inventory')){
                  targetAsInv = Inventory(target);

                  //should we show this weapon when it's held?
                  ShowIndicator = ShowIndicator && (ShowIndicatorIfInventoryHeld || !targetAsInv.bHeldItem);

                  //should we show this weapon when it's not held (and not dropped -- eg: spawned but not picked up yet)?
                  ShowIndicator = ShowIndicator && (ShowIndicatorIfInventoryNotHeld || targetAsInv.bHeldItem);

                  //should we show this weapon if dropped?
                  ShowIndicator = ShowIndicator && (ShowIndicatorIfInventoryDropped || class'InventoryHelper'.static.IsInventoryDropped(targetAsInv));
              }

              if(!ShowIndicator){
                  if(bLogToGameLogfile){
                      Log("IndicatorHud - skipping target as indicator hud isn't to be shown");
                  }
                  //the target is obscured by world geometry, so ignore this target
                  element = element.Next;
                  continue;
              }

              IndicatorTextureToDisplay = IndicatorTexture;
              C.DrawColor = ColorForIndicator;

              if(UseTargetNameForLabel) {
                  IndicatorLabel = string(target.Name);
              }

              ShowIndicatorLabel = ShowIndicatorLabel && (Len(IndicatorLabel) > 0);

              //conditionally set the position if we wnat the indictaor above
              if(ShowIndicatorAboveTarget) {
			      class'HUDHelper'.static.getActorSizeOnHudFromColliderWithPoints(C, target, targetTopPos, targetBottomPos);
                  targetPos = targetTopPos;
              } else {
			      targetPos = target.Location;
			  }

			  targetPos += IndicatorOffsetFromTarget;

              CurrentTargetDistance = VSize(targetPos - CamLoc);

              if(((MaxTargetIndicatorViewDistance > 0) && (CurrentTargetDistance > MaxTargetIndicatorViewDistance)) || (PlayerOwner == target)) {
                  element = element.Next;

                  if(bLogToGameLogfile){
                      Log("IndicatorHud - skipping target due to distance");
                  }

                  continue;
              }

              class'HUDHelper'.static.getXY(C, targetPos, targetScreenXPos, targetScreenYPos);

              C.Font = MyFonts.GetMediumFont(C.ClipX);

              if((C.Font == None) && (C.LargeFont != None)){
                  C.Font = C.LargeFont;
              }

              if(ShowTargetDistanceLabels){
                  DistanceAsMeters = class'MathHelper'.static.UUtoMeters(CurrentTargetDistance);

                  if(DistanceAsMeters > 1000){
                      DistLabelText = (DistanceAsMeters / 1000.0)$"Km";
                  } else {
                      DistLabelText = DistanceAsMeters$"m";
                  }

                  C.SetPos(0, 0);
                  C.TextSize(DistLabelText, DistLabelSizeX, DistLabelSizeY);
              }

              if(ShowIndicatorLabel){
                  C.SetPos(0, 0);
                  C.TextSize(IndicatorLabel, IndicatorLabelSizeX, IndicatorLabelSizeY);
              }

              targetIsBehind = class'VectorHelper'.static.isBehind(CamLoc, camX, targetPos);

              isOffScreen = class'HUDHelper'.static.IsOffScreen(C, targetScreenXPos, targetScreenYPos, offLeft_int, offRight_int, offTop_int, offBottom_int, 15);

              ShowIndicator = (!isOffScreen && !targetIsBehind) || ShowIndicatorWhenOffScreen;

              if(bLogToGameLogfile){
                  Log("IndicatorHud - target indicator ShowIndicator:"@ShowIndicator);
                  Log("IndicatorHud - target indicator isOffScreen:"@isOffScreen@" - targetIsBehind:"@targetIsBehind@" - ShowIndicatorWhenOffScreen:"@ShowIndicatorWhenOffScreen);
                  Log("IndicatorHud - indicator off screen vars: offLeft_int-"$offLeft_int$" - offRight_int-"$offRight_int$" - offTop_int-"$offTop_int$" - offBottom_int-"$offBottom_int);

                  if(BehindViewTexture != None){
                      Log("IndicatorHud - BehindViewTexture:"$BehindViewTexture);
                  } else {
                      Log("IndicatorHud - BehindViewTexture: None");
                  }
              }

              offLeft = offLeft_int == 1;
              offRight = offRight_int == 1;
              offTop = offTop_int == 1;
              offBottom = offBottom_int == 1;

              if(UseTriangleQuadrantsForOffScreen) {
                isInAnyTri = class'HUDHelper'.static.GetScreenTrianglesPointIsIn(C, targetScreenXPos, targetScreenYPos, topTri_int, bottomTri_int, leftTri_int, rightTri_int);
                isInTopTri = topTri_int == 1;
                isInBottomTri = bottomTri_int == 1;
                isInLeftTri = leftTri_int == 1;
                isInRightTri = rightTri_int == 1;

                if(isOffScreen && ShowIndicator) {
                    if(isInTopTri || offTop){
                        if(UseTextOnlyIndicators) {
                            textIndicator = "^^^";
                        } else if(OffBottomLeftViewTexture != None) {
                            IndicatorTextureToDisplay = OffTopViewTexture;
                        }
                    } else if(isInBottomTri || offBottom){
                        if(UseTextOnlyIndicators) {
                            textIndicator = "\\//";
                        } else if(OffBottomLeftViewTexture != None) {
                            IndicatorTextureToDisplay = OffBottomViewTexture;
                        }
                    } else if(isInLeftTri || offLeft){
                        if(UseTextOnlyIndicators) {
                            textIndicator = "<-";
                        } else if(OffBottomLeftViewTexture != None) {
                            IndicatorTextureToDisplay = OffLeftViewTexture;
                        }
                    } else if(isInRightTri || offRight){
                        if(UseTextOnlyIndicators) {
                            textIndicator = "->";
                        } else if(OffBottomLeftViewTexture != None) {
                            IndicatorTextureToDisplay = OffRightViewTexture;
                        }
                    } else if(!isInAnyTri) {
                         if(UseTextOnlyIndicators) {
                            textIndicator = "(*)";
                        } else if(IndicatorTexture != None) {
                            IndicatorTextureToDisplay = IndicatorTexture;
                        }
                    }
                } else {
                    //on screen
                    if(UseTextOnlyIndicators) {
                        textIndicator = "(*)";
                    } else if(IndicatorTexture != None) {
                        IndicatorTextureToDisplay = IndicatorTexture;
                    }
                }
              } else if(ShowIndicator){
                if(offLeft) {
                    if(offBottom) {
                        //lower left
                        if(UseTextOnlyIndicators) {
                             textIndicator = "//";
                        } else if(OffBottomLeftViewTexture != None) {
                            IndicatorTextureToDisplay = OffBottomLeftViewTexture;
                        }
                    } else if(offTop) {
                        //upper left
                        if(UseTextOnlyIndicators) {
                            textIndicator = "\\";
                        } else if(OffTopLeftViewTexture != None) {
                            IndicatorTextureToDisplay = OffTopLeftViewTexture;
                        }
                    } else {
                        //left
                        if(UseTextOnlyIndicators) {
                            textIndicator = "<-";
                        } else if(OffLeftViewTexture != None) {
                            IndicatorTextureToDisplay = OffLeftViewTexture;
                        }
                    }
                } else if(offRight) {
                    if(offBottom) {
                        //lower right
                        if(UseTextOnlyIndicators) {
                            textIndicator = "\\";
                        } else if(OffBottomRightViewTexture != None) {
                            IndicatorTextureToDisplay = OffBottomRightViewTexture;
                        }
                    } else if(offTop) {
                        //upper right
                        if(UseTextOnlyIndicators) {
                            textIndicator = "//";
                        } else if(OffTopRightViewTexture != None) {
                            IndicatorTextureToDisplay = OffTopRightViewTexture;
                        }
                    } else {
                        //right
                        if(UseTextOnlyIndicators) {
                            textIndicator = "->";
                        } else if(OffRightViewTexture != None) {
                            IndicatorTextureToDisplay = OffRightViewTexture;
                        }
                    }
                } else if(offTop) {
                    //top
                    if(UseTextOnlyIndicators) {
                        textIndicator = "^^^";
                    } else if(OffTopViewTexture != None) {
                        IndicatorTextureToDisplay = OffTopViewTexture;
                    }
                } else if(offBottom) {
                    //bottom
                    if(UseTextOnlyIndicators) {
                        textIndicator = "\\//";
                    } else if(OffBottomViewTexture != None) {
                        IndicatorTextureToDisplay = OffBottomViewTexture;
                    }
                } else {
                    //on screen
                    if(UseTextOnlyIndicators) {
                        textIndicator = "(*)";
                    } else if(IndicatorTexture == None) {
                        IndicatorTextureToDisplay = default.IndicatorTexture;
                    }
                }

                if(targetIsBehind) {
                    if(UseTextOnlyIndicators) {
                        textIndicator = "<->";
                    } else if(BehindViewTexture != None) {
                        IndicatorTextureToDisplay = BehindViewTexture;
                    }
                }
              }

              //DONE setting indicator, now can fetch indicator sizes
              //sanity check to ensure there's always a set texture
              if(IndicatorTextureToDisplay == None) {
                  IndicatorTextureToDisplay = default.IndicatorTexture;
              }

              if(UseTextOnlyIndicators) {
                  //get text rendering dimensions
                  C.SetPos(0,0);
                  C.TextSize(textIndicator, IndicatorWidth, IndicatorHeight);
              } else {
                  IndicatorWidth = IndicatorTextureToDisplay.USize;
                  IndicatorHeight = IndicatorTextureToDisplay.VSize;
              }

              if(targetIsBehind || isOffScreen) {
                  if(!ShowIndicator || (StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen <= 0)) {
                      finalIndicatorScale = 0;
                  } else {
                      finalIndicatorScale = class'HUDHelper'.static.getScaleForTextureFromMaxDimension(IndicatorTextureToDisplay, StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen * screenSmallestDimension);
                  }
              } else {//then normal scaling
                  if(ScaleIndicatorSizeToTarget){
                      targetHudSize = class'HUDHelper'.static.getActorSizeOnHudFromCollider(C, target, false) + 10;

                      //ensure size of indicator isn't too large/small on the hud
                      //limit that it can't be more less than 10% the smallest screen dimension, and no more than 25% o the screen dimension
                      targetHudSize = Clamp(targetHudSize, screenLargestDimension * 0.05, screenLargestDimension * 0.25);

                      finalIndicatorScale = class'HUDHelper'.static.getScaleForTextureFromMaxDimension(IndicatorTextureToDisplay, targetHudSize);
                  } else {//if we arent scaling indicator based on the target, then use the static scale value
                      finalIndicatorScale = class'HUDHelper'.static.getScaleForTextureFromMaxDimension(IndicatorTextureToDisplay, StaticIndicatorPercentOfMinScreenDimension * screenSmallestDimension);
                  }
              }

              if(UseTextOnlyIndicators) {
                  IndicatorXLimitMargin = IndicatorWidth * finalIndicatorScale;
                  IndicatorYLimitMargin = IndicatorHeight * finalIndicatorScale;
              } else {
                  IndicatorXLimitMargin = ((IndicatorWidth/2.0) * finalIndicatorScale);
                  IndicatorYLimitMargin = ((IndicatorHeight/2.0) * finalIndicatorScale);
              }

              //if the target is behind, then apply special rules to "glue" the indicator to the side of the screen
              if(targetIsBehind) {
			    if(BehindViewTexture == None){
				    ShowIndicator = false;
				}

                if(ShowIndicator) {
                    if(UseTriangleQuadrantsForOffScreen){//if this is true, the triangle quadrant booleans have been set prior
                        drawAtScreenX = Clamp(targetScreenXPos, IndicatorXLimitMargin, C.ClipX-IndicatorXLimitMargin);
                        drawAtScreenY = Clamp(targetScreenYPos, IndicatorYLimitMargin, C.ClipY-IndicatorYLimitMargin);

                        if(isInTopTri || offTop){
                            drawAtScreenY = IndicatorYLimitMargin;
                        } else if(isInBottomTri || offBottom){
                            drawAtScreenY = C.ClipY - IndicatorYLimitMargin;
                        } else if(isInLeftTri || offLeft){
                            drawAtScreenX = IndicatorXLimitMargin;
                        } else if(isInRightTri || offRight){
                            drawAtScreenX = C.ClipX - IndicatorXLimitMargin;
                        } else if(!isInAnyTri){
                            //No action needed right now
                        }
                    } else {
                        drawAtScreenY = Clamp(targetScreenYPos, IndicatorYLimitMargin, C.ClipY-IndicatorYLimitMargin);

                        if(targetScreenXPos < screenMiddleX){
                            //left side
                            drawAtScreenX = IndicatorXLimitMargin;
                        } else {
                            //right side
                            drawAtScreenX = C.ClipX - IndicatorXLimitMargin;
                        }
                    }
                }

                //hide any labels to avoid congesting the players HUD
                ShowTargetDistanceLabels = false;
                ShowIndicatorLabel = false;
              } else {//target is not behind
                  //set the position of the indicator like normal
                  if(UseTextOnlyIndicators) {
                      drawAtScreenX = Clamp(targetScreenXPos, 0, C.ClipX-IndicatorXLimitMargin);
                      drawAtScreenY = Clamp(targetScreenYPos, 0, C.ClipY-IndicatorYLimitMargin);
                  } else {
                      drawAtScreenX = Clamp(targetScreenXPos, IndicatorXLimitMargin, C.ClipX-IndicatorXLimitMargin);
                      drawAtScreenY = Clamp(targetScreenYPos, IndicatorYLimitMargin, C.ClipY-IndicatorYLimitMargin);
                  }

				  //zero offset from the indicator
                  OffsetFromIndicatorPos.X = drawAtScreenX;

				  //move the offset up / down so we are at the "true" edge of the rendered indicator (it's drawn CENTERED on the x/y coords)
				  if(IndicatorLabelsAboveIndicator) {
					  OffsetFromIndicatorPos.Y = drawAtScreenY - IndicatorYLimitMargin;
				  } else {
					  OffsetFromIndicatorPos.Y = drawAtScreenY + IndicatorYLimitMargin;
				  }

                  //target is in front, so adjust distance positions
                  if(ShowTargetDistanceLabels){
                      //center label
                      DistanceLabelXPos = OffsetFromIndicatorPos.X - (DistLabelSizeX / 2.0);

                      //position above/below indicator
                      if(IndicatorLabelsAboveIndicator) {
                          DistanceLabelYPos = OffsetFromIndicatorPos.Y - IndicatorLabelMargin - DistLabelSizeY;
                          OffsetFromIndicatorPos.Y = DistanceLabelYPos;
                      } else {
                          DistanceLabelYPos = OffsetFromIndicatorPos.Y + IndicatorLabelMargin;
                          OffsetFromIndicatorPos.Y = DistanceLabelYPos + DistLabelSizeY;
                      }
                  }

                  //target is in front, so adjust indicator label positions
                  if(ShowIndicatorLabel){
                      //center label
                      IndicatorLabelXPos = OffsetFromIndicatorPos.X - (IndicatorLabelSizeX / 2.0);
                      //IndicatorLabelSizeY
                      //position above/below previous label/indicator
                      if(IndicatorLabelsAboveIndicator) {
                          IndicatorLabelYPos = OffsetFromIndicatorPos.Y - IndicatorLabelSizeY - IndicatorYLimitMargin;
                          OffsetFromIndicatorPos.Y = IndicatorLabelYPos;
                      } else {
                          IndicatorLabelYPos = OffsetFromIndicatorPos.Y;
                          OffsetFromIndicatorPos.Y = IndicatorLabelYPos + IndicatorLabelSizeY + IndicatorYLimitMargin;
                      }
                  }
              }

              if(ShowIndicator) {
                  if(UseTextOnlyIndicators) {
                      C.Style = ERenderStyle.STY_Normal;
                      C.DrawColor = class'ColorHelper'.static.GetWhiteColor();
                      C.SetPos(drawAtScreenX, drawAtScreenY);
                      C.DrawTextClipped(textIndicator);
                  } else if(finalIndicatorScale > 0){
                      if(BlinkIndicator){
                          //blend the blink alpha value with the current indicator color (due to the STY_Translucent render mode, BLACK will be transparent, and white will take the color of the indicator)
                          C.DrawColor = C.DrawColor*BlinkAlphaValue;
                      } else {
                          C.DrawColor = C.DrawColor*BaseAlphaValue;
                      }

                      C.Style = ERenderStyle.STY_Translucent;

                      if(bLogToGameLogfile){
                          Log("target indicator rendering with params drawAtScreenX:"@drawAtScreenX@" - drawAtScreenY:"@drawAtScreenY@" - finalIndicatorScale:"@finalIndicatorScale@" - PlayerHUDScale:"@PlayerHUDScale@" - IndicatorTextureToDisplay is None? - "@(IndicatorTextureToDisplay == None)@" - C.Color(R,G,B): ("@C.DrawColor.R@","@C.DrawColor.G@","@C.DrawColor.B@")");
                      }

                      if(ShowIndicatorAboveTarget){
                          class'HUDHelper'.static.DrawTextureCenteredAboveAtXY(C, IndicatorTextureToDisplay, drawAtScreenX, drawAtScreenY, finalIndicatorScale, PlayerHUDScale, true);
                      } else {
                          class'HUDHelper'.static.DrawTextureAtXY(C, IndicatorTextureToDisplay, drawAtScreenX, drawAtScreenY, finalIndicatorScale, PlayerHUDScale, True);
                      }
                  }
              }

              if(ShowTargetDistanceLabels){
                  C.Style = ERenderStyle.STY_Normal;
                  C.DrawColor = class'ColorHelper'.static.GetWhiteColor();
                  C.SetPos(DistanceLabelXPos, DistanceLabelYPos);
                  C.DrawTextClipped(DistLabelText);
              }

              if(ShowIndicatorLabel) {
                  C.Style = ERenderStyle.STY_Normal;
                  C.DrawColor = class'ColorHelper'.static.GetWhiteColor();

				  //handle any unique cases
				  if(ShowIndicatorAboveTarget){
				      //IndicatorLabelYPos -= (IndicatorTextureToDisplay.VSize * finalIndicatorScale);
				  }

                  C.SetPos(IndicatorLabelXPos, IndicatorLabelYPos);
                  C.DrawTextClipped(IndicatorLabel);
              }

              element = element.Next;
          }
      }
}

static function IndicatorHud GetCurrentPlayerIndicatorHudInstance(Actor context){
    local Mutator m;
    local IndicatorHud ih;
    local PlayerPawn pp;

    foreach context.AllActors(class'PlayerPawn', pp) {
       if(pp.myHud != None) {
           m = pp.myHud.HUDMutator;
       }

       While(m != None) {
           if(m.IsA('IndicatorHud')) {
               ih = IndicatorHud(m);
               break;
           } else {
               m = m.NextHUDMutator;
           }
       }

       if(ih == None) {
           ih = class'IndicatorHud'.static.SpawnAndRegister(context);
       }

       return ih;
    }
}

static function IndicatorHud SpawnAndRegister(Actor context){
    local Mutator hudMut;
    local IndicatorHud hud;

    hudMut = class'HUDMutator'.static.GetHUDMutatorFromAnyPlayerPawnByClass(context, class'IndicatorHud');

    if(hudMut == None){
        hud = context.Spawn(class'IndicatorHud');
        hud.PlayerIndicatorTargets = new class'LinkedList';
        hud.GlobalIndicatorTargets = class'IndicatorHudGlobalTargets'.static.GetRef(context);
        hud.RegisterThisHUDMutator();
    } else {
        hud = IndicatorHud(hudMut);
    }

    return hud;
}

function VerifyTargets(){
   local ListElement element, nextElement;
   local Actor target;

   if((PlayerIndicatorTargets != None) && (PlayerIndicatorTargets.Count > 0)){
      element = PlayerIndicatorTargets.Head;

      While(element != None) {
          target = Actor(Element.Value);

          if(target == None || target.bDeleteMe) {
             nextElement = element.Next;
             element.RemoveFromList();
             element = nextElement;
          } else {
             element = element.Next;
          }
      }
   }

   if((GlobalIndicatorTargets != None) && (GlobalIndicatorTargets.GlobalIndicatorTargets != None) && GlobalIndicatorTargets.GlobalIndicatorTargets.Count > 0){
      element = GlobalIndicatorTargets.GlobalIndicatorTargets.Head;

      While(element != None) {
          target = Actor(Element.Value);
          if(target == None || target.bDeleteMe) {
               nextElement = element.Next;
               element.RemoveFromList();
               element = nextElement;
          } else {
             element = element.Next;
          }
      }
   }
}

static function IndicatorTextureVariations GetTexturesForBuiltInOption(byte wantedBuiltinTex, optional byte offScreenTexDesired){//HUDIndicator_Texture_BuiltIn - wantedBuiltinTex
    local IndicatorTextureVariations texVariation, offScreenTexVariation;
    texVariation = new class'IndicatorTextureVariations';

    if(offScreenTexDesired != HUDIndicator_Texture_BuiltIn.Empty){
        offScreenTexVariation = class'IndicatorHud'.static.GetTexturesForBuiltInOption(offScreenTexDesired);
    }

    switch(wantedBuiltinTex){
        /*0*/case HUDIndicator_Texture_BuiltIn.Empty:
            texVariation = None;
        break;
        //Icons
        /*1*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Bolt:
            texVariation.InViewTex = Texture'HudIndicator_Bolt';
        break;
        /*2*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Bomb:
            texVariation.InViewTex = Texture'HudIndicator_Bomb';
        break;
        /*3*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Bullets:
            texVariation.InViewTex = Texture'HudIndicator_Bullets';
        break;
        /*4*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Lever:
            texVariation.InViewTex = Texture'HudIndicator_Lever';
        break;
        /*5*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Explosion:
            texVariation.InViewTex = Texture'HudIndicator_Explosion';
        break;
        /*6*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Gun:
            texVariation.InViewTex = Texture'HudIndicator_Gun';
        break;
        /*7*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Poison:
            texVariation.InViewTex = Texture'HudIndicator_Poison';
        break;
        /*8*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Rocket:
            texVariation.InViewTex = Texture'HudIndicator_Rocket';
        break;
        /*9*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Watch:
            texVariation.InViewTex = Texture'HudIndicator_Watch';
        break;
        /*10*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Enforcer:
            texVariation.InViewTex = Texture'HudIndicator_Enforcer';
        break;
        /*11*/case HUDIndicator_Texture_BuiltIn.HudIndicator_CircleX_Closed:
            texVariation.InViewTex = Texture'HudIndicator_CircleX_Closed';
        break;
        /*12*/case HUDIndicator_Texture_BuiltIn.HudIndicator_CircleX_Open:
            texVariation.InViewTex = Texture'HudIndicator_CircleX_Open';
        break;
        /*13*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Diamond_Closed:
            texVariation.InViewTex = Texture'HudIndicator_Diamond_Closed';
        break;
        /*14*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Diamond_Open:
            texVariation.InViewTex = Texture'HudIndicator_Diamond_Open';
        break;
        /*15*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Door1:
            texVariation.InViewTex = Texture'HudIndicator_Door1';
        break;
        /*16*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Door2:
            texVariation.InViewTex = Texture'HudIndicator_Door2';
        break;
        /*17*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Dot:
            texVariation.InViewTex = Texture'HudIndicator_Dot';
        break;
        /*18*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Exclaim_Circle_Closed:
            texVariation.InViewTex = Texture'HudIndicator_Exclaim_Circle_Closed';
        break;
        /*19*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Exclaim_Circle_Open:
            texVariation.InViewTex = Texture'HudIndicator_Exclaim_Circle_Open';
        break;
        /*21*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Exclaim_Triangle_Closed:
            texVariation.InViewTex = Texture'HudIndicator_Exclaim_Triangle_Closed';
        break;
        /*20*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Exclaim_Triangle_Open:
            texVariation.InViewTex = Texture'HudIndicator_Exclaim_Triangle_Open';
        break;
        /*22*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Fire:
            texVariation.InViewTex = Texture'HudIndicator_Fire';
        break;
        /*23*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Flag:
            texVariation.InViewTex = Texture'HudIndicator_Flag';
        break;
        /*24*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Flag2:
            texVariation.InViewTex = Texture'HudIndicator_Flag2';
        break;
        /*25*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Flag3:
            texVariation.InViewTex = Texture'HudIndicator_Flag3';
        break;
        /*26*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Forward_Closed:
            texVariation.InViewTex = Texture'HudIndicator_Forward_Closed';
        break;
        /*27*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Forward_Open:
            texVariation.InViewTex = Texture'HudIndicator_Forward_Open';
        break;
        /*28*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Gear:
            texVariation.InViewTex = Texture'HudIndicator_Gear';
        break;
        /*29*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Hammer:
            texVariation.InViewTex = Texture'HudIndicator_Hammer';
        break;
        /*30*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Hand:
            texVariation.InViewTex = Texture'HudIndicator_Hand';
        break;
        /*31*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Home:
            texVariation.InViewTex = Texture'HudIndicator_Home';
        break;
        /*32*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Key:
            texVariation.InViewTex = Texture'HudIndicator_Key';
        break;
        /*33*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Lock:
            texVariation.InViewTex = Texture'HudIndicator_Lock';
        break;
        /*34*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Play:
            texVariation.InViewTex = Texture'HudIndicator_Play';
        break;
        /*36*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Question_Solid:
            texVariation.InViewTex = Texture'HudIndicator_Question_Solid';
        break;
        /*35*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Question_Open:
            texVariation.InViewTex = Texture'HudIndicator_Question_Open';
        break;
        /*37*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Reticle:
            texVariation.InViewTex = Texture'HudIndicator_Reticle';
        break;
        /*38*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Shield:
            texVariation.InViewTex = Texture'HudIndicator_Shield';
        break;
        /*39*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Speech:
            texVariation.InViewTex = Texture'HudIndicator_Speech';
        break;
        /*40*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Target:
            texVariation.InViewTex = Texture'HudIndicator_Target';
        break;
        /*41*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Water:
            texVariation.InViewTex = Texture'HudIndicator_Water';
        break;
        /*42*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Waypoint:
            texVariation.InViewTex = Texture'HudIndicator_Waypoint';
        break;
        /*43*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Waypoint2:
            texVariation.InViewTex = Texture'HudIndicator_Waypoint2';
        break;
        /*44*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Waypoint3:
            texVariation.InViewTex = Texture'HudIndicator_Waypoint3';
        break;
        /*45*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Wrench:
            texVariation.InViewTex = Texture'HudIndicator_Wrench';
        break;
        /*46*/case HUDIndicator_Texture_BuiltIn.HudIndicator_WrenchCircle:
            texVariation.InViewTex = Texture'HudIndicator_WrenchCircle';
        break;
        /*47*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Wrenches:
            texVariation.InViewTex = Texture'HudIndicator_Wrenches';
        break;
        /*48*/case HUDIndicator_Texture_BuiltIn.HudIndicator_X:
            texVariation.InViewTex = Texture'HudIndicator_X';
        break;
        /*49*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Knight:
            texVariation.InViewTex = Texture'HudIndicator_Knight';
        break;

        //Indicators
        /*56*/case HUDIndicator_Texture_BuiltIn.HudElement_Ring:
            texVariation.InViewTex = Texture'HudElement_Ring';
            texVariation.BehindViewTex = Texture'HudElement_Ring';
        break;
        /*57*/case HUDIndicator_Texture_BuiltIn.HudElement_Ring_B:
            texVariation.InViewTex = Texture'HudElement_Ring_B';
            texVariation.BehindViewTex = Texture'HudElement_Ring_B';
        break;
        /*58*/case HUDIndicator_Texture_BuiltIn.HudIndicator_DownArrow_Open:
            texVariation.InViewTex = Texture'HudIndicator_DownArrow_Open';
            texVariation.BehindViewTex = Texture'HudIndicator_DownArrow_Open';

            texVariation.OffBottomLeftViewTex = Texture'HudIndicator_DownArrow_Open_BL';
            texVariation.OffBottomRightViewTex = Texture'HudIndicator_DownArrow_Open_BR';
            texVariation.OffLeftViewTex = Texture'HudIndicator_DownArrow_Open_L';
            texVariation.OffRightViewTex = Texture'HudIndicator_DownArrow_Open_R';
            texVariation.OffTopLeftViewTex = Texture'HudIndicator_DownArrow_Open_UL';
            texVariation.OffTopRightViewTex = Texture'HudIndicator_DownArrow_Open_UR';
            texVariation.OffTopViewTex = Texture'HudIndicator_DownArrow_Open_U';
            texVariation.OffBottomViewTex = Texture'HudIndicator_DownArrow_Open';
        break;
        /*59*/case HUDIndicator_Texture_BuiltIn.HudIndicator_DownArrow_Solid:
            texVariation.InViewTex = Texture'HudIndicator_DownArrow_Solid';
            texVariation.BehindViewTex = Texture'HudIndicator_DownArrow_Solid';

            texVariation.OffBottomLeftViewTex = Texture'HudIndicator_DownArrow_Solid_BL';
            texVariation.OffBottomRightViewTex = Texture'HudIndicator_DownArrow_Solid_BR';
            texVariation.OffLeftViewTex = Texture'HudIndicator_DownArrow_Solid_L';
            texVariation.OffRightViewTex = Texture'HudIndicator_DownArrow_Solid_R';
            texVariation.OffTopLeftViewTex = Texture'HudIndicator_DownArrow_Solid_UL';
            texVariation.OffTopRightViewTex = Texture'HudIndicator_DownArrow_Solid_UR';
            texVariation.OffTopViewTex = Texture'HudIndicator_DownArrow_Solid_U';
            texVariation.OffBottomViewTex = Texture'HudIndicator_DownArrow_Solid';
        break;
        /*60*/case HUDIndicator_Texture_BuiltIn.HudIndicator_DownClassicArrow_Solid:
            texVariation.InViewTex = Texture'HudIndicator_DownClassicArrow_Solid';
            texVariation.BehindViewTex = Texture'HudIndicator_DownClassicArrow_Solid';

            texVariation.OffBottomLeftViewTex = Texture'HudIndicator_DownClassicArrow_Solid_BL';
            texVariation.OffBottomRightViewTex = Texture'HudIndicator_DownClassicArrow_Solid_BR';
            texVariation.OffLeftViewTex = Texture'HudIndicator_DownClassicArrow_Solid_L';
            texVariation.OffRightViewTex = Texture'HudIndicator_DownClassicArrow_Solid_R';
            texVariation.OffTopLeftViewTex = Texture'HudIndicator_DownClassicArrow_Solid_UL';
            texVariation.OffTopRightViewTex = Texture'HudIndicator_DownClassicArrow_Solid_UR';
            texVariation.OffTopViewTex = Texture'HudIndicator_DownClassicArrow_Solid_U';
            texVariation.OffBottomViewTex = Texture'HudIndicator_DownClassicArrow_Solid';
        break;
        /*61*/case HUDIndicator_Texture_BuiltIn.HudIndicator_DownTab_Closed:
            texVariation.InViewTex = Texture'HudIndicator_DownTab_Closed';
            texVariation.BehindViewTex = Texture'HudIndicator_DownTab_Closed';

            texVariation.OffBottomLeftViewTex = Texture'HudIndicator_DownTab_Closed_BL';
            texVariation.OffBottomRightViewTex = Texture'HudIndicator_DownTab_Closed_BR';
            texVariation.OffLeftViewTex = Texture'HudIndicator_DownTab_Closed_L';
            texVariation.OffRightViewTex = Texture'HudIndicator_DownTab_Closed_R';
            texVariation.OffTopLeftViewTex = Texture'HudIndicator_DownTab_Closed_UL';
            texVariation.OffTopRightViewTex = Texture'HudIndicator_DownTab_Closed_UR';
            texVariation.OffTopViewTex = Texture'HudIndicator_DownTab_Closed_U';
            texVariation.OffBottomViewTex = Texture'HudIndicator_DownTab_Closed';
        break;
        /*62*/case HUDIndicator_Texture_BuiltIn.HudIndicator_DownTab_Open:
            texVariation.InViewTex = Texture'HudIndicator_DownTab_Open';
            texVariation.BehindViewTex = Texture'HudIndicator_DownTab_Open';

            texVariation.OffBottomLeftViewTex = Texture'HudIndicator_DownTab_Open_BL';
            texVariation.OffBottomRightViewTex = Texture'HudIndicator_DownTab_Open_BR';
            texVariation.OffLeftViewTex = Texture'HudIndicator_DownTab_Open_L';
            texVariation.OffRightViewTex = Texture'HudIndicator_DownTab_Open_R';
            texVariation.OffTopLeftViewTex = Texture'HudIndicator_DownTab_Open_UL';
            texVariation.OffTopRightViewTex = Texture'HudIndicator_DownTab_Open_UR';
            texVariation.OffTopViewTex = Texture'HudIndicator_DownTab_Open_U';
            texVariation.OffBottomViewTex = Texture'HudIndicator_DownTab_Open';
        break;
        /*64*/case HUDIndicator_Texture_BuiltIn.HudIndicator_DownTriangle_Solid:
            texVariation.InViewTex = Texture'HudIndicator_DownTriangle_Solid';
            texVariation.BehindViewTex = Texture'HudIndicator_DownTriangle_Solid';

            texVariation.OffBottomLeftViewTex = Texture'HudIndicator_DownTriangle_Solid_BL';
            texVariation.OffBottomRightViewTex = Texture'HudIndicator_DownTriangle_Solid_BR';
            texVariation.OffLeftViewTex = Texture'HudIndicator_DownTriangle_Solid_L';
            texVariation.OffRightViewTex = Texture'HudIndicator_DownTriangle_Solid_R';
            texVariation.OffTopLeftViewTex = Texture'HudIndicator_DownTriangle_Solid_UL';
            texVariation.OffTopRightViewTex = Texture'HudIndicator_DownTriangle_Solid_UR';
            texVariation.OffTopViewTex = Texture'HudIndicator_DownTriangle_Solid_U';
            texVariation.OffBottomViewTex = Texture'HudIndicator_DownTriangle_Solid';
        break;
        /*63*/case HUDIndicator_Texture_BuiltIn.HudIndicator_DownTriangle_Open:
            texVariation.InViewTex = Texture'HudIndicator_DownTriangle_Open';
            texVariation.BehindViewTex = Texture'HudIndicator_DownTriangle_Open';

            texVariation.OffBottomLeftViewTex = Texture'HudIndicator_DownTriangle_Open_BL';
            texVariation.OffBottomRightViewTex = Texture'HudIndicator_DownTriangle_Open_BR';
            texVariation.OffLeftViewTex = Texture'HudIndicator_DownTriangle_Open_L';
            texVariation.OffRightViewTex = Texture'HudIndicator_DownTriangle_Open_R';
            texVariation.OffTopLeftViewTex = Texture'HudIndicator_DownTriangle_Open_UL';
            texVariation.OffTopRightViewTex = Texture'HudIndicator_DownTriangle_Open_UR';
            texVariation.OffTopViewTex = Texture'HudIndicator_DownTriangle_Open_U';
            texVariation.OffBottomViewTex = Texture'HudIndicator_DownTriangle_Open';
        break;
        /*65*/case HUDIndicator_Texture_BuiltIn.HudIndicator_DownWedge:
            texVariation.InViewTex = Texture'HudIndicator_DownWedge';
            texVariation.BehindViewTex = Texture'HudIndicator_DownWedge';

            texVariation.OffBottomLeftViewTex = Texture'HudIndicator_DownWedge_BL';
            texVariation.OffBottomRightViewTex = Texture'HudIndicator_DownWedge_BR';
            texVariation.OffLeftViewTex = Texture'HudIndicator_DownWedge_L';
            texVariation.OffRightViewTex = Texture'HudIndicator_DownWedge_R';
            texVariation.OffTopLeftViewTex = Texture'HudIndicator_DownWedge_UL';
            texVariation.OffTopRightViewTex = Texture'HudIndicator_DownWedge_UR';
            texVariation.OffTopViewTex = Texture'HudIndicator_DownWedge_U';
            texVariation.OffBottomViewTex = Texture'HudIndicator_DownWedge';
        break;
        /*66*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Nav_Closed:
            texVariation.InViewTex = Texture'HudIndicator_Nav_Closed';
            texVariation.BehindViewTex = Texture'HudIndicator_Nav_Closed';
        break;
        /*67*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Nav_Open:
            texVariation.InViewTex = Texture'HudIndicator_Nav_Open';
            texVariation.BehindViewTex = Texture'HudIndicator_Nav_Open';
        break;
        /*68*/case HUDIndicator_Texture_BuiltIn.HudIndicator_SelectionBox:
            texVariation.InViewTex = Texture'HudIndicator_SelectionBox';
            texVariation.BehindViewTex = Texture'HudIndicator_SelectionBox';
        break;
        /*69*/case HUDIndicator_Texture_BuiltIn.HudIndicator_SelectionBox2:
            texVariation.InViewTex = Texture'HudIndicator_SelectionBox2';
            texVariation.BehindViewTex = Texture'HudIndicator_SelectionBox2';
        break;
        /*70*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Square_Open:
            texVariation.InViewTex = Texture'HudIndicator_Square_Open';
            texVariation.BehindViewTex = Texture'HudIndicator_Square_Open';
        break;

        /*71*/case HUDIndicator_Texture_BuiltIn.HudIndicator_SkullAndBones:
            texVariation.InViewTex = Texture'HudIndicator_SkullAndBones';
            texVariation.BehindViewTex = Texture'HudIndicator_SkullAndBones';
        break;
        /*72*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Bones:
            texVariation.InViewTex = Texture'HudIndicator_Bones';
            texVariation.BehindViewTex = Texture'HudIndicator_Bones';
        break;
        /*73*/case HUDIndicator_Texture_BuiltIn.HudIndicator_Skull:
            texVariation.InViewTex = Texture'HudIndicator_Skull';
            texVariation.BehindViewTex = Texture'HudIndicator_Skull';
        break;

        default:
            texVariation.InViewTex = Texture'HudElement_Ring_B';
            texVariation.BehindViewTex = Texture'HudElement_Ring_B';
    }

    if(offScreenTexVariation != None){
         //add these textures as the "off screen" textures
         if(texVariation == None){//in case no texture selected / found
              texVariation = offScreenTexVariation;
              texVariation.InViewTex = None;
         } else {
             texVariation.OffBottomLeftViewTex = offScreenTexVariation.OffBottomLeftViewTex;
             texVariation.OffBottomRightViewTex = offScreenTexVariation.OffBottomRightViewTex;
             texVariation.OffLeftViewTex = offScreenTexVariation.OffLeftViewTex;
             texVariation.OffRightViewTex = offScreenTexVariation.OffRightViewTex;
             texVariation.OffTopLeftViewTex = offScreenTexVariation.OffTopLeftViewTex;
             texVariation.OffTopRightViewTex = offScreenTexVariation.OffTopRightViewTex;
             texVariation.OffTopViewTex = offScreenTexVariation.OffTopViewTex;
             texVariation.OffBottomViewTex = offScreenTexVariation.OffBottomViewTex;
         }
    }

    return texVariation;
}

function Tick(float DeltaTime) {
    if(BlinkIndicator){
       LastDeltaTime = DeltaTime;
    }
}

defaultproperties {
   bLogToGameLogfile=false,
   StaticIndicatorPercentOfMinScreenDimension=0.05,
   StaticIndicatorPercentOfMinScreenDimensionWhenOffScreen=0.05,
   ShowIndicatorIfTargetHidden=true,
   ShowIndicatorWhenOffScreen=false,
   ShowIndicatorsThatAreObscured=true,
   ScaleIndicatorSizeToTarget=true,
   UseHudColorForIndicators=true,
   IndicatorColor=(R=255,G=186,B=3),
   IndicatorLabel="",
   ShowIndicatorLabel=true,
   UseTargetNameForLabel=false,
   IndicatorLabelsAboveIndicator=true,
   IndicatorLabelMargin=10,
   IndicatorOffsetFromTarget=Vect(0,0,0),
   UseTextOnlyIndicators=false,
   ShowTargetDistanceLabels=false,
   UseTriangleQuadrantsForOffScreen=true,
   MaxTargetIndicatorViewDistance=2000.0,
   ShowIndicatorAboveTarget=false,
   IndicatorTexture=Texture'HudElement_Ring_B',

   CurrentBlinkTime=0.0,
   BlinkingIsFadingIn=true,
   BlinkRate=0.5,
   BlinkIndicator=true,
   BaseAlphaValue=1.0,
   LastDeltaTime=0.0,

   BehindViewTexture=Texture'HudElement_Ring_B',
   OffTopLeftViewTexture=Texture'HudElement_Ring_B',
   OffLeftViewTexture=Texture'HudElement_Ring_B',
   OffBottomLeftViewTexture=Texture'HudElement_Ring_B',
   OffBottomViewTexture=Texture'HudElement_Ring_B',
   OffBottomRightViewTexture=Texture'HudElement_Ring_B',
   OffRightViewTexture=Texture'HudElement_Ring_B',
   OffTopRightViewTexture=Texture'HudElement_Ring_B',
   OffTopViewTexture=Texture'HudElement_Ring_B'
}
