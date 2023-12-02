trigger ClientUniqueIdValidation on Client__c(before insert) {
  // Obtener los ExternalIds de los clientes que se están insertando
  Set<String> externalIds = new Set<String>();
  for (Client__c cliente : Trigger.new) {
    externalIds.add(cliente.ExternalId__c);
  }

  // Consultar por clientes existentes con los mismos ExternalIds
  List<Client__c> existingClients = [
    SELECT Id, ExternalId__c
    FROM Client__c
    WHERE ExternalId__c IN :externalIds
  ];

  // Verificar y lanzar un error si se encuentra un cliente existente
  for (Client__c newClient : Trigger.new) {
    for (Client__c existingClient : existingClients) {
      if (newClient.ExternalId__c == existingClient.ExternalId__c) {
        newClient.addError(
          'Ya existe un cliente con el mismo ExternalId: ' +
          newClient.ExternalId__c
        );
      }
    }
  }

}
