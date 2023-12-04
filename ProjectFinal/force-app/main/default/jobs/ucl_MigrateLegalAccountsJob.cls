public with sharing class ucl_MigrateLegalAccountsJob implements Schedulable {
  public ucl_MigrateLegalAccountsJob() {
  }

  public void execute(SchedulableContext ctx) {
    try {
      ucl_LegalAdvisorsService.migrateAllLegalAccounts();
      System.debug('Job activated');
      ucl_Utils.sendEmailNotification(true, null);
    } catch (Exception e) {
      System.debug('Error ' + e);
      ucl_Utils.sendEmailNotification(false, e.getMessage());
    }
  }
}
