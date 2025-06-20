@isTest
public with sharing class TeamMemberAbsenceServiceTest {

    static Integer maxProspectsCountInTheTeam = 5;
    static Integer minProspectsCountInTheTeam = 0;

    @TestSetup
    static void setup(){
        Commercial_Team__c team = CommercialTeamFixtureFactory.create();
        User testUser = UserFixtureFactory.create();
        Team_Member__c mostAssignedMember = TeamMemberFixtureFactory.build(false, true, maxProspectsCountInTheTeam, team.Id, testUser.Id);
        Team_Member__c absentMember = TeamMemberFixtureFactory.build(false, true, minProspectsCountInTheTeam, team.Id, testUser.Id);

        insert new List<Team_Member__c>{mostAssignedMember, absentMember};
    }

    @isTest
    static void setCounterAfterAbscenceReturnTest() {

        Map<Id, Team_Member__c> teamMembersOldState = new Map<Id, Team_Member__c> ( [SELECT Id, prospects_count__c, is_absent__c, commercial_team__c, is_manager__c 
                                                                                    FROM Team_Member__c 
                                                                                    ORDER BY prospects_count__c ASC] );

        List<Team_Member__c> teamMembersNewState = new List<Team_Member__c>();

        for (Team_Member__c oldMember : teamMembersOldState.values()) {
            Team_Member__c newMember = oldMember.clone(true, true, false, false);
            teamMembersNewState.add(newMember);
        }

        Team_Member__c memberThatReturnedFromAbscense = teamMembersNewState[0];

        memberThatReturnedFromAbscense.is_absent__c = false;

        Test.startTest();
        TeamMemberAbsenceService.setCounterAfterAbscenceReturn(teamMembersNewState, teamMembersOldState);
        Test.stopTest();

        System.assertEquals(maxProspectsCountInTheTeam, teamMembersNewState[0]?.prospects_count__c, 'Prospects count should be aligned with the highest counter in the team');
    }

    @isTest
    static void buildMembersWithTeamIdKeyMapTest(){
        List<Team_Member__c> teamMembers = [SELECT Id, commercial_team__c FROM Team_Member__c];

        Test.startTest();
        Map<Id, Team_Member__c> membersWithTeamIdKeyMap = TeamMemberAbsenceService.buildMembersWithTeamIdKeyMap(teamMembers);
        Test.stopTest();

        for(Team_Member__c teamMember : teamMembers){

            System.Assert.isTrue(membersWithTeamIdKeyMap.containsKey(teamMember.commercial_team__c), 'The map should contain the key: ' + teamMember.commercial_team__c);
        }
    }
}