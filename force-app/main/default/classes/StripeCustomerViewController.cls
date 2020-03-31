public class StripeCustomerViewController 
{	
    @AuraEnabled
    public static List<StripeSubscription__c> fetchStripeSubscription(Id custId)
    {
        List<StripeSubscription__c> subscriptionList = [SELECT Id, StripePlanAmount__c, Stripe_Customer__c 
                                                FROM StripeSubscription__c WHERE Stripe_Customer__c =:custId];
        
        return subscriptionList;
    }
    
    @AuraEnabled
    public static List<StripeCharge__c> fetchStripeCharge(Id custId)
    {
        List<StripeCharge__c> chargeList = [SELECT Id,Name,Amount__c,Status__c,Created__c FROM StripeCharge__c WHERE Stripe_Customer__c =:custId];
        return chargeList;
    }
    
    @AuraEnabled
    public static List<ProductWrap> fetchProducts(Id custId)
    {
        List<ProductWrap> prdList = new List<ProductWrap>();
        
        for(StripePlan__c pln: [SELECT Id,Name,Product__r.Name, Interval_Count__c 
                                FROM StripePlan__c 
                                WHERE Stripe_Subscription__r.Stripe_Customer__c =:custId])
        {
            ProductWrap prd = new ProductWrap();
            prd.ProductId = pln.Id;
            prd.ProductName = pln.Product__r.Name;
            prd.ProductSize = pln.Interval_Count__c;
            
            prdList.add(prd);
        }
        
        return prdList;
    }
    
    @AuraEnabled
    public static List<StripePaymentMethod__c> fetchStripePaymentMethods(Id custId)
    {
        List<StripePaymentMethod__c> stripePayMthds = [SELECT Id, Last_Four_Digits__c, Brand__c 
                                                       FROM StripePaymentMethod__c 
                                                       WHERE Stripe_Customer__c =:custId];
        
        return stripePayMthds;
    }
    
    Public class ProductWrap{
        @AuraEnabled
        public String ProductId{get;set;}
        @AuraEnabled
        public String ProductName{get;set;}
        @AuraEnabled
        public Decimal ProductSize{get;set;}
    }
}