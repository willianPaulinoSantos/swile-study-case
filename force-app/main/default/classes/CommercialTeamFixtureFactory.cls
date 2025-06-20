@isTest
public with sharing class CommercialTeamFixtureFactory {


    public static Commercial_Team__c create(Commercial_Team__c specificCommercialTeam){

        insert specificCommercialTeam;
        return specificCommercialTeam;
    }

    public static Commercial_Team__c create() {

        Commercial_Team__c standardTeam = new CommercialTeamBuilder()
                                    .withCountry('FR')
                                    .withProductInterest('Meal Voucher')
                                    .withEmployeeRange('1 - 100')
                                    .withIsActive(true)
                                    .build();

        return create(standardTeam);
    }
}