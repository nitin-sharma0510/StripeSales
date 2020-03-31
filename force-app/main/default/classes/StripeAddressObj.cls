public class StripeAddressObj {
    public AddressObj address {get;set;}
    public String email {get;set;}
    public String name {get;set;}
    public String phone {get;set;}
    
    public StripeAddressObj() {
        address = new AddressObj();
    }

    public class AddressObj {		
        public String city {get;set;}
        public String country {get;set;}
        public String line1 {get;set;}
        public String line2 {get;set;}
        public String postal_code {get;set;}
        public String state {get;set;}

        public AddressObj() {}       
    }
}