public class CommercialTeamBuilder {

    Commercial_Team__c commercialTeam = new Commercial_Team__c ();
    private List<Team_Member__c> members = new List<Team_Member__c>();

    public CommercialTeamBuilder withCountry(String countryCode) {
        this.commercialTeam.country_code__c = countryCode;
        return this;
    }

    public CommercialTeamBuilder withProductInterest(String productInterest) {
        this.commercialTeam.product_interest__c = productInterest;
        return this;
    }

    public CommercialTeamBuilder withEmployeeRange(String employeeRange) {
        this.commercialTeam.employee_range__c = employeeRange;
        return this;
    }

    public CommercialTeamBuilder withId(String Id) {
        this.commercialTeam.Id = Id;
        return this;
    }

    public CommercialTeamBuilder withIsActive(Boolean isActive) {
        this.commercialTeam.is_active__c = isActive;
        return this;
    }

    public CommercialTeamBuilder withMockedId() {
        this.commercialTeam.Id = TestFactoryHelper.getFakeId(Commercial_Team__c.SObjectType, 1);
        return this;
    }

    public Commercial_Team__c build() {

        return this.commercialTeam;
    }
}
