@isTest
public class MockAssignmentService implements AssignmentInterface {
        
    public static Boolean wasCalled = false;
    public static void assign(List<SObject> records) {
        wasCalled = true;
    }
}