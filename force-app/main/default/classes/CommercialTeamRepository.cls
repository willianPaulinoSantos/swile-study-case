public with sharing class CommercialTeamRepository {

    public List<Commercial_Team__c> getCommercialTeamsBySalesAllocation(string country, string product, string prospectsEmployeeRange) {

        return [SELECT Id, Name 
                FROM Commercial_Team__c 
                WHERE country_code__c = :country
                AND product_interest__c = :product 
                AND employee_range__c =: prospectsEmployeeRange];
    }

    public List<Commercial_Team__c> getAllActiveTeamsWithTeamMembers(){

        return [SELECT Id, Name, maximum_prospects_count__c, country_code__c, employee_range__c, product_interest__c,
                (SELECT Id, Name, user__c, is_absent__c, is_manager__c, prospects_count__c FROM Team_Members__r ORDER BY prospects_count__c ASC)
                FROM Commercial_Team__c 
                WHERE is_active__c = True];
    }
}