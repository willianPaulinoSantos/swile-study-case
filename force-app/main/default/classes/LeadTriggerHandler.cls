public with sharing class LeadTriggerHandler extends TriggerHandler{

    @testVisible
    List<Lead> newLeads;
    Map<Id, Lead> oldLeads;
    LeadAssignmentService leadAssignmentService;


    public LeadTriggerHandler() {

        this ( (List<Lead>) Trigger.new, (Map<Id, Lead>) Trigger.oldMap);
    }

    public LeadTriggerHandler(List<Lead> newLeads, Map<Id, Lead> oldLeads) {
        this.newLeads = newLeads;
        this.oldLeads = oldLeads;
        this.leadAssignmentService = new LeadAssignmentService();
        
    }

    public override void beforeInsert() {
        
       leadAssignmentService.assign(newLeads);
    }
}