@isTest
public class WebhookStripeSubscriptionTest {

    @isTest static void postMethodTest(){
        
        String jsonMsg='{"created":1326853478,"livemode":false,"id":"evt_00000000000000","type":"customer.subscription.created","object":"event","request":null,"pending_webhooks":1,"api_version":"2019-08-14","data":{"object":{"id":"sub_00000000000000","object":"subscription","application_fee_percent":null,"billing":"charge_automatically","billing_cycle_anchor":1578573543,"billing_thresholds":null,"cancel_at":null,"cancel_at_period_end":false,"canceled_at":null,"collection_method":"charge_automatically","created":1578573543,"current_period_end":1581251943,"current_period_start":1578573543,"customer":"cus_00000000000000","days_until_due":null,"default_payment_method":null,"default_source":null,"default_tax_rates":[],"discount":null,"ended_at":null,"invoice_customer_balance_settings":{"consume_applied_balance_on_void":true},"items":{"object":"list","data":[{"id":"si_00000000000000","object":"subscription_item","billing_thresholds":null,"created":1578573543,"metadata":{},"plan":{"id":"plan_00000000000000","object":"plan","active":true,"aggregate_usage":null,"amount":10000,"amount_decimal":"10000","billing_scheme":"per_unit","created":1578478935,"currency":"usd","interval":"month","interval_count":1,"livemode":false,"metadata":{},"nickname":"testing month","product":"prod_00000000000000","tiers":null,"tiers_mode":null,"transform_usage":null,"trial_period_days":17,"usage_type":"licensed"},"quantity":1,"subscription":"sub_00000000000000","tax_rates":[{"id":"txr_1Fz0bIGAJHaJ7JBvVZZhGd4K","object":"tax_rate","active":true,"created":1578574740,"description":"VAT Germany","display_name":"VAT","inclusive":false,"jurisdiction":"DE","livemode":false,"metadata":{},"percentage":19}]}],"has_more":false,"url":"/v1/subscription_items?subscription=sub_GW2MlYHxXz2qZN"},"latest_invoice":null,"livemode":false,"metadata":{},"next_pending_invoice_item_invoice":null,"pending_invoice_item_interval":null,"pending_setup_intent":null,"plan":{"id":"plan_00000000000000","object":"plan","active":true,"aggregate_usage":null,"amount":10000,"amount_decimal":"10000","billing_scheme":"per_unit","created":1578478935,"currency":"usd","interval":"month","interval_count":1,"livemode":false,"metadata":{},"nickname":"testing month","product":"prod_00000000000000","tiers":null,"tiers_mode":null,"transform_usage":null,"trial_period_days":17,"usage_type":"licensed"},"quantity":1,"schedule":null,"start":1578573543,"start_date":1578573543,"status":"active","tax_percent":null,"trial_end":null,"trial_start":null}}}';
        RestResponse res=new RestResponse();
        RestRequest req=new RestRequest();
        
        req.requestURI='/StripeSubscription/';
        req.httpMethod='POST';
        req.requestBody=Blob.valueOf(jsonMsg);
        RestContext.request=req;
        RestContext.response=res;
        
        Test.startTest();
        WebhookStripeSubscription.postMethod();
        Test.stopTest();

    }
}