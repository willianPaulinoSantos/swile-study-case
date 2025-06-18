public with sharing class LeadAssignmentService implements AssignmentInterface {

    CommercialTeamRepository commercialTeamRepository;

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

                List<Team_Member__c> sortedEligibleMembers = sortMembersByProspectsCountAscending(eligibleTeamMembers);
    
                lead.OwnerId = sortedEligibleMembers[0].user__c;
                sortedEligibleMembers[0].prospects_count__c += 1;
                teamMembersToUpdate.add(sortedEligibleMembers[0]);
            }
        }
    }

    public Map<string, Commercial_Team__c> buildCommercialTeamMap(List<Commercial_Team__c> teams){

        Map<string, Commercial_Team__c> commercialTeamMap = new Map<string, Commercial_Team__c>();

        for(Commercial_Team__c team : teams){
            commercialTeamMap.put(CompositeKeyBuilder.buildKey(team), team);
        }

        return commercialTeamMap;
    }

    private Map<string, Commercial_Team__c> getCommercialTeamWithMembersMap(){
        return buildCommercialTeamMap(commercialTeamRepository.getAllActiveTeamsWithTeamMembers());
    }

    private Boolean isValidList(List<Lead> leads){
        return leads != null && !leads.isEmpty();
    }

    private List<Team_Member__c> getElegibleTeamMembers(Commercial_Team__c team){
        List<Team_Member__c> eligibleMembers = new List<Team_Member__c>();

            for (Team_Member__c member : team.Team_Members__r) {
                if (!member.is_manager__c && !member.is_absent__c) {
                    eligibleMembers.add(member);
                }
            }
        
        if(eligibleMembers.isEmpty()) {
            return null;
        }

        return eligibleMembers;
    }

    private Boolean isThereAnyElegibleTeam(Commercial_Team__c team){
        if (team == null || team.Team_Members__r == null) {
                System.debug('No matching team found for Lead:');
                return false;
        }

        return true;
    }

    public List<Team_Member__c> sortMembersByProspectsCountAscending(List<Team_Member__c> teamMembers) {
        List<Team_Member__c> sortedTeamMembers = (List<Team_Member__c>) SObjectSortUtils.quickSortByNumericField(teamMembers, 'prospects_count__c');
        System.debug('Sorted members: ' + sortedTeamMembers);
        return sortedTeamMembers;
    }

    private Map<String, List<Team_Member__c>> buildEligibleMemberMap(Map<String, Commercial_Team__c> teamMap) {
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
}