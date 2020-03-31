trigger StripePlanTrigger on StripePlan__c (after insert, after update) {
	
    Map<Id, StripeSubscription__c> subUpsert = new Map<Id, StripeSubscription__c>();
    Map<Id,Id> subsIdwithPlnId = new Map<Id,Id>();
    
    for(StripePlan__c pln : Trigger.new) {
        if(String.isNotEmpty(pln.Stripe_Subscription__c)) {
        	subsIdwithPlnId.put(pln.Stripe_Subscription__c, pln.Id);   
        }    
    }
    
    for(StripeSubscription__c sub : [SELECT Id,Plan__c FROM StripeSubscription__c WHERE Id IN:subsIdwithPlnId.keySet()]) {
        
        if(String.isEmpty(sub.Plan__c)) {
            sub.Plan__c = subsIdwithPlnId.get(sub.Id);
            subUpsert.put(sub.Id, sub);
        }
    }
    
    if(!subUpsert.isEmpty()) {
        upsert subUpsert.values();
    }
}