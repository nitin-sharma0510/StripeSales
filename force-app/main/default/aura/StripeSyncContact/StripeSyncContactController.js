({
    doInit : function(component, event, helper) {
        var action = component.get("c.syncStripeCustomer");
        var toastEvent = $A.get("e.force:showToast");
        //alert(component.get('v.recordId'));
        action.setParams({
            'stripeCustId':component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var msg = response.getReturnValue();
            if (msg === "Success" && component.isValid() && state === "SUCCESS") {
                toastEvent.setParams({
                    title : 'Success Message',
                    message: 'Contact has been synced',
                    messageTemplate: '',
                    duration:' 50000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                location.reload(true);
            }else{
                alert(msg);
            }
            $A.get("e.force:closeQuickAction").fire()
        });
        
        $A.enqueueAction(action);
    },
})