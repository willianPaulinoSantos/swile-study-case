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
                teamMembersToUpdate.add( getLastOwner( sortedEligibleMembers, opp ) );
            }

            opp.OwnerId = sortedEligibleMembers[0].user__c;
            sortedEligibleMembers[0].prospects_count__c += 1;
            teamMembersToUpdate.add(sortedEligibleMembers[0]);

        }
        update new List<Team_Member__c>(teamMembersToUpdate);
    }

    public Set<Id> getAccountIds(List<Opportunity> opportunities){

        Set<Id> accountIds = new Set<Id>();

        for(Opportunity opp : opportunities){
            accountIds.add(opp.AccountId);
        }
        return accountIds;
    }
}