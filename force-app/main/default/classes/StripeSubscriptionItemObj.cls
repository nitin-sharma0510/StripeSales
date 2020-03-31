public class StripeSubscriptionItemObj {

    public String id {get;set;}
    public String subscription {get;set;} //id of subscription(parent) that its part of
    public Integer quantity {get;set;}
    //public String customer {get;set;} //id of customer(parent) its related to
    public DateTime created {get;set;}
    public StripePlanObj plan {get;set;} //id of plan(prant) its related to 
    public List<StripeTaxRateObj> taxRates {get;set;}

    public StripeSubscriptionItemObj() {}
}