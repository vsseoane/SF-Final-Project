@isTest
private class Test_ucl_LegalAdvisorsService {
  @isTest
  static void testMigrateAllLegalAccount() {
    Test.setMock(
      HttpCalloutMock.class,
      new MockHttpResponseGeneratorWithJSON()
    );
    Test.startTest();
    Boolean success = ucl_LegalAdvisorsService.migrateAllLegalAccounts();

    System.assertEquals(success, true, 'Expected migration to be successful');

    Test.stopTest();
  }

  @isTest
  static void testMigrateAllLegalAccountWithRepeatedClient() {
    Test.setMock(
      HttpCalloutMock.class,
      new MockHttpResponseGeneratorWithJSON()
    );
    Legal_Accounts__c account = createAccount();
    upsert account;
    Client__c client1 = createClient(account.id);
    upsert client1;

    Test.startTest();
    Boolean success = ucl_LegalAdvisorsService.migrateAllLegalAccounts();

    List<Client__c> clients = [
      SELECT Id, Legal_Advisor__c, Name
      FROM Client__c
      WHERE Legal_Advisor__c = :account.id
    ];
    System.assertEquals(
      clients.size(),
      2,
      'The clients should be deleted since it is deprecated, it is not coming in the JSON'
    );
    Test.stopTest();
  }

  @isTest
  static void testMigrateAllLegalAccountWithJSONEmpty() {
    Test.setMock(
      HttpCalloutMock.class,
      new MockHttpResponseGeneratorWithJSONEmpty()
    );
    Test.startTest();
    Boolean success = ucl_LegalAdvisorsService.migrateAllLegalAccounts();

    System.assertEquals(success, false, 'Expected migration to be successful');

    Test.stopTest();
  }

  public static Client__c createClient(Id accountId) {
    Client__c client = new Client__c();
    client.isMigrated__c = true;
    client.Legal_Advisor__c = accountId;
    client.Name = 'ClientDeprecated';
    client.externalId__c = '232323232';
    return client;
  }

  public static Legal_Accounts__c createAccount() {
    Legal_Accounts__c account = new Legal_Accounts__c();
    account.Account_Number__c = '00000001';
    account.Name = 'AccountName';
    account.Account_Status__c = 'Enabled';
    account.isMigrated__c = true;
    return account;
  }
}
