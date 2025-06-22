public with sharing abstract class AbstractAssignmentService {
    
    public CommercialTeamRepository commercialTeamRepository = new CommercialTeamRepository();
    public static final string FIELD_TO_SORT_BY = 'prospects_count__c';

    public Boolean isValidList(List<SObject> records) {

        return records != null && !records.isEmpty();
    }

    public virtual Map<string, Commercial_Team__c> getCommercialTeamWithMembersMap(){

        return buildCommercialTeamMap(commercialTeamRepository.getAllActiveTeamsWithTeamMembers());
    }

    public virtual Map<string, Commercial_Team__c> buildCommercialTeamMap(List<Commercial_Team__c> teams){

        Map<string, Commercial_Team__c> commercialTeamMap = new Map<string, Commercial_Team__c>();

        for(Commercial_Team__c team : teams){
            commercialTeamMap.put(CompositeKeyBuilder.buildKey(team), team);
        }

        return commercialTeamMap;
    }

    public virtual Map<String, List<Team_Member__c>> buildEligibleMemberMap(Map<String, Commercial_Team__c> teamMap) {
        Map<String, List<Team_Member__c>> result = new Map<String, List<Team_Member__c>>();

        for (String key : teamMap.keySet()) {

            Commercial_Team__c team = teamMap.get(key);
            List<Team_Member__c> members = new List<Team_Member__c>();

            for (Team_Member__c member : team.Team_Members__r) {
                if (!member.is_manager__c && !member.is_absent__c) {
                    members.add(member);
                }
            }

            result.put(key, members);
        }
        return result;
    }

    public virtual List<Team_Member__c> sortMembersByProspectsCountAscending(List<Team_Member__c> teamMembers, String fieldApiName) {
        
        List<Team_Member__c> sortedTeamMembers = (List<Team_Member__c>) SObjectSortUtils.bubbleSortByNumericField(teamMembers, fieldApiName);

        return sortedTeamMembers;
    }

    public Boolean isReassignRequest(){
        return !Trigger.isExecuting;
    }

    public virtual List<Team_Member__c> decrementProspectCountOnReassignment(List<Team_Member__c> teamMembers, SObject oldRecordState){

        Id oldOwnerId = (Id) oldRecordState.get('OwnerId');

        List<Team_Member__c> listWithTheOldOwner = new List<Team_Member__c>();

        for(Team_Member__c teamMember : teamMembers){
            if(teamMember.user__c == oldOwnerId){
                teamMember.prospects_count__c -= 1;
                listWithTheOldOwner.add(teamMember);
            }
        }
        return listWithTheOldOwner;
    }

    public Team_Member__c getLastOwner(List<Team_Member__c> teamMembers, SObject oldRecordState){

        List<Team_Member__c> listWithTheOldOwner = decrementProspectCountOnReassignment(teamMembers, oldRecordState);

        if(listWithTheOldOwner.isEmpty()){
            return null;
        }

        return listWithTheOldOwner[0];
    }
    
    public Boolean isTheElegibleNewOwnerTheCurrentOwner(List<Team_Member__c> teamMembers, SObject record){

        Id oldOwnerId = (Id) record.get('OwnerId');

        if(teamMembers[0].user__c == oldOwnerId){
            return true;
        }
        return false;
    }
}