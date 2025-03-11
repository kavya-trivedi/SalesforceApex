trigger AccountAfterEventListener on Account (after insert, after update) {

    if (Trigger.isUpdate) {

        // TASK 5: Write a trigger so that whenever an account name is modified, send an email notification to the contact of the Account.

        Set<Id> updatedAccountIds = new Set<Id>();
    
        // Collect Account IDs where the name is changed
        for (Account acc : Trigger.new) {
            Account oldAcc = Trigger.oldMap.get(acc.Id);

            if (oldAcc.Name != acc.Name) {
                updatedAccountIds.add(acc.Id);
            }
        }

        System.debug('updatedAccountIds = ' + updatedAccountIds);

        List<Account> acctsWithCons = new List<Account>(
        [SELECT Id, Name, (SELECT Id, LastName, Email FROM Contacts) FROM Account WHERE Id IN :updatedAccountIds]);

        List<String> relatedCons = new List<String>();

        for (Account a : acctsWithCons) {

            // Iterate over each contact and add to the list
            for (Contact c : a.Contacts) {
                if(c != null && c.Email != null) {
                    relatedCons.add(c.Email);
                    EmailManager.sendMail(c.Email, 'Account Name Modified', 'Hello ' + c.LastName + ',\n\nYour Account name has been modified!\n\nThank you for choosing Salesforce.');
                }
            }
        }
        System.debug('acctsWithCons = ' + acctsWithCons);
        System.debug('relatedCons = ' + relatedCons);


        // TASK 13: When the rating of an account is modified to Hot, share the record with Wilson using apex-based sharing rules.

        List<AccountShare> shares = new List<AccountShare>();

        for (Account acc : Trigger.new) {
            Account oldAcc = Trigger.oldMap.get(acc.Id);

            if(acc.Rating == 'Hot' && oldAcc.Rating != 'Hot') {
                AccountShare accShare = new AccountShare();
                accShare.AccountId = acc.Id;
                accShare.UserOrGroupId = [SELECT Id FROM User WHERE Name = 'Manager User' LIMIT 1].Id;
                accShare.AccountAccessLevel = 'Read';
                accShare.OpportunityAccessLevel = 'Read';

                System.debug('accShare = ' + accShare);
                shares.add(accShare);
            }
        }

        System.debug('shares = ' + shares);
        if (!shares.isEmpty()) {
            insert shares;
        }
    }

    if (Trigger.isInsert) {

        // TASK 10: Whenever a new account is created, create a new contact for the account with the same name as the account.

        List<Contact> conList = new List<Contact>();

        for (Account a : Trigger.new) {
            conList.add(new Contact(LastName = a.Name, AccountId = a.Id));
        }

        System.debug('Contact List = ' + conList);

        if (!conList.isEmpty()) {
            insert conList;
        }
    }
}