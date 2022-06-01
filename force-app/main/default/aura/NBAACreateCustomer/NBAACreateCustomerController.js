({
    doInit: function(component, event, helper) {
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
        
        var action = component.get('c.getAccountId'); // name on the apex class
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") { 
                var result = JSON.parse(JSON.stringify(response.getReturnValue()));          
                console.log('Account Id: ' + result);
        		component.set('v.accntId', result);
                component.set('v.showSpinner', false);
            }       
        });
        $A.enqueueAction(action);      
    },
    
    handleSaveContact: function(component, event, helper) {
        
        component.set('v.showSpinner', true);
        
        var accntId = component.get('v.accntId');
        
        component.set("v.simpleNewContact.AccountId", accntId);
        component.set("v.simpleNewContact.ContactType__c", "Primary Contact");
        component.set("v.simpleNewContact.Invited_to_NBAA__c", "Invited");
        
        component.find("contactRecordCreator").saveRecord(function(saveResult) {
			
            component.set('v.showSpinner', false);
            
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                
                // record is saved successfully                                            
                var conId = saveResult.recordId;                
                helper.createUser(component, event, conId);
                
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
    
    handleCancel: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" : '/'
        });
        urlEvent.fire();
    },
    
    handleClear : function(component, event, helper){
        var emptyContactFields = component.get('v.simpleNewContact');
        emptyContactFields.FirstName = '';
        emptyContactFields.LastName = '';
        emptyContactFields.Email = ''; 
        emptyContactFields.Title = ''; 
        component.set('v.simpleNewContact', emptyContactFields);
    },
    
    createContact : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" : '/nbaa-customerinvitations'
        });
        urlEvent.fire();
    }
})