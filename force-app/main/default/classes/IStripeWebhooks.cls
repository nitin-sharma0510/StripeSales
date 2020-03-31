public interface IStripeWebhooks {
    
    void parseResponse(Map<String,Object> mapOfData,Map<String,String> paramsMap);
    
}