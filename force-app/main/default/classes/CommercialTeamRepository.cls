public with sharing class CommercialTeamRepository {

    public List<Commercial_Team__c> getAllActiveTeamsWithTeamMembers(){

        return [SELECT Id, Name, maximum_prospects_count__c, country_code__c, employee_range__c, product_interest__c,
                (SELECT Id, Name, user__c, is_absent__c, is_manager__c, prospects_count__c FROM Team_Members__r ORDER BY prospects_count__c ASC)
                FROM Commercial_Team__c 
                WHERE is_active__c = True];
    }

    public Map<Id, Commercial_Team__c> getTeamsByIds(Set<Id> commercialTeamIds){

        return new Map<Id, Commercial_Team__c>(
                [SELECT Id, Name, maximum_prospects_count__c, country_code__c, employee_range__c, product_interest__c
                FROM Commercial_Team__c 
                WHERE Id IN :commercialTeamIds]);
    }
}