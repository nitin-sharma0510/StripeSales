@isTest
public class WebhookStripeProductTest {
	
    @isTest static void postMethodTest(){
        
        String jsonMsg='{"created":1326853478,"livemode":false,"id":"evt_00000000000000","type":"product.created","object":"event","request":null,"pending_webhooks":1,"api_version":"2019-08-14","data":{"object":{"id":"prod_00000000000000","object":"product","active":true,"attributes":["M","red","male"],"caption":"Sand","created":1567679859,"deactivate_on":[],"description":"Description of Product B","images":[],"livemode":false,"metadata":{},"name":"Product B","package_dimensions":null,"shippable":true,"type":"good","updated":1571641288,"url":""}}}';
        RestRequest req=new RestRequest();
        RestResponse res=new RestResponse();
        
        req.requestURI='/StripeProduct/';
        req.httpMethod='POST';
        req.requestBody=Blob.valueOf(jsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        
        Test.startTest();
        WebhookStripeProduct.postMethd();
        Test.stopTest();
    }
}