public with sharing class LeadAssignmentService extends AbstractAssignmentService implements AssignmentInterface {

    CommercialTeamRepository commercialTeamRepository;

    public static final string FIELD_TO_SORT_BY = 'prospects_count__c';

    public LeadAssignmentService() {
        this.commercialTeamRepository = new CommercialTeamRepository();
    }

    public void assign(List<Lead> leads) {

        if(!isValidList(leads)) {
            return;
        }

        Map<String, Commercial_Team__c> commercialTeamMap = getCommercialTeamWithMembersMap();

        Map<String, List<Team_Member__c>> teamMembersMap = buildEligibleMemberMap(commercialTeamMap);

        List<Team_Member__c> teamMembersToUpdate = new List<Team_Member__c>();

        for (Lead lead : leads) {
            String key = CompositeKeyBuilder.buildKey(lead);

            List<Team_Member__c> eligibleTeamMembers = teamMembersMap.get(key);

            if (eligibleTeamMembers != null && !eligibleTeamMembers.isEmpty()) {

                List<Team_Member__c> sortedEligibleMembers = sortMembersByProspectsCountAscending(eligibleTeamMembers, FIELD_TO_SORT_BY);
    
                lead.OwnerId = sortedEligibleMembers[0].user__c;
                sortedEligibleMembers[0].prospects_count__c += 1;
                teamMembersToUpdate.add(sortedEligibleMembers[0]);
            }
        }
    }
}