public class CreateWebhooks {

    private static String SITE_URL; //= 'https://stripe-api-developer-edition.ap15.force.com/stripe/services/apexrest/';
    
    //webhook for all the classes accept post request
    private static final String CHARGE_WEBHOOK = 'StripeCharges';
    //private static List<String> chargeEvents = new List<String>{'charge.updated','charge.succeeded'};

    private static final String PRODUCT_WEBHOOK = 'StripeProduct';
    //private static List<String> prodEvents = new List<String>{'product.updated','product.created'};

    private static final String PAYMENT_WEBHOOK = 'StripePaymentMethod';
    //private static List<String> paymentEvents = new List<String>{'payment_method.attached','payment_method.card_automatically_updated','payment_method.detached','payment_method.updated'};

    private static final String SUBSCRIPTION_WEBHOOK = 'StripeSubscription';
    //private static List<String> subscripEvents = new List<String>{'customer.subscription.updated','customer.subscription.created'};

    private static final String CUSTOMER_WEBHOOK = 'StripeCustomer';
    //private static List<String> custmrEvents = new List<String>{'customer.created','customer.updated'};
        
    //endpoint to create webhook endpoints in Stripe
    private static final String ENDPOINT = 'https://api.stripe.com/v1/webhook_endpoints';

    private static String secretKey;
    
    public static void fetchEndpoint() {
        
        StripeSiteSettings__c site = StripeSiteSettings__c.getOrgDefaults();
        String url = site.WebhookUrl__c;

        if(url.right(1).equals('/')) {
            SITE_URL = url+'services/apexrest/';
        }else {
            SITE_URL = url+'/services/apexrest/';
        }
        
        System.debug('SITE_URL@@@@>' + SITE_URL);
    }

    public static void create(String accId) {

        fetchEndpoint();
        System.debug('logLevel '+SITE_URL);
        Set<String> allEvents = new Set<String>();
        List<Webhook__c> webhkList = new List<Webhook__c>();
        Stripe_Account__c stripeAcc = [SELECT Id, API_Secret__c,(SELECT Id,Url__c FROM Webhooks__r) FROM Stripe_Account__c WHERE Id =:accId];
        
        secretKey = stripeAcc.API_Secret__c;
        
        for(Webhook__c webhk: stripeAcc.Webhooks__r) {
            allEvents.add(webhk.Url__c);
        }

        if(stripeAcc.Webhooks__r.isEmpty()) {            

            webhkList.add(createStripeChargeWebhook(accId));
            webhkList.add(createStripeProducteWebhook(accId));
            webhkList.add(createStripeSubscriptionWebhook(accId));
            webhkList.add(createStripeCustomerWebhook(accId));
            webhkList.add(createPaymentWebhook(accId));
        }else {

            if(!allEvents.contains(SITE_URL + CHARGE_WEBHOOK)) {
                webhkList.add(createStripeChargeWebhook(accId));
            }

            if(!allEvents.contains(SITE_URL + PRODUCT_WEBHOOK)) {
                webhkList.add(createStripeProducteWebhook(accId));
            }

            if(!allEvents.contains(SITE_URL + SUBSCRIPTION_WEBHOOK)) {
                webhkList.add(createStripeSubscriptionWebhook(accId));
            }

            if(!allEvents.contains(SITE_URL + CUSTOMER_WEBHOOK +'?AccId='+ accId)) {
                webhkList.add(createStripeCustomerWebhook(accId));
            }

            if(!allEvents.contains(SITE_URL + PAYMENT_WEBHOOK)) {
                webhkList.add(createPaymentWebhook(accId));
            }
        } 
        
        if(!webhkList.isEmpty())
        insert webhkList;
    }

    private static Webhook__c createStripeChargeWebhook(String accId) {

        String body = 'url='+ SITE_URL + CHARGE_WEBHOOK 
                        +'&enabled_events[]=charge.updated&enabled_events[]=charge.succeeded';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setMethod('POST');

        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(secretKey));
        // Add the basic auth string to the Request Header
        req.setHeader('Authorization', authorizationHeader);

        req.setbody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);

        System.debug('RESPONSE '+response.getBody());
        return createLog(accId, (Map<String, Object>)JSON.deserializeUntyped(response.getBody()));
    }

    private static Webhook__c createStripeProducteWebhook(String accId) {

        String body = 'url='+ SITE_URL + PRODUCT_WEBHOOK 
                        +'&enabled_events[]=product.updated&enabled_events[]=product.created';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setMethod('POST');

        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(secretKey));
        // Add the basic auth string to the Request Header
        req.setHeader('Authorization', authorizationHeader);

        req.setbody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);

        System.debug('RESPONSE '+response.getBody());
        return createLog(accId, (Map<String, Object>)JSON.deserializeUntyped(response.getBody()));
    }

    private static Webhook__c createStripeSubscriptionWebhook(String accId) {

        String body = 'url='+ SITE_URL + SUBSCRIPTION_WEBHOOK 
                        +'&enabled_events[]=customer.subscription.updated&enabled_events[]=customer.subscription.created';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setMethod('POST');

        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(secretKey));
        // Add the basic auth string to the Request Header
        req.setHeader('Authorization', authorizationHeader);

        req.setbody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);

        System.debug('RESPONSE '+response.getBody());
        return createLog(accId, (Map<String, Object>)JSON.deserializeUntyped(response.getBody()));
    }

    private static Webhook__c createStripeCustomerWebhook(String accId) {

        String body = 'url='+ SITE_URL + CUSTOMER_WEBHOOK +'?AccId='+ accId 
                        +'&enabled_events[]=customer.created&enabled_events[]=customer.updated';
                        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setMethod('POST');

        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(secretKey));
        // Add the basic auth string to the Request Header
        req.setHeader('Authorization', authorizationHeader);

        req.setbody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);

        System.debug('RESPONSE '+response.getBody());
        return createLog(accId, (Map<String, Object>)JSON.deserializeUntyped(response.getBody()));
    }

    private static Webhook__c createPaymentWebhook(String accId) {

        String body = 'url='+ SITE_URL + PAYMENT_WEBHOOK 
                        +'&enabled_events[]=payment_method.attached&enabled_events[]=payment_method.card_automatically_updated'+
                        '&enabled_events[]=payment_method.detached&enabled_events[]=payment_method.updated';
                        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT);
        req.setMethod('POST');

        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(secretKey));
        // Add the basic auth string to the Request Header
        req.setHeader('Authorization', authorizationHeader);

        req.setbody(body);
        Http http = new Http();
        HTTPResponse response = http.send(req);

        System.debug('RESPONSE '+response.getBody());
        return createLog(accId, (Map<String, Object>)JSON.deserializeUntyped(response.getBody()));
    }

    public static Webhook__c createLog(String accId, Map<String,Object> mapObj) {

        Webhook__c webhk = new Webhook__c();

        webhk.Url__c = (String)mapObj.get('url');
        webhk.WebhookId__c = (String)mapObj.get('id');
        webhk.Livemode__c = (Boolean)mapObj.get('livemode');
        webhk.Status__c = (String)mapObj.get('status');
        webhk.Enabled_Events__c = String.join((List<Object>)mapObj.get('enabled_events'), ', ');
        webhk.Created__c = System.today();
        webhk.StripeAccount__c = accId;

        return webhk;
    }
     
}