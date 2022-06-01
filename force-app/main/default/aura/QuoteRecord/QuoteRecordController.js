({
    doInit : function(component, event) {

		var action = component.get("c.getQuote");
        action.setParams({
            "lstRecordId": component.get("v.recordId")  
        });

		action.setCallback(this, function(s) {
        	var squawk = s.getReturnValue();           
            var sqk = JSON.parse(JSON.stringify(squawk));
            //console.log('Squawk: ' + sqk[0]);
            component.set("v.name", sqk[0].Name);          
        });
        
        $A.enqueueAction(action);
	},
    
	generateDoc : function(component, event) {
        
    	var address = "/generate-squawk-document?id=" + component.get("v.recordId");
    	var urlEvent = $A.get("e.force:navigateToURL");
    	urlEvent.setParams({
      		"url": address,
      		"isredirect" :false
    	});
    	urlEvent.fire();
	}
})