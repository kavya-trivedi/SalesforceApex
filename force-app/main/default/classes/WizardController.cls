public with sharing class WizardController {
    
    @AuraEnabled(cacheable=true)
    public static List<SObject> getRecords(String objectName) {
        if (String.isEmpty(objectName)) {
            throw new AuraHandledException('Object Name is required');
        }

        if (objectName == 'Lead') {
            return [SELECT Id, Name, Email FROM Lead WHERE Email != NULL LIMIT 10];
        } else if (objectName == 'Account') {
            return [SELECT Id, Name, Email__c FROM Account WHERE Email__c IN ('kavyabt24@gmail.com', 'kavyabtrivedi24@gmail.com', 'trivedikavya024@gmail.com') LIMIT 10];
        } else if (objectName == 'Contact') {
            return [SELECT Id, Name, Email FROM Contact WHERE Email != NULL LIMIT 10];
        } else {
            throw new AuraHandledException('Invalid Object Name');
        }
    }
}
