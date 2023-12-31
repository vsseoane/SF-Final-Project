public with sharing class ucl_LegalAdvisorsService {
  @AuraEnabled
  public static Boolean migrateAllLegalAccounts() {
    HttpResponse response = new HttpResponse();
    Boolean successful = false;

    try {
      response = ucl_Utils.makeRequest(
        'https://altimetrik-bootcamp.herokuapp.com/',
        'LegalAccounts',
        'GET'
      );
      List<Object> legalAccountsObj = (List<Object>) JSON.deserializeUntyped(
        response.getBody()
      );

      if (legalAccountsObj.isEmpty()) {
        System.debug('legalAccounts is empty');
        return successful;
      }

      List<Legal_Accounts__c> legalAccounts = new List<Legal_Accounts__c>();

      Map<String, List<Client__c>> accountsNumbersWithClients = new Map<String, List<Client__c>>();

      for (Object obj : legalAccountsObj) {
        Map<String, Object> accountJson = (Map<String, Object>) obj;
        Legal_Accounts__c legalAccount = adaptAccountObj(accountJson);

        if (!shouldInsert(legalAccount))
          continue;

        legalAccounts.add(legalAccount);
        List<Object> clientsObj = (List<Object>) accountJson.get('Clients');
        if (!clientsObj.isEmpty()) {
          List<Client__c> clients = parseClientsFromAccount(clientsObj);
          accountsNumbersWithClients.put(
            legalAccount.Account_Number__c,
            clients
          );
        }
      }

      if (!legalAccounts.isEmpty()) {
        upsert legalAccounts Account_Number__c;
      }
      Map<String, Id> accountsReference = buildAccountsReference(legalAccounts);
      saveClients(accountsNumbersWithClients, accountsReference);

      successful = true;
    } catch (Exception e) {
      successful = false;
      ucl_HandleCustomException.LogException(e);
      System.debug('Error:' + e);
    }

    return successful;
  }

  private static Date parseDate(String dateString) {
    List<String> dateComponents = dateString.split('/');
    Integer month = Integer.valueOf(dateComponents[0]);
    Integer day = Integer.valueOf(dateComponents[1]);
    Integer year = Integer.valueOf(dateComponents[2]);
    Date dt = Date.newInstance(year, month, day);
    return dt;
  }

  private static Legal_Accounts__c adaptAccountObj(
    Map<String, Object> accountObj
  ) {
    Legal_Accounts__c legalAccount = new Legal_Accounts__c();
    legalAccount.Account_Number__c = (String) accountObj.get('AccountNumber');
    legalAccount.Name = (String) accountObj.get('AccountName');
    legalAccount.Account_Status__c = (String) accountObj.get('AccountStatus');
    legalAccount.As_of_Date__c = parseDate((String) accountObj.get('AsOfDate'));
    legalAccount.isMigrated__c = true;
    return legalAccount;
  }

  private static List<Client__c> parseClientsFromAccount(
    List<Object> clientsObj
  ) {
    List<Client__c> clients = new List<Client__c>();
    for (Object clientObj : clientsObj) {
      Map<String, Object> clientMap = (Map<String, Object>) clientObj;
      Client__c client = new Client__c();
      client.Address__c = (String) clientMap.get('Address');
      client.Email__c = (String) clientMap.get('Email');
      client.externalId__c = (String) clientMap.get('ClientNumber');
      client.Name = (String) clientMap.get('FirstName');
      client.Last_Name__c = (String) clientMap.get('LastName');
      client.Phone__c = (String) clientMap.get('Phone');
      client.isMigrated__c = true;
      clients.add(client);
    }
    return clients;
  }

  private static void saveClients(
    Map<String, List<Client__c>> accountsWithClients,
    Map<String, Id> accountsReference
  ) {
    List<Client__c> clientsToAdd = new List<Client__c>();

    for (String accountNumber : accountsWithClients.keySet()) {
      Id accountId = accountsReference.get(accountNumber);
      List<Client__c> clients = accountsWithClients.get(accountNumber);
      removeDeprecatedClients(accountId, clients);
      for (Client__c c : clients) {
        c.Legal_Advisor__c = accountId;
        clientsToAdd.add(c);
      }
    }

    if (!clientsToAdd.isEmpty()) {
      upsert clientsToAdd externalId__c;
    }
  }

  private static Map<String, Id> buildAccountsReference(
    List<Legal_Accounts__c> accounts
  ) {
    Map<String, Id> accountsReference = new Map<String, Id>();
    for (Legal_Accounts__c a : accounts) {
      accountsReference.put(a.Account_Number__c, a.Id);
    }
    return accountsReference;
  }

  private static Boolean shouldInsert(Legal_Accounts__c legalAccount) {
    Boolean shouldInsert = true;
    if (legalAccount.Account_Status__c == 'Disabled') {
      List<Legal_Accounts__c> tempAccount = [
        SELECT Id
        FROM Legal_Accounts__c
        WHERE
          Account_Status__c = 'Enabled'
          AND Account_Number__c = :legalAccount.Account_Number__c
      ]; //isMigrated__c = True AND
      if (tempAccount.isEmpty()) {
        shouldInsert = false;
      }
    }
    return shouldInsert;
  }

  private static void removeDeprecatedClients(
    Id accountId,
    List<Client__c> clientsToAdd
  ) {
    List<Client__c> previousClients = [
      SELECT Id
      FROM Client__c
      WHERE Legal_Advisor__c = :accountId AND isMigrated__c = TRUE
    ];
    if (previousClients == null) {
      return;
    }

    List<Client__c> clientsToRemove = new List<Client__c>();
    for (Client__c previousClient : previousClients) {
      if (!clientsToAdd.contains(previousClient)) {
        clientsToRemove.add(previousClient);
      }
    }

    if (!clientsToRemove.isEmpty()) {
      delete clientsToRemove;
    }
  }
}
