public with sharing class LegalAccountMigrationService {

    public LegalAccountMigrationService() { }

    public HttpResponse getAllLegalAccounts() {
        HttpResponse response = makeGetRequest();
        try {

            if(response.getStatusCode() != 200) {
                System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
                return response;
            }
            
            List<Object> legalAccountsObj = (List<Object>) JSON.deserializeUntyped(response.getBody());
            if(legalAccountsObj.isEmpty()) {
                System.debug('legalAccounts is empty');
                return response;
            }

            List<Legal_Accounts__c> legalAccounts = new List<Legal_Accounts__c>();
            List<Client__c> clients = new List<Client__c>();
            Map<String, List<Client__c>> accountsNumbersWithClients = new Map<String, List<Client__c>>();
            Integer i = 0;
            for(Object accountObj: legalAccountsObj) {
                Map<String, Object> account = (Map<String, Object>) accountObj;
                Legal_Accounts__c legalAccount = adaptAccountObj(account);
                legalAccounts.add(legalAccount);
                List<Object> clientsObj = (List<Object>) account.get('Clients');
                Boolean itHasClients = clientsObj.size() > 0;
                if(itHasClients) {
                    clients = getClientsFromAccount(clientsObj);
                    accountsNumbersWithClients.put(legalAccount.Account_Number__c, clients);
                } 
                
            }

            if(legalAccounts.size() > 0) {
                upsert legalAccounts;
            }
            Map<String, Id> accountsReference = buildAccountsReference(legalAccounts);
            saveClients(accountsNumbersWithClients, accountsReference);
        } catch(Exception e ) {
            System.debug('Error ' + e);
        }
        return response;
    }

    private HttpResponse makeGetRequest() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String uriResource = 'LegalAccounts';
        request.setEndpoint('https://altimetrik-bootcamp.herokuapp.com/' + uriResource);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return response;
    }

    private Date parseDate(String dateString) {
        List<String> dateComponents = dateString.split('/');
        Integer month = Integer.valueOf(dateComponents[0]);
        Integer day = Integer.valueOf(dateComponents[1]);
        Integer year = Integer.valueOf(dateComponents[2]);
        Date dt = Date.newInstance(year, month, day);
        return dt;
    }

    private Legal_Accounts__c adaptAccountObj(Map<String, Object> accountObj) {
        Legal_Accounts__c legalAccount = new Legal_Accounts__c();
        legalAccount.Account_Number__c = (String) accountObj.get('AccountNumber');
        legalAccount.Name = (String) accountObj.get('AccountName');
        legalAccount.Account_Status__c = (String) accountObj.get('AccountStatus');
        legalAccount.As_of_Date__c = parseDate((String) accountObj.get('AsOfDate'));
        legalAccount.isMigrated__c = True;
        return legalAccount;
    }

    private List<Client__c> getClientsFromAccount(List<Object> clientsObj) {
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
            clients.add(client);
        }
        return clients;
    }

    private void saveClients(Map<String, List<Client__c>> accountsWithClients, Map<String, Id> accountsReference) { 
        List<Client__c> clientsToAdd = new List<Client__c>();
        for (String accountNumber : accountsWithClients.keySet()) {
            List<Client__c> clients = accountsWithClients.get(accountNumber);
             for (Client__c c : clients) {
                 c.Legal_Advisor__c = accountsReference.get(accountNumber);
                 clientsToAdd.add(c);
            }
         }
        System.debug('Counts to clients to add: ' + clientsToAdd.size());
        if(!clientsToAdd.isEmpty()) {
            upsert clientsToAdd;
        }
    }

    private Map<String, Id> buildAccountsReference(List<Legal_Accounts__c> accounts) {
        Map<String, Id> accountsReference = new Map<String, Id>();
        for (Legal_Accounts__c a : accounts) {
            accountsReference.put(a.Account_Number__c, a.Id);
        }
        return accountsReference;
    }
}