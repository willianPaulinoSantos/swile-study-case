@isTest
public with sharing class TeamMemberBuilderTest {
    @isTest
    static void TeamMemberBuildingTest() {

        Id commercialTeamTestId = TestFactoryHelper.getFakeId(Commercial_Team__c.SObjectType, 1);
        Id userTestId = TestFactoryHelper.getFakeId(User.SObjectType, 1);

        Test.startTest();

        Team_Member__c absentMember = new TeamMemberBuilder()
                                    .withIsManager(false)
                                    .withIsAbsent(true)
                                    .withProspectsCount(0)
                                    .withCommercialTeamId(commercialTeamTestId)
                                    .withUserId(userTestId)
                                    .build();

        Test.stopTest();

        System.AssertEquals(false, absentMember.is_manager__c, 'absent property wrongly setted');
        System.AssertEquals(true, absentMember.is_absent__c, 'absent property wrongly setted');
        System.AssertEquals(0, absentMember.prospects_count__c, 'prospect count property wrongly setted');
        System.AssertEquals(commercialTeamTestId, absentMember.commercial_team__c, 'commercial team property wrongly setted');
        System.AssertEquals(userTestId, absentMember.user__c, 'user property wrongly setted');


    }
}