class MyFontsSingleton extends Actor nousercreate;

var private FontInfo Ref;

final static function FontInfo GetRef(Actor referenceToUseForSpawn) {
    local FontInfo singleton;

    if(default.Ref == None) {
        singleton = FontInfo(referenceToUseForSpawn.Spawn(Class<Actor>(DynamicLoadObject("Botpack.FontInfo", class'Class'))) );
        default.Ref = singleton;
    }

    return default.Ref;
}

defaultproperties
{
      Ref=None
}
