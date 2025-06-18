public with sharing class AssignmentServiceFactory {
    public static AssignmentInterface getService(SObjectType type) {
        if (type == Lead.SObjectType) {
            System.debug('object type indentifying is working');
            return new LeadAssignmentService();
        }
        if (type == Opportunity.SObjectType) {
            //return new OpportunityAssignmentService();
            System.debug('working with Opportunity');
        }
        throw new AssignmentFactoryException('Unsupported object type: ' + String.valueOf(type));
    }

    public class AssignmentFactoryException extends Exception {}
}