@isTest
public class StripeCustomerViewControllerTest {

    @isTest
    private static void testFetchStripe(){
        
        Stripe_Account__c acc=TestUtils.createStripeAccount();
        
        Stripe_Customer__c cust = new Stripe_Customer__c();
        cust.StripeAccountID__c=acc.Id;
        insert cust;
        
        //String jsonStr='{"id":"plan_GVcvwakJhpKlRD","object":"plan","active":true,"aggregate_usage":null,"amount":10000,"amount_decimal":"10000","billing_scheme":"per_unit","created":1578478935,"currency":"usd","interval":"month","interval_count":1,"livemode":false,"metadata":{},"nickname":"testing month","product":"prod_GVctSX10Usl6FE","tiers":null,"tiers_mode":null,"transform_usage":null,"trial_period_days":17,"usage_type":"licensed"}';
        //StripePlanObj planObj=JsonToStripeObject.jsonToPlan((Map<String,Object>)JSON.deserializeUntyped(jsonStr));
        
        StripeSubscription__c sub = new StripeSubscription__c();
        sub.Stripe_Customer__c = cust.Id;
        insert sub;
        
       
        StripePlan__c pln = new StripePlan__c();
        pln.Stripe_Subscription__c = sub.Id;
        insert pln;
        
        Test.startTest();
        StripeCustomerViewController.fetchProducts(cust.Id);
        StripeCustomerViewController.fetchStripeCharge(cust.Id);
        StripeCustomerViewController.fetchStripePaymentMethods(cust.Id);
        StripeCustomerViewController.fetchStripeSubscription(cust.Id);
        Test.stopTest();
    }
}