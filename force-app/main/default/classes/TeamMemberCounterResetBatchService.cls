public with sharing class TeamMemberCounterResetBatchService {

    public static final Integer PROSPECT_COUNT_RESET_VALUE = 0;

    public List<Team_Member__c> resetCounters(List<Team_Member__c> teamMembers){

        for(Team_Member__c teamMember : teamMembers){
            teamMember.prospects_count__c = PROSPECT_COUNT_RESET_VALUE; 
        }

        update teamMembers;
        return teamMembers;
    }
}