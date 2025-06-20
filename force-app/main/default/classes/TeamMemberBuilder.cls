public class TeamMemberBuilder {

    private Team_Member__c newTeamMember = new Team_Member__c();

    public TeamMemberBuilder withIsManager(Boolean value) {
        this.newTeamMember.is_manager__c = value;
        return this;
    }

    public TeamMemberBuilder withIsAbsent(Boolean value) {
        this.newTeamMember.is_absent__c = value;
        return this;
    }

    public TeamMemberBuilder withProspectsCount(Integer count) {
        this.newTeamMember.prospects_count__c = count;
        return this;
    }

    public TeamMemberBuilder withCommercialTeamId(Id teamId) {
        this.newTeamMember.commercial_team__c = teamId;
        return this;
    }

    public TeamMemberBuilder withUserId(Id userId) {
        this.newTeamMember.user__c = userId;
        return this;
    }

    public TeamMemberBuilder withMockedId() {
        this.newTeamMember.Id = TestFactoryHelper.getFakeId(Team_Member__c.SObjectType, 1);
        return this;
    }

    public Team_Member__c build() {
        return this.newTeamMember;
    }
}