public with sharing class ucl_Utils {
  @AuraEnabled
  public static void sendEmailNotification(
    Boolean isSuccess,
    String errorMessage,
    String email
  ) {
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    String[] toAddresses = new List<String>{ email };
    mail.setToAddresses(toAddresses);

    mail.setSubject(
      isSuccess
        ? 'The Legal Account Migration Job was Successful'
        : 'The Legal Account Migration Job was Failed'
    );

    String body = isSuccess
      ? 'Migration Legal Account Successful'
      : 'The MigrateLegalAccounts Job has encountered an error. Error Message: ' +
        errorMessage;

    mail.setPlainTextBody(body);
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }

  public static HttpResponse makeRequest(
    String url,
    String uriResource,
    String verb
  ) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(url + uriResource);
    request.setMethod(verb);
    HttpResponse response = http.send(request);
    Integer successful = 200;
    if (response.getStatusCode() != successful) {
      System.debug(
        'Error: ' + response.getStatusCode() + ' ' + response.getStatus()
      );
      throw new HandleCustomException(
        'Error' + response.getStatusCode() + ' ' + response.getStatus()
      );
    }
    return response;
  }
}
