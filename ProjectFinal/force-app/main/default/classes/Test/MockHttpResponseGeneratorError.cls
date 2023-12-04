@isTest
public class MockHttpResponseGeneratorError implements HttpCalloutMock {
  private Integer statusCode;

  public MockHttpResponseGeneratorError(Integer statusCode) {
    this.statusCode = statusCode;
  }

  public HttpResponse respond(HttpRequest request) {
    HttpResponse response = new HttpResponse();
    response.setStatusCode(statusCode);
    response.setStatus('Not Found');
    response.setBody('{"Response": "failure"}');
    return response;
  }
}
