({
	userresetPassword : function(component, event, helper) {
        var action = component.get('c.resetPassword');
        action.setCallback(this, function(response) {
            var state  = response.getState();
            
            if (state === "SUCCESS") {
                  var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "variant": "Success",
                        "title": "Success",
                        "message": "Password Reset Successfully"
                    });
    			toastEvent.fire();
            }
            if (state === "ERROR")
            { 
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "variant": "Error",
                        "title": "Password Reset Error",
                        "message": response.getError().message
                    });
    			toastEvent.fire();
                console.log(JSON.stringify(response.getError()));
            }
            
        });
        $A.enqueueAction(action);
		
	}
})