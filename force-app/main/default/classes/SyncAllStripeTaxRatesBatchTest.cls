@isTest
public class SyncAllStripeTaxRatesBatchTest {
    
    public static String jsonstr = '{"object":"list","data":[{"id":"txr_1FYuGcGAJHaJ7JBvAE8IGAXW","object":"tax_rate","active":true,"created":1572353866,"description":"vat","display_name":"VAT","inclusive":false,"jurisdiction":"karnataka","livemode":false,"metadata":{},"percentage":20},{"id":"txr_1FVFF0GAJHaJ7JBverWq9dTB","object":"tax_rate","active":true,"created":1571481178,"description":"GST","display_name":"GST","inclusive":false,"jurisdiction":"India","livemode":false,"metadata":{},"percentage":18}],"has_more":false,"url":"/v1/tax_rates"}';
    static testMethod void testBatch(){
        
        Stripe_Account__c acc=TestUtils.createStripeAccount();
        
        Test.startTest();
        SyncAllStripeTaxRatesBatch syncBatch = new SyncAllStripeTaxRatesBatch(acc.Id,null);
        Database.executeBatch(syncBatch);
        Test.stopTest();
    }
}