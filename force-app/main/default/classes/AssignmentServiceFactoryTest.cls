@isTest
public class AssignmentServiceFactoryTest {

    @isTest
    static void getServiceTest_Lead() {
        
        SObjectType leadType = Lead.SObjectType;

        Test.startTest();

        AssignmentInterface leadService = AssignmentServiceFactory.getService(leadType);
        System.assertNotEquals(null, leadService, 'Did not return any service');
        System.assertEquals(true, leadService instanceof LeadAssignmentService, 'wrong instance');

        Test.stopTest();
    }

    @isTest
    static void getServiceTest_Opportunity() {
        
        SObjectType oppType = Opportunity.SObjectType;

        Test.startTest();

        AssignmentInterface oppService = AssignmentServiceFactory.getService(oppType);
        System.assertNotEquals(null, oppService, 'Did not return any service');
        System.assertEquals(true, oppService instanceof OpportunityAssignmentService,'wrong instance');

        Test.stopTest();
    }

    @isTest
    static void getServiceTest_unsupportedType() {
        
        SObjectType customType = Account.SObjectType;

        Test.startTest();
        Boolean exceptionThrown = false;
        try {
            AssignmentServiceFactory.getService(customType);
        } catch (AssignmentServiceFactory.AssignmentFactoryException ex) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assertEquals(true, exceptionThrown, 'Expected exception for unsupported SObjectType');
    }
} 
