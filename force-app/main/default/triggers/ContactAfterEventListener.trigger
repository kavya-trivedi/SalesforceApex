trigger ContactAfterEventListener on Contact (after delete, after insert, after update, after undelete) {

    if (RecursiveTriggerHandler.isFirstTime) {
        RecursiveTriggerHandler.isFirstTime = false;

        if(Trigger.isDelete) {
    
            // TASK 8: Whenever contact is deleted, delete the corresponding account records.
            Set<Id> accId = new Set<Id>();
            for(Contact c : Trigger.old) {
                accId.add(c.AccountId);
            }
            System.debug('accId = ' + accId);
            Account[] accList = [SELECT Id FROM Account WHERE ID IN :accId];
            System.debug('accList = ' + accList);
            if(!accList.isEmpty()) {
                delete accList;
            }
        }
    
        // if (Trigger.isInsert) {
    
        //     // TASK 11: Whenever a new contact is created, create an event related to that contact. {PENDING}
    
        //     List<Event> eventList = new List<Event>();
    
        //     for (Contact c : Trigger.new) {
        //         eventList.add(new Event(Subject = 'Meeting', WhatId = c.Id));
        //     }
    
        //     System.debug('Event List = ' + eventList);
    
        //     if (!eventList.isEmpty()) {
        //         insert eventList;
        //     }
        // }
    
    
        // ROLLUP SUMMARY: Create a field - “Total Amount” in the Account Object, and another field - “Amount” in the Contact object. The “Total Amount” field will store the rollup of all the related contacts. Write a trigger so that whenever values are added/modified to the “Amount” field in Contact, It should update “Total Amount” to its associated parent Account. It should happen at the same time while deleting the contacts.
    
        Set<Id> accountIds = new Set<Id>();
        if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
            for (Contact con : Trigger.new) {
                if(con.AccountId != null) {
                    accountIds.add(con.AccountId);
                }
            }
        }
    
        if (Trigger.isDelete) {
            for (Contact con : Trigger.old) {
                if(con.AccountId != null) {
                    accountIds.add(con.AccountId);
                }
            }
        }
    
        if (!accountIds.isEmpty()) {
                
            List<AggregateResult> totalAmountList = [SELECT Account.Id, SUM(Amount__c) totalAmount FROM Contact WHERE Account.Id IN :accountIds GROUP BY Account.Id];
            System.debug('accountTotalAmounts = ' + totalAmountList);
    
            Map<Id, Decimal> accountTotalAmounts = new Map<Id, Decimal>();
    
            for (Integer i = 0; i < totalAmountList.size(); i++) {
                accountTotalAmounts.put(totalAmountList[i].Id, (Decimal)totalAmountList[i].get('totalAmount'));
            }
            System.debug('accountTotalAmounts = ' + accountTotalAmounts);
    
            List<Account> updatedAccList = [SELECT Id, Total_Amount__c FROM Account WHERE Id IN :accountIds];
            System.debug('updatedAccList1 = ' + updatedAccList);
    
            for (Account acc : updatedAccList) {
                acc.Total_Amount__c = accountTotalAmounts.get(acc.Id);
            }
            System.debug('updatedAccList2 = ' + updatedAccList);
    
            if (!updatedAccList.isEmpty()) {
                update updatedAccList;
            }
        }
    
    
        // SHEEP PROBLEM: Write a trigger so that whenever Contact is updated, It should update all contacts related to its parent Account with the name of Account.
    
        if (Trigger.isUpdate) {
    
            Map<Id, Id> OldToNewAccountMap = new Map<Id, Id>();
            
            for (Contact con : Trigger.new) {
                Contact oldCon = Trigger.oldMap.get(con.Id);
    
                if (con.AccountId != oldCon.AccountId && oldCon.AccountId != null && con.AccountId != null) {
                    oldToNewAccountMap.put(oldCon.AccountId, con.AccountId);
                }
            }
            System.debug('oldToNewAccountMap = ' + oldToNewAccountMap);
    
            Contact[] contactsToUpdate = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId IN :OldToNewAccountMap.keySet()];
            System.debug('contactsToUpdate = ' + contactsToUpdate);
    
            for (Contact cu : contactsToUpdate) {
                if (oldToNewAccountMap.containsKey(cu.AccountId)) {
                    System.debug('Contains Key!');
                    cu.AccountId = oldToNewAccountMap.get(cu.AccountId);
                }
            }
            System.debug('contactsToUpdate = ' + contactsToUpdate);
    
            if (!contactsToUpdate.isEmpty()) {
                update contactsToUpdate;
            }
        }
    }
}
