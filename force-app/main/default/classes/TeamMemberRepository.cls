public with sharing class TeamMemberRepository {

    public Map<Id, Team_Member__c> findByUserIds(Set<Id> userIds) {
        return new Map<Id, Team_Member__c>( 
            [SELECT Id, commercial_team__c, is_absent__c, is_manager__c, user__c, prospects_count__c
            FROM Team_Member__c
            WHERE user__c IN :userIds] );
    }
}