@IsTest
public class TeamMemberCounterResetBatchTest {

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
    public static void testBatchExecution() {

        Test.startTest();
        TeamMemberCounterResetBatch batch = new TeamMemberCounterResetBatch();
        Id jobId = Database.executeBatch(batch);
        Test.stopTest();

        List<Team_Member__c> updatedTeamMembers = [SELECT Id, prospects_count__c FROM Team_Member__c];

        for (Team_Member__c member : updatedTeamMembers) {
            System.assertEquals(0, member.prospects_count__c, 'Counter should be reset to 0');
        }
    }
}
