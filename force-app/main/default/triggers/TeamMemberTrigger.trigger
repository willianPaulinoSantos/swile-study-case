trigger TeamMemberTrigger on Team_Member__c (before update) {

    new TeamMemberTriggerHandler().run();
}