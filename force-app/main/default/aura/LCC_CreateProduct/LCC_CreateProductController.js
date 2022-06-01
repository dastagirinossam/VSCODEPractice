({    
    doInit : function(cmp, event, helper) {
		event.stopPropagation(); 
        var flow = cmp.find("flow");

        flow.startFlow("CloneProductBundle");            
    },
 
    statusChange : function (cmp, event) {
        if (event.getParam('status') === "FINISHED") {           
            $A.get("e.force:closeQuickAction").fire();   
        }   
	}
})