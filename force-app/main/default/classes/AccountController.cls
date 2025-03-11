public with sharing class AccountController {
    @AuraEnabled(cacheable=true)  // Allows LWC to call this method
    public static List<Account> getAccounts() {
        return [SELECT Id, Name FROM Account];
    }

    @AuraEnabled(cacheable=true)  // Exposing to LWC
    public static Map<String, List<sObject>> getContactsAndOpportunities(Id accountId) {
        Map<String, List<sObject>> result = new Map<String, List<sObject>>();
        result.put('contacts', [SELECT Id, Name FROM Contact WHERE AccountId = :accountId]);
        result.put('opportunities', [SELECT Id, Name FROM Opportunity WHERE AccountId = :accountId]);
        return result;
    }
}
