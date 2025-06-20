@isTest
public with sharing class TeamMemberTriggerHandlerTest {

    static Integer maxProspectsCountInTheTeam = 5;
    static Integer minProspectsCountInTheTeam = 0;

    @TestSetup
    static void setup(){
        
        Commercial_Team__c team = CommercialTeamFixtureFactory.create();
        User testUser = UserFixtureFactory.create();
        Team_Member__c mostAssignedMember = TeamMemberFixtureFactory.build(false, false, maxProspectsCountInTheTeam, team.Id, testUser.Id);
        Team_Member__c absentMember = TeamMemberFixtureFactory.build(false, true, minProspectsCountInTheTeam, team.Id, testUser.Id);

        insert new List<Team_Member__c>{mostAssignedMember, absentMember};
    }

    @isTest
    static void beforeUpdateEndToEnd() {

        List<Team_Member__c> teamMembers = getTeamMembers();

        Team_Member__c returningFromAbsenceMember = teamMembers[0];
        returningFromAbsenceMember.is_absent__c = false;

        Test.startTest();
        update returningFromAbsenceMember;
        Test.stopTest();

        List<Team_Member__c> teamMembersAfterUpdate = getTeamMembers();
                              
        System.assertEquals(teamMembersAfterUpdate[0].prospects_count__c, maxProspectsCountInTheTeam, 'Counter not aligned with the highest team counter');
        System.assertEquals(teamMembersAfterUpdate[0].is_absent__c, false, 'Assignment should be reversed');
    }

    static List<Team_Member__c> getTeamMembers(){
        return [SELECT Id, prospects_count__c, is_absent__c, commercial_team__c, is_manager__c 
                FROM Team_Member__c
                ORDER BY prospects_count__c ASC];
    }
}