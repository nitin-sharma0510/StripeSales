({
	handleAccChange: function (cmp, event) {
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
    },
    setEvent : function(cmp,event){
        let evt = cmp.getEvent("getBatchMapValues");
        evt.setParams({"batchEventMap" : cmp.get("v.batchMap")});
        evt.fire();
    },
})