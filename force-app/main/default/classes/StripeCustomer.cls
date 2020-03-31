public class StripeCustomer {

    
    @auraEnabled
    public static String syncStripeCustomer(Id stripeCustId) 
    {	
        String respString;
        
        if(String.isNotEmpty(stripeCustId))
        {
         	Stripe_Customer__c custList = [SELECT Id, StripeCustomerID__c, StripeAccountID__r.API_Secret__c FROM Stripe_Customer__c WHERE Id =:stripeCustId];
        	
            if(!Test.isRunningTest()) {
            	respString = StripeApiCallout.doCallout(custList.StripeAccountID__r.API_Secret__c,'customers/'+custList.StripeCustomerID__c);   
            }else {
                respString = MockHttpResponseSingleCustomerGenerator.jsonstr;
            }
            
        	
            try {
                updateCustomerWithRelatedObj(respString);
            } catch (Exception ex) {
                Logger.capture(ex);
                return ex.getMessage();
            }

            return 'Success';   
        }else {
            return 'No id to process';
        }
    }
    
    public static void updateCustomerWithRelatedObj(String respJson)
    {
        Map<String, Object> respMap = (Map<String, Object>)JSON.deserializeUntyped(respJson);
        System.debug(respMap);
        
        StripeCustomerObj customer = JsonToStripeObject.jsonToCustomer(respMap);

        StripeDmlHandler.customerObjDml(new List<StripeCustomerObj>{customer});    
    }
}