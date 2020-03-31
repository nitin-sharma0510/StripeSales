@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id":"we_1FwQA6GdoNmxs7AiVaasjwSv","object":"webhook_endpoint","api_version":"2019-12-03","application":null,"created":1577958014,"enabled_events":["charge.failed","charge.succeeded"],"livemode":false,"secret":"whsec_s6pYn8uZN6gfQlceiXW7OffOoJ33bA3r","status":"enabled","url":"https://example.com/my/webhook/endpoint"}');
        res.setStatusCode(200);
        return res;
    }
}