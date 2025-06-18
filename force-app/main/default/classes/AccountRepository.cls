public with sharing class AccountRepository {

    public Map<Id, Account> getAccountsMapById(Set<Id> accountIds) {
        return new Map<Id, Account>(
            [SELECT Id, Name, country_code__c, employee_range__c FROM Account WHERE Id IN :accountIds]
        );
    }
}