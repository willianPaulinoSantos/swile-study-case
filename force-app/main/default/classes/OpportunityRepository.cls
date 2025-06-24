public with sharing class OpportunityRepository {
    public List<Opportunity> getOpportunityById(Id id) {

        return [SELECT Id, Name, product_interest__c, AccountId, OwnerId
                FROM Opportunity
                WHERE Id =: id];
    }
}