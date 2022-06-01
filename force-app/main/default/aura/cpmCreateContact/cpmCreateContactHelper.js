({
    createUser : function(component, event, conId) {
        console.log('Contact Id: ' + conId);

        var action = component.get('c.CreateUserFromContact'); // name on the apex class
        action.setParams({'contactIds': conId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") { 
                console.log('Success');
        		component.set('v.saved', true);

                component.set('v.newUserId', response.getReturnValue());
                console.log('New User: ' + response.getReturnValue());
            }else{
                console.log('Problem saving User, error: ' + JSON.stringify(response.error));
            }
            component.set('v.showSpinner', false);
        });
        $A.enqueueAction(action);
    }
})