public with sharing class ucl_MigrateLegalAccountsJob implements Schedulable {
    public ucl_MigrateLegalAccountsJob() {

    }
    
    public void execute(SchedulableContext ctx) {
        try {
            ucl_LegalAdvisors l = new ucl_LegalAdvisors();
            l.migrateAllLegalAccounts();
            System.debug('Job activated');
            sendEmailNotification(true, null, 'vsseoane@gmail.com');
        } catch(Exception e ) {
            System.debug('Error ' + e);
            sendEmailNotification(false, e.getMessage(), 'vsseoane@gmail.com');
        }
    }

    private void sendEmailNotification(Boolean isSuccess, String errorMessage, String email) {
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