
public with sharing class ucl_MigrateLegalAccountsJob implements Schedulable {
    public ucl_MigrateLegalAccountsJob() {

    }
    
    public void execute(SchedulableContext ctx) {
        try {
            ucl_LegalAdvisors.migrateAllLegalAccounts();
            System.debug('Job activated');
            ucl_Utils.sendEmailNotification(true, null, 'vsseoane@gmail.com');
        } catch(Exception e ) {
            System.debug('Error ' + e);
            ucl_Utils.sendEmailNotification(false, e.getMessage(), 'vsseoane@gmail.com');
        }
    }

}