({
    doInit : function(component, event, helper) {
        var action = component.get("c.getRSVP");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var contact = JSON.parse(JSON.stringify(response.getReturnValue()));
                component.set('v.recordId', contact.Id);
                
                console.log('Hello: ' + contact.Id);
            }else{
                console.log('Try Again: ' + response.error);
            }
        });
        $A.enqueueAction(action); 
    },
    
    onCheck: function(component, event, helper) {
        var checkCmp = component.find("checkbox").get("v.value");
        console.log('Checkbox: ' + checkCmp);
        component.set("v.hide", checkCmp); 
    },
    
    handleRSVP: function(component, event, helper) {

        component.find("recordLoader").saveRecord(function(saveResult) {
            alert('saveresult'+saveResult);
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // record is saved successfully
                
                var conId = saveResult.recordId;                
                helper.createUser(component, event, conId);
                
            } else if (saveResult.state === "INCOMPLETE") {
                // handle the incomplete state
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                console.log('Problem saving contact, error: ' + JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        });
    },
    
    handleCancel: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" : 'https://fullcopy1-standardaero.cs20.force.com/Customer/s'
        });
        urlEvent.fire();
    },
      
    onError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Error."
        });
        toastEvent.fire();
    }
       
})