({
    getrecord : function(component, event, helper) {
        var action = component.get('c.getContactIdOfLoggedInUser'); // name on the apex class
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('State: ' + state);
            if (state === "SUCCESS") {
                var result = JSON.parse(JSON.stringify(response.getReturnValue()));
                console.log('Contact: ' + result[0].Invited_to_NBAA__c);
                component.set('v.recordId', result[0].Id);
                component.set('v.name', result[0].Name);
                
                //if(result[0].Invited_to_NBAA__c == 'Invited')
                    //component.set('v.acceptedResponse', false);
                
                //if(result[0].Invited_to_NBAA__c == 'RSVP_Pending_Confirmation')
                    //component.set('v.acceptedResponse', true);
                
                //if(result[0].Invited_to_NBAA__c == 'Confirmed')
                    component.set('v.acceptedResponse', true);
                
                
                component.set('v.inviteStatus', result[0].Invited_to_NBAA__c);
                component.set('v.additionalGuest', result[0].Additional_Guest__c);
                
                component.set('v.nbaaInviteFront', 
                              'https://standardaero--c.na79.content.force.com/servlet/servlet.ImageServer?id=0151O000004FOLm&oid=00D00000000hfim'
                             );
                component.set('v.nbaaInviteBack', 
                              'https://standardaero--c.na79.content.force.com/servlet/servlet.ImageServer?id=0151O000004FOwI&oid=00D00000000hfim'
                             );
                
            }else{
                console.log('Error: ');
            }       
        });
        $A.enqueueAction(action);
    },
    
    handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
    },
    
    handleSubmit: function(cmp, event, helper) {
        cmp.find('contactForm').submit();
        cmp.set('v.disabled', true);
        cmp.set('v.showSpinner', true);
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
    
    checkboxSelect: function(component, event, helper){
        var chkbox = component.get('v.additionalGuest');
        console.log(chkbox);
        
        component.set("v.showGuest", chkbox);           
    },
    
    frontInvite : function(component, event, helper) {
        console.log('0691O00000CVyyF front invite');
        var docId =  '0691O00000CVyyF'; // NBAA
        $A.get('e.lightning:openFiles').fire({
            recordIds: [docId]
        });
    },
    
    backInvite : function(component, event, helper) {
        console.log('0691O00000CVz8j back invite');
        var docId =  '0691O00000CVz8j'; // NBAA
        $A.get('e.lightning:openFiles').fire({
            recordIds: [docId]
        });
    }
    
})