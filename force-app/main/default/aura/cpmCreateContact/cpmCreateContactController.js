({
    doInit: function(component, event, helper) {
        
        var accntId = component.get('v.accntId');
        component.set("v.accntId", accntId);
        console.log('Account Id: ' + accntId);
                       
        // Prepare a new record from template
        component.find("contactRecordCreator").getNewRecord(
            "Contact", // sObject type (objectApiName)
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newContact");
                var error = component.get("v.newContactError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }
                console.log("Record template initialized: " + rec.apiName);
            })
        );           
    },
    
    handleSaveContact: function(component, event, helper) {
        
        component.set('v.showSpinner', true);
        
        var accntId = component.get('v.accntId');
        console.log('Account Id: ' + accntId); 
        
        component.set("v.simpleNewContact.AccountId", accntId);
        component.set("v.simpleNewContact.ContactType__c", "Primary Contact");
        
        component.find("contactRecordCreator").saveRecord(function(saveResult) {
			          
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                
                // record is saved successfully                                            
                var conId = saveResult.recordId;
                console.log('Contact Id: ' + conId);
                helper.createUser(component,event,conId);
             
            } else if (saveResult.state === "INCOMPLETE") {
                // handle the incomplete state
                console.log("User is offline, device doesn't support drafts.");
                component.set('v.showSpinner', false);
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                console.log('Problem saving contact, error: ' + JSON.stringify(saveResult.error));
                component.set('v.showSpinner', false);
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                component.set('v.showSpinner', false);
            }
        });
    },
    
    handleError: function(cmp, event, helper) {
        
        cmp.set('v.showSpinner', false);
    },
    
    handleSuccess: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
    },
    
    handleChange : function(component, event, helper) {
        // When an option is selected, navigate to the next screen
        var response = event.getSource().getLocalId();
        component.set("v.value", response);
         console.log('response1'+event.getSource())
        var navigate = component.get("v.navigateFlow");
        console.log('navigate'+navigate)
        
        if(response=='previousId'){
            navigate("BACK");
        }
        
        if(response=='nextId'){
            navigate("NEXT");
        }
    },
    
    handleClear : function(component, event, helper){
        var emptyContactFields = component.get('v.simpleNewContact');
        emptyContactFields.FirstName = '';
        emptyContactFields.LastName = '';
        emptyContactFields.Email = ''; 
        emptyContactFields.Title = ''; 
        component.set('v.simpleNewContact', emptyContactFields);
    },
            
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
   },
    
    hideSpinner : function(component,event,helper){   
       component.set("v.Spinner", false);
    }
   
})