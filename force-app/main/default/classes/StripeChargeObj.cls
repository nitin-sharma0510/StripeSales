public class StripeChargeObj {
    
    public String Id {get;set;}
    public DateTime created {get;set;}
    public String customer {get;set;}
    public Decimal amount {get;set;}
    public Decimal amount_refunded {get;set;}
    public Boolean captured {get;set;}
    public String curncy {get;set;}
    public String description {get;set;}
    public String failure_msg {get;set;}
    public String invoice {get;set;}
    public String order {get;set;}
    public Boolean paid {get;set;}
    public String receipt_num {get;set;}
    public String receipt_url {get;set;}
    public Boolean refunded {get;set;}
    public String status {get;set;}    
    
    public StripeChargeObj() {}

    public class ChargeWrapper
    {
        public String objType {get;set;}
        public List<StripeChargeObj> data {get;set;}
        public Boolean has_more {get;set;}
        public String url {get;set;}

        public ChargeWrapper() {}
    }
}