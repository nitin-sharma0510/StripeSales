@isTest
public class TestUtils {
    
    public static Stripe_Account__c createStripeAccount() {
        
        Stripe_Account__c acc = new Stripe_Account__c();
        acc.Name = 'Test Stripe Account';
        acc.Active__c = true;
        acc.API_Key__c = 'testapikey';
        acc.API_Secret__c = 'testsecretkey';
        
        insert acc;
        return acc; 
    }
    
    public static Stripe_Account__c createStripeAccount(String name, Boolean active, String apikey, String apisecret, Boolean insertData) {
        
        Stripe_Account__c acc = new Stripe_Account__c();
        acc.Name = name;
        acc.Active__c = active;
        acc.API_Key__c = apikey;
        acc.API_Secret__c = apisecret;
        
        if(insertData)
        insert acc;
        
        return acc;
    }
}