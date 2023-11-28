public with sharing class LegalAccountMigrationService {
    public LegalAccountMigrationService() {

    }

    public HttpResponse getAllLegalAccounts() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String uriResource = 'LegalAccounts';
        request.setEndpoint('https://altimetrik-bootcamp.herokuapp.com/' + uriResource);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            List<Legal_Accounts__c> legalAccounts = new List<Legal_Accounts__c>();
            List<Object> legalAccountsObj = (List<Object>) JSON.deserializeUntyped(response.getBody());
            if(legalAccountsObj.isEmpty()) {
                System.debug('legalAccounts is empty');
            }
            for(Object accountObj: legalAccountsObj) {
                Map<String, Object> account = (Map<String, Object>) accountObj;
                Legal_Accounts__c legalAccount = new Legal_Accounts__c();
                legalAccount.Account_Number__c = (String) account.get('AccountNumber');
                legalAccount.Name = (String) account.get('AccountName');
                legalAccount.Account_Status__c = (String) account.get('AccountStatus');
                legalAccount.As_of_Date__c = getDateParsed((String) account.get('AsOfDate'));
                legalAccounts.add(legalAccount);
            }
            if(legalAccounts.size() > 0) {
                insert legalAccounts;
            }
        }
        return response;
    }

    private Date getDateParsed(String dateString) {
        List<String> dateComponents = dateString.split('/');
        Integer month = Integer.valueOf(dateComponents[0]);
        Integer day = Integer.valueOf(dateComponents[1]);
        Integer year = Integer.valueOf(dateComponents[2]);
        Date dt = Date.newInstance(year, month, day);
        return dt;
    }
}