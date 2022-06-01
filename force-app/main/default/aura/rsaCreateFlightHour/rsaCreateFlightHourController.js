({
    doInit: function(component, event, helper) {
        // Prepare a new record from template        
        component.find("flightHourRecordCreator").getNewRecord(
            "Flight_Hours__c", // sObject type 
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newFlightHour");
                var error = component.get("v.newFlightHourError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }
                console.log("Record template initialized: " + rec.sobjectType);
            })
        );
        
        var action = component.get("c.eqFlightHours");
        action.setParams({"eqId": component.get("v.recordId")});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.equip", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    
    },

    handleSaveFlightHour: function(component, event, helper) {
               
        var equip = component.get("v.equip");
        
        component.set("v.simpleNewFlightHour.Parent_Equipment__c", equip.Id);
        component.set("v.simpleNewFlightHour.Equipment__c", equip.Id);
        component.set("v.simpleNewFlightHour.Flow_Counter_EZ_Flight_Hour__c", 1);
        component.set("v.simpleNewFlightHour.Hours__c", equip.LastHours__c);
        component.set("v.simpleNewFlightHour.Hours_Date__c", equip.LastHoursDate__c);
        component.set("v.simpleNewFlightHour.Cycles__c", equip.LastCycles__c);
        component.set("v.simpleNewFlightHour.Cycles_Date__c", equip.LastCyclesDate__c);
        
        component.find("flightHourRecordCreator").saveRecord(function(saveResult) {
            
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // handle the successful create
            } else if (saveResult.state === "INCOMPLETE") {
                // handle the incomplete state
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                console.log('Problem saving contact, error: ' + JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        });
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
    },
        
    cancel:function(component, event, helper) {
        var close = $A.get('e.force:closeQuickAction');
		close.fire();
    }
})