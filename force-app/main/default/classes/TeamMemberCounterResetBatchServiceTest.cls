@IsTest
public class TeamMemberCounterResetBatchServiceTest {

    @TestSetup
    static void setup(){
        List<Team_Member__c> teamMembers = new List<Team_Member__c>();

        Commercial_Team__c team = CommercialTeamFixtureFactory.create();

        for (Integer i = 0; i < 10; i++) {
            teamMembers.add(new Team_Member__c(prospects_count__c = 10, commercial_team__c = team.Id));
        }

        insert teamMembers;
    }

    @IsTest
    static void testResetCounters() {

        Test.startTest();

        List<Team_Member__c> teamMembers = [SELECT Id, prospects_count__c FROM Team_Member__c];
        TeamMemberCounterResetBatchService service = new TeamMemberCounterResetBatchService();
        List<Team_Member__c> updatedTeamMembers = service.resetCounters(teamMembers);

        Test.stopTest();

        for (Team_Member__c member : updatedTeamMembers) {
            System.assertEquals(0, member.prospects_count__c, 'Counter should be reset to 0');
        }
    }
}
