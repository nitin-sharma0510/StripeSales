public class StripeDmlHandler
{   
    public static void customerObjDml(List<StripeCustomerObj> custList)
    {
        //Data to upsert
        List<Stripe_Customer__c> customers = new List<Stripe_Customer__c>();
        List<StripeSubscription__c> subs = new List<StripeSubscription__c>();
        List<StripeSubscriptionItem__c> subItems = new List<StripeSubscriptionItem__c>();
        List<StripeTaxRate__c> taxRate = new List<StripeTaxRate__c>();
        
        //changing the plan list to map to avoid duplicates in the same json
        Map<String, StripePlan__c> plans = new Map<String, StripePlan__c>();

        //taxrates map
        Map<String, List<StripeTaxRateObj>> taxRtsObjMap = new Map<String, List<StripeTaxRateObj>>();  

        //Map to point to sf id after upsert
        Map<String, Id> custmrExtrnlIdMap = new Map<String,Id>();
        Map<String, Id> subExtrnlIdMap = new Map<String,Id>();
        Map<String, Id> subItmExtrnlIdMap = new Map<String, Id>();
        Map<String, Id> prodExtrnlIdMap = new Map<String, Id>();

        //Map to point planExt id to stripesubitemExt id
        Map<String,String> planExToItemExtMap = new  Map<String,String>();

        //child json object
        List<StripeSubscriptionObj> subObjList = new List<StripeSubscriptionObj>();
        List<StripeSubscriptionItemObj> itemObjList = new List<StripeSubscriptionItemObj>();
        

        //product map
        Set<String> prodExtIds = new Set<String>();

        //Iterating on StripeCustomerObj and populating Sobject for dml
        for(StripeCustomerObj custObj : custList)
        {
            Stripe_Customer__c cust = new Stripe_Customer__c();

            if(!String.isBlank(custObj.parentId)) {
                cust.StripeAccountID__c = custObj.parentId;
            }
            cust.StripeCustomerID__c = custObj.custId;
            cust.Name = custObj.name;
            cust.Phone__c = custObj.phone;
            cust.Email__c = custObj.email;
            cust.Balance__c = custObj.balance;
            cust.Currency__c = custObj.currenc;
            cust.Delinquent__c = custObj.delinquent;
            cust.Created__c = custObj.createdTime;

            customers.add(cust);

            //Add child list for upsert later with parent id
            subObjList.addAll(custObj.subList);
        }
        
        Database.UpsertResult[] results = Database.upsert(customers, Stripe_Customer__c.StripeCustomerID__c);

        for(Integer index = 0, size = results.size(); index < size; index++) {
            if(results[index].isSuccess()) {
                custmrExtrnlIdMap.put(customers[index].StripeCustomerID__c, results[index].getId());
            }
        }

        for(StripeSubscriptionObj subObj : subObjList)
        {
            if(custmrExtrnlIdMap.containsKey(subObj.parentCust))
            {
                StripeSubscription__c sub = new StripeSubscription__c();
                sub.Stripe_Customer__c	= custmrExtrnlIdMap.get(subObj.parentCust);
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
 
                subs.add(sub);

                //Add child list for upsert later with parent id
                itemObjList.addAll(subObj.items);
            }
        }

        Database.UpsertResult[] resultsSub = Database.upsert(subs, StripeSubscription__c.StripeSubscriptionId__c);

        for(Integer index = 0, size = resultsSub.size(); index < size; index++) {
            if(resultsSub[index].isSuccess()) {
                subExtrnlIdMap.put(subs[index].StripeSubscriptionId__c, resultsSub[index].getId());
            }
        }

        for(StripeSubscriptionItemObj obj : itemObjList)
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
    }

    public static void stripeChargeDml(List<StripeChargeObj> chargeList)
    {
        Set<String> custmrIds = new Set<String>();
        Map<String, Stripe_Customer__c> extnIdToSfcustmr = new Map<String, Stripe_Customer__c>();
        List<StripeCharge__c> chargeToUpsert = new List<StripeCharge__c>();

        for(StripeChargeObj obj : chargeList)
        {
            custmrIds.add(obj.customer);
        }

        for(Stripe_Customer__c cust : [SELECT id,StripeCustomerID__c FROM Stripe_Customer__c WHERE StripeCustomerID__c IN:custmrIds])
        {
            extnIdToSfcustmr.put(cust.StripeCustomerID__c, cust);
        }

        for(StripeChargeObj obj : chargeList) 
        {
            if(extnIdToSfcustmr.containsKey(obj.customer))
            {
                StripeCharge__c charge = new StripeCharge__c();

                charge.StripeChargeId__c = obj.Id;
                charge.Created__c = obj.created;
                charge.Stripe_Customer__c = extnIdToSfcustmr.get(obj.customer).Id;
                charge.Amount__c = obj.amount;
                charge.Amount_Refunded__c = obj.amount_refunded;
                charge.Captured__c = obj.captured;
                charge.Currency__c = obj.curncy;
                charge.Description__c = obj.description;
                charge.Failure_Message__c = obj.failure_msg;
                charge.Invoice_Id__c = obj.invoice;
                charge.Order_Id__c = obj.order;
                charge.Paid__c = obj.paid;
                charge.Receipt_Id__c = obj.receipt_num;
                charge.Receipt_Url__c = obj.receipt_url;
                charge.Refunded__c = obj.refunded;
                charge.Status__c = obj.status;

                chargeToUpsert.add(charge);
            }
        }

        if(!chargeToUpsert.isEmpty())
        {
            Database.upsert(chargeToUpsert, StripeCharge__c.StripeChargeId__c);       
        }
    }
}