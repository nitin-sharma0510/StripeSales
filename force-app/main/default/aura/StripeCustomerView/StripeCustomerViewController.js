({
    init : function(component, event, helper) {
        helper.fetchStripeSubscription(component);
        helper.fetchStripeCharges(component);
        helper.fetchProductList(component);
        helper.fetchPaymentList(component);
    }
})