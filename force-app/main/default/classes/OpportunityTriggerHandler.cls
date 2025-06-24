public with sharing class OpportunityTriggerHandler extends TriggerHandler{

    @testVisible
    List<Opportunity>  newOpportunities;
    Map<Id, Opportunity> oldOpportunities;
    OpportunityAssignmentService opportunityAssignmentService;

    public OpportunityTriggerHandler() {

        this ( (List<Opportunity>) Trigger.new, (Map<Id, Opportunity>) Trigger.oldMap);
    }

    public OpportunityTriggerHandler(List<Opportunity>  newOpportunities, Map<Id, Opportunity> oldOpportunities) {

        this.newOpportunities = newOpportunities;
        this.oldOpportunities = oldOpportunities;
        this.opportunityAssignmentService = new OpportunityAssignmentService();
    }

    
    public override void beforeInsert(){

        opportunityAssignmentService.assign(newOpportunities);
    }
}