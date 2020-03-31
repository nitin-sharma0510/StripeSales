public class StripeController{
    @AuraEnabled
    public static List <Stripe_Account__c> fetchAccounts() {
        //Qyery 10 accounts
        List<Stripe_Account__c> stripeList = [SELECT Id, Name, Active__c, API_Key__c, OwnerId, 
                                              CreatedDate, Description__c FROM Stripe_Account__c];
        //return list of accounts
        return stripeList;
    }

    @AuraEnabled
    public static string createWebhook(String accId){
    
        try {
            CreateWebhooks.create(accId);
            return 'success';        
        } catch (Exception ex) {
            Logger.capture(ex);
            return ex.getMessage();
        }
    }

    @AuraEnabled
    public static List <StripeEvent__c> fetchEventLogs() {
        
        List<StripeEvent__c> ventLogs = [SELECT Id, Name, Type__c, StartProcessingTime__c, EndProcessingTime__c, 
                                              Action__c FROM StripeEvent__c ORDER BY CreatedDate DESC LIMIT 100];
        return ventLogs;
    }

    @AuraEnabled
    public static String fetchAccountBalance(String accId) {
        System.debug('fetchAccountBalance start');

        List<Stripe_Account__c> stripeAccList = [SELECT Id, API_Secret__c FROM Stripe_Account__c WHERE Id =:accId];

        if(!stripeAccList.isEmpty()) {

            String secretKey = stripeAccList[0].API_Secret__c;

            try {
                Map<String,Object> respMap = (Map<String,Object>)JSON.deserializeUntyped(StripeApiCallout.doCallout(secretKey, 'balance'));
				System.debug('RESPMAP '+respMap);
                for(Object obj : (List<Object>)respMap.get('available')) {
                    Map<String,Object> balMap = (Map<String,Object>)obj;
                    
                    System.debug('OBJECTbalMap '+balMap.get('amount'));
                    String bal = String.valueOf(balMap.get('amount'));
                    return bal;
                }
                return '';//should not reach here
            } catch (Exception ex) {
                Logger.capture(ex);
                return 'error';
            }
        }else {
            return 'no records';
        }
    }
    
    @auraEnabled
    public static StripeSiteSettings__c fetchSiteSettings() {
        return StripeSiteSettings__c.getOrgDefaults();
    }
    
    @auraEnabled
    public static void saveSiteSettings(StripeSiteSettings__c recrd) {
        if(recrd != null)
            upsert recrd;
        //System.debug('SITE SETTINGS '+recrd);
    }
    
    @auraEnabled
    public static String verifySiteUrl(String url) {
		
        String endpoint;
        
        if(url.right(1).equals('/')) {
            endpoint = url+'services/apexrest/StripeSiteTest';
        }else {
            endpoint = url+'/services/apexrest/StripeSiteTest';
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        
        if(Test.isRunningTest()) {
            return 'success';
        }
        HttpResponse resp = new Http().send(req);
        //System.debug('TEST '+resp.getBody());
		return resp.getBody();
    }
    
    @auraEnabled
    public static String runbatch(String stripeAccId, String batchName) {
        System.debug('STRIPE ACC '+stripeAccId+' BatchName'+batchName);
        Id jobId;
        
        if(String.isNotBlank(stripeAccId)) {
            
            if(batchName.containsIgnoreCase('SyncAllStripeCustomerBatch'))
        		jobId = Database.executeBatch(new SyncAllStripeCustomerBatch(stripeAccId, null));
            
            if(batchName.containsIgnoreCase('SyncAllStripeProductsBatch'))
                jobId = Database.executeBatch(new SyncAllStripeProductsBatch(stripeAccId, null));
            
            if(batchName.containsIgnoreCase('SyncAllStripeTaxRatesBatch'))
                jobId = Database.executeBatch(new SyncAllStripeTaxRatesBatch(stripeAccId, null));
            
            if(batchName.containsIgnoreCase('SyncAllStripeChargesBatch'))
                jobId = Database.executeBatch(new SyncAllStripeChargesBatch(stripeAccId, null));
        }
        
        
        if(String.isNotBlank(jobId)) {
        	return 'success';   
        }
        else {
            return 'Stripe Account Id is missing~!';
        }
    }
}