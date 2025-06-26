public with sharing class TeamMemberFilter {

    public List<Team_Member__c> filterMembersBecomingAbscent(List<Team_Member__c> teamMembersNewState, Map<Id, Team_Member__c> teamMembersOldState){

        List<Team_Member__c> filteredTeamMembersAbscense = new List<Team_Member__c>();

        for(Team_Member__c member : teamMembersNewState){

            if(member.is_absent__c == true && teamMembersOldState.get(member.Id)?.is_absent__c == false){

                filteredTeamMembersAbscense.add(member);
            }
        }

        return filteredTeamMembersAbscense;
    }


    public List<Team_Member__c> filterMembersReturningFromAbscense(List<Team_Member__c> teamMembersNewState, Map<Id, Team_Member__c> teamMembersOldState){

        List<Team_Member__c> filteredTeamMembersReturningFromAbscense = new List<Team_Member__c>();

        for(Team_Member__c member : teamMembersNewState){

            if(member.is_absent__c == false && teamMembersOldState.get(member.Id)?.is_absent__c == true){

                filteredTeamMembersReturningFromAbscense.add(member);
            }
        }

        return filteredTeamMembersReturningFromAbscense;
    }
}