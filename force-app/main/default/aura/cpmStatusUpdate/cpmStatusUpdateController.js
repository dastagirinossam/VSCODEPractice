({
    doInit: function(component, event, helper) {
        // Prepare a new record from template
        component.find("statusUpdateCreator").getNewRecord(
            "Status_Update__c", // sObject type (entity API name)
            null,           // record type (null if no recordtype exist
            false,         // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newStatusUpdate");  //targetRecord attribute
                var error = component.get("v.newStatusUpdateError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                }
                else {
                    console.log("Record template initialized: " + rec.sobjectType);
                }
            })
        );
        
        helper.getProject(component, event, helper);
    },
    
    saveStatusUpdate: function(component, event, helper) {

        var recordId = component.get('v.recordId');     

        component.set("v.simpleNewStatusUpdate.Project__c", recordId);     
        component.find("statusUpdateCreator").saveRecord(function(saveResult) {
            
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                
                console.log('Success: ' + saveResult.recordId);
                helper.sendMail(component, event, helper, saveResult.recordId);
                
            }else if(saveResult.state === "ERROR"){
                console.log("In error");
                var errors = response.getError();
                console.log(errors);
                
                var message = component.find("notifLib").showToast({
                    "variant" : "error",
                    "header" : "Status Update Error",
                    "message" : errors[0].message          
                });
                
                $A.get("e.force:closeQuickAction").fire();                
            }
        });
        
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