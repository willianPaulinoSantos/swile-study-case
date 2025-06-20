@isTest
public class TestFactoryHelper {
    
    public static String getFakeId(Schema.SObjectType sobjectType, Integer value) {
        String result = String.valueOf(value++);
        return sobjectType.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }

}