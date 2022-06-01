({
    /*
     * This method is being called from init event
     * to fetch all available recordTypes
     * */
    fetchListOfRecordTypes: function(component, event, helper) {
        var action = component.get("c.fetchRecordTypeValues");
        //pass the object name here for which you want
        //to fetch record types
        action.setCallback(this, function(response) {
            component.set("v.lstOfRecordType", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    /*
     * This method will be called when "Next" button is clicked
     * It finds the recordTypeId from selected recordTypeName
     * and passes same value to helper to create a record
     * */
    
    createRecord: function(component, event, helper, sObjectRecord) {
        var action2 = component.get("c.getRecTypeId");
        var recordTypeLabel = component.find("recordTypePickList").get("v.value");
        action2.setParams({
            "recordTypeLabel": recordTypeLabel
        });
        
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var RecTypeID  = response.getReturnValue();
                helper.showCreateRecordModal(component, RecTypeID, "Opportunity");
                
            } else{
                alert('You did not select any record type');
            }
        });
        $A.enqueueAction(action2);  
    },
    /*
     * closing quickAction modal window
     * */
    closeModal : function(component, event, helper){
        helper.closeModal();
    }
})