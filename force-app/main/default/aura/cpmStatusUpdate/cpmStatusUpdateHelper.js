({
    getProject : function(component, event, helper) {
        
        var rId = component.get("v.recordId");
        console.log('Record Id: ' + rId);
        var action = component.get("c.getRecordValues");
        action.setParams({'recordId' : rId});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set('v.record', response.getReturnValue());
            }           
        });
        
        $A.enqueueAction(action);
    },
    
    sendMail : function(component, event, helper, suId) {
        var files = component.get("v.selected");
        var fileMap = JSON.stringify(files);

        var action = component.get("c.sendEmailApex");
        action.setParams({
            "suId" : suId,
            "fileMap" : fileMap
        });
        
        action.setCallback(this, function(response){
            console.log("In call back of notify component on send button");
            var state = response.getState();
            console.log(state);
            if(state === "SUCCESS"){
                console.log("In success");

                var message = component.find("notifLib").showToast({
                    "variant" : "success",
                    "title" : "Status Update Email Sent",
                    "message" : "Status Update email was sent successfully"           
                });
                
                $A.get("e.force:closeQuickAction").fire();
                
            }else if(state === "ERROR"){
                console.log("In error");
                var errors = response.getError();
                console.log(errors);
                
                var message = component.find("notifLib").showToast({
                    "variant" : "error",
                    "header" : "Error sending the message",
                    "message" : errors[0].message          
                });
                
                $A.get("e.force:closeQuickAction").fire();
                
            }
        });
        
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
    }
 })