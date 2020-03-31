public class JsonToStripeObject
{
    
    public static StripeCustomerObj jsonToCustomer(Map<String,Object> jsonObj)
    {
        StripeCustomerObj cust = new StripeCustomerObj();

        if((String)jsonObj.get('object') == 'customer')
        {
            cust.custId = (String)jsonObj.get('id');
            cust.email = (String)jsonObj.get('email');
            cust.name = (String)jsonObj.get('name');
            cust.phone = (String)jsonObj.get('phone');
            cust.balance = (Decimal)jsonObj.get('balance');
            cust.currenc = (String)jsonObj.get('currency');
            cust.delinquent = (Boolean)jsonObj.get('delinquent');
            cust.createdTime = convertToDatetime((Long)jsonObj.get('created'));
            
            if(jsonObj.get('shipping') != null)
            cust.shipping = jsonToShippingAddress((Map<String, Object>)jsonObj.get('shipping'));

            Map<String, Object> subMap = (Map<String, Object>)jsonObj.get('subscriptions');
            cust.subList = jsonToSubscriptionList((List<Object>)subMap.get('data'));

            Map<String, Object> cardMap = (Map<String, Object>)jsonObj.get('sources');
            cust.cardList = jsonToCardList((List<Object>)cardMap.get('data'));
        }

        return cust;
    }

    public static StripeCustomerObj jsonToCustomer(Map<String,Object> jsonObj, String parentId)
    {
        StripeCustomerObj cust = new StripeCustomerObj();

        if((String)jsonObj.get('object') == 'customer')
        {
            cust.parentId = parentId;
            cust.custId = (String)jsonObj.get('id');
            cust.email = (String)jsonObj.get('email');
            cust.name = (String)jsonObj.get('name');
            cust.phone = (String)jsonObj.get('phone');
            cust.balance = (Decimal)jsonObj.get('balance');
            cust.currenc = (String)jsonObj.get('currency');
            cust.delinquent = (Boolean)jsonObj.get('delinquent');
            cust.createdTime = convertToDatetime((Long)jsonObj.get('created'));

            if(jsonObj.get('shipping') != null)
            cust.shipping = jsonToShippingAddress((Map<String, Object>)jsonObj.get('shipping'));

            Map<String, Object> subMap = (Map<String, Object>)jsonObj.get('subscriptions');
            cust.subList = jsonToSubscriptionList((List<Object>)subMap.get('data'));

            Map<String, Object> cardMap = (Map<String, Object>)jsonObj.get('sources');
            cust.cardList = jsonToCardList((List<Object>)cardMap.get('data'));
        }

        return cust;
    }

    public static List<StripeCustomerObj> jsonToCustomerList(List<Object> jsonCustmrs)
    {
        List<StripeCustomerObj> custList = new List<StripeCustomerObj>();

        for(Object cust : jsonCustmrs)
        {
            custList.add(jsonToCustomer((Map<String,Object>)cust));
        }

        return custList;
    }

    //with parent id
    public static List<StripeCustomerObj> jsonToCustomerList(List<Object> jsonCustmrs, String parentId)
    {
        List<StripeCustomerObj> custList = new List<StripeCustomerObj>();

        for(Object cust : jsonCustmrs)
        {
            custList.add(jsonToCustomer((Map<String,Object>)cust, parentId));
        }

        return custList;
    }

    //Stripe Product JSON to product wrapper class
    public static StripeProductObj jsonToProduct(Map<String,Object> jsonProd)
    {
        StripeProductObj newProd = new StripeProductObj();

        if((String)jsonProd.get('object') == 'product')
        {
            newProd.id = (String)jsonProd.get('id');
            newProd.name = (String)jsonProd.get('name');
            newProd.active = (Boolean)jsonProd.get('active');

            List<String> attr = new List<String>();
            for(Object obj : (List<Object>)jsonProd.get('attributes'))
            {
                attr.add(String.valueOf(obj));
            }

            newProd.attributes = attr;
            newProd.created = convertToDatetime((Long)jsonProd.get('created'));
            newProd.description = (String)jsonProd.get('description');
            newProd.updated = convertToDatetime((Long)jsonProd.get('updated'));
        }

        return newProd;
    }

    public static List<StripeProductObj> jsonToProductList(List<Object> jsonprods)
    {
        List<StripeProductObj> products = new List<StripeProductObj>();

        for(Object prod : jsonprods)
        {
            products.add(jsonToProduct((Map<String,Object>)prod));
        }

        return products;
    }

    //Stripe TaxRate JSON to TaxRate object
    public static StripeTaxRateObj jsonToTaxRate(Map<String,Object> jsonTaxRate)
    {
        StripeTaxRateObj taxrate = new StripeTaxRateObj();

        //System.debug('before if');
        if((String)jsonTaxRate.get('object') == 'tax_rate')
        {
            //System.debug('after if');
            taxrate.created = convertToDatetime((Long)jsonTaxRate.get('created'));
            taxrate.Id = (String)jsonTaxRate.get('id');
            taxrate.active = (Boolean)jsonTaxRate.get('active');
            taxrate.Description = (String)jsonTaxRate.get('description');
            taxrate.Name = (String)jsonTaxRate.get('display_name');
            taxrate.inclusive = (Boolean)jsonTaxRate.get('inclusive');
            taxrate.jurisdiction = (String)jsonTaxRate.get('jurisdiction');
            taxrate.percentage = (Decimal)jsonTaxRate.get('percentage');
        }

        return taxrate;
    }

    public static List<StripeTaxRateObj> jsonToTaxRateList(List<Object> jsontaxRates)
    {   
        //System.debug('Value: '+jsontaxRates);
        List<StripeTaxRateObj> taxes = new List<StripeTaxRateObj>();

        for(Object tax : jsontaxRates)
        {
            taxes.add(jsonToTaxRate((Map<String,Object>)tax));
        }

        return taxes;
    }

    public static StripeSubscriptionItemObj jsonToSubscriptionItem(Map<String,Object> jsonSubsItem)
    {
        StripeSubscriptionItemObj subItem = new StripeSubscriptionItemObj();

        if((String)jsonSubsItem.get('object') == 'subscription_item')
        {
            subItem.id = (String)jsonSubsItem.get('id');
            subItem.subscription = (String)jsonSubsItem.get('subscription');
            subItem.quantity = (Integer)jsonSubsItem.get('quantity');
            subItem.created = convertToDatetime((Long)jsonSubsItem.get('created'));
            subItem.plan = jsonToPlan((Map<String,Object>)jsonSubsItem.get('plan'));
            subItem.taxRates = jsonToTaxRateList((List<Object>)jsonSubsItem.get('tax_rates'));
        }

        return subItem;
    }

    public static List<StripeSubscriptionItemObj> jsonToSubscriptionItemList(List<Object> jsonSubsItem)
    {
        List<StripeSubscriptionItemObj> subItemList = new List<StripeSubscriptionItemObj>();

        for(Object subItem : jsonSubsItem)
        {
            subItemList.add(jsonToSubscriptionItem((Map<String,Object>)subItem));
        }

        return subItemList;
    }

    public static StripeSubscriptionObj jsonToSubscription(Map<String,Object> jsonSub)
    {
        StripeSubscriptionObj sub = new StripeSubscriptionObj();

        if((string)jsonSub.get('object') == 'subscription')
        {
            sub.id = (String)jsonSub.get('id');
            sub.parentCust = (String)jsonSub.get('customer');
            sub.created = convertToDatetime((Long)jsonSub.get('created'));
            sub.started = convertToDatetime((Long)jsonSub.get('start_date'));
            sub.status = (String)jsonSub.get('status');
            sub.quantity = (Integer)jsonSub.get('quantity');

            if(jsonSub.get('plan') != null)
            sub.plan = jsonToPlan((Map<String,Object>)jsonSub.get('plan'));
        
            Map<String,Object> itemsMap = (Map<String,Object>)jsonSub.get('items');
            sub.items = jsonToSubscriptionItemList((List<Object>)itemsMap.get('data'));

            sub.collectionMethd = (String)jsonSub.get('collection_method');
            sub.currentPeriodStart = convertToDatetime((Long)jsonSub.get('current_period_start'));
            sub.currentPeriodEnd = convertToDatetime((Long)jsonSub.get('current_period_end'));
            sub.trialStart = convertToDatetime((Long)jsonSub.get('trial_start'));
            sub.trialEnd = convertToDatetime((Long)jsonSub.get('trial_end'));
            sub.cancelPeriodEnd = (Boolean)jsonSub.get('cancel_at_period_end');
            sub.canceledAt = convertToDatetime((Long)jsonSub.get('canceled_at'));
            sub.discount = (String)jsonSub.get('discount');
        }

        return sub;
    }

    public static List<StripeSubscriptionObj> jsonToSubscriptionList(List<Object> jsonList)
    {
        List<StripeSubscriptionObj> subList = new List<StripeSubscriptionObj>();

        for(Object sub : jsonList)
        {
            subList.add(jsonToSubscription(((Map<String,Object>)sub)));
        }

        return subList;
    }

    //Stripe Plan JSON to plan object in apex
    public static StripePlanObj jsonToPlan(Map<String,Object> jsonPlan)
    {
        StripePlanObj plan = new StripePlanObj();

        if((String)jsonPlan.get('object') == 'plan')
        {
            plan.id = (String)jsonPlan.get('id');
            plan.amount = (Decimal)jsonPlan.get('amount');
            plan.billingScheme = (String)jsonPlan.get('billing_scheme');
            plan.created = convertToDatetime((Long)jsonPlan.get('created'));
            plan.currncy = (String)jsonPlan.get('currency');
            plan.interval = (String)jsonPlan.get('interval');
            plan.intervalCount = (Decimal)jsonPlan.get('interval_count');
            plan.nickname = (String)jsonPlan.get('nickname');
            plan.product = (String)jsonPlan.get('product');
        }

        return plan;
    }

    public static List<StripePlanObj> jsonToPlanList(List<Object> jsonPlans)
    {
        List<StripePlanObj> planList = new List<StripePlanObj>();

        for(Object plan : jsonPlans)
        {
            planList.add(jsonToPlan(((Map<String,Object>)plan)));
        }

        return planList;
    }

    public static StripePaymentMethodObj jsonToPaymentMethod(Map<String,Object> jsonPay)
    {
        StripePaymentMethodObj payMth = new StripePaymentMethodObj();

        if((String)jsonPay.get('object') == 'payment_method')
        {
            payMth.id = (String)jsonPay.get('id');
            payMth.created = convertToDatetime((Long)jsonPay.get('created'));
            payMth.customer = (String)jsonPay.get('customer');
            payMth.card = jsonToCard((Map<String,Object>)jsonPay.get('card'));
            payMth.billing_details = jsonToBillingAddress((Map<String,Object>)jsonPay.get('billing_details'));
        }

        return payMth;
    }

    //Stripe Card JSON to card object in apex
    public static StripeCardObj jsonToCard(Map<String,Object> jsonCard)
    {
        StripeCardObj card = new StripeCardObj();

        card.brand = (String)jsonCard.get('brand');
        card.country = (String)jsonCard.get('country');
        card.last4 = Integer.valueOf(jsonCard.get('last4'));
        card.exp_month = (Integer)jsonCard.get('exp_month');
        card.exp_year = (Integer)jsonCard.get('exp_year');

        return card;
    }

    public static List<StripeCardObj> jsonToCardList(List<Object> jsonCard)
    {
        List<StripeCardObj> cardList = new List<StripeCardObj>();

        for(Object card : jsonCard)
        {
            cardList.add(jsonToCard(((Map<String,Object>)card)));
        }

        return cardList;
    }

    //Stripe Address JSON to address object in apex
    public static StripeAddressObj jsonToBillingAddress(Map<String,Object> jsonAdrs)
    {
        StripeAddressObj fullAdd = new StripeAddressObj();

        fullAdd.name = (String)jsonAdrs.get('name');
        fullAdd.email = (String)jsonAdrs.get('email');
        fullAdd.phone = (String)jsonAdrs.get('phone');
        
        Map<String,Object> addrs = (Map<String,Object>)jsonAdrs.get('address');
        fullAdd.address.line1 = (String)addrs.get('line1');
        fullAdd.address.line2 = (String)addrs.get('line2');
        fullAdd.address.state = (String)addrs.get('postal_code');
        fullAdd.address.country = (String)addrs.get('country');

        return fullAdd;
    }

    public static StripeShippingAddressObj jsonToShippingAddress(Map<String,Object> jsonAdrs)
    {
        StripeShippingAddressObj fullAdd = new StripeShippingAddressObj();

        fullAdd.name = (String)jsonAdrs.get('name');
        fullAdd.phone = (String)jsonAdrs.get('phone');

        Map<String,Object> addrs = (Map<String,Object>)jsonAdrs.get('address');
        fullAdd.address.line1 = (String)addrs.get('line1');
        fullAdd.address.line2 = (String)addrs.get('line2');
        fullAdd.address.state = (String)addrs.get('postal_code');
        fullAdd.address.country = (String)addrs.get('country');
        fullAdd.address.city = (String)addrs.get('city');

        return fullAdd;
    }

    public static StripeChargeObj jsonToCharge(Map<String,Object> jsonChr)
    {
        StripeChargeObj chrgObj = new StripeChargeObj();

        chrgObj.Id = (String)jsonChr.get('id');
        chrgObj.created = convertToDatetime((Long)jsonChr.get('created'));
        chrgObj.customer = (String)jsonChr.get('customer');
        chrgObj.amount = (Decimal)jsonChr.get('amount');
        chrgObj.amount_refunded = (Decimal)jsonChr.get('amount_refunded');
        chrgObj.captured = (Boolean)jsonChr.get('captured');
        chrgObj.curncy = (String)jsonChr.get('currency');
        chrgObj.description = (String)jsonChr.get('description');
        chrgObj.failure_msg = (String)jsonChr.get('failure_message');
        chrgObj.invoice = (String)jsonChr.get('invoice');
        chrgObj.order = (String)jsonChr.get('order');
        chrgObj.paid = (Boolean)jsonChr.get('paid');
        chrgObj.receipt_num = (String)jsonChr.get('receipt_number');
        chrgObj.receipt_url = (String)jsonChr.get('receipt_url');
        chrgObj.refunded = (Boolean)jsonChr.get('refunded');
        chrgObj.status = (String)jsonChr.get('status');

        return chrgObj;
    }

    public static List<StripeChargeObj> jsonToChargeList(List<Object> jsonCharges)
    {
        List<StripeChargeObj> chargeList = new List<StripeChargeObj>();

        for(Object charge : jsonCharges)
        {
            chargeList.add(jsonToCharge((Map<String,Object>)charge));
        }

        return chargeList;
    }

    public static Datetime convertToDatetime(Long unix)
    {
        if(unix != null)
        {
            return Datetime.newInstance(unix * 1000);
        }

        return null;
    }
}