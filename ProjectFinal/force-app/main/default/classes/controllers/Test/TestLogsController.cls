@isTest
private class TestLogsController {
  @isTest
  static void testGetLogs() {
    CustomException__c customE = new CustomException__c(
      Exception_Message__c = 'This is a test',
      ClassName__c = 'TestLogsController',
      MethodName__c = 'testGetLogs',
      Line_Number__c = 34
    );
    insert customE;
    Test.startTest();
    List<CustomException__c> logs = ucl_LogsController.getLogs();
    Test.stopTest();
    System.assertNotEquals(0, logs.size(), 'The method should return logs');
  }
}
