public class StripePaymentMethodObj {
    public String id {get;set;}
    public DateTime created {get;set;}
    public String customer {get;set;}
    public String type {get;set;}
    //public String brand {get;set;}
    public StripeCardObj card {get;set;}
    public StripeAddressObj billing_details {get;set;}
      
    public StripePaymentMethodObj() {}
}