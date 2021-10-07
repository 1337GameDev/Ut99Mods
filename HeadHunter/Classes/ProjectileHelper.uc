class ProjectileHelper extends Actor nousercreate;

static function int DeleteProjectilesOfClass(Actor context, name projClass) {
    local int countDeleted;
    local Projectile proj;

    ForEach context.AllActors(class'Projectile', proj) {
        if(proj.IsA(projClass)){
            countDeleted++;
            proj.Destroy();
        }
    }

    return countDeleted;
}

defaultproperties {

}
