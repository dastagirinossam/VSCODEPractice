({
    getMyProjects: function(component) {
        
        var action = component.get("c.getCount"); // name on the apex class
        action.setCallback(this, function(p) {
            //alert('return projects'+p.getReturnValue().length);
            if(p.getReturnValue().length > 0 ){
                
                component.set("v.projects", p.getReturnValue());                 
            }else{
                
                component.set("v.Message", true);
                component.set("v.projects", null);  
                this.toggleClassInverse(component,'backdrop','slds-backdrop--');
            }
        });
        $A.enqueueAction(action);
    },
    
    hideSquawks : function(component) {
        component.set("v.body",[]);
    },
    
    SearchHelper: function(component, event, searchText) { 
        
        var action = component.get("c.findSquawks");
        
        action.setParams({"searchKeyWord": searchText});
        action.setCallback(this, function(s) { 
            
            // if storeResponse size is 0 ,display no record found message on screen.
            if (s.getReturnValue().length == 0) {
                component.set("v.SquawkMessage", true);
            }else if (s.getReturnValue().length > 1){
                this.toggleClass(component,'backdrop','slds-backdrop--');
                this.toggleClass(component,'squawkSearchMultiple','slds-fade-in-');
                document.body.style.overflow = "hidden";
                component.set("v.squawks", s.getReturnValue()); 
                component.set("v.searchCount", s.getReturnValue().length);
                
            }else if (s.getReturnValue().length == 1){
                this.toggleClass(component,'backdrop','slds-backdrop--');
                this.toggleClass(component,'squawkSearch','slds-fade-in-');
                document.body.style.overflow = "hidden";
                component.set("v.SquawkMessage", false);               
                
                var squawk = s.getReturnValue();           
                var sqk = JSON.parse(JSON.stringify(squawk));
                component.set("v.searchCount", s.getReturnValue().length);           
                component.set("v.squawk", sqk[0].Id);           
                component.set("v.squawkName", sqk[0].Name);                
                component.set("v.AddWorkStatus", sqk[0].Add_Work_Status__c);
                component.set("v.EstTotal", sqk[0].AddWork_Estimated_Total__c);
                component.set("v.RTS", sqk[0].RTS__c);
                component.set("v.jcdesc", sqk[0].Job_Card_Description__c);
                component.set("v.labAmount", sqk[0].Labor_Amount__c);
                component.set("v.matAmount", sqk[0].Material_Amount__c);
                component.set("v.labType", sqk[0].Add_Work_Labor_Type__c);
                component.set("v.matType", sqk[0].Material_Type__c);
                
                if(sqk[0].Designated_Approver__c != null){
                    component.set("v.dApprover", sqk[0].Designated_Approver__r.Name);           
                    component.set("v.dApproverId", sqk[0].Designated_Approver__c);
                }
                
                if(sqk[0].Project__c != null){
                    component.set("v.Project", sqk[0].Project__r.Name);
                    component.set("v.ProjectId", sqk[0].Project__c);                                
                }
                
                if(sqk[0].SBQQ__Quote__c != null){
                    component.set("v.quote", sqk[0].SBQQ__Quote__r.Name);
                    component.set("v.quoteId", sqk[0].SBQQ__Quote__c);
                }                
                
            }
            
        });
        $A.enqueueAction(action); 
    },
    
    toggleClass: function(component,componentId,className) {
        var modal = component.find(componentId);
        $A.util.removeClass(modal,className+'hide');
        $A.util.addClass(modal,className+'open');        
    },
    
    toggleClassInverse: function(component,componentId,className) {
        var modal = component.find(componentId);
        $A.util.addClass(modal,className + 'hide');
        $A.util.removeClass(modal,className + 'open');
    },
    
    rejectRtsHelper: function(component, event, rejectRecordsIds) {
        component.set("v.Spinner", true); 
        var action = component.get('c.getRtsRecords');
        
        action.setParams({
            "lstRecordId": rejectRecordsIds
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                this.toggleClassInverse(component,'squawkModal','slds-fade-in-');
                if (response.getReturnValue().length > 0) {
                    this.toggleClass(component,'RtsSelectedModal','slds-fade-in-');
                } else {
                    this.toggleClass(component,'rejectModal','slds-fade-in-');
                }
            }
        });
        $A.enqueueAction(action);
        component.set("v.Spinner", false); 
    },
    
    ApprovedSquawksHelper : function(component) {
        var projId = component.get('v.ProjId');                                    
        var action = component.get('c.getProjectRecords'); // name on the apex class
        action.setParams({'lstRecordId': projId});
        action.setCallback(this, function(p) {
            
            component.set("v.squawks", p.getReturnValue());
            if(p.getReturnValue().length > 0){
                var squawks = p.getReturnValue();           
                var project = JSON.parse(JSON.stringify(squawks));                    
                component.set("v.ProjName", project[0].Project__r.Name);
                component.set("v.projMaxAmount", project[0].Project__r.Max_Approval_Limit__c);
                component.set("v.projEstTotal",project[0].Project__r.Estimated_Total__c);
                component.set("v.selectedCount", "0");
                this.toggleClass(component,'squawkModal','slds-fade-in-');
            }else{
                component.set("v.squawks", null);
                component.set("v.selectedCount", "0");
                component.set("v.selectAll", false);
                component.set("v.returnSize", "height: 100%");
                this.toggleClassInverse(component,'backdrop','slds-backdrop--');
                document.body.style.overflow = "auto";
            }
        });
        
        $A.enqueueAction(action);  
        
        this.toggleClassInverse(component,'approveModal','slds-fade-in-');
    },
    
    RejectedSquawksHelper : function(component) {
        var projId = component.get('v.ProjId');                                    
        var action = component.get('c.getProjectRecords'); // name on the apex class
        action.setParams({'lstRecordId': projId});
        action.setCallback(this, function(p) {
            
            component.set("v.squawks", p.getReturnValue());
            
            var squawks = p.getReturnValue();           
            var project = JSON.parse(JSON.stringify(squawks));
            if(p.getReturnValue().length > 0){   
                component.set("v.ProjName", project[0].Project__r.Name);
                component.set("v.projMaxAmount", project[0].Project__r.Max_Approval_Limit__c);
                component.set("v.projEstTotal",project[0].Project__r.Estimated_Total__c);
                component.set("v.selectedCount", "0");
                this.toggleClass(component,'squawkModal','slds-fade-in-');
            }else{
                component.set("v.squawks", null);
                component.set("v.selectedCount", "0");
                component.set("v.selectAll", false);
                component.set("v.returnSize", "height: 100%");
                this.toggleClassInverse(component,'backdrop','slds-backdrop--');
                document.body.style.overflow = "auto";
            }
        });
        
        $A.enqueueAction(action);  
        
        this.toggleClassInverse(component,'rejectModal','slds-fade-in-');
    },
    
    approveSelectedHelper: function(component, event, approveRecordsIds) {
        //call apex class method
        var maxAmount = component.get('v.projMaxAmount');
        var appTotal = component.get('v.projAppTotal');
        var action = component.get('c.approveRecords');
        
        action.setParams({
            "lstRecordId": approveRecordsIds,
            "maxAmount" : maxAmount,
            "appTotal" : appTotal
        });
        
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(state);
                if (response.getReturnValue() != '') {
                    var message = response.getReturnValue();
                    // if getting any error while delete the records , then display a alert msg/
                    var toastEvent = $A.get("e.force:showToast");
                    console.log('Error Message: ' + response.getReturnValue());
                    
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error Approving Squawks",
                        "message": "You are not able to Approve these Squawks. If you have questions regarding this, please contact your Customer Project Manager."
                    });
                    toastEvent.fire();
                }else{
                    console.log('fail');
                }
            }
        });
        $A.enqueueAction(action);
        
        this.getMyProjects(component);
        this.ApprovedSquawksHelper(component);       
    },
    
    rejectSelectedHelper: function(component, event, rejectRecordsIds) {
        //call apex class method
        var action = component.get('c.rejectRecords');
        
        action.setParams({
            "lstRecordId": rejectRecordsIds
        });
        
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(state);
                if (response.getReturnValue() != '') {
                    var message = response.getReturnValue();
                    // if getting any error while delete the records , then display a alert msg/
                    var toastEvent = $A.get("e.force:showToast");
                    console.log('Error Message: ' + response.getReturnValue());
                    
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error Rejecting Squawks",
                        "message": "You are not able to Reject these Squawks. If you have questions regarding this, please contact your Customer Project Manager."
                    });
                    toastEvent.fire();
                } else {
                    console.log('check it--> update successful');
                } 			
            }
        });
        $A.enqueueAction(action);
        
        this.getMyProjects(component);
        this.RejectedSquawksHelper(component);           
    },
    
    deferSelectedHelper: function(component, event, deferRecordsIds) {
        //call apex class method
        
       var res= component.find("DeferToBuyer").DeferToBuyerQL(deferRecordsIds);
       // alert('result of child comp'+res);
        
        /*var action = component.get('c.deferRecords');
        
        action.setParams({
            "lstRecordId": deferRecordsIds
        });
        
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(state);
                alert(response.getReturnValue());
                if (response.getReturnValue() != '') {
                    var message = response.getReturnValue();
                    // if getting any error while delete the records , then display a alert msg/
                    var toastEvent = $A.get("e.force:showToast");
                    console.log('Error Message: ' + response.getReturnValue());
                    //alert(response.getReturnValue());
                    
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error Deferring Squawks",
                        "message": "You are not able to Defer these Squawks. If you have questions regarding this, please contact your Customer Project Manager."
                    });
                    toastEvent.fire();
                } else {
                    console.log('check it--> update successful');
                } 			
            }
        });
        $A.enqueueAction(action);*/
        
        this.getMyProjects(component);
        this.DeferredSquawksHelper(component);           
    },
    
    DeferredSquawksHelper : function(component) {
        var projId = component.get('v.ProjId');                                    
        var action = component.get('c.getProjectRecords'); // name on the apex class
        action.setParams({'lstRecordId': projId});
        //alert('defer');
        action.setCallback(this, function(p) {
            
            component.set("v.squawks", p.getReturnValue());
            if(p.getReturnValue().length > 0){
                var squawks = p.getReturnValue();           
                var project = JSON.parse(JSON.stringify(squawks));                    
                component.set("v.ProjName", project[0].Project__r.Name);
                component.set("v.projMaxAmount", project[0].Project__r.Max_Approval_Limit__c);
                component.set("v.projEstTotal",project[0].Project__r.Estimated_Total__c);
                component.set("v.selectedCount", "0");
                this.toggleClass(component,'squawkModal','slds-fade-in-');
            }else{
                component.set("v.squawks", null);
                component.set("v.selectedCount", "0");
                component.set("v.selectAll", false);
                component.set("v.returnSize", "height: 100%");
                this.toggleClassInverse(component,'backdrop','slds-backdrop--');
                document.body.style.overflow = "auto";
            }
        });
        
        $A.enqueueAction(action);  
        
        this.toggleClassInverse(component,'deferModal', 'slds-fade-in-');
    }
    
    
})