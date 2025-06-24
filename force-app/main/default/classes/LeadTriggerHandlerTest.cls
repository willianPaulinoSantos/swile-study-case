@isTest
private class LeadTriggerHandlerTest {

    @testSetup
    static void setup() {
        User testUser = UserFixtureFactory.create();

        Commercial_Team__c team = CommercialTeamFixtureFactory.create();

        Team_Member__c elegibleMember = TeamMemberFixtureFactory.build(false, false, 0, team.Id, testUser.Id);
        elegibleMember.Name = 'This_Member_Receives_The_Lead';

        Team_Member__c loadedMember = TeamMemberFixtureFactory.build(false, false, 1, team.Id, testUser.Id);
        elegibleMember.Name = 'This_Member_Does_Not_Receives_The_Lead';

        insert new List<Team_Member__c>{ elegibleMember, loadedMember };
    }

    @isTest
    static void beforeInsertEndToEnd() {
        
        List<Team_Member__c> targetLeadOwner = [SELECT Id, Name, user__c FROM Team_Member__c WHERE prospects_count__c = 0];

        Lead newLead = new Lead( country_code__c = 'FR', product_interest__c = 'Meal Voucher', employee_range__c = '1 - 100', Company = 'Swile', LastName = 'Test Lead' );
        
        Test.startTest();
        insert newLead;
        Test.stopTest();

        Lead insertedLead = [SELECT Id, OwnerId FROM Lead WHERE Company = 'Swile'];
        System.assertEquals(insertedLead.OwnerId, targetLeadOwner[0].user__c , 'Lead OwnerId should have been assigned by trigger');
    }
}
