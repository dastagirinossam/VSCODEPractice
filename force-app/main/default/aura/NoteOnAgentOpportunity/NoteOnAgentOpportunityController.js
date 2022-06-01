({
    create : function(component, event, helper) {
        //getting the candidate information
        var candidate = component.get("v.note");
        //Calling the Apex Function
        var action = component.get("c.createRecord");
        //Setting the Apex Parameter
        action.setParams({
            nt : candidate,
            PrentId : component.get("v.recordId")
        });
        //Setting the Callback
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            //check if result is successfull
            if(state == "SUCCESS"){
                //Reset Form
                var newCandidate = {'sobjectType': 'ContentNote',
                                    'Title': '',
                                    'Content': ''
                                   };
                //resetting the Values in the form
                component.set("v.note",newCandidate);
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
       /* var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.recordId"),
            "slideDevName": "detail"
        });
        navEvt.fire(); */
        
        $A.get('e.force:refreshView').fire();
       
        $A.get("e.force:closeQuickAction").fire();
		//adds the server-side action to the queue        
        $A.enqueueAction(action);
    },
    closeModel : function (component, event, helper) {
       $A.get("e.force:closeQuickAction").fire();
    }
})