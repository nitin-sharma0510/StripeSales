public class StripeWebhookHandler {

    public static void createLog(Map<String,Object> webhk, String objId, Datetime startTime, Datetime endTime) {
        
        List<String> rsource = new List<String>();

        StripeEvent__c evnt = new StripeEvent__c();

        evnt.Type__c = (String)webhk.get('type');
        rsource = evnt.Type__c.split('\\.');
        
        if(rsource.size() == 2 ) {
            
            evnt.PrimaryResource__c = rsource[0];
            evnt.Action__c = rsource[1];
        }else if(rsource.size() == 3 ) {
            
            evnt.PrimaryResource__c = rsource[0];
            evnt.SecondaryResource__c = rsource[1];
            evnt.Action__c = rsource[2];
        }

        Map<String, Object> obj = (Map<String, Object>)webhk.get('data');
        Map<String, Object> objData = (Map<String,Object>)obj.get('object');
        evnt.ResourceType__c = (String)objData.get('object');
        evnt.ResourceId__c = (String)objData.get('id');
        evnt.ResourceRecord__c = objId;

        String objDataStr = String.valueOf(objData);
        evnt.Data__c = objDataStr.abbreviate(131072);
        evnt.StartProcessingTime__c = startTime;
        evnt.EndProcessingTime__c = endTime;

        insert evnt;
    }
}