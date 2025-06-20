public with sharing class OpportunityTriggerHandler extends TriggerHandler{

    @testVisible
    List<Opportunity>  newOpportunities;
    Map<Id, Opportunity> oldOpportunities;

    public OpportunityTriggerHandler() {

        this ( (List<Opportunity>) Trigger.new, (Map<Id, Opportunity>) Trigger.oldMap);
    }

    public OpportunityTriggerHandler(List<Opportunity>  newOpportunities, Map<Id, Opportunity> oldOpportunities) {

        this.newOpportunities = newOpportunities;
        this.oldOpportunities = oldOpportunities;
    }

    
    public override void beforeInsert(){

        SalesAssignmentOrchestrator.startAssignmentProcess(newOpportunities);
    }
}