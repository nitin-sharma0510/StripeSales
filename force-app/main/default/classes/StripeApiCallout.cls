public class StripeApiCallout {
    
    
    private static Map<String, StripeAccountAPI__c> mcs = StripeAccountAPI__c.getAll();
    private static Integer timeout = 60000;
    
    public static String doCallout(String secretKey, String resource) {
        
        String endPoint = 'https://api.stripe.com/v1/'+resource;
        System.debug(endPoint);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setTimeout(timeout);
        req.setHeader('Authorization', 'Bearer '+secretKey);
        
        HttpResponse resp = new Http().send(req);
        //System.debug(resp.getBody());
        //if(checkForResponseErrors(resp)) {
            return resp.getBody();
        /*} else {
            CalloutException ce = new CalloutException('Error while requesting Information.');
            ce.setMessage(resp.getBody());
            throw ce;
        }*/
        
        //return null;
    }
    
    /*private static Boolean checkForResponseErrors(HttpResponse resp) {
        return resp.getStatus() == 'OK';
    }*/


}