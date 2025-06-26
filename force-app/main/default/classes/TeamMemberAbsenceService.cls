public with sharing class TeamMemberAbsenceService {

    public static TeamMemberFilter filter = new TeamMemberFilter();

    public static void orchestrateTeamMembershipUpdate(List<Team_Member__c> teamMembersNewState, Map<Id, Team_Member__c> teamMembersOldState){

        List<Team_Member__c> filteredTeamMembersBecomingAbsence = filter.filterMembersBecomingAbscent(teamMembersNewState, teamMembersOldState);
        List<Team_Member__c> filteredTeamMembersReturningAbsence = filter.filterMembersReturningFromAbscense(teamMembersNewState, teamMembersOldState);

        if(filteredTeamMembersReturningAbsence.isEmpty() && filteredTeamMembersBecomingAbsence.isEmpty()) {
            return;
        }

        if(!filteredTeamMembersReturningAbsence.isEmpty()){
            handleTeamMembersReturningAbsence(filteredTeamMembersReturningAbsence);
        }

        if(!filteredTeamMembersBecomingAbsence.isEmpty()){
            handleTeamMembersBecomingAbsence(filteredTeamMembersBecomingAbsence);
        }
    }

    

    public static void handleTeamMembersBecomingAbsence(List<Team_Member__c> triggeredTeamMembers){

        updateTeamMembersAbsenceStatus(triggeredTeamMembers, true);

    }

    public static void handleTeamMembersReturningAbsence(List<Team_Member__c> triggeredTeamMembers){

        updateTeamMembersAbsenceStatus(triggeredTeamMembers, false);
       
    }

    public static void updateTeamMembersAbsenceStatus(List<Team_Member__c> triggeredTeamMembers, Boolean isBecomingAbsence){
        Map<Id, Team_Member__c> teamMemberByUserIdMap = new Map<Id, Team_Member__c>();

        for(Team_Member__c member : triggeredTeamMembers){
            teamMemberByUserIdMap.put(member.user__c, member);
        }

        Map<Id, Team_Member__c> usersTeamsMembershipMap = new TeamMemberRepository().findByUserIds(teamMemberByUserIdMap.keySet());
        Map<Id, Team_Member__c> membersWithTeamIdKeyMap = buildMembersWithTeamIdKeyMap(usersTeamsMembershipMap.values());
        Map<Id, Commercial_Team__c> commercialTeamsMap = new CommercialTeamRepository().getTeamsByIds(membersWithTeamIdKeyMap.keySet());
        
        if(isBecomingAbsence){

            setUsersTeamMembershipAsAbsent(usersTeamsMembershipMap);

            removeTriggeredRecordsFromTeamMembership(triggeredTeamMembers, usersTeamsMembershipMap);

            update usersTeamsMembershipMap.values();

        } else {

            setCounterAfterAbscenceReturn(usersTeamsMembershipMap, commercialTeamsMap, triggeredTeamMembers);

            removeTriggeredRecordsFromTeamMembership(triggeredTeamMembers, usersTeamsMembershipMap);

            update usersTeamsMembershipMap.values();
        }
    }

    public static Map<Id, Team_Member__c> buildMembersWithTeamIdKeyMap(List<Team_Member__c> teamMembers){

        Map<Id, Team_Member__c> membersWithTeamIdKeyMap = new Map<Id, Team_Member__c>();

        for(Team_Member__c member : teamMembers){

            membersWithTeamIdKeyMap.put(member.commercial_team__c, member);
        }

        return membersWithTeamIdKeyMap;
    }

    public static void setCounterAfterAbscenceReturn(Map<Id, Team_Member__c> usersTeamsMembershipMap, Map<Id, Commercial_Team__c> commercialTeamsMap, List<Team_Member__c> triggeredTeamMembers){

        if(usersTeamsMembershipMap.isEmpty()){
            return;
        }

        for(Team_Member__c member : usersTeamsMembershipMap.values()){

            member.prospects_count__c = commercialTeamsMap.get(member.commercial_team__c)?.maximum_prospects_count__c;
            member.is_absent__c = false;
        }

        for(Team_Member__c member : triggeredTeamMembers){

            member.prospects_count__c = commercialTeamsMap.get(member.commercial_team__c)?.maximum_prospects_count__c;
        }
    }

    public static void setUsersTeamMembershipAsAbsent(Map<Id, Team_Member__c> usersTeamsMembershipMap){

        for(Team_Member__c member : usersTeamsMembershipMap.values()){
            member.is_absent__c = true;
        }
    }

    public static void removeTriggeredRecordsFromTeamMembership(List<Team_Member__c> triggeredTeamMembers, Map<Id, Team_Member__c> usersTeamsMembershipMap){

        for(Team_Member__c member : triggeredTeamMembers){

            if(usersTeamsMembershipMap.keySet().contains(member.Id)){
                usersTeamsMembershipMap.remove(member.Id);
            }
        }
    }
}