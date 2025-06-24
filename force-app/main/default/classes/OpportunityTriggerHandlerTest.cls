@isTest
public with sharing class OpportunityTriggerHandlerTest {

    @testSetup
    static void setup() {
        User testUser = UserFixtureFactory.create();

        Commercial_Team__c team = CommercialTeamFixtureFactory.create();

        Team_Member__c elegibleMember = TeamMemberFixtureFactory.build(false, false, 0, team.Id, testUser.Id);
        elegibleMember.Name = 'This_Member_Receives_The_Opportunity';

        Team_Member__c loadedMember = TeamMemberFixtureFactory.build(false, false, 1, team.Id, testUser.Id);
        elegibleMember.Name = 'This_Member_Does_Not_Receives_The_Opportunity';

        insert new List<Team_Member__c>{ elegibleMember, loadedMember };

        insert new Account(country_code__c = 'FR', Name = 'Swile', employee_range__c = '1 - 100');
    }
    
    @isTest
    static void beforeInsertEndToEnd() {
        List<Team_Member__c> targetLeadOwner = [SELECT Id, Name, user__c FROM Team_Member__c WHERE prospects_count__c = 0];

        List<Account> accoun = [SELECT Id, Name, country_code__c, employee_range__c FROM Account LIMIT 1];

        Opportunity newOpportunity = new Opportunity ( Name = 'Test Opp', 
                                                        StageName = 'Qualification', 
                                                        CloseDate = DateTime.now().addDays(4).date(), 
                                                        product_interest__c = 'Meal Voucher', 
                                                        AccountId = accoun[0].Id);
        
        Test.startTest();
        insert newOpportunity;
        Test.stopTest();

        Opportunity insertedOpportunity = [SELECT Id, OwnerId FROM Opportunity WHERE AccountId =: accoun[0].Id];
        System.assertEquals(insertedOpportunity.OwnerId, targetLeadOwner[0].user__c , 'Lead OwnerId should have been assigned by trigger');
    }
}