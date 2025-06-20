public with sharing class TeamMemberTriggerHandler extends TriggerHandler {
    @testVisible
    List<Team_Member__c> newTeamMembers;
    Map<Id, Team_Member__c> oldTeamMembers;

    public TeamMemberTriggerHandler() {

        this ( (List<Team_Member__c>) Trigger.new, (Map<Id, Team_Member__c>) Trigger.oldMap);
    }

    public TeamMemberTriggerHandler(List<Team_Member__c> newTeamMembers, Map<Id, Team_Member__c> oldTeamMembers) {
        this.newTeamMembers = newTeamMembers;
        this.oldTeamMembers = oldTeamMembers;
        
    }

    public override void beforeUpdate() {
        
        TeamMemberAbsenceService.setCounterAfterAbscenceReturn(newTeamMembers, oldTeamMembers);
    }
}