public with sharing class AssignmentServiceFactory {

    public static Map<SObjectType, AssignmentInterface> testServiceOverrides = new Map<SObjectType, AssignmentInterface>();

    public static AssignmentInterface getService(SObjectType type) {

        if (testServiceOverrides.containsKey(type)) {
            
            return testServiceOverrides.get(type);
        }

        if (type == Lead.SObjectType) {
            
            return new LeadAssignmentService();
        }

        if (type == Opportunity.SObjectType) {
            
            return new OpportunityAssignmentService();
        }

        throw new AssignmentFactoryException('Unsupported object type: ' + String.valueOf(type));
    }

    public class AssignmentFactoryException extends Exception {}
}