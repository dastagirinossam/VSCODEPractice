({
   doInit : function(component, event) {
       	document.body.style.overflow = "auto";

		var action = component.get("c.getProjectDetails");
        action.setParams({
            "lstRecordId": component.get("v.recordId") 
        });

		action.setCallback(this, function(s) {
        	var project = s.getReturnValue();           
            var proj = JSON.parse(JSON.stringify(project));
            
            console.log('proj: '+ JSON.stringify(proj));
            console.log("Returned: " + proj[0].Name);
            
            component.set("v.Name", proj[0].Name);
			component.set("v.InputDate", proj[0].Input_Date__c);
    		component.set("v.OutputDate", proj[0].Delivery_Date__c);
 			component.set("v.afCrewchief", proj[0].Airframe_Crew_Chief_Name__c);
            
            component.set("v.estimatedLaborHours", proj[0].Estimated_Labor_Hours__c);
            component.set("v.totalEstimatedLaborHours", proj[0].Total_Estimated_Labor_Hours__c);
            component.set("v.pendingEstimatedLaborHours", proj[0].Pending_Estimated_Labor_Hours__c);
            
            component.set("v.showELH", proj[0].Show_Estimated_Labor_Hours__c);
            
            console.log('Crew Chief: ' + proj[0].Crew_Chief__c);
            component.set("v.proposalNo", proj[0].Proposal__c);
    		component.set("v.pendingSquawks", proj[0].Pending_Squawks__c);
    		component.set("v.description", proj[0].MPM4_BASE__Description__c);
 			component.set("v.approvedTotal", proj[0].Approved_Total__c);
            component.set("v.pendingTotal", proj[0].Pending_Total__c);
            component.set("v.estimatedTotal", proj[0].Estimated_Total__c);
            
            component.set("v.cpm", proj[0].CPM__c);
            if(proj[0].CPM__c != null){
                component.set("v.cpmName", proj[0].CPM__r.Name);
            }
            
            component.set("v.lmb", proj[0].LastModifiedById);
            if(proj[0].LastModifiedById != null){
                component.set("v.lmbName", proj[0].LastModifiedBy.Name);
                component.set("v.lmbDate", proj[0].LastModifiedDate);
            }
    		  		
            component.set("v.desApprover", proj[0].Designated_Approver__c);
            if(proj[0].Designated_Approver__c != null){
                component.set("v.desApproverName", proj[0].Designated_Approver__r.Name);
            }
    		
            component.set("v.secApprover", proj[0].Secondary_Approver__c);
            if(proj[0].Secondary_Approver__c != null){
                component.set("v.secApproverName", proj[0].Secondary_Approver__r.Name);
            }
            
            component.set("v.thirdApprover", proj[0].X3_Approver__c);
            if(proj[0].X3_Approver__c != null){
                component.set("v.thirdApproverName", proj[0].X3_Approver__r.Name);
            }
            
            component.set("v.fourthApprover", proj[0].X4_Approver__c);
            if(proj[0].X4_Approver__c != null){
                component.set("v.fourthApproverName", proj[0].X4_Approver__r.Name);
            }
            
            component.set("v.fifthApprover", proj[0].X5_Approver__c);
            if(proj[0].X5_Approver__c != null){
                component.set("v.fifthApproverName", proj[0].X5_Approver__r.Name);
            }
            
            component.set("v.sixthApprover", proj[0].X6_Approver__c);
            if(proj[0].X6_Approver__c != null){
                component.set("v.sixthApproverName", proj[0].X6_Approver__r.Name);
            }
           
        });
        
        $A.enqueueAction(action);
       
       var action1 = component.get("c.checkIsBroker");
        action1.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse[0] =='Customer - Broker' ){
                    component.set("v.isBroker", true);
                    
                }
            }
        });
        $A.enqueueAction(action1);
	} 
})