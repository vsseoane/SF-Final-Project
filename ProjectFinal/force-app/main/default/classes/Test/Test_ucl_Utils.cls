@isTest
private class Test_ucl_Utils {
  @isTest
  static void testGetSystemAdministratorEmail() {
    Test.startTest();
    Profile sysAdmProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'System Administrator'
      LIMIT 1
    ];
    String emailToTest = 'test@example.com';
    User sysAdmUser = new User(
      FirstName = 'Test',
      LastName = 'User',
      Email = emailToTest,
      UserName = 'user12@test1234.com',
      Alias = 'us',
      TimeZoneSidKey = 'America/Montevideo',
      LocaleSidKey = 'en_AU',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      ProfileId = sysAdmProfile.Id
    );
    insert sysAdmUser;

    List<String> result = ucl_Utils.getSystemAdministratorEmail();
    Test.stopTest();

    System.assert(
      result.contains(emailToTest),
      'Expected email does not match'
    );
  }

  @isTest
  static void testmakeRequest() {
    Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorOk());

    Test.startTest();
    HttpResponse response = ucl_Utils.makeRequest(
      'https://url.com',
      '/resource',
      'GET'
    );
    Test.stopTest();

    System.assertEquals(
      200,
      response.getStatusCode(),
      'Expected status code does not match'
    );
  }

  @isTest
  static void testmakeRequestWithError() {
    Test.setMock(
      HttpCalloutMock.class,
      new MockHttpResponseGeneratorError(404)
    );

    Test.startTest();

    try {
      HttpResponse response = ucl_Utils.makeRequest(
        'https://url.com',
        '/resource',
        'GET'
      );
      System.assert(false, 'Exception not thrown as expected');
    } catch (ucl_HandleCustomException ex) {
      System.assertEquals(
        'Error404 Not Found',
        ex.getMessage(),
        'Exception message does not match'
      );
    }
    Test.stopTest();
  }
}
