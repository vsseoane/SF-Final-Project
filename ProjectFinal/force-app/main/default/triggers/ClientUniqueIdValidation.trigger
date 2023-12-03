trigger ClientUniqueIdValidation on Client__c(before insert) {
  Set<String> externalIds = new Set<String>();
  Set<String> accountIds = new Set<String>();
  for (Client__c client : Trigger.new) {
    externalIds.add(client.ExternalId__c);
    accountIds.add(client.Legal_Advisor__c);
  }

  List<Client__c> existingClients = [
    SELECT Id, ExternalId__c
    FROM Client__c
    WHERE ExternalId__c IN :externalIds AND Legal_Advisor__c IN :accountIds
  ];

  for (Client__c newClient : Trigger.new) {
    for (Client__c existingClient : existingClients) {
      if (newClient.ExternalId__c == existingClient.ExternalId__c) {
        HandleCustomException.LogException(
          'There is already a client with the same ExternalId : ' +
          newClient.ExternalId__c
        );
        newClient.addError(
          'There is already a client with the same ExternalId : ' +
          newClient.ExternalId__c
        );
      }
    }
  }

}
