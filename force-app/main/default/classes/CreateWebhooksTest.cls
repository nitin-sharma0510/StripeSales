@isTest
public class CreateWebhooksTest {

    @testsetup static void setupdata() {
                
        StripeSiteSettings__c site = new StripeSiteSettings__c();
        site.WebhookUrl__c = 'https://www.google.com/';
        
        insert site;
		
        Stripe_Account__c acc = new Stripe_Account__c();
        acc.Name = 'Test Stripe Account';
        acc.Active__c = true;
        acc.API_Key__c = 'testapikey';
        acc.API_Secret__c = 'testsecretkey';
        
        Insert acc;

    }
    
    @isTest static void createTest() {        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Stripe_Account__c acc = [SELECT Id FROM Stripe_Account__c WHERE Name = 'Test Stripe Account'];
        Test.startTest();
        	CreateWebhooks.create(acc.Id);
        Test.stopTest();
    }
}