public class EmailManager {
    
    @AuraEnabled
    public static void sendMail(List<String> addresses, String subject, String body) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for (String address : addresses) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {address});
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
            emails.add(mail);
        }

        // Send the emails
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
        inspectResults(results);
    }

    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            } else {
                sendResult = false;
                System.debug('Errors occurred: ' + res.getErrors());
            }
        }
        return sendResult;
    }
}
