({
    doInit : function(component, event) {

		var action = component.get("c.getProjectDetails");
        action.setParams({
            "lstRecordId": component.get("v.recordId") 
        });

		action.setCallback(this, function(s) {
        	var project = s.getReturnValue();           
            var proj = JSON.parse(JSON.stringify(project));        
            component.set("v.name", proj[0].Name);
        });
        
        $A.enqueueAction(action);
	}
       
})