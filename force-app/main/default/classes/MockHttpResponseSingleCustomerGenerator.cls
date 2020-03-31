@isTest
global class MockHttpResponseSingleCustomerGenerator implements HttpCalloutMock{

    public static String jsonstr = '{"id":"cus_GWJeawCzYfQ1SW","object":"customer","address":null,"balance":0,"created":1578637858,"currency":"usd","default_source":null,"delinquent":false,"description":null,"discount":null,"email":null,"invoice_prefix":"19CAD1A","invoice_settings":{"custom_fields":null,"default_payment_method":null,"footer":null},"livemode":false,"metadata":{},"name":null,"phone":null,"preferred_locales":[],"shipping":null,"sources":{"object":"list","data":[],"has_more":false,"url":"/v1/customers/cus_GWJeawCzYfQ1SW/sources"},"subscriptions":{"object":"list","data":[],"has_more":false,"url":"/v1/customers/cus_GWJeawCzYfQ1SW/subscriptions"},"tax_exempt":"none","tax_ids":{"object":"list","data":[],"has_more":false,"url":"/v1/customers/cus_GWJeawCzYfQ1SW/tax_ids"}}';
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals(True, req.getEndpoint().contains('https://api.stripe.com/v1/'));
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"id":"cus_GWJeawCzYfQ1SW","object":"customer","address":null,"balance":0,"created":1578637858,"currency":"usd","default_source":null,"delinquent":false,"description":null,"discount":null,"email":null,"invoice_prefix":"19CAD1A","invoice_settings":{"custom_fields":null,"default_payment_method":null,"footer":null},"livemode":false,"metadata":{},"name":null,"phone":null,"preferred_locales":[],"shipping":null,"sources":{"object":"list","data":[],"has_more":false,"url":"/v1/customers/cus_GWJeawCzYfQ1SW/sources"},"subscriptions":{"object":"list","data":[],"has_more":false,"url":"/v1/customers/cus_GWJeawCzYfQ1SW/subscriptions"},"tax_exempt":"none","tax_ids":{"object":"list","data":[],"has_more":false,"url":"/v1/customers/cus_GWJeawCzYfQ1SW/tax_ids"}}');
        res.setStatusCode(200);
        return res;
    }

}