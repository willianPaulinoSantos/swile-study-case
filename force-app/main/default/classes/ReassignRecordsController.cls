public with sharing class ReassignRecordsController {

    public static final String LEAD_API_NAME = String.valueOf(Lead.SObjectType);
    public static final String OPPORTUNITY_API_NAME = String.valueOf(Opportunity.SObjectType);

    private LeadAssignmentService leadAssignmentService;
    private OpportunityAssignmentService opportunityAssignmentService;

    public ReassignRecordsController(){
        this.leadAssignmentService = new LeadAssignmentService();
        this.opportunityAssignmentService = new OpportunityAssignmentService();
    }

     @AuraEnabled
    public static void reassignOwners(Id recordId, String objectApiName) {

        if (recordId == null) {
            return;
        }
        orchestrateAssignment(objectApiName, recordId);
    }

    private static void orchestrateAssignment(String objectApiName, Id recordId){

        if( objectApiName == LEAD_API_NAME ) {

            List<Lead> leadList = new LeadRepository().getLeadById(recordId);
            new LeadAssignmentService().assign(leadList);

            updateRecords(leadList);
        }

        if( objectApiName == OPPORTUNITY_API_NAME ) {

            List<Opportunity> opportunityList = new OpportunityRepository().getOpportunityById(recordId);
            new OpportunityAssignmentService().assign(opportunityList);

            updateRecords(opportunityList);
        }
    }

    public static void updateRecords(List<SObject> records){
        try{

            update records;

        } catch (Exception e){

            throw new ReassignRecordsControllerException('error when reassingning records. Error message: ' + e.getMessage());
        }
    }

    public class ReassignRecordsControllerException extends Exception{}

}