({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.getContactList");
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var records = response.getReturnValue();
                if(records.length > 0){

                    records.forEach(function(record){
                        record.linkName = '/Customer/s/customerconfirmation?id=' + record.Id;
                    });
                    component.set('v.mydata', records);
                    component.set('v.contactList', true);
                    component.set('v.mycolumns', [
                        
                        {label: 'Name', fieldName: 'linkName', type: 'url', 
                         typeAttributes: {label: { fieldName: 'Name'}, target: '_self'}},
                        {label: 'Guest Details', fieldName: 'Guest_Details__c', type: 'text'}
                    ]); 
                
                }
            }                      
        });       
        
        $A.enqueueAction(action);
    }
})