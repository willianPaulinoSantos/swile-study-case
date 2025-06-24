public with sharing class LeadRepository {
    public List<Lead> getLeadById(Id Id) {
        return [SELECT Id, LastName, country_code__c, employee_range__c, product_interest__c, OwnerId
                FROM Lead
                WHERE Id =: Id];
    }
}