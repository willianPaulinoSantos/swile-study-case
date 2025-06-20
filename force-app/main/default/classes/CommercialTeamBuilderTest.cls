@isTest
public with sharing class CommercialTeamBuilderTest {
    @isTest
    static void commercialTeamBuildingTest() {

        Id commercialTeamMockedId = TestFactoryHelper.getFakeId(Commercial_Team__c.SObjectType, 1);

        Test.startTest();

        Commercial_Team__c commercialTeam = new CommercialTeamBuilder()
                                            .withEmployeeRange('1 - 100')
                                            .withCountry('FR')
                                            .withProductInterest('Meal Voucher')
                                            .withId(commercialTeamMockedId)
                                            .build();

        Test.stopTest();

        System.AssertEquals('1 - 100', commercialTeam.employee_range__c, 'Build the object with wrong EmployeeRange reference');
        System.AssertEquals('FR', commercialTeam.country_code__c, 'Build the object with wrong country reference');
        System.AssertEquals('Meal Voucher', commercialTeam.product_interest__c, 'Build the object with wrong product reference');
        System.AssertEquals(commercialTeam.Id, commercialTeamMockedId, 'Build the object with wrong Id reference');
    }
}