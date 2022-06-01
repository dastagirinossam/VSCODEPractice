({
    helperMethod1 : function(component, event, helper){
        var rId = component.get("v.recordId");    
        var action = component.get("c.getAccount");
        action.setParams({
            recordId : rId
        });
                      
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('Account Id: ' + result);
                component.set("v.accountId", result);
            }
        });
        
        $A.enqueueAction(action);
	},
    
    helperMethod2 : function(component, event, helper) {
        var rId = component.get("v.recordId");
        console.log("In Init");
        
        var action = component.get("c.getAttachments");
        action.setParams({
            recordId : rId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log("result of Attach display component");
                console.log(result);
                component.set("v.fileIds", result);
            }
        });
        
        $A.enqueueAction(action);
    }

})