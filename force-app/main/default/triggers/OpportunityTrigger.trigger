trigger OpportunityTrigger on Opportunity (before insert) {

    new OpportunityTriggerHandler().run();
}