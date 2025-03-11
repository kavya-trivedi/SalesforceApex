// Create a batch class that will run every day at 9 AM and update all account description fields to the current date and time.

public with sharing class BatchClass2 implements Database.Batchable<sObject>, Schedulable {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Description FROM Account
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts) {
        List<Account> accountsToUpdate = new List<Account>();

        for (Account a : accounts) {
            a.Description = System.now().format();
            accountsToUpdate.add(a);
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch Job Completed!');
    }

    public void execute(SchedulableContext sc) {
        BatchClass2 bc2 = new BatchClass2();
        Database.executeBatch(bc2);
    }
}