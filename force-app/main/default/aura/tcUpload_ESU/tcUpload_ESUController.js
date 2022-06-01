({
    doInit: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:tcEndUserStatement_OppUpload",
            componentAttributes: {
                recordId : component.get("v.recordId")
            }
            
        });
        evt.fire();
    }
})