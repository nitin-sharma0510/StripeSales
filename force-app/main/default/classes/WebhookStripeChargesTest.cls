@isTest
public class WebhookStripeChargesTest {
	
    @isTest static void postMethodTest(){
        
        String jsonMsg='{"created":1326853478,"livemode":false,"id":"evt_00000000000000","type":"charge.succeeded","object":"event","request":null,"pending_webhooks":1,"api_version":"2019-08-14","data":{"object":{"id":"ch_00000000000000","object":"charge","amount":12000,"amount_refunded":0,"application":null,"application_fee":null,"application_fee_amount":null,"balance_transaction":"txn_00000000000000","billing_details":{"address":{"city":null,"country":null,"line1":null,"line2":null,"postal_code":null,"state":null},"email":null,"name":null,"phone":null},"captured":true,"created":1571481007,"currency":"usd","customer":"cus_00000000000000","description":null,"dispute":null,"disputed":false,"failure_code":null,"failure_message":null,"fraud_details":{},"invoice":null,"livemode":false,"metadata":{},"on_behalf_of":null,"order":null,"outcome":{"network_status":"approved_by_network","reason":null,"risk_level":"normal","risk_score":4,"seller_message":"Payment complete.","type":"authorized"},"paid":true,"payment_intent":"pi_00000000000000","payment_method":"card_00000000000000","payment_method_details":{"card":{"brand":"visa","checks":{"address_line1_check":null,"address_postal_code_check":null,"cvc_check":null},"country":"US","exp_month":4,"exp_year":2022,"fingerprint":"QechR8d2eLBno2nL","funding":"debit","installments":null,"last4":"5556","network":"visa","three_d_secure":null,"wallet":null},"type":"card"},"receipt_email":null,"receipt_number":"1487-2779","receipt_url":"https://pay.stripe.com/receipts/acct_1FExPKGAJHaJ7JBv/ch_1FVFCFGAJHaJ7JBvuzhs6s9Q/rcpt_G1Hl4x8XZstYv0cZyLKWBkr4YeXfIWa","refunded":false,"refunds":{"object":"list","data":[],"has_more":false,"url":"/v1/charges/ch_1FVFCFGAJHaJ7JBvuzhs6s9Q/refunds"},"review":null,"shipping":null,"source_transfer":null,"statement_descriptor":"Test Payment","statement_descriptor_suffix":null,"status":"succeeded","transfer_data":null,"transfer_group":null}}}';
        RestRequest req=new RestRequest();
        RestResponse res=new RestResponse();
        
        req.requestURI='/StripeCharges/';
        req.httpMethod='POST';
        req.requestBody=Blob.valueOf(jsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        
        Test.startTest();
        WebhookStripeCharges.postMethod();
        Test.stopTest();
        
        
    }
}