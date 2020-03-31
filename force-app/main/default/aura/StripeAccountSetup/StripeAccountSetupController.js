({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', helper.getLabels());
        helper.fetchData(cmp);
        
        cmp.set('v.columns2', helper.getLogLabels());
        helper.fetchEventLogs(cmp);
    },
    
    tab3: function (cmp, event, helper) {
        if(cmp.get("v.siteSettings") === null) 
        helper.fetchSiteSettings(cmp);
    },
    
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        
        switch (action.name) {
            //Handle click on edit details button
            case 'edit_details':
                helper.handleShowModal(cmp, event);
                break;
     		//Handle click on view balance button
            case 'view_balance':
                helper.getBalance(row, cmp);
                break;
        }
    },
    
    handleChange: function (cmp, event) {
        // This will contain the value for Account Id
        var selectedOptionValue = event.getParam("value");
        cmp.set('v.accId',selectedOptionValue);
        //alert("Option selected: '" + cmp.get("v.accId")+ "'");
    },
    
    handleClick: function (cmp, event, helper) {
        //alert('button');
        helper.createWebhook(cmp);
        //alert('button after');
    },
    
    saveSettings: function (cmp, event, helper) {
        helper.verifySiteSettings(cmp);
        helper.saveSiteSettings(cmp);
    },
    
    /*handleAccChange: function (cmp, event) {
        // This will contain the value for Account Id
        var selectedOptionValue = event.getParam("value");
        var batchmap = cmp.get('v.batchMap');
        
		batchmap.account_id = selectedOptionValue;
        cmp.set('v.batchMap',batchmap)
        cmp.set('v.pickDep',false);
    },
    
    handleBatchChange: function (cmp, event) {
        // This will contain the value for Account Id
        var selectedOptionValue = event.getParam("value");
        var batchmap = cmp.get('v.batchMap');
		batchmap.batch_name = selectedOptionValue;
        console.log('TEST '+JSON.stringify(batchmap));
        cmp.set('v.batchMap',batchmap);
    },*/
    
    runBatch: function (cmp, event,helper) {
        console.log('event', event.getParam("batchEventMap"));
        cmp.set('v.batchMap',event.getParam("batchEventMap"));
		helper.runBatchHelper(cmp);
    }
});