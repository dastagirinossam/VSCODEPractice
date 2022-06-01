({
	doInit : function(component, event, helper) {
        //Get Approval History
        helper.method1(component);
        
        //Get Files
        helper.method2(component);

    },
    
    sortByAction: function(component, event, helper) {
        component.set("v.selectedTabsoft", 'Action');
        helper.sortBy(component, "Action");
    },
         
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    viewDoc : function(component, event) {                        
        var src = event.getSource().get("v.value");       
        console.log(src);
        
        var action = component.get("c.getPreview");
        
        	action.setParams({"file": src});

			action.setCallback(this, function(s) {
            
        	var contentDoc = s.getReturnValue();           
            var doc = JSON.parse(JSON.stringify(contentDoc));
           
            if(contentDoc != null){
            	var docId =  doc[0].ContentDocumentId;
                       
            	$A.get('e.lightning:openFiles').fire({
        			recordIds: [docId]
    			});
            }
        });
        
        $A.enqueueAction(action);
	}
})