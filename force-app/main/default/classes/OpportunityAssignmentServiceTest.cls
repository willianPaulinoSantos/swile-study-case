@isTest
public with sharing class OpportunityAssignmentServiceTest {

    @TestSetup
    static void setup(){

        TestFactoryHelper.createCommercialTeamWithMembers();
        Account acc = new Account(Name = 'TestAccount', country_code__c = 'FR', employee_range__c = '1 - 100');
        insert acc;
        
    }
    
    @isTest
    static void assignTest() {

        List<Account> accList = [SELECT Id, Name, country_code__c, employee_range__c FROM Account LIMIT 1];

        List<Opportunity> oppList = new List<Opportunity>{
            new Opportunity (product_interest__c = 'Meal Voucher', AccountId = accList[0].Id)
        };

        Test.startTest();
        new OpportunityAssignmentService().assign(oppList);
        Test.stopTest();

        System.assertNotEquals(null, oppList[0].OwnerId, 'Assign failed: owner not set');
    }
}