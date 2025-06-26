public with sharing class OpportunityAssignmentService extends AbstractAssignmentService implements AssignmentInterface{

    public AccountRepository accountRepository = new AccountRepository();
     
    public void assign(List<Opportunity> opportunities) {

        Map<Id, Account> accountMap = accountRepository.getAccountsMapById(getAccountIds(Opportunities));
        Map<String, Commercial_Team__c> commercialTeamMap = getCommercialTeamWithMembersMap();
        Map<String, List<Team_Member__c>> teamMembersMap = buildEligibleMemberMap(commercialTeamMap);
        Map<Id, Team_Member__c> teamMembersToUpdate = new Map<Id, Team_Member__c>();

        for (Opportunity opp : Opportunities) {
            String key = CompositeKeyBuilder.buildKey(opp, accountMap.get(opp.accountId));

            List<Team_Member__c> eligibleTeamMembers = teamMembersMap.get(key);

            if(!isValidList(eligibleTeamMembers)){
                continue;
            }

            List<Team_Member__c> sortedEligibleMembers = sortMembersByProspectsCountAscending(eligibleTeamMembers, FIELD_TO_SORT_BY);

            if(isTheElegibleNewOwnerTheCurrentOwner(sortedEligibleMembers, opp)){
                continue;
            }

            if(isReassignRequest()){

                handleReassignment(sortedEligibleMembers, opp, teamMembersToUpdate);
            }

            opp.OwnerId = sortedEligibleMembers[0].user__c;
            sortedEligibleMembers[0].prospects_count__c += 1;
            teamMembersToUpdate.put(sortedEligibleMembers[0].Id, sortedEligibleMembers[0]);

        }
        update teamMembersToUpdate.values();
    }

    public Set<Id> getAccountIds(List<Opportunity> opportunities){

        Set<Id> accountIds = new Set<Id>();

        for(Opportunity opp : opportunities){
            accountIds.add(opp.AccountId);
        }
        return accountIds;
    }
}