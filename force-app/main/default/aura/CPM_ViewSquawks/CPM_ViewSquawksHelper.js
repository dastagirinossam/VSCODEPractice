({
    
    getSquawks: function(component, event, helper){
        var action = component.get('c.getSquawks'); // name on the apex class
        action.setParams({'projId': component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") { 
                console.log('Success: ' + response.getReturnValue());
                component.set('v.qlList', response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    getAmounts: function(component, event, helper){
        var action = component.get('c.getAmounts'); // name on the apex class
        action.setParams({'projId': component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var amounts = response.getReturnValue();      
            
            if (state === "SUCCESS") { 
                component.set('v.totalLabor', amounts.laborAmount);
                component.set('v.totalMaterial', amounts.materialAmount);
                component.set('v.totalAmount', amounts.totalAmount);
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    getStatusSquawks: function(component, event, helper){
        var status = component.get('v.value');
        var action = component.get('c.getSquawkStatus'); // name on the apex class      
        action.setParams({'projId': component.get("v.recordId"),
                          'status' : status});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") { 
                console.log('Success: ' + response.getReturnValue());
                component.set('v.qlList', response.getReturnValue());
            }else{
                console.log('Error: ' + JSON.stringify(response.getError()));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getStatusAmounts: function(component, event, helper){
        var status = component.get('v.value');
        var action = component.get('c.getStatusAmounts'); // name on the apex class
        action.setParams({'projId': component.get("v.recordId"),
                          'status' : status});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var amounts = response.getReturnValue();      
            
            if (state === "SUCCESS") { 
                component.set('v.totalLabor', amounts.laborAmount);
                component.set('v.totalMaterial', amounts.materialAmount);
                component.set('v.totalAmount', amounts.totalAmount);
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    getSquawkSearch: function(component, event, helper){
        var squawkNo = component.get('v.squawkNo');
        var description = component.get('v.description');
        
        var action = component.get('c.getSquawkSearch'); // name on the apex class      
        action.setParams({'projId': component.get("v.recordId"),
                          'squawkNo' : squawkNo,
                          'description' : description});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") { 
                console.log('Success: ' + response.getReturnValue());
                component.set('v.qlList', response.getReturnValue());
            }else{
                console.log('Error: ' + JSON.stringify(response.getError()));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getSquawkSearchAmount: function(component, event, helper){
        var squawkNo = component.get('v.squawkNo');
        var description = component.get('v.description');
        
        var action = component.get('c.getSquawkSearchAmount'); // name on the apex class      
        action.setParams({'projId': component.get("v.recordId"),
                          'squawkNo' : squawkNo,
                          'description' : description});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            var state = response.getState();
            var amounts = response.getReturnValue();      
            
            if (state === "SUCCESS") { 
                component.set('v.totalLabor', amounts.laborAmount);
                component.set('v.totalMaterial', amounts.materialAmount);
                component.set('v.totalAmount', amounts.totalAmount);
            }
        });
        
        $A.enqueueAction(action);
    }
})