({
	doInit: function(component) {
        var action = component.get("c.getOldProjects"); // name on the apex class
        action.setCallback(this, function(p) {
            component.set("v.projects", p.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    Search: function(component, event, helper) {
    	var searchKeyFld = component.find("searchId");     
        var srcValue = searchKeyFld.get("v.value");
        if (srcValue == '' || srcValue == null) {
            // display error message if input value is blank or null
            component.set("v.ErrorMessage", true);
        } else {
            component.set("v.ErrorMessage", false);
            // call helper method
            helper.SearchHelper(component, event);
        }
    }
})