public with sharing class ErrorLog {
    public static void handleException() {
        try {
            Error_log__c m = new Error_log__c();
            insert m;
            System.debug('No exceptions occured');
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        System.debug('Statement after insert.');
    }
}