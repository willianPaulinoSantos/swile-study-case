@isTest
public class SalesAssignmentOrchestratorTest {

    @isTest
    static void startAssignmentProcessTest_validLeadList() {
        List<SObject> mockLeads = new List<SObject>{
            new Lead(Id = '00Q000000000001', LastName = 'Test', Company = 'Test Co')
        };

        MockAssignmentService.wasCalled = false;
        AssignmentServiceFactory.testServiceOverrides.put(Lead.SObjectType, new MockAssignmentService());

        Test.startTest();
        SalesAssignmentOrchestrator.startAssignmentProcess(mockLeads);
        Test.stopTest();

        System.assert(MockAssignmentService.wasCalled, 'Expected assign method to be called');
    }
}