public with sharing class TeamMemberAbsenceService {

    public static TeamMemberFilter filter = new TeamMemberFilter();

    public static void setCounterAfterAbscenceReturn(List<Team_Member__c> teamMembersNewState, Map<Id, Team_Member__c> teamMembersOldState){

        List<Team_Member__c> filteredTeamMembers = filter.filterMembersReturningFromAbscense(teamMembersNewState, teamMembersOldState);
        Map<Id, Team_Member__c> membersWithTeamIdKeyMap = buildMembersWithTeamIdKeyMap(filteredTeamMembers);
        Map<Id, Commercial_Team__c> commercialTeamsMap = new CommercialTeamRepository().getTeamsByIds(membersWithTeamIdKeyMap.keySet());

        for(Team_Member__c member : filteredTeamMembers){

            member.prospects_count__c = commercialTeamsMap.get(member.commercial_team__c)?.maximum_prospects_count__c;
        }
    }

    public static Map<Id, Team_Member__c> buildMembersWithTeamIdKeyMap(List<Team_Member__c> teamMembers){

        Map<Id, Team_Member__c> membersWithTeamIdKeyMap = new Map<Id, Team_Member__c>();

        for(Team_Member__c member : teamMembers){

            membersWithTeamIdKeyMap.put(member.commercial_team__c, member);
        }

        return membersWithTeamIdKeyMap;
    }

}