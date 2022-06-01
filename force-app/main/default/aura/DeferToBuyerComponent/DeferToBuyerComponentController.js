({
	createDeferToBuyer : function(component, event, helper) {
        console.log('Record Ids: ' + event.getParam("arguments").listofRecords);
        var action = component.get("c.listOfDeferRecords");
       // alert('record ids'+event.getParam("arguments").listofRecords);
        action.setParams({
            lstRecordId: event.getParam("arguments").listofRecords
            
            
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var blnCreated = response.getReturnValue();
               console.log('success');
            }
            else{
                alert("Please reach out to your System Administartion or CPM in Defering the quote");
            }
        });
        
        $A.enqueueAction(action);
        
		
	}
})