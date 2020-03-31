@istest
public class StripeProductObjTest {
	
    @isTest
    private static void test() {
        
        String jsonstr = '{"id":"prod_FknxP64Wxe0rZs","object":"product","active":true,"attributes":["M","red","male"],"caption":"Sand","created":1567679859,"deactivate_on":[],"description":"Description of Product B","images":[],"livemode":false,"metadata":{},"name":"Product B","package_dimensions":null,"shippable":true,"type":"good","updated":1571641288,"url":""}';
        
        StripeProductObj abc = JsonToStripeObject.jsonToProduct((Map<String,Object>)JSON.deserializeUntyped(jsonstr));
        
    }
}