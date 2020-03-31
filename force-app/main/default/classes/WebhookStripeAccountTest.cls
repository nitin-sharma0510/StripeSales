@isTest
public class WebhookStripeAccountTest {
	
    @isTest static void postMethodTest(){
        
        String jsonMsg='{"created":1326853478,"livemode":false,"id":"evt_00000000000000","type":"customer.created","object":"event","request":null,"pending_webhooks":1,"api_version":"2019-08-14","data":{"object":{"id":"cus_00000000000000","object":"customer","account_balance":0,"address":null,"balance":0,"created":1578399158,"currency":"usd","default_source":null,"delinquent":false,"description":null,"discount":null,"email":null,"invoice_prefix":"2DB5092","invoice_settings":{"custom_fields":null,"default_payment_method":null,"footer":null},"livemode":false,"metadata":{},"name":null,"phone":null,"preferred_locales":[],"shipping":null,"sources":{"object":"list","data":[],"has_more":false,"url":"/v1/customers/cus_GVHU8O1g5T0Jqb/sources"},"subscriptions":{"object":"list","data":[],"has_more":false,"url":"/v1/customers/cus_GVHU8O1g5T0Jqb/subscriptions"},"tax_exempt":"none","tax_ids":{"object":"list","data":[],"has_more":false,"url":"/v1/customers/cus_GVHU8O1g5T0Jqb/tax_ids"},"tax_info":null,"tax_info_verification":null}}}';
		RestRequest req=new RestRequest();
        RestResponse res=new RestResponse();
        
        Stripe_Account__c acc=TestUtils.createStripeAccount();
       
        req.requestURI='/StripeCustomer?AccId='+acc.Id;
        req.httpMethod='POST';
        req.requestBody=Blob.valueOf(jsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        
        Test.startTest();
        WebhookStripeAccount.postMethod();
        Test.stopTest();
        
    }
   
}