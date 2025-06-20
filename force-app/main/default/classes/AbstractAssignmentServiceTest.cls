@isTest
private class AbstractAssignmentServiceTest {

    private class TestAssignmentService extends AbstractAssignmentService implements AssignmentInterface {
        public void assign(List<SObject> records) {
            // No-op for test
        }
    }

    @testSetup
    static void setup() {
        Commercial_Team__c team = new CommercialTeamBuilder()
                                    .withCountry('FR')
                                    .withProductInterest('Meal Voucher')
                                    .withEmployeeRange('1 - 100')
                                    .withIsActive(true)
                                    .build();

        insert team;

        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User u = new User(
                FirstName = 'Test',
                LastName = 'User',
                Alias = 'tuser',
                Email = 'testuser@example.com',
                Username = 'testuser_' + DateTime.now().getTime() + '@example.com',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                ProfileId = p.Id
                );
        insert u;

        List<Team_Member__c> teamMembers = new List<Team_Member__c>();

        Team_Member__c elegibleMember = new TeamMemberBuilder()
                                    .withIsManager(false)
                                    .withIsAbsent(false)
                                    .withProspectsCount(3)
                                    .withCommercialTeamId(team.Id)
                                    .withUserId(u.Id)
                                    .build();

        Team_Member__c secondElegibleMember = new TeamMemberBuilder()
                                    .withIsManager(false)
                                    .withIsAbsent(false)
                                    .withProspectsCount(0)
                                    .withCommercialTeamId(team.Id)
                                    .withUserId(u.Id)
                                    .build();

        Team_Member__c manager = new TeamMemberBuilder()
                                    .withIsManager(true)
                                    .withIsAbsent(false)
                                    .withProspectsCount(0)
                                    .withCommercialTeamId(team.Id)
                                    .withUserId(u.Id)
                                    .build();

        Team_Member__c absentMember = new TeamMemberBuilder()
                                    .withIsManager(false)
                                    .withIsAbsent(true)
                                    .withProspectsCount(0)
                                    .withCommercialTeamId(team.Id)
                                    .withUserId(u.Id)
                                    .build();

        teamMembers.add(elegibleMember);
        teamMembers.add(manager);
        teamMembers.add(absentMember);

        insert teamMembers;
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
