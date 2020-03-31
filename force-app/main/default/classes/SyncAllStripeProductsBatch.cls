global class SyncAllStripeProductsBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful {
    
    public String stripeAccountId;
    public String veryLastProductId;
    public Boolean hasMoreCallout = false;

    public SyncAllStripeProductsBatch(Id stripeId, String lastProdId) {
        this.stripeAccountId = stripeId;
        this.veryLastProductId = lastProdId;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, API_Secret__c FROM Stripe_Account__c WHERE API_Secret__c != null AND Id = :stripeAccountId';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Stripe_Account__c> records)
    {   
        List<StripeProductObj> prodList = new  List<StripeProductObj>();
        List<Product2> prodUpsert = new List<Product2>();

        for(Stripe_Account__c stripAcc : records)
        {   
            Integer countCallout = 1;
            String response;

            //do callout
            if(String.isNotBlank(veryLastProductId)) {
                response = doCallOut('200',veryLastProductId,stripAcc.API_Secret__c);
            }else {
                response = doCallOut('200',null,stripAcc.API_Secret__c);
            }

            Map<String,Object> respMap = (Map<String, Object>)JSON.deserializeUntyped(response);

            prodList.addAll(JsonToStripeObject.jsonToProductList((List<Object>)respMap.get('data')));
            veryLastProductId = prodList[prodList.size()-1].id;

            hasMoreCallout = (Boolean)respMap.get('has_more');
        }
        
        for ( StripeProductObj prdObj: prodList) {

            Product2 prod = new Product2();
            prod.StripeProductId__c = prdObj.id;
            prod.Updated__c = prdObj.updated;
            prod.Name = prdObj.name;
            prod.Description = prdObj.description;
            prod.Attributes__c = String.join(prdObj.attributes, ',');
            prod.IsActive = prdObj.active;
            prod.Created__c = prdObj.created;

            prodUpsert.add(prod);
        }

        Database.upsert(prodUpsert, Product2.StripeProductId__c); //upsert Stripe customers
    }   

    global void finish(Database.BatchableContext BC) {

        if(hasMoreCallout) {
            Database.executeBatch(new SyncAllStripeProductsBatch(stripeAccountId, veryLastProductId));
        }else {
            
            AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
        
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Customer Sync Batch ' + a.Status);
            mail.setPlainTextBody('Sync Complete');
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    public static String doCallOut(String size, String lastRecId, String secretKey) {

        String getStr;

        if(String.isNotBlank(lastRecId)) {
            getStr = 'limit='+size+'&starting_after='+lastRecId;
        }else {
            getStr = 'limit='+size;
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.stripe.com/v1/products?'+getStr);
        //req.setEndpoint('https://webhook.site/a3f1b27d-518a-4899-bfd1-be8cc6afda9e');
        req.setMethod('GET');

        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(secretKey));
        // Add the basic auth string to the Request Header
        req.setHeader('Authorization', authorizationHeader);

        Http http = new Http();
        
        if(Test.isRunningTest()) {
            return SyncAllStripeProductsBatchTest.jsonstr;
        }
        
        HTTPResponse response = http.send(req);
        return response.getBody();

    }
}