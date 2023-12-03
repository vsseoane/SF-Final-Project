public with sharing class LogsController {
  @AuraEnabled(cacheable=true)
  public static List<CustomException__c> getLogs() {
    return [
      SELECT Exception_Message__c, ClassName__c, MethodName__c, Line_Number__c
      FROM CustomException__c
      WITH SECURITY_ENFORCED
    ];
  }
}
