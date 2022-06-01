({
	toggleClass: function(component,componentId,className) {
		var modal = component.find(componentId);
		$A.util.removeClass(modal,className+'hide');
		$A.util.addClass(modal,className+'open');
	},

	toggleClassInverse: function(component,componentId,className) {
		var modal = component.find(componentId);
		$A.util.addClass(modal,className+'hide');
		$A.util.removeClass(modal,className+'open');
	},
    
    navigate : function(component, event) {
    	var address = "/squawk/" + component.get("v.recordId");
    	var urlEvent = $A.get("e.force:navigateToURL");
    	urlEvent.setParams({
      		"url": address,
      		"isredirect" :false
    	});
    	urlEvent.fire();
	},
         
    statusChange : function(component, event) {

		var action = component.get("c.getQuoteLine");
        action.setParams({"lstRecordId": component.get("v.recordId")});

		action.setCallback(this, function(s) {
        	var squawk = s.getReturnValue();           
            var sqk = JSON.parse(JSON.stringify(squawk));        
            component.set("v.status", sqk[0].Add_Work_Status__c);
            console.log('Status: ' + sqk[0].Add_Work_Status__c);
        });
        
        $A.enqueueAction(action);
	}
})