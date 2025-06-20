@isTest
public with sharing class AccountRepositoryTest {


     @testSetup
    static void setupData() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Acc 1', country_code__c = 'FR', employee_range__c = '1 - 100'),
            new Account(Name = 'Test Acc 2', country_code__c = 'BR', employee_range__c = '101 - 500')
        };
        insert accounts;
    }

    @isTest
    static void getAccountsMapByIdTest() {
        List<Account> accounts = [SELECT Id FROM Account];
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }

        AccountRepository repo = new AccountRepository();
        Map<Id, Account> result = repo.getAccountsMapById(accountIds);

        System.assertEquals(accountIds.size(), result.size(), 'Account map size mismatch');
        for (Id id : accountIds) {
            System.assert(result.containsKey(id), 'Expected ID not found in map');
        }
    }
}