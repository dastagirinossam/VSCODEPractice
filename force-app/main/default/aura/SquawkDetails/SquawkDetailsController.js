({
   doInit : function(component, event) {

		var action = component.get("c.getQuoteLine");
        action.setParams({
            "lstRecordId": component.get("v.recordId") 
        });

		action.setCallback(this, function(s) {
        	var squawk = s.getReturnValue();           
            var sqk = JSON.parse(JSON.stringify(squawk));
            console.log('string12>>'+ JSON.stringify(squawk))

            if(sqk[0].Add_Work_Status__c == 'Denied'){
              component.set("v.AddWorkStatus", 'Declined');  
            }else{
            	component.set("v.AddWorkStatus", sqk[0].Add_Work_Status__c);
            }
            
            component.set("v.EstTotal", sqk[0].AddWork_Estimated_Total__c);
     		component.set("v.RTS", sqk[0].RTS__c);
    		component.set("v.jcdesc", sqk[0].Job_Card_Description__c);
    		component.set("v.labAmount", sqk[0].Labor_Amount__c);
    		component.set("v.matAmount", sqk[0].Material_Amount__c);
    		component.set("v.labType", sqk[0].Add_Work_Labor_Type__c);
    		component.set("v.matType", sqk[0].Material_Type__c);
            
            component.set("v.estimatedLaborHrs", sqk[0].Estimated_Labor_Hours__c);
            component.set("v.showELH", sqk[0].Show_Estimated_Labor_Hours__c);
            
            if(sqk[0].Designated_Approver__c != null){
            	component.set("v.dApprover", sqk[0].Designated_Approver__r.Name);           
            	component.set("v.dApproverId", sqk[0].Designated_Approver__c);
            }

            if(sqk[0].Project__c != null){
    			component.set("v.Project", sqk[0].Project__r.Name);
            	component.set("v.ProjectId", sqk[0].Project__c);
                
                if(sqk[0].Project__r.CPM__c != null){
            		component.set("v.cpm", sqk[0].Project__r.CPM__r.Name);
            		component.set("v.cpmId", sqk[0].Project__r.CPM__c);
            	}               
            }
            
            console.log('Quote: ' + sqk[0].SBQQ__Quote__r.Name);
            
            if(sqk[0].SBQQ__Quote__c != null){
            	component.set("v.quote", sqk[0].SBQQ__Quote__r.Name);
            	component.set("v.quoteId", sqk[0].SBQQ__Quote__c);
            }
            
    		component.set("v.createdBy", sqk[0].CreatedBy.Name);
            component.set("v.createdById", sqk[0].CreatedBy.Id)
            
        });
        
        $A.enqueueAction(action);
	} 
})