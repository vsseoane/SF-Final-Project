@isTest
public class MockHttpResponseGeneratorWithJSON implements HttpCalloutMock {
  public HttpResponse respond(HttpRequest request) {
    HttpResponse response = new HttpResponse();
    response.setStatusCode(200);
    response.setStatus('OK');

    String jsonResponse =
      '[{"AccountNumber":"00000001","AccountName":"Fadeo","AccountStatus":"Enabled","AsOfDate":"2/20/2019","Clients":[{"FirstName":"Fran2","LastName":"Ruddick2","Email":"fruddick0@issuu.com","Phone":"390-285-2477","Address":"434 Maple Drive","ClientNumber":"c0001-1"},{"FirstName":"Merrel","LastName":"Hewes","Email":"mhewes1@paypal.com","Phone":"246-738-5648","Address":"003 Moland Way","ClientNumber":"c0001-2"}]},' +
      '{"AccountNumber":"00000002","AccountName":"Rooxo2","AccountStatus":"Disabled","AsOfDate":"6/9/2019","Clients":[{"FirstName":"Riobard","LastName":"Quimby","Email":"rquimby7@amazon.com","Phone":"929-369-3034","Address":"8 Little Fleur Street","ClientNumber":"c0001-1"},{"FirstName":"Kathlin","LastName":"Tackell","Email":"ktackell8@statcounter.com","Phone":"746-430-4623","Address":"6 Susan Drive","ClientNumber":"c0002-2"}]},' +
      '{"AccountNumber":"00000003","AccountName":"Mario3","AccountStatus":"Enabled","AsOfDate":"6/9/2019","Clients":[{"FirstName":"Juana","LastName":"LaLoca","Email":"juanalaloca@example.com","Phone":"123-456-7890","Address":"123 Updated Street","ClientNumber":"c0003-1"}, {"FirstName":"Mariano","LastName":"Martinez","Email":"juanalaloca@example.com","Phone":"123-456-7890","Address":"123 Updated Street","ClientNumber":"c0003-2"}]}]';
    response.setBody(jsonResponse);
    return response;
  }
}
