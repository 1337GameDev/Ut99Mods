class HaloAnnouncerMutator extends Mutator;

var bool HasAnnouncerOption;

var Class<LocalMessage> OriginalDeathMessageClass;

static function HaloAnnouncerMutator RegisterMutator(Actor context) {
	local Mutator mut;
	
	mut = class'LGDUtilities.MutatorHelper'.static.GetGameMutatorByClass(context, class'HaloAnnouncer.HaloAnnouncerMutator');
	if(mut == None) {
        mut = context.Spawn(class'HaloAnnouncer.HaloAnnouncerMutator');
        context.Level.Game.BaseMutator.AddMutator(mut);
	}
	
    return HaloAnnouncerMutator(mut);
}

event PreBeginPlay() {
	local HaloAnnouncerCustomMessagesSingleton singleton;
	
	HasAnnouncerOption = Level.Game.GetPropertyText("UseHaloAnnouncer") != "";
	class'HaloAnnouncer.HaloStatsTrackerMutator'.static.RegisterMutator(self);
	
	singleton = class'HaloAnnouncer.HaloAnnouncerCustomMessagesSingleton'.static.GetRef(self);
	
	if(singleton != None) {
		singleton.AddCustomKillingSpreeMessageSender(new class'HaloAnnouncer.HaloAnnouncerKillingSpreeMessageSender');
	}
}

event PostBeginPlay() {
	default.OriginalDeathMessageClass = Level.Game.DeathMessageClass;
	Level.Game.DeathMessageClass = Class'HaloAnnouncer.HaloDeathMessagePlus';
}