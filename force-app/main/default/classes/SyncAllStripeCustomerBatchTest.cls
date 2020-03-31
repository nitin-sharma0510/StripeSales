@isTest
public class SyncAllStripeCustomerBatchTest {
    
    static testMethod void testBatch(){
        
        Stripe_Account__c acc=TestUtils.createStripeAccount();
        
        Test.startTest();
        	SyncAllStripeCustomerBatch syncBatch = new SyncAllStripeCustomerBatch(acc.Id,null);
        	Database.executeBatch(syncBatch);
        Test.stopTest();
    }

}