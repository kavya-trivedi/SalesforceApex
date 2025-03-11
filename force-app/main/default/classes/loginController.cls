public with sharing class loginController {
    public String myEmail {get; set;}
    public String myPassword {get; set;}
    public PageReference doLogin() {
        try {
            MyAccount__c[] record = [Select Name from myaccount__c where (email__c=:myEmail and password__c=:myPassword) limit 1];
            return Page.WelcomePage;
        } catch (Exception e) {
            system.debug(e);
            return null;
        }
    }
}