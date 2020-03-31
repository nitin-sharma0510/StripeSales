public class StripeSubscriptionObj {

    public String id {get;set;}
    public String parentCust {get;set;}
    public DateTime created {get;set;}
    public DateTime started {get;set;}
    public String status {get;set;}
    public Integer quantity {get;set;}
    public StripePlanObj plan {get;set;}
    public List<StripeSubscriptionItemObj> items {get;set;}
    public String collectionMethd {get;set;}
    public DateTime currentPeriodStart {get;set;}
    public DateTime currentPeriodEnd {get;set;}
    public DateTime trialEnd {get;set;}
    public DateTime trialStart {get;set;}
    public Boolean cancelPeriodEnd {get;set;}
    public DateTime canceledAt {get;set;}
    public String discount {get;set;}
    //public StripePaymentMethodObj defaultPaymentMethod {get;set;} 

    public StripeSubscriptionObj() {}
}