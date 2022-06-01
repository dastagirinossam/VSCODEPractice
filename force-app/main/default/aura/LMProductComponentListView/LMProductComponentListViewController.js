({
    doInit : function(component, event, helper) {
        var action = component.get("c.listValues");
        action.setParams({
            "objectInfo" : component.get("v.objectInfo")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var listViewResult = response.getReturnValue();
                if(listViewResult.length > 0){
                    component.set("v.listViewResult",listViewResult);
                    
                    component.set("v.currentListViewName", 'AllProducts');
                    console.log('List View: ' + listViewResult[0].developerName);
                    component.set("v.bShowListView", true);     
                }            } 
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    createProduct: function(component, event, helper){
        var url = '/apex/Create_Product';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        
        urlEvent.fire();
        
    },
    createNewView: function(component,event,helper){
        var url='/ui/list/FilterEditPage?ftype=Product2&retURL=/lightning/n/Product_List_View';
        var urlEvent=$A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":url
        });
        urlEvent.fire();
    },
    onPicklistChange: function(component, event, helper) {
        
        component.set("v.bShowListView", false);
        var lstViewName = event.getSource().get("v.value"); 
        component.set("v.currentListViewName", lstViewName);
        component.set("v.bShowListView", true); 
    },
    
    editView: function(component, event, helper){
        var action = component.get("c.getListViewId");
        action.setParams({
            objectInfo : component.get('v.objectInfo'),
            listViewName : component.get('v.currentListViewName')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listViewId = response.getReturnValue();
                //var url='/ui/list/FilterEditPage?ftype=Product2&retURL=/lightning/n/Product_List_View';
                var url = '/ui/list/FilterEditPage?id='+listViewId+'&retURL=/lightning/n/Product_List_View';
                var urlEvent=$A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url":url
                });
                
                urlEvent.fire();
                
            }
        });
        $A.enqueueAction(action);
    }
})