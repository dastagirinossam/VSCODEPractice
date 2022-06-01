({
    init : function(component, event, helper) {
        
        var recId = component.get("v.recordId");
        var action = component.get("c.accountSummary");
        action.setParams({ Ids : recId });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                component.set("v.accWrapper", resp);
                var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
                component.set('v.today', today);
                component.set("v.Loadif", "True");
                
            }
            else if (state === "INCOMPLETE") {
                
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);	
    },
    
    savePDF : function(component, event, helper) {   
        var recordId = component.get("v.recordId");
        /*var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "*/
        window.open("https://standardaero.lightning.force.com/apex/AccountSummary?id=" + recordId);
        /*});
        urlEvent.fire();*/
    },
    
    cancel: function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
   
})