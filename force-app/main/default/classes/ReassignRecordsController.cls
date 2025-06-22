public with sharing class ReassignRecordsController {

    public static final String LEAD_API_NAME = String.valueOf(Lead.SObjectType);
    public static final String OPPORTUNITY_API_NAME = String.valueOf(Opportunity.SObjectType);

     @AuraEnabled
    public static void reassignOwners(Id recordId, String objectApiName) {

        if (recordId == null) {
            return;
        }

        List<SObject> records = orchestrateQuery(objectApiName, recordId);

        SalesAssignmentOrchestrator.startAssignmentProcess(records);
        update records;
    }

    private static List<SObject> orchestrateQuery(String objectApiName, Id recordId){

        List<SObject> recordList = new List<SObject>();

        if( objectApiName == LEAD_API_NAME ) {

             recordList.add( new LeadRepository().getLeadById(recordId) );
        }

        if( objectApiName == OPPORTUNITY_API_NAME ) {

             recordList.add( new OpportunityRepository().getOpportunityById(recordId) );
        }

        return recordList;
    }

}