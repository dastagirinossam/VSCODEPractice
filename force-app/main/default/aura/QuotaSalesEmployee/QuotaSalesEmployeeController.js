({
    doInit : function(component, event, helper) {
        var myAction = component.get("c.QEmpRecord");
        myAction.setParams({
            empId : component.get("v.employeID")
            
        }); 
        
        myAction.setCallback(this, function(response) { 
            if(response.getState() === "SUCCESS")  
                var wrap = response.getReturnValue();
            
            console.log(wrap);
            component.set("v.searchResult",wrap.emp);        
        }); 
        
        $A.enqueueAction(myAction); 
        
    },
    
    ToggleExpandCollapse: function(component, event, helper){
        help.ToggleExpandCollapseHandler(component, event);
    }
})