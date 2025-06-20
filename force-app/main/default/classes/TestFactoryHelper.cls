@isTest
public class TestFactoryHelper {
    
    public static String getFakeId(Schema.SObjectType sobjectType, Integer value) {
        String result = String.valueOf(value++);
        return sobjectType.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }

    public static void createCommercialTeamWithMembers(){

        Commercial_Team__c team = CommercialTeamFixtureFactory.create();

        User u = UserFixtureFactory.create();

        Team_Member__c elegibleMember = TeamMemberFixtureFactory.build(false, false, 3, team.Id, u.Id);


        Team_Member__c secondElegibleMember = TeamMemberFixtureFactory.build(false, false, 3, team.Id, u.Id);

        Team_Member__c manager = TeamMemberFixtureFactory.build(true, false, 0, team.Id, u.Id);

        Team_Member__c absentMember = TeamMemberFixtureFactory.build(false, true, 0, team.Id, u.Id);

        insert new List<Team_Member__c>{elegibleMember, secondElegibleMember, manager, absentMember};
    }

}