({
    
    doInit : function(component, event) {
        var recordId = component.get("v.recordId");
       	var action = component.get("c.getQuoteLine"); // name on the apex class
        action.setParams({"lstRecordId": recordId});
        action.setCallback(this, function(p) {
            component.set("v.Squawk", p.getReturnValue());
            console.log(p.getReturnValue());
        });
        $A.enqueueAction(action);
    },

 	approveSquawk: function(component, event) {
		var approveRecordId = component.get("v.recordId");               
  		var action = component.get('c.approveRecords'); 
                
        action.setParams({"lstRecordId": approveRecordId});
  		action.setCallback(this, function(response) {
            
   			var state = response.getState();
   			if (state === "SUCCESS") {
    			console.log(state);
    			if (response.getReturnValue() != '') {
     				// if getting any error while delete the records , then display a alert msg/
     				alert('The following error has occurred. while Updating record-->' + response.getReturnValue());
    			} else {
     				console.log('check it--> update successful');
    			}
                this.onLoad(component, event);
   			}
  		});
        
  		$A.enqueueAction(action);
        this.doInit(component, event, helper);

 	},
    
    rejectSquawk: function(component, event, helper) {
		var rejectRecordId = component.get("v.recordId");               
  		var action = component.get('c.rejectRecords'); 
                
        action.setParams({"lstRecordId": rejectRecordId});
  		action.setCallback(this, function(response) {
            
   			var state = response.getState();
   			if (state === "SUCCESS") {
    			console.log(state);
    			if (response.getReturnValue() != '') {
     				// if getting any error while delete the records , then display a alert msg/
     				alert('The following error has occurred. while Updating record-->' + response.getReturnValue());
    			} else {
     				console.log('check it--> update successful');
    			}
    			this.onLoad(component, event);
   			}
  		});
        
  		$A.enqueueAction(action);
        window.location.reload()
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
        
        if(status == 'Pending'){
			helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'rejectModal','slds-fade-in-');
        }else if(status == 'PendingX'){
            helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'rejectRtsModal','slds-fade-in-');
        }else if(status == 'Approved'){
            helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'approvedModal','slds-fade-in-');  
        }else if(status == 'ApprovedX'){
            helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'approvedModal','slds-fade-in-'); 
        }else if(status == 'Denied'){
            helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'rejectedModal','slds-fade-in-'); 
        }else if(status == 'DeniedX'){
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
    
    hideRejectRtsModal : function(component, event, helper) {
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'rejectRtsModal','slds-fade-in-');
	}
})