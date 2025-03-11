global class UpdateLeadBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select AnnualRevenue from Lead]);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> lList) {
        for (Lead l : lList) {
            if (l.annualRevenue == null) {
                l.annualRevenue = 1000000;
            }
        }
        update lList;
    }
    
    global void finish(Database.BatchableContext bc) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{'kavyabt24@gmail.com', 'kavyabtrivedi24@gmail.com'};
		mail.setToAddresses(toAddresses);
        mail.setSubject('CONGRATULATIONS! Batch Job is completed 🎉');
        mail.setPlainTextBody('Hey User, the Batch Job that you had started is successfully completed!');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
}