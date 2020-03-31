public class CustomerHandler implements IStripeWebhooks{
    public static void parseResponse(Map<String,Object> postData, Map<String,String>paramsMap){
        DateTime startTime = System.now();
        System.debug('paramsMap ==> '+paramsMap);
        String stripeAccId = paramsMap.get('AccId');
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
    
}