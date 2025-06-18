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

        for (Lead lead : leads) {
            String key = CompositeKeyBuilder.buildKey(lead);
            Commercial_Team__c team = commercialTeamMap.get(key);

            if(!isThereAnyElegibleTeam(team)) {
            return;
            }

            List<Team_Member__c> eligibleMembers = getElegibleTeamMembers(team);

            Team_Member__c assigned = eligibleMembers[0];
            lead.OwnerId = assigned.user__c;
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

    private List<Team_Member__c> sortByProspectsCountAsc(List<Team_Member__c> teamMembers) {
        // TO DO
        return teamMembers;
    }
}