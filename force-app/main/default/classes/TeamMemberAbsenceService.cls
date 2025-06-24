public with sharing class TeamMemberAbsenceService {

    public static TeamMemberFilter filter = new TeamMemberFilter();

    public static void orchestrateTeamMembershipUpdate(List<Team_Member__c> teamMembersNewState, Map<Id, Team_Member__c> teamMembersOldState){

        List<Team_Member__c> filteredTeamMembersBecomingAbsence = filter.filterMembersBecomingAbscent(teamMembersNewState, teamMembersOldState);
        List<Team_Member__c> filteredTeamMembersReturningAbsence = filter.filterMembersReturningFromAbscense(teamMembersNewState, teamMembersOldState);
        Map<Id, Team_Member__c> teamMembersToUpdate = new Map<Id, Team_Member__c>();

        if(filteredTeamMembersReturningAbsence.isEmpty() && filteredTeamMembersBecomingAbsence.isEmpty()) {
            return;
        }

        if(!filteredTeamMembersReturningAbsence.isEmpty()){
            handleTeamMembersReturningAbsence(filteredTeamMembersReturningAbsence, teamMembersToUpdate);
        }

        if(!filteredTeamMembersBecomingAbsence.isEmpty()){
            handleTeamMembersBecomingAbsence(filteredTeamMembersBecomingAbsence);
        }
    }

    

    public static void handleTeamMembersBecomingAbsence(List<Team_Member__c> triggeredTeamMembers){

        updateTeamMembersAbsenceStatus(triggeredTeamMembers, true);

    }

    public static void handleTeamMembersReturningAbsence(List<Team_Member__c> triggeredTeamMembers, Map<Id, Team_Member__c> teamMembersToUpdate){

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

            for(Team_Member__c member : triggeredTeamMembers){

                if(usersTeamsMembershipMap.keySet().contains(member.Id)){
                    usersTeamsMembershipMap.remove(member.Id);
                }
                member.is_absent__c = true;
            }

            for(Team_Member__c member : usersTeamsMembershipMap.values()){
                member.is_absent__c = true;
            }

            update usersTeamsMembershipMap.values();

        } else {

            Map<Id, Team_Member__c> teamMembersToUpdate =  filter.filterMembersReturningFromAbscenseBasedOnMaximunProspectCount(usersTeamsMembershipMap, commercialTeamsMap);

            setCounterAfterAbscenceReturn(teamMembersToUpdate, commercialTeamsMap);

            for(Team_Member__c member : triggeredTeamMembers){

                if(teamMembersToUpdate.keySet().contains(member.Id)){
                    teamMembersToUpdate.remove(member.Id);
                }
                member.is_absent__c = false;
                member.prospects_count__c = commercialTeamsMap.get(member.commercial_team__c)?.maximum_prospects_count__c;
            }

            update teamMembersToUpdate.values();
        }
    }

    public static Map<Id, Team_Member__c> buildMembersWithTeamIdKeyMap(List<Team_Member__c> teamMembers){

        Map<Id, Team_Member__c> membersWithTeamIdKeyMap = new Map<Id, Team_Member__c>();

        for(Team_Member__c member : teamMembers){

            membersWithTeamIdKeyMap.put(member.commercial_team__c, member);
        }

        return membersWithTeamIdKeyMap;
    }

    public static void setCounterAfterAbscenceReturn(Map<Id, Team_Member__c> teamMembersToUpdate, Map<Id, Commercial_Team__c> commercialTeamsMap){

        if(teamMembersToUpdate.isEmpty()){
            return;
        }

        for(Team_Member__c member : teamMembersToUpdate.values()){

            member.prospects_count__c = commercialTeamsMap.get(member.commercial_team__c)?.maximum_prospects_count__c;
            member.is_absent__c = false;
        }
    }

    public static void setUsersTeamMembershipAsAbsent(Map<Id, Team_Member__c> teamMembersToUpdate){

        for(Team_Member__c member : teamMembersToUpdate.values()){
            member.is_absent__c = true;
        }
    }
}