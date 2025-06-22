public with sharing class TeamMemberRepository {

    public Team_Member__c findByUserId(Id userId) {
        List<Team_Member__c> teamMembers = findByUserId(new Set<Id> {userId});

        return teamMembers.size() > 0 ? teamMembers[0] : null;
    }

    public List<Team_Member__c> findByUserId(Set<Id> userIds) {
        return [SELECT Id, commercial_team__c, is_absent__c, is_manager__c, user__c, prospects_count__c
                FROM Team_Member__c
                WHERE user__c IN :userIds];
    }
}