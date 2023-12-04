@isTest
private class TestHandleCustomEx {
  @isTest
  static void testLogEx() {
    Test.startTest();
    NullPointerException e = new NullPointerException();
    HandleCustomException.LogException(e);
    Test.stopTest();
    List<CustomException__c> logs = [SELECT Id FROM CustomException__c];
    System.assertNotEquals(
      0,
      logs.size(),
      'The method should return custom Exception/logs'
    );
  }

  @isTest
  static void testLogExString() {
    Test.startTest();
    NullPointerException e = new NullPointerException();
    ucl_HandleCustomException.LogException('This is an error');

    List<CustomException__c> logs = [
      SELECT Id
      FROM CustomException__c
    ];
    Test.stopTest();
    System.assertNotEquals(
      0,
      logs.size(),
      'The method should return custom Exception/logs'
    );
  }
}
