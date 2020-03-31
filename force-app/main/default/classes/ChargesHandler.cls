public class ChargesHandler implements IStripeWebhooks {
    public static void parseResponse(Map<String,Object> postData, Map<String,String>paramsMap){
        
        DateTime startTime = System.now();
        String stripeAccId = paramsMap.get('AccId');
        List<StripeCharge__c> upsrtChr = new List<StripeCharge__c>();
        
        Map<String,Object> chargeMap = (Map<String,Object>)postData.get('data');
        StripeChargeObj chrObj = JsonToStripeObject.jsonToCharge((Map<String,Object>)chargeMap.get('object'));
        
        StripeCharge__c charge = new StripeCharge__c();
        charge.StripeChargeId__c = chrObj.Id;
        charge.Created__c = chrObj.created;
        
        List<Stripe_Customer__c> SfCust = [SELECT id,StripeCustomerID__c FROM Stripe_Customer__c 
                                           WHERE StripeCustomerID__c =: chrObj.customer];
        
        charge.Stripe_Customer__c = SfCust.isEmpty() ? null : SfCust[0].Id;
        charge.Amount__c = chrObj.amount/100;
        charge.Amount_Refunded__c = chrObj.amount_refunded;
        charge.Captured__c = chrObj.captured;
        charge.Currency__c = chrObj.curncy;
        charge.Description__c = chrObj.description;
        charge.Failure_Message__c = chrObj.failure_msg;
        charge.Invoice_Id__c = chrObj.invoice;
        charge.Order_Id__c = chrObj.order;
        charge.Paid__c = chrObj.paid;
        charge.Receipt_Id__c = chrObj.receipt_num;
        charge.Receipt_Url__c = chrObj.receipt_url;
        charge.Refunded__c = chrObj.refunded;
        charge.Status__c = chrObj.status;
        
        upsrtChr.add(charge);
        
        RestResponse res = RestContext.response;
        try {
            Database.UpsertResult[] resultsChr = Database.upsert(upsrtChr, StripeCharge__c.StripeChargeId__c);
            
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf('{"inserted/updated stripe Subscription" : {"id":"'+resultsChr[0].getId()+'"}}');
            res.statusCode = 200;
            
            StripeWebhookHandler.createLog(postData, resultsChr[0].getId(), startTime, System.now());
        } catch (Exception ex) {
            Logger.capture(ex);
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(JSON.serializePretty(ex.getMessage()));
            res.statusCode = 500;
            
            StripeWebhookHandler.createLog(postData, 'error: '+ex.getMessage().abbreviate(200), startTime, System.now());
        }            
    }
}