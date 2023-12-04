@isTest
private class TestClientUniqueIdValidationTrigg {
  @isTest
  static void TestClientUniqueIdValidationTriggNoDuplicates() {
    Test.startTest();
    Legal_Accounts__c legalAccount1 = createLegalAccount1();
    Legal_Accounts__c legalAccount2 = createLegalAccount2();
    List<Client__c> clients = new List<Client__c>();
    clients.add(
      new Client__c(ExternalId__c = '123', Legal_Advisor__c = legalAccount1.Id)
    );
    clients.add(
      new Client__c(ExternalId__c = '456', Legal_Advisor__c = legalAccount2.Id)
    );

    insert clients;
    Test.stopTest();
    for (Client__c client : clients) {
      System.assert(
        client.Id != null,
        'Record should be inserted successfully'
      );
    }
  }

  @isTest
  static void TestClientUniqueIdValidationTriggDuplicatesDifferentAcc() {
    Test.startTest();

    Legal_Accounts__c legalAccount1 = createLegalAccount1();
    Legal_Accounts__c legalAccount2 = createLegalAccount2();
    List<Client__c> clients = new List<Client__c>();
    clients.add(
      new Client__c(ExternalId__c = '123', Legal_Advisor__c = legalAccount1.Id)
    );
    clients.add(
      new Client__c(ExternalId__c = '123', Legal_Advisor__c = legalAccount2.Id)
    );

    insert clients;
    Test.stopTest();
    for (Client__c client : clients) {
      System.assert(
        client.Id != null,
        'Record should be inserted successfully'
      );
    }
  }

  @isTest
  static void TestClientUniqueIdValidationTriggDuplicatesSameAccount() {
    Legal_Accounts__c legalAccount1 = createLegalAccount1();
    Client__c client1 = new Client__c(
      ExternalId__c = '12',
      Legal_Advisor__c = legalAccount1.Id
    );
    Client__c client2 = new Client__c(
      ExternalId__c = '12',
      Legal_Advisor__c = legalAccount1.Id
    );

    Test.startTest();
    insert client1;
    Database.SaveResult result = Database.insert(client2, false);
    System.assert(!result.isSuccess());
    System.assertEquals(
      'There is already a client with the same ExternalId : 12',
      result.getErrors()[0].getMessage()
    );
    Test.stopTest();
  }

  private static Legal_Accounts__c createLegalAccount1() {
    Legal_Accounts__c legalAccount = new Legal_Accounts__c();
    legalAccount.Name = 'LegalAdvisor 1';
    legalAccount.Account_Status__c = 'Enabled';
    legalAccount.Account_Number__c = '001';
    insert legalAccount;
    return legalAccount;
  }

  private static Legal_Accounts__c createLegalAccount2() {
    Legal_Accounts__c legalAccount2 = new Legal_Accounts__c();
    legalAccount2.Name = 'LegalAdvisor 2';
    legalAccount2.Account_Status__c = 'Enabled';
    legalAccount2.Account_Number__c = '002';
    insert legalAccount2;
    return legalAccount2;
  }
}
