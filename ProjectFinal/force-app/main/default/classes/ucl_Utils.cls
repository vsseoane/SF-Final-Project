public with sharing class ucl_Utils {

    @AuraEnabled
    public static void sendEmailNotification(Boolean isSuccess, String errorMessage, String email) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        String[] toAddresses = new String[]{email}; 
        mail.setToAddresses(toAddresses);

        mail.setSubject(isSuccess ? 'The Legal Account Migration Job was Successful' : 'The Legal Account Migration Job was Failed');

        String body = isSuccess
            ? 'Migration Legal Account Successful'
            : 'The MigrateLegalAccounts Job has encountered an error. Error Message: ' + errorMessage;

        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}