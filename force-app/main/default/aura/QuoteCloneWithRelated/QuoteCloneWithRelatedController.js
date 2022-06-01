({
    doInit: function(cmp, event, helper) {
               
        var action = cmp.get("c.doClone");
        action.setParams({parentId : cmp.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state sucess'+state);
            
            if (cmp.isValid()) {
                if (state === "SUCCESS") {
                    console.log('state sucess'+state);
                    
                    var clonedId = response.getReturnValue();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": clonedId
                    });
                    navEvt.fire();
                } else if(state == "ERROR"){
                    console.log('state'+state);
                    var errors = response.getError();
                    if(errors) {
                        console.log(errors[0].message);
                        var hideQuickAcion = $A.get("e.force:closeQuickAction");
                        hideQuickAcion.fire();
                    }
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    // function automatic called by aura:waiting event  
    showSpinner: function(cmp, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        cmp.set("v.spinner", true); 
    },
    
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(cmp,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        cmp.set("v.spinner", false);
    }
    
})