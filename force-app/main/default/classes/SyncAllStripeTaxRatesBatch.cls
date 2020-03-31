global class SyncAllStripeTaxRatesBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful {
    
    public String stripeAccountId;
    public String veryLastTaxId;
    public Boolean hasMoreCallout = false;

    public SyncAllStripeTaxRatesBatch(Id stripeId, String lastTaxId) {
        this.stripeAccountId = stripeId;
        this.veryLastTaxId = lastTaxId;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, API_Secret__c FROM Stripe_Account__c WHERE API_Secret__c != null AND Id = :stripeAccountId';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Stripe_Account__c> records)
    {   
        List<StripeTaxRateObj> taxList = new  List<StripeTaxRateObj>();
        List<StripeTaxRate__c> taxUpsert = new List<StripeTaxRate__c>();

        for(Stripe_Account__c stripAcc : records)
        {   
            Integer countCallout = 1;
            String response;

            //do callout
            if(String.isNotBlank(veryLastTaxId)) {
                response = doCallOut('200',veryLastTaxId,stripAcc.API_Secret__c);
            }else {
                response = doCallOut('200',null,stripAcc.API_Secret__c);
            }

            Map<String,Object> respMap = (Map<String, Object>)JSON.deserializeUntyped(response);

            taxList.addAll(JsonToStripeObject.jsonToTaxRateList((List<Object>)respMap.get('data')));
            veryLastTaxId = taxList[taxList.size()-1].id;

            hasMoreCallout = (Boolean)respMap.get('has_more');
        }
        
        for(StripeTaxRateObj obj : taxList)
        {
            StripeTaxRate__c tax = new StripeTaxRate__c();
            tax.StripeId__c = obj.Id;
            tax.Active__c = obj.active;
            tax.Created__c = obj.created;
            tax.Name = obj.Name;
            tax.Description__c = obj.Description;
            tax.Inclusive__c = obj.inclusive;
            tax.Jurisdiction__c = obj.jurisdiction;
            tax.Percentage__c = obj.percentage;

            taxUpsert.add(tax);
        }

        Database.upsert(taxUpsert, StripeTaxRate__c.StripeId__c); //upsert Stripe customers
    }   

    global void finish(Database.BatchableContext BC) {

        if(hasMoreCallout) {
            Database.executeBatch(new SyncAllStripeProductsBatch(stripeAccountId, veryLastTaxId));
        }else {
            
            AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
        
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Customer Sync Batch ' + a.Status);
            mail.setPlainTextBody('Sync Complete');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
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
        req.setEndpoint('https://api.stripe.com/v1/tax_rates?'+getStr);
        //req.setEndpoint('https://webhook.site/a3f1b27d-518a-4899-bfd1-be8cc6afda9e');
        req.setMethod('GET');

        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(secretKey));
        // Add the basic auth string to the Request Header
        req.setHeader('Authorization', authorizationHeader);

        Http http = new Http();
        
        if(Test.isRunningTest()) {
            return SyncAllStripeTaxRatesBatchTest.jsonstr;
        }
        
        HTTPResponse response = http.send(req);
        return response.getBody();

    }
}