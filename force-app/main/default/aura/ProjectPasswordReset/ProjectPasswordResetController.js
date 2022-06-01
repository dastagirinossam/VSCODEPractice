({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
     
        var action = component.get("c.getProjectRecord")
        action.setParams({
            'pojId' : recordId
        }); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                component.set("v.ProjRec", result);
                console.log('Project: ' + JSON.stringify(result));
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);	
    },
    
    onSubmit : function(component, event, helper) {
        
        var newlst =[];
        
        var desApVal1 = component.find("desgApp").get("v.value");
        if(desApVal1 == true){
            newlst.push(component.get("v.ProjRec").Designated_Approver__c); 
        }
        
        if(component.get("v.ProjRec").Secondary_Approver__c != null){
            var desApVal2 = component.find("secApp").get("v.value");
            if(desApVal2 == true){
                newlst.push(component.get("v.ProjRec").Secondary_Approver__c);  
            }
        }
        
        if(component.get("v.ProjRec").X3_Approver__c != null){
            var desApVal3 = component.find("3rdApp").get("v.value");
            if(desApVal3 == true){
                newlst.push(component.get("v.ProjRec").X3_Approver__c);  
            }
        }
        
        if(component.get("v.ProjRec").X4_Approver__c != null){
            var desApVal4= component.find("4thApp").get("v.value");
            if(desApVal4 == true){
                newlst.push(component.get("v.ProjRec").X4_Approver__c);  
            }
        }
        
        if(component.get("v.ProjRec").X5_Approver__c != null){
            var desApVal5 = component.find("5thApp").get("v.value");
            if(desApVal5 == true){
                newlst.push(component.get("v.ProjRec").X5_Approver__c);  
            }
        }
        
        if(component.get("v.ProjRec").X6_Approver__c != null){
            var desApVal6 = component.find("6thApp").get("v.value");
            if(desApVal6 == true){
                newlst.push(component.get("v.ProjRec").X6_Approver__c);  
            }
        }
        
        if(newlst.length > 0){
            var action = component.get('c.setPassWordProj'); 
            
            action.setParams({ 
                'uIds' : newlst
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result =  response.getReturnValue(); 
                    
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        title : 'Passwords Reset',
                        message : 'Passwords have been reset succesfully!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    resultsToast.fire();
                    
                    // Close the action panel
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();        
                }
                else if (state === "ERROR") {
                    var errors =  response.getReturnValue();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }else{
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                title : 'Select Approver',
                message : 'Please select a Designated Approver to reset password.',
                duration:' 2000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            resultsToast.fire();
        }
    },
    
    cancel: function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    }
})