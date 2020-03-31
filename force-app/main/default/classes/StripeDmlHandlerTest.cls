@isTest
public class StripeDmlHandlerTest {

    @isTest
    private static void testCustomerObjDml(){
        
        Stripe_Account__c acc = TestUtils.createStripeAccount();
        
        String jsonStr='{"id":"cus_FsJHzgh9cRz3DL","object":"customer","account_balance":0,"address":null,"balance":0,"created":1569410857,"currency":"usd","default_source":"card_1FVEzlGAJHaJ7JBviF03k2FF","delinquent":false,"description":"Record","discount":null,"email":"shubh@rajtest.com","invoice_prefix":"4374BF3C","invoice_settings":{"custom_fields":null,"default_payment_method":null,"footer":null},"livemode":false,"metadata":{},"name":"Sumit Raj","phone":null,"preferred_locales":[],"shipping":{"address":{"city":"","country":"","line1":"","line2":"","postal_code":"","state":""},"name":"Sumit Raj","phone":""},"sources":{"object":"list","data":[{"id":"card_1FVEzlGAJHaJ7JBviF03k2FF","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","customer":"cus_FsJHzgh9cRz3DL","cvc_check":null,"dynamic_last4":null,"exp_month":4,"exp_year":2022,"fingerprint":"QechR8d2eLBno2nL","funding":"debit","last4":"5556","metadata":{},"name":null,"tokenization_method":null}],"has_more":false,"total_count":1,"url":"/v1/customers/cus_FsJHzgh9cRz3DL/sources"},"subscriptions":{"object":"list","data":[{"id":"sub_G24SbyVjzjSqwL","object":"subscription","application_fee_percent":null,"billing":"charge_automatically","billing_cycle_anchor":1571662135,"billing_thresholds":null,"cancel_at":null,"cancel_at_period_end":false,"canceled_at":null,"collection_method":"charge_automatically","created":1571662135,"current_period_end":1579610935,"current_period_start":1576932535,"customer":"cus_FsJHzgh9cRz3DL","days_until_due":null,"default_payment_method":null,"default_source":null,"default_tax_rates":[],"discount":null,"ended_at":null,"invoice_customer_balance_settings":{"consume_applied_balance_on_void":true},"items":{"object":"list","data":[{"id":"si_G24SuvmBdJBsbY","object":"subscription_item","billing_thresholds":null,"created":1571662135,"metadata":{},"plan":{"id":"plan_G24Rvji1w3ipGO","object":"plan","active":true,"aggregate_usage":null,"amount":10000,"amount_decimal":"10000","billing_scheme":"per_unit","created":1571662080,"currency":"usd","interval":"month","interval_count":1,"livemode":false,"metadata":{},"nickname":"Monthly","product":"prod_G24RY20SeDXqTb","tiers":null,"tiers_mode":null,"transform_usage":null,"trial_period_days":null,"usage_type":"licensed"},"quantity":1,"subscription":"sub_G24SbyVjzjSqwL","tax_rates":[]}],"has_more":false,"total_count":1,"url":"/v1/subscription_items?subscription=sub_G24SbyVjzjSqwL"},"latest_invoice":"in_1Fs7OIGAJHaJ7JBvWwXfgPTG","livemode":false,"metadata":{},"next_pending_invoice_item_invoice":null,"pending_invoice_item_interval":null,"pending_setup_intent":null,"plan":{"id":"plan_G24Rvji1w3ipGO","object":"plan","active":true,"aggregate_usage":null,"amount":10000,"amount_decimal":"10000","billing_scheme":"per_unit","created":1571662080,"currency":"usd","interval":"month","interval_count":1,"livemode":false,"metadata":{},"nickname":"Monthly","product":"prod_G24RY20SeDXqTb","tiers":null,"tiers_mode":null,"transform_usage":null,"trial_period_days":null,"usage_type":"licensed"},"quantity":1,"schedule":null,"start":1571662135,"start_date":1571662054,"status":"active","tax_percent":null,"trial_end":null,"trial_start":null}],"has_more":false,"total_count":1,"url":"/v1/customers/cus_FsJHzgh9cRz3DL/subscriptions"},"tax_exempt":"none","tax_ids":{"object":"list","data":[],"has_more":false,"total_count":0,"url":"/v1/customers/cus_FsJHzgh9cRz3DL/tax_ids"},"tax_info":null,"tax_info_verification":null}';
    	StripeCustomerObj custObj=JsonToStripeObject.jsonToCustomer((Map<String,Object>)JSON.deserializeUntyped(jsonstr),acc.Id);
        
        List<StripeCustomerObj> custList=new List<StripeCustomerObj>();
        custList.add(custObj);
        
        StripeDmlHandler.customerObjDml(custList);
    }
    
    @isTest
    private static void stripeChargeDmlTest() {
    	
        Stripe_Account__c acc = TestUtils.createStripeAccount();
        
        Stripe_Customer__c cust = new Stripe_Customer__c();
        cust.StripeAccountID__c = acc.Id;
        cust.StripeCustomerID__c = 'cus_FsJHzgh9cRz3DL';
        insert cust;
        
        String jsonstr = '{"id":"ch_1FVFCFGAJHaJ7JBvuzhs6s9Q","object":"charge","amount":12000,"amount_refunded":0,"application":null,"application_fee":null,"application_fee_amount":null,"balance_transaction":"txn_1FyEn7GAJHaJ7JBv8X07m3SL","billing_details":{"address":{"city":null,"country":null,"line1":null,"line2":null,"postal_code":null,"state":null},"email":null,"name":null,"phone":null},"captured":true,"created":1571481007,"currency":"usd","customer":"cus_FsJHzgh9cRz3DL","description":null,"disputed":false,"failure_code":null,"failure_message":null,"fraud_details":{},"invoice":null,"livemode":false,"metadata":{},"on_behalf_of":null,"order":null,"outcome":{"network_status":"approved_by_network","reason":null,"risk_level":"normal","risk_score":4,"seller_message":"Payment complete.","type":"authorized"},"paid":true,"payment_intent":"pi_1FVFCFGAJHaJ7JBvTOGAiNfB","payment_method":"card_1FVEzlGAJHaJ7JBviF03k2FF","payment_method_details":{"card":{"brand":"visa","checks":{"address_line1_check":null,"address_postal_code_check":null,"cvc_check":null},"country":"US","exp_month":4,"exp_year":2022,"fingerprint":"QechR8d2eLBno2nL","funding":"debit","installments":null,"last4":"5556","network":"visa","three_d_secure":null,"wallet":null},"type":"card"},"receipt_email":null,"receipt_number":"1487-2779","receipt_url":"https://pay.stripe.com/receipts/acct_1FExPKGAJHaJ7JBv/ch_1FVFCFGAJHaJ7JBvuzhs6s9Q/rcpt_G1Hl4x8XZstYv0cZyLKWBkr4YeXfIWa","refunded":false,"refunds":{"object":"list","data":[],"has_more":false,"url":"/v1/charges/ch_1FVFCFGAJHaJ7JBvuzhs6s9Q/refunds"},"review":null,"shipping":null,"source_transfer":null,"statement_descriptor":"Test Payment","statement_descriptor_suffix":null,"status":"succeeded","transfer_data":null,"transfer_group":null}';
    	
        List<StripeChargeObj> chargeList = new List<StripeChargeObj>();
        
        StripeChargeObj chrge = JsonToStripeObject.jsonToCharge((Map<String,Object>)JSON.deserializeUntyped(jsonstr));
        
        chargeList.add(chrge);
        
        StripeDmlHandler.stripeChargeDml(chargeList);
        
    }
}