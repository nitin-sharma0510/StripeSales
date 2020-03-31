@isTest
public class WebhookStripePaymentMethodTest {
    
    @isTest static void postMethodTest1() {
        
        String JsonMsg = '{"created":1326853478,"livemode":false,"id":"evt_00000000000000","type":"payment_method.attached","object":"event","request":null,"pending_webhooks":1,"api_version":"2019-12-03","data":{"object":{"id":"pm_00000000000000","object":"payment_method","billing_details":{"address":{"city":"","country":"","line1":"","line2":"","postal_code":"","state":""},"email":"jenny@example.com","name":null,"phone":"+15555555555"},"card":{"brand":"visa","checks":{"address_line1_check":null,"address_postal_code_check":null,"cvc_check":null},"country":"US","exp_month":8,"exp_year":2021,"fingerprint":"sHTU4cWSxyXd25N6","funding":"credit","generated_from":null,"last4":"4242","three_d_secure_usage":{"supported":true},"wallet":null},"created":123456789,"customer":null,"livemode":false,"metadata":{"order_id":"123456789"},"type":"card"}}}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/StripePaymentMethod/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        WebhookStripePaymentMethod.postMethod();
        Test.stopTest();
    }

    @isTest static void postMethodTest2() {
        
        String JsonMsg = '{"created":1326853478,"livemode":false,"id":"evt_00000000000000","type":"payment_method.attached","object":"event","request":null,"pending_webhooks":1,"api_version":"2019-12-03","data":{"object":{"id":"pm_00000000000000","object":"payment_method","billing_details":{"address":{"city":"","country":"","line1":"","line2":"","postal_code":"","state":""},"email":"jenny@example.com","name":null,"phone":"+15555555555"},"card":{"brand":"visa","checks":{"address_line1_check":null,"address_postal_code_check":null,"cvc_check":null},"country":"US","exp_month":8,"exp_year":2021,"fingerprint":"sHTU4cWSxyXd25N6","funding":"credit","generated_from":null,"last4":"4242","three_d_secure_usage":{"supported":true},"wallet":null},"created":123456789,"customer":"id12345","livemode":false,"metadata":{"order_id":"123456789"},"type":"card"}}}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/StripePaymentMethod/';  //Request URL
        req.httpMethod = 'POST'; //HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        
        Stripe_Account__c acc = TestUtils.createStripeAccount();
        
        Stripe_Customer__c cus = new Stripe_Customer__c();
        cus.Name = 'firstname lastname';
        cus.StripeCustomerID__c = 'id12345';
        cus.StripeAccountID__c = acc.Id;
        
        insert cus;
        
        Test.startTest();
        WebhookStripePaymentMethod.postMethod();
        Test.stopTest();
    }
}