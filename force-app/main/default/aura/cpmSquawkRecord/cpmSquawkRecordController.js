({
    doInit: function(component, event, helper) {
        
        var action = component.get('c.showNotification');
        action.setParams({"ids" : component.get("v.recordId")}); 
        action.setCallback(this, function(response){ 
            $A.get("e.force:closeQuickAction").fire();
            var state = response.getState();
            if(state === "SUCCESS"){ 
                
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/apex/Squawk?Id=" + component.get("v.recordId")
                });
                urlEvent.fire();                    
            }else if(state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        
        $A.enqueueAction(action);
    }
})