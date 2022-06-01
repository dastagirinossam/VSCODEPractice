({
    doInit: function(component, event, helper) {
        
        var action = component.get('c.showNotification');
        action.setParams({"ids" : component.get("v.recordId")}); 
        action.setCallback(this, function(response){ 
            $A.get("e.force:closeQuickAction").fire();
            var state = response.getState();
            if(state === "SUCCESS"){ 
                
                var flagNotification = response.getReturnValue();
                if(flagNotification){                    
                    component.find('notifLib').showNotice({
                        "variant": "error",
                        "header": "Product Type Permission",
                        "message": "Your user profile does not allow creating or editing this type of product. Please contact the appropriate TSM to load this product or contact Jeff Hutcherson to evaluate your user profile settings.",
                    });
                        
                }else{                   
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/apex/AdjustCPQMaterials?scontrolCaching=1&id=" + component.get("v.recordId")
                    });
                    urlEvent.fire();                    
                }
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
    },
    
    closeModel: function(component, event, helper) {
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})