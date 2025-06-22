public with sharing class OpportunityRepository {
    public Opportunity getOpportunityById(Id id) {

        return [SELECT Id, Name, product_interest__c, AccountId, OwnerId
                FROM Opportunity
                WHERE Id =: id]?.get(0);
    }
}