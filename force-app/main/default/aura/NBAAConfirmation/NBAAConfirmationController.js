({
    getrecord : function(component, event, helper) {
        var conId = window.location.href;
        var cId = conId.slice(-18);
        component.set('v.recordId', cId);            
    },
    
    handleSubmit: function(cmp, event, helper) {
        cmp.set('v.disabled', true);
        cmp.set('v.showSpinner', true);
    },
    
    handleSuccess: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
    },
    
    handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
    },
    
    handleCancel: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" : '/nbaa-customerinvitations'
        });
        urlEvent.fire();
    }
})