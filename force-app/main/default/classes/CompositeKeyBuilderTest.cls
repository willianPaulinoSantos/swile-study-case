@isTest
public with sharing class CompositeKeyBuilderTest {
    
    @isTest
    static void buildLeadKeyTest() {
        Lead testLead = new Lead ( country_code__c = 'FR', product_interest__c = 'Meal Voucher', employee_range__c = '1 - 100', Company = 'Swile' );

        Test.startTest();
        String leadCompositeKey = CompositeKeyBuilder.buildKey(testLead);
        Test.stopTest();

        System.assertEquals('frmealvoucher1-100', leadCompositeKey, 'Build lead composite key failed');
    }

    @isTest
    static void buildCommercialTeamKeyTest() {

        Commercial_Team__c team = new Commercial_Team__c ( country_code__c = 'FR', product_interest__c = 'Meal Voucher', employee_range__c = '1 - 100'); 

        Test.startTest();
        String leadCompositeKey = CompositeKeyBuilder.buildKey(team);
        Test.stopTest();

        System.assertEquals('frmealvoucher1-100', leadCompositeKey, 'Build commercial team composite key failed');
    }

    @isTest
    static void buildOpportunityKeyTest() {

        Account acc = new Account(country_code__c = 'FR', Name = 'Swile', employee_range__c = '1 - 100');

        Opportunity opp = new Opportunity (product_interest__c = 'Meal Voucher');

        Test.startTest();
        String opportunityCompositeKey = CompositeKeyBuilder.buildKey(opp, acc);
        Test.stopTest();

        System.assertEquals('frmealvoucher1-100', opportunityCompositeKey, 'Build opportunity composite key failed');
    }
}