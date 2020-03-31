public class StripeCustomerObj {
    
    public string custId {get;set;}
    public string email {get;set;}
    public string name {get;set;}
    public String phone {get;set;}
    public Decimal balance {get;set;}
    public String currenc {get;set;}
    public Boolean delinquent {get;set;}
    public DateTime createdTime {get;set;}
    public StripeShippingAddressObj shipping {get;set;}
    public List<StripeSubscriptionObj> subList {get;set;}
    public List<StripeCardObj> cardList {get;set;}
    public String parentId {get;set;}
    
    public StripeCustomerObj() {}
}