({
    doInit: function(component, event, helper) {
             
        var recordId = component.get('v.recordId');
        component.set("v.recordId", recordId);
        
        var accntId = component.get('v.accntId');
        component.set("v.accntId", accntId);
             
    },
    
    handleOnload : function(component, event, helper) {
        event.preventDefault();
        var recUi = event.getParam("recordUi");
        var recordId = component.get('v.recordId');       
    },

    handleOnSubmit : function(component, event, helper) {
        event.preventDefault();
        var fields = event.getParam("fields");
        console.log('Success!');
        component.find("form").submit(fields);
    },
    
    handleChange : function(component, event, helper) {
        // When an option is selected, navigate to the next screen
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
        console.log('response1'+event.getSource())
        var navigate = component.get("v.navigateFlow");
        console.log('navigate'+navigate)
        
        if(response=='previousId'){
            navigate("BACK");
        }
        
        if(response=='nextId'){
            navigate("NEXT");
        }
    },
        
    handleSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var conId = record.id;
        
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
    },
    
    handleError : function(component, event, helper) {
        var record = event.getParam("response");
    },
    
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
   },
    
    hideSpinner : function(component,event,helper){   
       component.set("v.Spinner", false);
    }
})