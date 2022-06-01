({
	doInit: function(component) {
        var action = component.get("c.getActiveProjects"); // name on the apex class
        action.setCallback(this, function(p) {
        	if(p.getReturnValue().length > 0 ){
            	component.set("v.projects", p.getReturnValue());                 
            }else{
            	component.set("v.Message", true);
            }
        });
        $A.enqueueAction(action);
    }
})