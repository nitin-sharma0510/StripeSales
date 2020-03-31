({
    fetchStripeSubscription : function(component) {
        var action = component.get("c.fetchStripeSubscription");
        action.setParams({
            custId:component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var subList = response.getReturnValue();
                var revenue = 0.00;
                subList.forEach(function(record){
                    revenue += record.StripePlanAmount__c;
                    console.log('CHARGE '+revenue);
                });
                component.set("v.subCount",subList.length);
                component.set("v.subRevenue",revenue);
                console.log('revenue @>'+JSON.stringify(subList));
            }else{
                alert("Error")
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchStripeCharges : function(component) {
        var action = component.get("c.fetchStripeCharge");
        action.setParams({
            custId:component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var chrgList = response.getReturnValue();
                component.set("v.chargeList",chrgList);
            }else{
                alert("Error")
            }
        });
        $A.enqueueAction(action);     
    },
    
    fetchProductList : function(component) {
        var action = component.get("c.fetchProducts");
        action.setParams({
            custId:component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var prdList = response.getReturnValue();
                component.set("v.productList",prdList);
                //console.log('TESTEST '+JSON.stringify(prdList));
            }else{
                alert("Error")
            }
        });
        $A.enqueueAction(action);     
    },
    
    fetchPaymentList : function(component) {
        var action = component.get("c.fetchStripePaymentMethods");
        action.setParams({
            custId:component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var payList = response.getReturnValue();
                component.set("v.paymentList",payList);
                console.log('TESTEST '+JSON.stringify(payList));
            }else{
                alert("Error")
            }
        });
        $A.enqueueAction(action);     
    }
})