({
   
    doInit : function(component, event) {
		var action = component.get("c.getCCO");
        action.setParams({
            "lstRecordId": component.get("v.recordId") 
        });

		action.setCallback(this, function(s) {
        	var changeOrder = s.getReturnValue();           
            var cco = JSON.parse(JSON.stringify(changeOrder));
            component.set("v.Aircraft", cco[0].Aircraft__c);
     		component.set("v.redeliveryDate", cco[0].Current_Redelivery_Date__c);                        
            component.set("v.dateSubmitted", cco[0].Date_Submitted__c);
            component.set("v.Description", cco[0].Description__c);
            component.set("v.name", cco[0].Name);
			component.set("v.project", cco[0].Project__r.Name);
            component.set("v.projectId", cco[0].Project__c);
            component.set("v.CostImpact", cco[0].Cost_Impact__c); 
        });
        
        $A.enqueueAction(action);
        console.log(component.get("v.name"));
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