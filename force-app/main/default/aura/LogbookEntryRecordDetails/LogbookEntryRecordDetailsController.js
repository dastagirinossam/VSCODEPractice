({
   
    doInit : function(component, event) {

		var action = component.get("c.getLbEntry");
        action.setParams({
            "lstRecordId": component.get("v.recordId") 
        });

		action.setCallback(this, function(s) {
        	var logbook = s.getReturnValue();           
            var lg = JSON.parse(JSON.stringify(logbook));
           
            component.set("v.workOrder", lg[0].Work_Order__c);
     		component.set("v.entryDate", lg[0].Entry_Date__c);
            component.set("v.name", lg[0].Name);
			component.set("v.project", lg[0].Project__r.Name);
            component.set("v.projectId", lg[0].Project__c);                        
                       
        });
        
        $A.enqueueAction(action);
	},
    
    viewDoc : function(component, event) {        
        
        var action = component.get("c.getLbPreview");
        
        action.setParams({
            "file": component.get("v.recordId")           
        });
       
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