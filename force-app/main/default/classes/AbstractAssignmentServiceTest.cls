@isTest
private class AbstractAssignmentServiceTest {

    private class TestAssignmentService extends AbstractAssignmentService implements AssignmentInterface {
        public void assign(List<SObject> records) {
            // No-op for test
        }
    }

    @testSetup
    static void setup() {
        TestFactoryHelper.createCommercialTeamWithMembers();
    }

    @isTest
    static void getCommercialTeamWithMembersMapTest() {

        List<Commercial_Team__c> teams = getTeams();


        TestAssignmentService service = new TestAssignmentService();
        Map<String, Commercial_Team__c> teamMap = service.buildCommercialTeamMap(teams);

        System.assertEquals(false, teamMap.isEmpty(), 'Expected non-empty team map');
    }

    @isTest
    static void buildEligibleMemberMapTest() {

        List<Commercial_Team__c> teams = getTeams();

        TestAssignmentService service = new TestAssignmentService();

        Map<String, Commercial_Team__c> teamMap = service.buildCommercialTeamMap(teams);

        Test.startTest();
        Map<String, List<Team_Member__c>> eligibleMap = service.buildEligibleMemberMap(teamMap);
        Test.stopTest();

        System.assert(!eligibleMap.isEmpty(), 'Expected eligible members map');

        for (List<Team_Member__c> members : eligibleMap.values()) {
            System.assertEquals(1, members.size(), 'Expected one eligible team member');
        }
    }

    @isTest
    static void sortMembersByProspectsCountAscendingTest() {

        List<Commercial_Team__c> teams = getTeams();

        TestAssignmentService service = new TestAssignmentService();
        List<Team_Member__c> sorted = service.sortMembersByProspectsCountAscending(teams[0].Team_Members__r, 'prospects_count__c');

        System.assertEquals(0, sorted[0].prospects_count__c, 'Expected lowest prospects_count__c first');
        System.assertEquals(0, sorted[1].prospects_count__c, 'Expected second lowest prospects_count__c');
        System.assertEquals(3, sorted[2].prospects_count__c, 'Expected second lowest prospects_count__c');
    }

    static List<Commercial_Team__c> getTeams(){
        return new CommercialTeamRepository().getAllActiveTeamsWithTeamMembers();
    }
}
