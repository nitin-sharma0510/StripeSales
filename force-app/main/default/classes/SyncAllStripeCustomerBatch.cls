global class SyncAllStripeCustomerBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful {
    
    public String stripeAccountId;
    public String veryLastCustomerId;
    public Boolean hasMoreCallout = false;

    public SyncAllStripeCustomerBatch(Id stripeId, String lastcustomerId) {
        this.stripeAccountId = stripeId;
        this.veryLastCustomerId = lastcustomerId;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, API_Secret__c FROM Stripe_Account__c WHERE API_Secret__c != null AND Id = :stripeAccountId';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Stripe_Account__c> records)
    {   
        List<StripeCustomerObj> custmerList = new  List<StripeCustomerObj>();

        for(Stripe_Account__c stripAcc : records)
        {   
            Integer countCallout = 1;
            String response;

            //do callout
            if(String.isNotBlank(veryLastCustomerId)) {
                response = doCallOut('200',veryLastCustomerId,stripAcc.API_Secret__c);
            }else {
                response = doCallOut('200',null,stripAcc.API_Secret__c);
            }

            Map<String,Object> respMap = (Map<String, Object>)JSON.deserializeUntyped(response);
            System.debug('CUSTOMER LIST '+(List<Object>)respMap.get('data'));

            custmerList.addAll(JsonToStripeObject.jsonToCustomerList((List<Object>)respMap.get('data'),stripAcc.Id));
            veryLastCustomerId = custmerList[custmerList.size()-1].custId;

            hasMoreCallout = (Boolean)respMap.get('has_more');
        }
        
        StripeDmlHandler.customerObjDml(custmerList); //upsert Stripe customers
    }   

    global void finish(Database.BatchableContext BC) {

        if(hasMoreCallout) {
            Database.executeBatch(new SyncAllStripeCustomerBatch(stripeAccountId, veryLastCustomerId));
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

    public static String doCallOut(String size, String lastCustId, String secretKey) {

        String getStr;

        if(String.isNotBlank(lastCustId)) {
            getStr = 'limit='+size+'&starting_after='+lastCustId;
        }else {
            getStr = 'limit='+size;
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.stripe.com/v1/customers?'+getStr);
        //req.setEndpoint('https://webhook.site/a3f1b27d-518a-4899-bfd1-be8cc6afda9e');
        req.setMethod('GET');

        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(secretKey));
        // Add the basic auth string to the Request Header
        req.setHeader('Authorization', authorizationHeader);

        Http http = new Http();
        
        if(Test.isRunningTest()) {
            return MockHttpCustomerResponseBatch.jsonstr;
        }
        HTTPResponse response = http.send(req);

        //System.debug('RESPONSE '+response.getBody());
        return response.getBody();

    }
}