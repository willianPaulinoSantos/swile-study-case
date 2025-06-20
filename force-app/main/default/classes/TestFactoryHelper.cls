@isTest
public class TestFactoryHelper {
    
    public static String getFakeId(Schema.SObjectType sobjectType, Integer value) {
        String result = String.valueOf(value++);
        return sobjectType.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }

    public static void createCommercialTeamWithMembers(){
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

}