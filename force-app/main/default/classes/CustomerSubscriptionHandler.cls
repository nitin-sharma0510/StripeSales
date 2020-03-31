public class CustomerSubscriptionHandler implements IStripeWebhooks {
    
  public static void parseResponse(Map<String,Object> postData, Map<String,String>paramsMap){        
        Datetime startTime = System.now();
        // its not in use
        string stripeAccId = RestContext.request.params.get('AccId');       
        
        RestResponse res = RestContext.response;
        List<StripeSubscription__c> subUpsert = new List<StripeSubscription__c>();
        List<StripeSubscriptionItem__c> subItemUpsert = new List<StripeSubscriptionItem__c>();
        List<StripeTaxRate__c> taxRate = new List<StripeTaxRate__c>();
        List<StripeSubscriptionItem__c> subItems = new List<StripeSubscriptionItem__c>();
        
        Map<String, StripePlan__c> plans = new Map<String, StripePlan__c>();
        Map<String, Id> subItmExtrnlIdMap = new Map<String, Id>();
        
        //externalid to object id maps
        Map<String, Id> subExtrnlIdMap = new Map<String,Id>();
        Map<String, String> planExToItemExtMap = new Map<String,String>();
        Map<String, Id> prodExtrnlIdMap = new Map<String, Id>();
        
        Map<String, List<StripeTaxRateObj>> taxRtsObjMap = new Map<String, List<StripeTaxRateObj>>();  
        
        Set<String> prodExtIds = new Set<String>();  
        
        Map<String,Object> subMap = (Map<String,Object>)postData.get('data');
        StripeSubscriptionObj subObj = JsonToStripeObject.jsonToSubscription((Map<String,Object>)subMap.get('object'));
        
        List<Stripe_Customer__c> stripeCust = [SELECT id,StripeCustomerID__c FROM Stripe_Customer__c 
                                               WHERE StripeCustomerID__c =: subObj.parentCust];
        
        StripeSubscription__c sub = new StripeSubscription__c();
        sub.Stripe_Customer__c	= stripeCust.isEmpty() ? null : stripeCust[0].Id;
        sub.StripeSubscriptionId__c = subObj.id; 
        sub.Created__c = subObj.created;
        sub.Started__c = subObj.started; 
        sub.Status__c = subObj.status;
        sub.Quantity__c = subObj.quantity;
        sub.Collection_Method__c = subObj.collectionMethd;
        sub.Current_Period_Start__c = subObj.currentPeriodStart;
        sub.Current_Period_End__c = subObj.currentPeriodEnd; 
        sub.Trial_End__c = subObj.trialEnd;
        sub.Trial_Start__c = subObj.trialStart;
        sub.Cancel_At_Period_End__c = subObj.cancelPeriodEnd;
        sub.Cancelled_At__c = subObj.canceledAt; 
        sub.Discount__c = subObj.discount;
        
        subUpsert.add(sub);
        try{
            Database.UpsertResult[] resultsSub = Database.upsert(subUpsert, StripeSubscription__c.StripeSubscriptionId__c);
            
            for(Integer index = 0, size = resultsSub.size(); index < size; index++) {
                if(resultsSub[index].isSuccess()) {
                    subExtrnlIdMap.put(subUpsert[index].StripeSubscriptionId__c, resultsSub[index].getId());
                }
            }
            
            for(StripeSubscriptionItemObj obj : subObj.items)
            {
                StripeSubscriptionItem__c itm = new StripeSubscriptionItem__c();
                
                itm.Subscription__c = subExtrnlIdMap.get(obj.subscription);
                itm.Quantity__c = obj.quantity;
                itm.Created__c = obj.created;
                itm.StripeSubscriptionItemId__c = obj.id;
                
                StripePlan__c pln = new StripePlan__c();
                pln.Stripe_Subscription__c = subExtrnlIdMap.get(obj.subscription);
                pln.StripePlanId__c = obj.plan.id;
                pln.Interval__c = obj.plan.interval;
                pln.Interval_Count__c = obj.plan.intervalCount;
                pln.Amount__c = obj.plan.amount;
                pln.Billing_Scheme__c = obj.plan.billingScheme;
                pln.Created__c = obj.plan.created;
                pln.Currency__c = obj.plan.currncy;
                pln.Name = obj.plan.nickname;
                pln.ExternalProdId__c = obj.plan.product;
                
                planExToItemExtMap.put(obj.plan.id, obj.id);
                
                prodExtIds.add(obj.plan.product);//Need sf product id to make relationship
                plans.put(pln.StripePlanId__c, pln); //dont dml yet
                
                subItems.add(itm);
                
                taxRtsObjMap.put(obj.id, obj.taxRates);
            }
            
            Database.UpsertResult[] resultSubItems = Database.upsert(subItems, StripeSubscriptionItem__c.StripeSubscriptionItemId__c);
            
            for(Integer index = 0, size = resultSubItems.size(); index < size; index++) {
                if(resultSubItems[index].isSuccess()) {
                    subItmExtrnlIdMap.put(subItems[index].StripeSubscriptionItemId__c, resultSubItems[index].getId());
                    
                    for(StripeTaxRateObj obj : taxRtsObjMap.get(subItems[index].StripeSubscriptionItemId__c))
                    {
                        StripeTaxRate__c tax = new StripeTaxRate__c();
                        tax.StripeId__c = obj.Id;
                        tax.Active__c = obj.active;
                        tax.Created__c = obj.created;
                        tax.Name = obj.Name;
                        tax.Description__c = obj.Description;
                        tax.Inclusive__c = obj.inclusive;
                        tax.Jurisdiction__c = obj.jurisdiction;
                        tax.Percentage__c = obj.percentage;
                        tax.StripeSubscriptionItem__c = resultSubItems[index].getId();
                        
                        taxRate.add(tax);
                    }
                }
            }
            
            for(Product2 prod : [SELECT id,StripeProductId__c FROM Product2 WHERE StripeProductId__c IN:prodExtIds]) {
                
                prodExtrnlIdMap.put(prod.StripeProductId__c, prod.Id);
            }
            
            for(StripePlan__c pln : plans.values())
            {
                pln.StripeSubscriptionItem__c = subItmExtrnlIdMap.get(planExToItemExtMap.get(pln.StripePlanId__c));
                
                if(prodExtrnlIdMap.containsKey(pln.ExternalProdId__c))
                    pln.Product__c = prodExtrnlIdMap.get(pln.ExternalProdId__c);
            }
            
            Database.upsert(taxRate, StripeTaxRate__c.StripeId__c);
            Database.upsert(plans.values(), StripePlan__c.StripePlanId__c);
        } catch (Exception ex) {
            Logger.capture(ex);
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(ex.getMessage() +' Line: '+ex.getStackTraceString());
            res.statusCode = 501;
            
            StripeWebhookHandler.createLog(postData, 'error: '+ex.getMessage().abbreviate(200), startTime, System.now());
        } 
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf('success');
        res.statusCode = 200;
        
        StripeWebhookHandler.createLog(postData, subExtrnlIdMap.values()[0], startTime, System.now());
    }
}