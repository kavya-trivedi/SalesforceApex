trigger ContactBeforeEventListener on Contact (before insert, before update, before delete) {
    
    // THE GREAT PROBLEM: Whenever a contact is created with the Amount field, it should check for the Max Amount of its parent account, if it’s lower than Amount it should simply insert the contact record. But, if it’s greater then it should divide that amount field value and contacts should get created with this divided amount. It should happen the same whenever a contact is created/Updated/Deleted.

    if (Trigger.isInsert || Trigger.isUpdate) {
        List<Contact> conList = new List<Contact>();
        for (Contact c : Trigger.new) {
            conList.add(c);
        }

        Map<Id, Decimal> amountMap = new Map<Id, Decimal>();

        List<Account> accounts = [SELECT Id, Max_Amount__c FROM Account];
        
        List<Contact> contacts = [SELECT Id, AccountId, Amount__c FROM Contact WHERE Id IN :conList];

        Map<Id, Decimal> accountMaxAmountMap = new Map<Id, Decimal>();
        for (Account acc : accounts) {
            accountMaxAmountMap.put(acc.Id, acc.Max_Amount__c);
        }

        for (Contact con : contacts) {
            amountMap.put(con.Id, accountMaxAmountMap.get(con.AccountId));
        }

        System.debug('amountMap = ' + amountMap);

        List<Contact> contactsToInsert = new List<Contact>();
        for (Contact c : conList) {
            if (c.Amount__c > amountMap.get(c.Id)) {
                System.debug('Greater');
                Decimal maxAmount = amountMap.get(c.Id);
                Decimal newContactAmount = c.Amount__c - maxAmount;
                while (newContactAmount > maxAmount) {
                    contactsToInsert.add(new Contact(LastName = c.LastName+'_clone', Amount__c = maxAmount, AccountId = c.AccountId));
                    newContactAmount -= maxAmount;
                }
                contactsToInsert.add(new Contact(LastName = c.LastName+'_clone', Amount__c = newContactAmount, AccountId = c.AccountId));
                c.Amount__c = maxAmount;
            }
        }

        if (!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
        }
    }
}
