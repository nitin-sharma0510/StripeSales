@isTest
public class StripeControllerTest {

    @isTest
    private static void testStripeController(){
        
        Stripe_Account__c acc = TestUtils.createStripeAccount();
        
        List<StripeEvent__c> eventList = new List<StripeEvent__c>();
        
        for(Integer i = 0; i<5; i++) {
            StripeEvent__c evnt = new StripeEvent__c();
            evnt.Action__c = 'account.created account.updated';
            evnt.Data__c = 'data=[test data]';
            evnt.EndProcessingTime__c = System.today();
            
            eventList.add(evnt);
        }
        insert eventList;
        
        StripeSiteSettings__c settingObj=new StripeSiteSettings__c();
        settingObj.StripeApiEndpoint__c='https://api.stripe.com/v1/';
        settingObj.WebhookUrl__c='https://stripe-api-developer-edition.ap15.force.com/';
        insert settingObj;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Test.startTest();
        
        StripeController.fetchAccounts();
        StripeController.createWebhook(acc.Id);
        StripeController.fetchAccountBalance(acc.Id);
        StripeController.runbatch(acc.Id, 'SyncAllStripeCustomerBatch');
        StripeController.fetchSiteSettings();
        StripeController.saveSiteSettings(settingObj);
        StripeController.verifySiteUrl('www.google.com');
        StripeController.fetchEventLogs();
        
        Test.stopTest();
    }
    
    @isTest
    private static void runbatch2() {
        
        Stripe_Account__c acc=TestUtils.createStripeAccount();
        StripeController.runbatch(acc.Id, 'SyncAllStripeProductsBatch');
    }
    
    @isTest
    private static void runbatch3() {
        
        Stripe_Account__c acc=TestUtils.createStripeAccount();
        StripeController.runbatch(acc.Id, 'SyncAllStripeTaxRatesBatch');
    }
    
    @isTest
    private static void runbatch4() {
        
        Stripe_Account__c acc=TestUtils.createStripeAccount();
        StripeController.runbatch(acc.Id, 'SyncAllStripeChargesBatch');
    }
}