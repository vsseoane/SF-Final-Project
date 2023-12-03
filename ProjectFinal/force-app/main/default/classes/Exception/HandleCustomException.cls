public with sharing class HandleCustomException extends Exception {
  public static void LogException(Exception e) {
    LogException(e, '');
  }

  public static void LogException(Exception e, string relatedToId) {
    try {
      String stackTrace = e.getStackTraceString().substringBefore('\n');
      String className = stackTrace.substringAfter('.').substringBefore('.');
      String methodName = stackTrace.substringBefore(':')
        .substringAfter(className)
        .substringAfter('.');

      CustomException__c exc = new CustomException__c();
      exc.Related_To_Number__c = relatedToId;
      exc.Exception_Message__c = e.getMessage();
      exc.Exception_Type__c = e.getTypeName();
      exc.Line_Number__c = e.getLineNumber();
      exc.StackTrace__c = e.getStackTraceString();
      exc.MethodName__c = methodName;
      exc.ClassName__c = className;
      exc.Date__c = DateTime.now();
      insert exc;
    } finally {
    }
  }
}
