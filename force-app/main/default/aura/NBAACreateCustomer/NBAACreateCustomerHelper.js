({
    createUser : function(component, event, conId) {
        console.log('Contact Id: ' + conId);
        var action = component.get('c.CreateUserFromContact'); // name on the apex class
        action.setParams({'contactIds': conId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                /*var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Customer Created",
                    "message": "Your Customer has been created!"
                });
                resultsToast.fire();*/             
        		component.set('v.saved', true);
            }       
        });
        $A.enqueueAction(action);
    }
})