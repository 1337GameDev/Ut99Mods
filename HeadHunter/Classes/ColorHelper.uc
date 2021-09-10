class ColorHelper extends Actor nousercreate;

var() editconst const color WhiteColor, RedColor, GreenColor,
GoldColor, TurqColor, GrayColor, BlueColor;

//=============================================================================
// function SColor.
//=============================================================================
simulated final function Color SColor(Color C,  float S) {
    local int R,G,B,A;

    R = Clamp( C.R*S, 0, 255 );
    G = Clamp( C.G*S, 0, 255 );
    B = Clamp( C.B*S, 0, 255 );
    A = Clamp( C.A*S, 0, 255 );

    C.R = R;
    C.G = G;
    C.B = B;
    C.A = A;

    return C;
}

final static function color RColor(float R, float G, float B, optional float A){
    local Color C;

    R = Clamp( R, 0, 255);
    G = Clamp( G, 0, 255);
    B = Clamp( B, 0, 255);
    A = Clamp( A, 0, 255);

    C.R = R;
    C.G = G;
    C.B = B;
    C.A = A;

    return C;
}

//=============================================================================
// function DrawPickupHudInfo.
//=============================================================================
final function color GetTeamColor(byte TNum){
    local Color C;
    // Draw Color Select
    switch ( TNum)
    {
    case  0 :       // Red Team
        C = RedColor;
        break;
    case  1 :       // Blue Team
        C = TurqColor;
        break;
    case  2 :       // Greem Team
        C = GreenColor;
        break;
    case  3 :       // Gold Team
        C = GoldColor;
        break;
    default :       // No Team
        C = WhiteColor;
        break;
    }

    return C;
}

static function Color GetRedColor(){
    return default.RedColor;
}
static function Color GetTurqColor(){
    return default.TurqColor;
}
static function Color GetGreenColor(){
    return default.GreenColor;
}
static function Color GetGoldColor(){
    return default.GoldColor;
}
static function Color GetWhiteColor(){
    return default.WhiteColor;
}

defaultproperties {
    RedColor=(R=255),
    BlueColor=(G=128,B=255)
    GreenColor=(G=255),
    GoldColor=(R=255,G=255),
    TurqColor=(G=128,B=255),
    WhiteColor=(R=255,G=255,B=255),
    GrayColor=(R=128,G=128,B=128)
}
