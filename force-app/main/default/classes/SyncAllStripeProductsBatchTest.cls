@isTest
public class SyncAllStripeProductsBatchTest {
    
    public static String jsonstr = '{"object":"list","data":[{"id":"prod_GVdIAgynTU29NV","object":"product","active":true,"attributes":[],"caption":"all about testing","created":1578480263,"deactivate_on":[],"description":null,"images":[],"livemode":false,"metadata":{},"name":"testing 117","package_dimensions":null,"shippable":true,"type":"good","updated":1578480266,"url":null},{"id":"prod_GVctSX10Usl6FE","object":"product","active":true,"attributes":[],"caption":null,"created":1578478814,"deactivate_on":[],"description":null,"images":[],"livemode":false,"metadata":{},"name":"test 717","package_dimensions":null,"shippable":null,"statement_descriptor":"testing statement","type":"service","unit_label":"17","updated":1578562604,"url":null},{"id":"prod_GQi24wErrr91of","object":"product","active":true,"attributes":[],"caption":null,"created":1577344714,"deactivate_on":[],"description":null,"images":[],"livemode":false,"metadata":{},"name":"test e","package_dimensions":null,"shippable":null,"statement_descriptor":"testing one one","type":"service","unit_label":"11","updated":1577344957,"url":null}],"has_more":false,"url":"/v1/products"}';
    
    static testMethod void testBatch(){
        
        Stripe_Account__c acc=TestUtils.createStripeAccount();
        
        Test.startTest();
        SyncAllStripeProductsBatch syncBatch = new SyncAllStripeProductsBatch(acc.Id,null);
        Database.executeBatch(syncBatch);
        Test.stopTest();
    }
}