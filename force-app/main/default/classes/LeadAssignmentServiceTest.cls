@isTest
public with sharing class LeadAssignmentServiceTest {

    @TestSetup
    static void setup(){
        TestFactoryHelper.createCommercialTeamWithMembers();
    }

    @isTest

    static void assignTest() {

        List<Lead> leadList = new List<Lead>{
            new Lead ( country_code__c = 'FR', product_interest__c = 'Meal Voucher', employee_range__c = '1 - 100', Company = 'Swile' )
        };

        Test.startTest();
        new LeadAssignmentService().assign(leadList);
        Test.stopTest();

        System.assertNotEquals(null, leadList[0].OwnerId, 'Assign failed: owner not set');
    }
}