({
    save: function(cmp, event, helper) {
        cmp.find("edit").get("e.recordSave").fire();
        var url = '/apex/ProductVF?c__id=' + cmp.get("v.recordId");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" : url,           
        });
        
        urlEvent.fire();        
    },
    
    handleSaveSuccess: function(component, event) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();       
    },
    
    close: function(cmp, event, helper){
        
        var url = '/apex/ProductVF?c__id=' + cmp.get("v.recordId");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" : url,          
        });
        
        urlEvent.fire();
    }
})