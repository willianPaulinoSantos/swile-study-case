public with sharing class LeadAssignmentService extends AbstractAssignmentService implements AssignmentInterface {

    public void assign(List<Lead> leads) {

        Map<String, Commercial_Team__c> commercialTeamMap = getCommercialTeamWithMembersMap();
        Map<String, List<Team_Member__c>> teamMembersMap = buildEligibleMemberMap(commercialTeamMap);
        Map<Id, Team_Member__c> teamMembersToUpdate = new Map<Id, Team_Member__c>();

        for (Lead lead : leads) {
            String key = CompositeKeyBuilder.buildKey(lead);

            List<Team_Member__c> eligibleTeamMembers = teamMembersMap.get(key);

            if(!isValidList(eligibleTeamMembers)){
                continue;
            }

            List<Team_Member__c> sortedEligibleMembers = sortMembersByProspectsCountAscending(eligibleTeamMembers, FIELD_TO_SORT_BY);

            if(isTheElegibleNewOwnerTheCurrentOwner(sortedEligibleMembers, lead)){
                continue;
            }
            
            if(isReassignRequest()){

                handleReassignment(sortedEligibleMembers, lead, teamMembersToUpdate);
            }

            lead.OwnerId = sortedEligibleMembers[0].user__c;
            sortedEligibleMembers[0].prospects_count__c += 1;
            teamMembersToUpdate.put(sortedEligibleMembers[0].Id, sortedEligibleMembers[0]);
        }

        update teamMembersToUpdate.values();
    }
}