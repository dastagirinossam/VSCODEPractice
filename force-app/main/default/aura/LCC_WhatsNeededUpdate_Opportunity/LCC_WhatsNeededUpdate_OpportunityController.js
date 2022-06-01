({
    
    doInit : function(component, event, helper) {
        event.stopPropagation(); 
        var recordId = component.get("v.recordId");
        
        var flow = component.find("flow");
        var inputVariables = [
            {
                name : 'varOpportunityId',
                type : 'String',
                value : recordId
            }
        ];
        flow.startFlow("WhatsNeedFlow", inputVariables);                               
    },
    
    statusChange : function (cmp, event) {
        if (event.getParam('status') === "FINISHED") {
            
            $A.get("e.force:closeQuickAction").fire();   
        }
        
    }
})