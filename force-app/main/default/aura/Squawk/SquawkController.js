({
    doInit : function(component, event) {

		var action = component.get("c.getQuoteLine");
        action.setParams({
            "lstRecordId": component.get("v.recordId") 
        });

		action.setCallback(this, function(s) {
        	var squawk = s.getReturnValue();           
            var sqk = JSON.parse(JSON.stringify(squawk));
            document.body.style.overflow = "auto"; 
            component.set("v.name", sqk[0].fxSquawkNo__c);
            component.set("v.isRTS", sqk[0].IsRTS__c);
            
            if(sqk[0].Add_Work_Status__c == 'Denied'){
                component.set("v.status", 'Declined');
            }else{
            	component.set("v.status", sqk[0].Add_Work_Status__c);
            }
            
            console.log('Project Type: ' + sqk[0].Project__r.Project_Type__c);
            
            if(sqk[0].Project__r.Project_Type__c == 'Pre-Buy'){                
                if((sqk[0].Project__r.Buyer_Inspection__c == undefined || sqk[0].Project__r.Buyer_Inspection__c == null) && sqk[0].Project__r.Seller_Inspection__c != null)
                    component.set("v.ProjType","Buyer");
                    
                if( (sqk[0].Project__r.Seller_Inspection__c == undefined || sqk[0].Project__r.Seller_Inspection__c == null) && sqk[0].Project__r.Buyer_Inspection__c != null)
                    component.set("v.ProjType","Seller");
                
                

            }
            
        });
        
        $A.enqueueAction(action);
	},
     	
 	approveSquawk: function(component, event, helper) {     
        
		var approveRecordId = component.get("v.recordId");               
  		var action = component.get("c.approveRecords");         
        
        component.set("v.Spinner", "True");
        
        action.setParams({"lstRecordId": approveRecordId});
  		action.setCallback(this, function(response) {
            
   			var state = response.getState();
   			if (state === "SUCCESS") {
    			console.log(state);
    			if (response.getReturnValue() != "") {
     				// if getting any error while delete the records , then display a alert msg/
     				alert("The following error has occurred. while Updating record-->" + response.getReturnValue());
    			} else {
     				console.log("check it--> update successful");                    
                    component.set("v.updateStatus", "True");                  
    			}    			
   			}
  		});
        
  		$A.enqueueAction(action);
        
        helper.toggleClassInverse(component,"backdrop","slds-backdrop--");
		helper.toggleClassInverse(component,"approveModal","slds-fade-in-");
        helper.statusChange(component, event);      
 	},
        
    navigate : function(component, event) {
    	var address = "/squawk/" + component.get("v.recordId");
   		var urlEvent = $A.get("e.force:navigateToURL");
    	urlEvent.setParams({
      		"url": address,
      		"isredirect" :false
    	});
    	urlEvent.fire();       
	},
       
    rejectSquawk: function(component, event, helper) {
		var rejectRecordId = component.get("v.recordId");               
  		var action = component.get("c.rejectRecords"); 
               
        component.set("v.Spinner", "True");
        
        action.setParams({"lstRecordId": rejectRecordId});
  		action.setCallback(this, function(response) {
            
   			var state = response.getState();
   			if (state === "SUCCESS") {
    			console.log(state);
    			if (response.getReturnValue() != "") {
     				// if getting any error while delete the records , then display a alert msg/
     				alert("The following error has occurred. while Updating record-->" + response.getReturnValue());
    			} else {
     				console.log("check it--> update successful");
                    component.set("v.updateStatus", "True");                  
    			}    			
   			}
  		});
        
  		$A.enqueueAction(action);
        
        helper.toggleClassInverse(component,"backdrop","slds-backdrop--");
		helper.toggleClassInverse(component,"rejectModal","slds-fade-in-");
        helper.statusChange(component, event);
 	},
    
    deferSquawk : function(component, event, helper) {
		var rejectRecordId= []; 
        rejectRecordId = component.get("v.recordId");
        alert('record '+rejectRecordId);
        var res= component.find("DeferToBuyer").DeferToBuyerQL(rejectRecordId);
        component.set("v.Spinner", "True");
        
  		/*var action = component.get("c.deferRecords"); 
               
        component.set("v.Spinner", "True");
        action.setParams({"lstRecordId": rejectRecordId});
  		action.setCallback(this, function(response) {
            
   			var state = response.getState();
   			if (state === "SUCCESS") {
    			console.log(state);
    			if (response.getReturnValue() != "") {
     				// if getting any error while delete the records , then display a alert msg/
     				alert("The following error has occurred. while Updating record-->" + response.getReturnValue());
    			} else {
     				console.log("check it--> update successful");
                    component.set("v.updateStatus", "True");                  
    			}    			
   			}
  		});
        
  		$A.enqueueAction(action);
        */
          component.set("v.updateStatus", "True");                  
        helper.toggleClassInverse(component,"backdrop","slds-backdrop--");
		helper.toggleClassInverse(component,"deferModal","slds-fade-in-");
        helper.statusChange(component, event);
    },
    
    showApprovalmodal: function(component, event, helper) {
        
        var status = event.target.id;
      
        if(status == 'Pending'){
			helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'approveModal','slds-fade-in-');
        }else if(status == 'Approved'){
            helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'approvedModal','slds-fade-in-');
        }else if(status == 'Denied'){
            helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'rejectedModal','slds-fade-in-');
        }
	},
    
    showRejectmodal: function(component, event, helper) {
        
        var status = event.target.id;
      	console.log(status);
        
        if(status == 'PendingN'){
			helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'rejectModal','slds-fade-in-');
        }else if(status == 'PendingY'){
            helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'rejectRtsModal','slds-fade-in-');
        }else if(status == 'ApprovedN'){
            helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'approvedModal','slds-fade-in-');  
        }else if(status == 'ApprovedY'){
            helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'approvedModal','slds-fade-in-'); 
        }else if(status == 'DeniedN'){
            helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'rejectedModal','slds-fade-in-'); 
        }else if(status == 'DeniedY'){
            helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'rejectedModal','slds-fade-in-'); 
        }
	},
    
      showDefermodal: function(component, event, helper) {
        
        var status = event.target.id;
      
        if(status == 'Pending'){
			helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'deferModal','slds-fade-in-');
        }else if(status == 'Approved'){
            helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'approvedModal','slds-fade-in-');
        }else if(status == 'Denied'){
            helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'rejectedModal','slds-fade-in-');
        }
	},
    
    showRejectModalRts: function(component, event, helper) {
        helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'rejectRtsModal','slds-fade-in-');
     	helper.toggleClass(component,'backdrop','slds-backdrop--');
		helper.toggleClass(component,'rejectModal','slds-fade-in-');
    },
    
    hideNotPendingModal: function(component, event, helper){
        var status = event.target.id;
        console.log(status);
        
        if(status == 'Approved'){
       		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
			helper.toggleClassInverse(component,'approvedModal','slds-fade-in-');
        }else if(status == 'Rejected'){
            helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
			helper.toggleClassInverse(component,'rejectedModal','slds-fade-in-');  
        }
    },
    
    hideApproveModal : function(component, event, helper) {
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'approveModal','slds-fade-in-');
	},
    
    hideRejectModal : function(component, event, helper) {
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'rejectModal','slds-fade-in-');
	},
    
    hideDeferModal : function(component, event, helper) {
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'deferModal','slds-fade-in-');
	},
    
    hideRejectRtsModal : function(component, event, helper) {
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'rejectRtsModal','slds-fade-in-');
	}
    
})