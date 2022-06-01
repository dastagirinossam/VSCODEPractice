({
    
    doInit : function(component, event, helper) {
		event.stopPropagation(); 
        var flow = component.find("flow");
        var recordId = component.get("v.recordId");
        var inputVariables = [
            {
                name : 'varProjectId',
                type : 'String',
                value : recordId
            }
        ];
        flow.startFlow("ProjectCreateQuote", inputVariables);
        
        
    },
 
    statusChange : function (cmp, event) {
        if (event.getParam('status') === "FINISHED") {
            
            $A.get("e.force:closeQuickAction").fire();   
        }   
	}
})