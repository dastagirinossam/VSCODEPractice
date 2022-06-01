({
    
    doInit : function(component, event, helper){        
        component.find("timeCardRecordCreator").getNewRecord(
            "Time_Card__c", // sObject type (objectApiName)
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newTimeCard");
                var error = component.get("v.newTimeCardError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }
                console.log("Record template initialized: " + rec.apiName);
            })
        );
    },
    
    handleSaveTimeCard: function(component, event, helper) {
        //if(helper.validateTimeCardForm(component)) {
        component.set("v.simpleNewTimeCard.Service_Appointment__c", component.get("v.recordId"));
        component.find("timeCardRecordCreator").saveRecord(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // record is saved successfully
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire(); 
            } else if (saveResult.state === "INCOMPLETE") {
                // handle the incomplete state
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                console.log('Problem saving timeCard, error: ' + JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        });
        //}
    }
})