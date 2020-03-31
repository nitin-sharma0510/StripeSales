({
    getLabels: function (cmp, event) {
        var labels = [
            {label: 'Account Name', fieldName: 'Name', type: 'text',sortable: true, iconName: 'standard:account'},
            {label: 'Active', fieldName: 'Active__c', type: 'boolean', sortable: true, iconName: 'standard:task2'},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'date', cellAttributes: { iconName: 'utility:event', iconAlternativeText: 'Close Date'}},
            {label: 'Created By', fieldName: 'OwnerId', type: 'text'},
            {label: 'Description', fieldName: 'Description__c', type: 'text'},
            {label: 'Edit', type: 'button', initialWidth: 135, typeAttributes: { label: 'Edit Details', name: 'edit_details', title: 'Click to Edit Record'}},
            {label: 'Balance', type: 'button', initialWidth: 135, typeAttributes: { label: 'View Balance', name: 'view_balance', title: 'Click to View Balance'}},
        ];
            
            return labels;        
            },
            
    getLogLabels: function (cmp, event) {
        var labels = [
            {label: 'Event Name', fieldName: 'linkName',sortable: true, type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
            {label: 'Event Type', fieldName: 'Type__c', type: 'text',sortable: true, iconName: 'standard:shift_type'},
            {label: 'Start Time', fieldName: 'StartProcessingTime__c', type: 'date', cellAttributes: { iconName: 'utility:clock', iconAlternativeText: 'Close Date'},
            typeAttributes: {  
            day: 'numeric',  
            month: 'short',  
            year: 'numeric',  
            hour: '2-digit',  
            minute: '2-digit',  
            second: '2-digit',  
            hour12: true}},
            {label: 'End Time', fieldName: 'EndProcessingTime__c', type: 'date', cellAttributes: { iconName: 'utility:clock', iconAlternativeText: 'Close Date'},
            typeAttributes: {  
            day: 'numeric',  
            month: 'short',  
            year: 'numeric',  
            hour: '2-digit',  
            minute: '2-digit',  
            second: '2-digit',  
            hour12: true}},
            {label: 'Action', fieldName: 'Action__c', type: 'text'}
        ];
        
        return labels;        
    },
    
    fetchEventLogs: function (cmp) {
        var action = cmp.get("c.fetchEventLogs");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                cmp.set('v.logsData', records);
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchData: function (cmp) {
        var action = cmp.get("c.fetchAccounts");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                cmp.set('v.data', records);
                
                var optionList = [];
                records.forEach(function(record){
                    optionList.push({label: record.Name, value: record.Id});
                });
                cmp.set('v.options',optionList);
            }
        });
        $A.enqueueAction(action);
    },
    
    handleShowModal: function(cmp, event) {
        
        var strAccId = event.getParam('row').Id;
        //alert("POP UP "+strAccId);
        var modalBody;
        $A.createComponent("c:RecordEditStripeTest", {strRecordId:strAccId},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   cmp.find('overlayLib').showCustomModal({
                                       header: "Stripe Account",
                                       body: modalBody,
                                       showCloseButton: true,
                                       cssClass: "",
                                       closeCallback: function() {
                                           //alert('You closed the alert!');
                                       }
                                   })
                               }
                           });
    },
    
    editRecord: function(row) {
        alert('Edit: ' + row.Id);
        //handleShowModal(row);
    },
    
    getBalance: function(row, cmp) {
        var action = cmp.get("c.fetchAccountBalance");
        action.setParams({
            accId:row.Id
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                alert('Balance: $'+response.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);
    },
    
    createWebhook: function(cmp) {
        //alert('ACCOUNT ID '+cmp.get("v.accId"));
        var action = cmp.get("c.createWebhook");
        var toastEvent = $A.get("e.force:showToast");
        
        action.setParams({accId:cmp.get("v.accId")});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var status = response.getReturnValue();
            console.log('STATE: '+state+' STATUS: '+status);
            if (state === "SUCCESS" && status === "success") {
                console.log('STATUS '+status);
             	toastEvent.setParams({
                    title : 'Success Message',
                    message: 'Webhooks created',
                    messageTemplate: '',
                    duration:'2000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'dismissible'
                });
                toastEvent.fire();
            }else {
                console.log('error during webhook creation');
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchSiteSettings: function (cmp) {
        var action = cmp.get("c.fetchSiteSettings");
        
        action.setParams({});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var record = response.getReturnValue();
                //alert('LINK: '+JSON.stringify(record));
                cmp.set('v.siteSettings', record);
            }
        });
        $A.enqueueAction(action);
    },
    
    verifySiteSettings: function (cmp) {
        var action = cmp.get("c.verifySiteUrl");
        var record = cmp.get("v.siteSettings");
        
        action.setParams({url: record.WebhookUrl__c});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('TEST '+response.getReturnValue());
            if (!response.getReturnValue().includes('success')) {
                alert('Site Url is not correct');
                
            }else if(response.getReturnValue().includes('success')){
                alert('Success');
            }
        });
        $A.enqueueAction(action);
    },
    
    saveSiteSettings: function (cmp) {
        var action = cmp.get("c.saveSiteSettings");
        
        action.setParams({recrd: cmp.get("v.siteSettings")});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Settings Saved')
            }
        });
        $A.enqueueAction(action);
    },
    
    runBatchHelper: function (cmp) {
        var action = cmp.get("c.runbatch");
        var varMap = cmp.get("v.batchMap");
        console.log('id',varMap.account_id);
        action.setParams({
            stripeAccId: varMap.account_id,
            batchName: varMap.batch_name           
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                alert(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    } 
});