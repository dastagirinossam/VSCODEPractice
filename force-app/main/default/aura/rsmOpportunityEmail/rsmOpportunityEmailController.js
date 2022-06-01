({
    sendMail : function(component, event, helper) {
        var files = component.get("v.selected");
        var fileMap = JSON.stringify(files);
        
        console.log('FileMap : ' + fileMap);  
        var recordId = component.get("v.recordId");
        console.log('Record Id: ' + recordId);
        var emailAddress = component.find("emailAddress").get("v.value");
        var emailSubject = component.find("emailSubject").get("v.value");
        var emailBody = component.find("emailBody").get("v.value");
        console.log('Email Body: ' + emailBody);
        
        var action = component.get("c.sendOpportunityEmail");
        action.setParams({
            "toEmail" : emailAddress,
            "emailSubject" : emailSubject,
            "emailBody" : emailBody,
            "fileMap" : fileMap,
            "oppId" : recordId
        });
        
        action.setCallback(this, function(response){
            console.log("In call back of notify component on send button");
            var state = response.getState();
            console.log(state);
            if(state === "SUCCESS"){
                console.log("In success");
                
                var message = component.find("notifLib").showToast({
                    "variant" : "success",
                    "title" : "Email Sent",
                    "message" : "Email was sent successfully"           
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
                $A.get('e.force:refreshView').fire();
                
            }
        });
        
        $A.enqueueAction(action);
    },
           
    cancel: function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    
    toOpenAttachments : function(component, event, helper) {
        console.log("Opened small modal to select attachments");
        component.set("v.open", true);
    },
    
    selectedAction : function(component, event, helper) {
        console.log("Opened selectedAction");
        
        var select = event.getParam("selectedIds");
        component.set("v.selected", select);
        console.log('Selected Files: ' + select);
        
    },
    
    handleRemoveOnly : function(component, event, helper) {
        console.log("in remove");
        var sel = event.getSource().get("v.name");
        console.log(JSON.stringify(sel));
        var lis = component.get("v.selected");
        console.log(JSON.stringify(lis));
        for(var i = 0; i < lis.length; i++){
            console.log(JSON.stringify(lis[i]));
            console.log(lis[i].Id);
            console.log(sel.Id);
            console.log(lis[i].Id == sel.Id);
            if(lis[i].Id == sel.Id){
                
                lis.splice(i,1);
            }
        }
        
        component.set("v.selected", lis);
        console.log(JSON.stringify(lis));
    }
})