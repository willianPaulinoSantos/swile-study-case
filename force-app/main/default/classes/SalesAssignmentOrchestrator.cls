public with sharing class SalesAssignmentOrchestrator {

    public static void startAssignmentProcess(List<SObject> records){
        
        if(!isValidList(records)) {
            return;
        }

        orchestrateAssignmentServices(records);
    }

    private static Boolean isValidList(List<SObject> records) {

        return records != null && !records.isEmpty();
    }

    @InvocableMethod(label='Do Assignment' description='Assigns owner to records')
    public static void orchestrateAssignmentServices(List<SObject> records) {
        try {

            SObjectType objectType = records[0].getSObjectType();
            AssignmentInterface service = AssignmentServiceFactory.getService(objectType);
            service.assign(records);

        } catch (Exception e) {

            throw new SalesAssignmentOrchestratorException('Assignment Error: ' + e.getMessage());
        }
    }

    public class SalesAssignmentOrchestratorException extends Exception {}
}