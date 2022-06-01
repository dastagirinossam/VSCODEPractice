({
    
    doInit : function(component, event, helper) {
		event.stopPropagation(); 
        var flow = component.find("flow");

        flow.startFlow("cpmCreateNewProject");            
    },
 
    statusChange : function (cmp, event) {
        if (event.getParam('status') === "FINISHED") {           
            $A.get("e.force:closeQuickAction").fire();   
        }   
	}
})