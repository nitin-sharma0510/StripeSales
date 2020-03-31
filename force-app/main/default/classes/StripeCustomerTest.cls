@isTest
public class StripeCustomerTest {

    @isTest
    private static void testStripeCustomer(){
        
        Stripe_Account__c acc=TestUtils.createStripeAccount();
        
        Stripe_Customer__c cust=new Stripe_Customer__c();
        cust.StripeAccountID__c=acc.Id;

        insert cust;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseSingleCustomerGenerator());
        
        Test.startTest();
       	 StripeCustomer.syncStripeCustomer(cust.Id);
        Test.stopTest();
    }
}