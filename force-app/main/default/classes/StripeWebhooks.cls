@RestResource(urlmapping = '/stripe/*')

global class StripeWebhooks {
    @HttpPost
    global static void postMethod() {
        
     	Map<String, Object> postData = (Map<String, Object>)JSON.deserializeUntyped(RestContext.request.requestBody.toString());
        String evetType =  (String)postData.get('type');

        list<Stripe_Webhook_Config__mdt> lstStripeMetaData = [SELECT Id, MasterLabel, Label, Event_Handler__c, QualifiedApiName
                                                              FROM Stripe_Webhook_Config__mdt 
                                                              WHERE Event_Handler__c != Null AND Label =: evetType limit 1  
                                                             ];
        
        if(lstStripeMetaData.size() >0){
            String websClassName =  lstStripeMetaData[0].Event_Handler__c;
            Type objType = Type.forName(websClassName);
            IStripeWebhooks webHookHandler = (IStripeWebhooks)objType.newInstance();
            webHookHandler.parseResponse(postData,RestContext.request.params); 
        }else{
            // error handling 
        }
    }
}