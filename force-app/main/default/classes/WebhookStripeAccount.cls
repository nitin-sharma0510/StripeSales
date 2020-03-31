@RestResource(urlmapping = '/StripeCustomer/*')
//have to add id of the account of stripe to attach the customer to account
global class WebhookStripeAccount {
    
    @HttpPost
    global static void postMethod()
    {   
        Datetime startTime = System.now();
        string stripeAccId = RestContext.request.params.get('AccId');       
        
        Map<String, Object> postData = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());

        if((String)postData.get('type') == 'customer.created' || (String)postData.get('type') == 'customer.updated')
        {
            Map<String,Object> cutmr = (Map<String,Object>)postData.get('data');
            StripeCustomerObj customer = JsonToStripeObject.jsonToCustomer((Map<String,Object>)cutmr.get('object'), stripeAccId);

            RestResponse res = RestContext.response;
            try {
                StripeDmlHandler.customerObjDml(new List<StripeCustomerObj>{customer});

                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf('{"Success"}}');
                res.statusCode = 200;
                StripeWebhookHandler.createLog(postData, '', startTime, System.now());
            } catch (Exception ex) {
                Logger.capture(ex);
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(JSON.serializePretty(ex.getMessage()));
                res.statusCode = 500;

                StripeWebhookHandler.createLog(postData, 'error: '+ex.getMessage().abbreviate(200), startTime, System.now());
            }
        }
        /*
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(JSON.serializePretty(insertedCase));
        res.statusCode = 200;
        */  
    }
}