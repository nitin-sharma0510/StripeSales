global class SyncAllStripeChargesBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful {
    
    public String stripeAccountId;
    public String veryLastChargeId;
    public Boolean hasMoreCallout = false;

    public SyncAllStripeChargesBatch(Id stripeId, String lastchrgeId) {
        this.stripeAccountId = stripeId;
        this.veryLastChargeId = lastchrgeId;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, API_Secret__c FROM Stripe_Account__c WHERE API_Secret__c != null AND Id = :stripeAccountId';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Stripe_Account__c> records)
    {   
        List<StripeChargeObj> chrgeList = new  List<StripeChargeObj>();

        for(Stripe_Account__c stripAcc : records)
        {   
            Integer countCallout = 1;
            String response;

            //do callout
            if(String.isNotBlank(veryLastChargeId)) {
                response = doCallOut('200',veryLastChargeId,stripAcc.API_Secret__c);
            }else {
                response = doCallOut('200',null,stripAcc.API_Secret__c);
            }

            Map<String,Object> respMap = (Map<String, Object>)JSON.deserializeUntyped(response);

            chrgeList.addAll(JsonToStripeObject.jsonToChargeList((List<Object>)respMap.get('data')));
            veryLastChargeId = chrgeList[chrgeList.size()-1].Id;

            hasMoreCallout = (Boolean)respMap.get('has_more');
        }
        
        StripeDmlHandler.stripeChargeDml(chrgeList); //upsert Stripe charge
    }   

    global void finish(Database.BatchableContext BC) {

        if(hasMoreCallout) {
            Database.executeBatch(new SyncAllStripeChargesBatch(stripeAccountId, veryLastChargeId));
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
        req.setEndpoint('https://api.stripe.com/v1/charges?'+getStr);
        
        req.setMethod('GET');

        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(secretKey));
        // Add the basic auth string to the Request Header
        req.setHeader('Authorization', authorizationHeader);

        Http http = new Http();
        
        if(Test.isRunningTest()) {
            return SyncAllStripeChargesBatchTest.jsonstr;
        }
        HTTPResponse response = http.send(req);

        //System.debug('RESPONSE '+response.getBody());
        return response.getBody();

    }
}