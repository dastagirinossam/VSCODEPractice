({
    doInit : function(component) {
        
        var conId = component.get('v.recordId');
        //component.set("v.contactId", conId);
        component.set('v.showSpinner', true);
        
        var action = component.get('c.CreateUserFromContact'); // name on the apex class
        action.setParams({'contactIds': conId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                
                component.set('v.saved', true);
                
                component.set('v.messageText',"New User created Successfully");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: component.get("v.messageText"),
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                component.set('v.newUserId', response.getReturnValue());
                console.log('New User: ' + response.getReturnValue());

            }else{
                alert('Problem saving User, error: ' + JSON.stringify(response.error));
            }
            
            component.set('v.showSpinner', false);            

        });              
        $A.enqueueAction(action);
    }
})