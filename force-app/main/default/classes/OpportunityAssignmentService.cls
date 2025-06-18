public with sharing class OpportunityAssignmentService extends AbstractAssignmentService implements AssignmentInterface{

    public AccountRepository accountRepository = new AccountRepository();
     
    public void assign(List<Opportunity> opportunities) {

        if(!isValidList(Opportunities)) {
            return;
        }

        Map<Id, Account> accountMap = accountRepository.getAccountsMapById(getAccountIds(Opportunities));

        Map<String, Commercial_Team__c> commercialTeamMap = getCommercialTeamWithMembersMap();

        Map<String, List<Team_Member__c>> teamMembersMap = buildEligibleMemberMap(commercialTeamMap);

        List<Team_Member__c> teamMembersToUpdate = new List<Team_Member__c>();

        for (Opportunity currentOpportunity : Opportunities) {
            String key = CompositeKeyBuilder.buildKey(currentOpportunity, accountMap.get(currentOpportunity.accountId));

            List<Team_Member__c> eligibleTeamMembers = teamMembersMap.get(key);

            if (eligibleTeamMembers != null && !eligibleTeamMembers.isEmpty()) {

                List<Team_Member__c> sortedEligibleMembers = sortMembersByProspectsCountAscending(eligibleTeamMembers, FIELD_TO_SORT_BY);
    
                currentOpportunity.OwnerId = sortedEligibleMembers[0].user__c;
                sortedEligibleMembers[0].prospects_count__c += 1;
                teamMembersToUpdate.add(sortedEligibleMembers[0]);
            }
        }
    }

    public Set<Id> getAccountIds(List<Opportunity> opportunities){

        Set<Id> accountIds = new Set<Id>();

        for(Opportunity currentOpportunity : opportunities){
            accountIds.add(currentOpportunity.AccountId);
        }
        return accountIds;
    }
}