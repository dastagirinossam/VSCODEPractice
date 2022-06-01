({  
    getSquawks: function(component, event, helper){
        var action = component.get('c.getQuoteSquawks'); // name on the apex class
        action.setParams({'quoteId': component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") { 
                console.log('Success: ' + response.getReturnValue());
                component.set('v.qlList', response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
        
    }
})