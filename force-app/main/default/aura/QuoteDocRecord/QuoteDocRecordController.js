({
    doInit : function(component, event) {

		var action = component.get("c.getQuoteDocument");
        action.setParams({
            "lstRecordId": component.get("v.recordId") 
        });

		action.setCallback(this, function(s) {
        	var document = s.getReturnValue();           
            var doc = JSON.parse(JSON.stringify(document));        
            component.set("v.name", doc[0].Name);
            component.set("v.version", doc[0].SBQQ__Version__c);
        });
        
        $A.enqueueAction(action);
	}
})