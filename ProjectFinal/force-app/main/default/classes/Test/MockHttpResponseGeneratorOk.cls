@isTest
public class MockHttpResponseGeneratorOk implements HttpCalloutMock {
  public HttpResponse respond(HttpRequest request) {
    HttpResponse response = new HttpResponse();
    response.setStatusCode(200);
    response.setStatus('OK');
    response.setBody('{"Response": "success"}');
    return response;
  }
}
