({
    makeRequest : function(component, event, helper) {
        
        var action = component.get("c.getToken");         
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var token = response.getReturnValue();
                
                helper.helperMethod1(component, event, helper, token);
                helper.helperMethod2(component, event, helper, token);
                helper.helperMethod3(component, event, helper, token);
                helper.helperMethod4(component, event, helper, token);
                helper.helperMethod5(component, event, helper, token);
                helper.helperMethod6(component, event, helper, token);
                //console.log('Success: ' + JSON.parse(JSON.stringify(jn.acAirframe)));
            }
        });
        
        $A.enqueueAction(action);
    }
})