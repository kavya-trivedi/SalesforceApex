trigger AccountBeforeEventListener on Account (before insert, before update) {
    
    if (Trigger.isInsert) {
    
        // TASK 7: Write a trigger to prefix the account name with Mr., or Mrs. whenever a new record is inserted.
        for (Account a : Trigger.new) {
            a.Name = 'Mr/Mrs. ' + a.Name;
        }

        // TASK 12: Write a trigger so that whenever a new record is created into an Account object before this new record is inserted delete the accounts with the same name.
        
        Set<String> accNames = new Set<String>();
        for (Account a : Trigger.new) {
            accNames.add(a.Name);
            System.debug('Account Name = ' + a.Name);
        }

        Account[] accToDel = [SELECT Id, Name FROM Account WHERE Name IN :accNames];
        System.debug('Accounts to Delete = ' + accToDel);

        if (!accToDel.isEmpty()) {
            delete accToDel;
        }
    }
}
