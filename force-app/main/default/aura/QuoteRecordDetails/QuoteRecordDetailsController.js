({
   
    doInit : function(component, event) {

		var action = component.get("c.getQuote");
        action.setParams({
            "lstRecordId": component.get("v.recordId") 
        });

		action.setCallback(this, function(s) {
        	var squawkQuote = s.getReturnValue();           
            var qte = JSON.parse(JSON.stringify(squawkQuote));
           
            component.set("v.AppTotal", qte[0].Approved_Total__c);
            component.set("v.EstTotal", qte[0].Estimated_Total__c);
     		component.set("v.PendingTotal", qte[0].Pending_Total__c);
    		component.set("v.QuoteType", qte[0].Labor_Type1__c);
    		component.set("v.WorkOrder", qte[0].Add_Work_Work_Order__c);
            
            if(qte[0].Project__c != null){
    			component.set("v.project", qte[0].Project__r.Name);
            	component.set("v.projectId", qte[0].Project__c);                        
            }
                       
        });
        
        $A.enqueueAction(action);
	} 
})