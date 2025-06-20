@isTest
public with sharing class CommercialTeamRepositoryTest {


    @TestSetup
    static void setup(){
        TestFactoryHelper.createCommercialTeamWithMembers();
    }
    
    @isTest
    static void getAllActiveTeamsWithTeamMembersTest() {

        List<Commercial_Team__c> teams = [SELECT Id, Name, maximum_prospects_count__c, country_code__c, employee_range__c, product_interest__c,
                (SELECT Id, Name, user__c, is_absent__c, is_manager__c, prospects_count__c FROM Team_Members__r ORDER BY prospects_count__c ASC)
                FROM Commercial_Team__c 
                WHERE is_active__c = True];

        Test.startTest();

        List<Commercial_Team__c> retrievedTeams = new CommercialTeamRepository().getAllActiveTeamsWithTeamMembers();

        Test.stopTest();

        System.assertEquals(teams.size(), retrievedTeams.size(), 'Teams not queried properly');
        System.assertEquals(teams[0].Team_Members__r.size(), retrievedTeams[0].Team_Members__r.size(), 'Team members not queried properly');
    }
}