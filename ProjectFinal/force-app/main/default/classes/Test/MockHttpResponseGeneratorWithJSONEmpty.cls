@isTest
public class MockHttpResponseGeneratorWithJSONEmpty implements HttpCalloutMock {
  public HttpResponse respond(HttpRequest request) {
    HttpResponse response = new HttpResponse();
    response.setStatusCode(200);
    response.setStatus('OK');

    String jsonResponse = '[]';
    response.setBody(jsonResponse);
    return response;
  }
}
