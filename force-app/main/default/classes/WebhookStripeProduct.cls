@RestResource(urlmapping = '/StripeProduct/*')
global class WebhookStripeProduct {
    
    @HttpPost
    global static void postMethd()
    {
        string stripeAccId = RestContext.request.params.get('id');       
        Datetime startTime = System.now();//for logging
        
        List<Product2> prodUpsert = new List<Product2>();       
        
        Map<String, Object> postData = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());

        if((String)postData.get('type') == 'product.created')
        {
            Map<String,Object> subMap = (Map<String,Object>)postData.get('data');
            StripeProductObj prdObj = JsonToStripeObject.jsonToProduct((Map<String,Object>)subMap.get('object'));

            Product2 prod = new Product2();
            prod.StripeProductId__c = prdObj.id;
            prod.Updated__c = prdObj.updated;
            prod.Name = prdObj.name;
            prod.Description = prdObj.description;
            prod.Attributes__c = String.join(prdObj.attributes, ',');
            prod.IsActive = prdObj.active;
            prod.Created__c = prdObj.created;

            prodUpsert.add(prod);

            RestResponse res = RestContext.response;

            try {
                Database.UpsertResult[] resultsProd = Database.upsert(prodUpsert, Product2.StripeProductId__c);

                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf('{"inserted/updated stripe Subscription" : {"id":"'+resultsProd[0].getId()+'"}}');
                res.statusCode = 200;

                StripeWebhookHandler.createLog(postData, resultsProd[0].getId(), startTime, System.now());
            } catch (Exception ex) {
                Logger.capture(ex);
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(JSON.serializePretty(ex.getMessage()));
                res.statusCode = 500;

                StripeWebhookHandler.createLog(postData, 'error: '+ex.getMessage().abbreviate(200), startTime, System.now());
            }
        }
    }
}