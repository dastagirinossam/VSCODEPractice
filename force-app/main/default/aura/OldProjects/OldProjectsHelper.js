({
    SearchHelper: function(component, event) {
        var action = component.get("c.findProjects");
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is 0 ,display no record found message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", true);
                } else {
                    component.set("v.Message", false);
                }
                // set numberOfRecord attribute value with length of return value from server
                component.set("v.numberOfRecord", storeResponse.length);
                // set searchResult list with return value from server.
                component.set("v.projects", storeResponse);
            } 
        });
        $A.enqueueAction(action); 
    },
})