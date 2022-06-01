({
    
    handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
    },
    
    handleSaveRecord: function(cmp, event, helper) {
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        cmp.find('contactForm').submit(eventFields);  
        
    },
    
    handleError: function(cmp, event, helper) {
        
        cmp.set('v.showSpinner', false);
    },
    
    handleSuccess: function(cmp, event, helper) {
        var conId = cmp.get('v.recordId');                
        helper.inviteUser(cmp, event, conId);
        
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
    },
    
    handleCancel: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" : '/nbaa-customerinvitations'
        });
        urlEvent.fire();
    }
    
})