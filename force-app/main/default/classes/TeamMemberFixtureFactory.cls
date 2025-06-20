@isTest
public with sharing class TeamMemberFixtureFactory {


    public static Team_Member__c create(Team_Member__c specificTeam) {

        insert specificTeam;
        return specificTeam;
    }

    public static Team_Member__c create(Boolean isManager, Boolean isAbscent, Integer prospectsCount, Id commercialTeamId, Id userId) {

        Team_Member__c teamMember = new TeamMemberBuilder()
                                    .withIsManager(isManager)
                                    .withIsAbsent(isAbscent)
                                    .withProspectsCount(prospectsCount)
                                    .withCommercialTeamId(commercialTeamId)
                                    .withUserId(userId)
                                    .build();
        return create(teamMember);
    }

    public static Team_Member__c build(Boolean isManager, Boolean isAbscent, Integer prospectsCount, Id commercialTeamId, Id userId){

        return new TeamMemberBuilder()
                    .withIsManager(isManager)
                    .withIsAbsent(isAbscent)
                    .withProspectsCount(prospectsCount)
                    .withCommercialTeamId(commercialTeamId)
                    .withUserId(userId)
                    .build();
    }
}