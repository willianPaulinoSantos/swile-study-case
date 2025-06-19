@isTest
public class SObjectSortUtilsTest {

    @isTest
    static void leadQuickSortByNumericFieldTestWi() {
        List<SObject> mockList = new List<SObject>();
        mockList.add(new Lead(AnnualRevenue = 15));
        mockList.add(new Lead(AnnualRevenue = 5));
        mockList.add(new Lead(AnnualRevenue = 10));

        List<SObject> sortedList = SObjectSortUtils.quickSortByNumericField(mockList, 'AnnualRevenue');

        System.assertEquals(5, sortedList[0].get('AnnualRevenue'), 'Not properly sorted');
        System.assertEquals(10, sortedList[1].get('AnnualRevenue'), 'Not properly sorted');
        System.assertEquals(15, sortedList[2].get('AnnualRevenue'), 'Not properly sorted');
    }

        @isTest
    static void teamMemberQuickSortByNumericFieldTest() {
        List<SObject> mockList = new List<SObject>();
        mockList.add(new Team_Member__c(prospects_count__c = 15));
        mockList.add(new Team_Member__c(prospects_count__c = 5));
        mockList.add(new Team_Member__c(prospects_count__c = 10));

        List<SObject> sortedList = SObjectSortUtils.quickSortByNumericField(mockList, 'prospects_count__c');

        System.assertEquals(5, sortedList[0].get('prospects_count__c'), 'Not properly sorted');
        System.assertEquals(10, sortedList[1].get('prospects_count__c'), 'Not properly sorted');
        System.assertEquals(15, sortedList[2].get('prospects_count__c'), 'Not properly sorted');
    }

     @isTest
    static void teamMemberBubbleSortByNumericFieldTest() {
        List<SObject> mockList = new List<SObject>();
        mockList.add(new Team_Member__c(prospects_count__c = 30));
        mockList.add(new Team_Member__c(prospects_count__c = 10));
        mockList.add(new Team_Member__c(prospects_count__c = 20));

        List<SObject> sortedList = SObjectSortUtils.bubbleSortByNumericField(mockList, 'prospects_count__c');

        System.assertEquals(10, sortedList[0].get('prospects_count__c'), 'Not properly sorted');
        System.assertEquals(20, sortedList[1].get('prospects_count__c'), 'Not properly sorted');
        System.assertEquals(30, sortedList[2].get('prospects_count__c'), 'Not properly sorted');
    }

    @isTest
    static void opportunityBubbleSortByNumericFieldTest() {
        List<SObject> mockList = new List<SObject>();
        mockList.add(new Opportunity(Amount = 30));
        mockList.add(new Opportunity(Amount = 10));
        mockList.add(new Opportunity(Amount = 20));

        List<SObject> sortedList = SObjectSortUtils.bubbleSortByNumericField(mockList, 'Amount');

        System.assertEquals(10, sortedList[0].get('Amount'), 'Not properly sorted');
        System.assertEquals(20, sortedList[1].get('Amount'), 'Not properly sorted');
        System.assertEquals(30, sortedList[2].get('Amount'), 'Not properly sorted');
    }
} 
