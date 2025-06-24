trigger TeamMemberTrigger on Team_Member__c (before update) {

    if (!TriggerRecursionControl.isFirstRun) return;

    TriggerRecursionControl.isFirstRun = false;

    new TeamMemberTriggerHandler().run();
}