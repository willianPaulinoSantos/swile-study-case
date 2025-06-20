public with sharing class LeadTriggerHandler extends TriggerHandler{

    @testVisible
    List<Lead> newLeads;
    Map<Id, Lead> oldLeads;


    public LeadTriggerHandler() {

        this ( (List<Lead>) Trigger.new, (Map<Id, Lead>) Trigger.oldMap);
    }

    public LeadTriggerHandler(List<Lead> newLeads, Map<Id, Lead> oldLeads) {
        this.newLeads = newLeads;
        this.oldLeads = oldLeads;
        
    }

    public override void beforeInsert() {
        
        SalesAssignmentOrchestrator.startAssignmentProcess(newLeads);
    }
}