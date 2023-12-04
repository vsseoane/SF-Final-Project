public with sharing class ucl_Utils {
  @AuraEnabled
  @future(callout=true)
  public static void sendEmailNotification(
    Boolean isSuccess,
    String errorMessage
  ) {
    try {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

      String email = getSystemAdministratorEmail();
      if (email == '') {
        email = 'vsseoane@gmail.com';
      }

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
      System.debug('Email sent to ' + email);
    } catch (Exception e) {
      ucl_HandleCustomException.LogException(e);
      System.debug('Error:' + e);
    }
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
      throw new ucl_HandleCustomException(
        'Error' + response.getStatusCode() + ' ' + response.getStatus()
      );
    }
    return response;
  }

  private static String getSystemAdministratorEmail() {
    String emailToReturn = '';
    Profile sys_adm_profile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'System Administrator'
    ];
    List<User> sys_adm = [
      SELECT id, Email
      FROM User
      WHERE ProfileId = :sys_adm_profile.Id
    ];

    emailToReturn = sys_adm[0]?.Email;
    System.debug('emailToreturn ' + emailToReturn);
    return emailToReturn;
  }
}
