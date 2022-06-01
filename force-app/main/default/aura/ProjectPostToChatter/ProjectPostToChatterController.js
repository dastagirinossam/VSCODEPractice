({    
	PostToChatter : function(component, event, helper) {
        
        var postChatter = component.find("chatterPost").get("v.value"); 
        var record = component.get('v.recordId');
        
        if(postChatter != null){
                  
            var action = component.get('c.RecordPostComment');
            action.setParams({
                "UserPost": postChatter,
                "RecordId" : record
            });
            
            action.setCallback(component, function(response) {
                var state = response.getState();
                if (state === 'SUCCESS'){
                    $A.get('e.force:refreshView').fire();
                } else {
                     console.log(state);
                }
            });
    
            $A.enqueueAction(action);		
        }
    }
})