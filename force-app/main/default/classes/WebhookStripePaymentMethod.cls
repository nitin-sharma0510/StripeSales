@RestResource(urlmapping = '/StripePaymentMethod/*')
//have to add id of the account of stripe to attach the customer to account
global class WebhookStripePaymentMethod {
    
    @HttpPost
    global static void postMethod()
    {
        Datetime startTime = System.now();
              
        List<StripePaymentMethod__c> spmUpsert = new List<StripePaymentMethod__c>();
        Map<String, Object> postData = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());

        //if((String)postData.get('type') == 'payment_method.attached') {
            
        Map<String,Object> paymntMethdObj = (Map<String,Object>)postData.get('data');
        StripePaymentMethodObj paymntMethd = JsonToStripeObject.jsonToPaymentMethod((Map<String,Object>)paymntMethdObj.get('object'));
        
        List<Stripe_Customer__c> stripeCust = [SELECT id,StripeCustomerID__c FROM Stripe_Customer__c 
                                                WHERE StripeCustomerID__c =: paymntMethd.customer];

        if(stripeCust.isEmpty()) {

            StripePaymentMethod__c spm = new StripePaymentMethod__c();
            spm.StripePaymentMethodId__c = paymntMethd.id;
            spm.Created__c = paymntMethd.created;
            
            //Call the customer api before linking
            StripeCustomer.syncStripeCustomer(paymntMethd.customer);
            List<Stripe_Customer__c> stripeCus = [SELECT id,StripeCustomerID__c FROM Stripe_Customer__c 
                                                WHERE StripeCustomerID__c =: paymntMethd.customer];
            spm.Stripe_Customer__c = stripeCus.isEmpty() ? null : stripeCus[0].Id;
            
            spm.Type__c = paymntMethd.type;
            spm.Brand__c = paymntMethd.card.brand;
            spm.Country__c = paymntMethd.card.country;
            spm.Last_Four_Digits__c = paymntMethd.card.last4;
            spm.Expiry_Month__c = paymntMethd.card.exp_month;
            spm.Expiry_Year__c = paymntMethd.card.exp_year;
            spm.Fingerprint__c = paymntMethd.card.fingerprint;

            spmUpsert.add(spm);
        }else {
            
            StripePaymentMethod__c spm = new StripePaymentMethod__c();
            spm.StripePaymentMethodId__c = paymntMethd.id;
            spm.Created__c = paymntMethd.created;
            spm.Stripe_Customer__c = stripeCust[0].Id;
            spm.Type__c = paymntMethd.type;
            spm.Brand__c = paymntMethd.card.brand;
            spm.Country__c = paymntMethd.card.country;
            spm.Last_Four_Digits__c = paymntMethd.card.last4;
            spm.Expiry_Month__c = paymntMethd.card.exp_month;
            spm.Expiry_Year__c = paymntMethd.card.exp_year;
            spm.Fingerprint__c = paymntMethd.card.fingerprint;

            spmUpsert.add(spm);
        }

        RestResponse res = RestContext.response;

        try {
            Database.UpsertResult[] resultsSpm = Database.upsert(spmUpsert, StripePaymentMethod__c.StripePaymentMethodId__c);

            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf('{"inserted/updated stripe Subscription" : {"id":"'+resultsSpm[0].getId()+'"}}');
            res.statusCode = 200;

            StripeWebhookHandler.createLog(postData, resultsSpm[0].getId(), startTime, System.now());
        } catch (Exception ex) {
            Logger.capture(ex);
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(JSON.serializePretty(ex.getMessage()));
            res.statusCode = 500;

            StripeWebhookHandler.createLog(postData, 'error: '+ex.getMessage().abbreviate(200), startTime, System.now());
        }
        //}    
    }
}