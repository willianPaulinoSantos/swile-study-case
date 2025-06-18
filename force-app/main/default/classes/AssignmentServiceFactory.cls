public with sharing class AssignmentServiceFactory {

    public static AssignmentInterface getService(SObjectType type) {

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