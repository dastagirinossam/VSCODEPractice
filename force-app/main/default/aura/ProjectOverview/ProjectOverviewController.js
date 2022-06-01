({
    doInit : function(component, event, helper) {
        component.set("v.Spinner", true);
        helper.getMyProjects(component);
        
        var action = component.get("c.checkIsBroker");
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse[0] =='Customer - Broker' ){
                    component.set("v.isBroker", true);
                    
                }
            }
        });
        $A.enqueueAction(action);
        component.set("v.Spinner", false); 
    },
    
    viewAllSquawks : function(component, event, helper){
        var project = event.getSource().get('v.value');
        
        
        var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({
            "url": '/project-squawks?id=' + project
        });
        eUrl.fire();
        
    },
    
    getSquawks : function(component, event, helper) {
        component.set("v.Spinner", true);
        var projValue = event.getSource().get('v.value');
        
        if(projValue == true){
            
            var projId = event.getSource().get('v.text');  
            console.log('Project Id: ' + projId);
            var action = component.get('c.getProjectRecords'); // name on the apex class
            action.setParams({'lstRecordId': projId});
            action.setCallback(this, function(p) {
                
                var x = screen.height;
                var y = x * .7;
                var z = (p.getReturnValue().length * 41) + 118;
                console.log(p.getReturnValue().length, z, y, x);
                if(z >= y){
                    component.set("v.returnSize", "height: " + y + "px;");                     
                }
                component.set("v.squawks", p.getReturnValue());
                var squawks = p.getReturnValue();           
                var project = JSON.parse(JSON.stringify(squawks));
                
                component.set("v.ProjId", projId);
                console.log("Project Id: " + projId);
                component.set("v.ProjName", project[0].Project__r.Name);
                component.set("v.showELH", project[0].Project__r.Show_Estimated_Labor_Hours__c);
                component.set("v.projMaxAmount", project[0].Project__r.Max_Approval_Limit__c);
                component.set("v.projAppTotal",project[0].Project__r.Approved_Total__c);
                
                //Added by Anil
                
                if(project[0].Project__r.Project_Type__c == 'Pre-Buy'){
                    
                    if((project[0].Project__r.Buyer_Inspection__c == undefined || project[0].Project__r.Buyer_Inspection__c == null) && project[0].Project__r.Seller_Inspection__c != null){
                        component.set("v.ProjType","Buyer");
                        
                    }
                    if( (project[0].Project__r.Seller_Inspection__c == undefined || project[0].Project__r.Seller_Inspection__c == null) && project[0].Project__r.Buyer_Inspection__c != null){
                        component.set("v.ProjType","Seller");
                    }
                }
                else {
                    component.set("v.ProjType","Inspection");
                    
                }
                component.find("squawkModal").getElement().focus();
                document.body.style.overflow = "hidden";
                
            });
            $A.enqueueAction(action);  
        }
        
        helper.toggleClass(component,'backdrop','slds-backdrop--');
        helper.toggleClass(component,'squawkModal','slds-fade-in-');
        component.set("v.Spinner", false); 
    },
    
    Search : function(component, event, helper) {
        component.set("v.Spinner", true); 
        var searchKeyFld = component.find("searchId");     
        var srcValue = searchKeyFld.get("v.value");
        var getAllId = component.find("projPack");
        
        component.set("v.SquawkMessage", false);
        
        if (srcValue == '' || srcValue == null) {
            component.set("v.ErrorMessage", true);
        } else {    
            component.set("v.ErrorMessage", false);             
            helper.SearchHelper(component, event, srcValue);
        }
        component.set("v.Spinner", false); 
    },
    
    getSquawk : function(component, event, helper) {
        component.set("v.Spinner", true); 
        helper.toggleClassInverse(component,'squawkSearchMultiple','slds-fade-in-');
        helper.toggleClass(component,'squawkSearch','slds-fade-in-');
        
        var idx = event.target.getAttribute('data-index');
        var squawk = component.get("v.squawks")[idx];
        
        component.set("v.openBigModal", false);
        component.set("v.openModal", true);              
        component.set("v.squawk", squawk.Id);           
        component.set("v.squawkName", squawk.Name);                
        component.set("v.AddWorkStatus", squawk.Add_Work_Status__c);
        component.set("v.EstTotal", squawk.AddWork_Estimated_Total__c);
        component.set("v.RTS", squawk.RTS__c);
        component.set("v.jcdesc", squawk.Job_Card_Description__c);
        component.set("v.labAmount", squawk.Labor_Amount__c);
        component.set("v.matAmount", squawk.Material_Amount__c);
        component.set("v.labType", squawk.Add_Work_Labor_Type__c);
        component.set("v.matType", squawk.Material_Type__c);
        
        if(squawk.Designated_Approver__c != null){
            component.set("v.dApprover", squawk.Designated_Approver__r.Name);           
            component.set("v.dApproverId", squawk.Designated_Approver__c);
        }
        
        if(squawk.Project__c != null){
            component.set("v.Project", squawk.Project__r.Name);
            component.set("v.ProjectId", squawk.Project__c);                                
        }
        
        if(squawk.SBQQ__Quote__c != null){
            component.set("v.quote", squawk.SBQQ__Quote__r.Name);
            component.set("v.quoteId", squawk.SBQQ__Quote__c);
        }
        component.set("v.Spinner", false); 
    },
    
    hideNotPendingModal: function(component, event, helper){
        var status = event.target.id;
        console.log(status);
        
        if(status == 'Approved'){
            helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
            helper.toggleClassInverse(component,'approvedModal','slds-fade-in-');
        }
    },
    
    handleCloseModal: function(component, event, helper) {
        helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
        helper.toggleClassInverse(component,'squawkSearch','slds-fade-in-');
        helper.toggleClassInverse(component,'squawkSearchMultiple','slds-fade-in-');
        document.body.style.overflow = "auto";
        component.set("v.searchId", null);
        component.set('v.searchKeyword', '');
        component.set("v.squawks", null);
    },
    
    handleCloseSquawksModal: function(component, event, helper) {
        var getAllId = component.find("projPack");
        console.log(getAllId.length);
        
        if(getAllId.length > 0){
            for(var i = 0; i < getAllId.length; i++){
                getAllId[i].set("v.value", false);
            } 
        }else{
            getAllId.set("v.value", false);	    
        }
        component.set("v.squawks", null);
        component.set("v.selectedCount", "0");
        component.set("v.selectAll", false);
        component.set("v.returnSize", "height: 100%");
        document.body.style.overflow = "auto";
        helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
        helper.toggleClassInverse(component,'squawkModal','slds-fade-in-');
    },
    
    goBack: function(component, event, helper) {
        var sc = component.get("v.searchCount");
        
        if(sc > 1){
            helper.toggleClass(component,'squawkSearchMultiple','slds-fade-in-');
            helper.toggleClassInverse(component,'squawkSearch','slds-fade-in-');
        }else{
            helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
            helper.toggleClassInverse(component,'squawkSearch','slds-fade-in-');
            helper.toggleClassInverse(component,'squawkSearchMultiple','slds-fade-in-');
            document.body.style.overflow = "auto";
            component.set("v.searchId", null);
            component.set('v.searchKeyword', '');
            component.set("v.squawks", null);      
        }
    },
    
    checkboxSelect: function(component, event, helper) {
        
        var selectedRec = event.getSource().get("v.value");
        
        var getSelectedNumber = component.get("v.selectedCount");
        
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
        }
        
        component.set("v.selectedCount", getSelectedNumber);
    },
    
    selectAll: function(component, event, helper) {
        
        var selectedHeaderCheck = event.getSource().get("v.value");        
        var getAllId = component.find("boxPack");
        
        if (!Array.isArray(getAllId)){
            if (selectedHeaderCheck == true) {
                component.find("boxPack").set("v.value", true);
                component.set("v.selectedCount", '1');
            }else if(selectedHeaderCheck == false) {
                component.find("boxPack").set("v.value", false);
                component.set("v.selectedCount", '0');            	
            }
        }
        
        if(getAllId != null){
            if (selectedHeaderCheck == true) { 
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("boxPack")[i].set("v.value", true);
                    component.set("v.selectedCount", getAllId.length);
                } 
            }else if (selectedHeaderCheck == false){
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("boxPack")[i].set("v.value", false);
                    component.set("v.selectedCount", 0);   				  		
                }
            }
        }
    },
    
    approveSelected: function(component, event, helper) {
        component.set("v.Spinner", true); 
        var appId = [];
        var getAllId = component.find("boxPack");
        
        if (!Array.isArray(getAllId)){
            appId.push(component.find("boxPack").get("v.text"));
        }else{  
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    appId.push(getAllId[i].get("v.text"));
                }
            } 
        }
        helper.approveSelectedHelper(component, event, appId);
        component.set("v.Spinner", false); 
    },
    
    rejectSelected: function(component, event, helper) {
        
        component.set("v.Spinner", true); 
        var rejId = []; 
        var getAllId = component.find("boxPack");       
        
        if (!Array.isArray(getAllId)){
            rejId.push(component.find("boxPack").get("v.text"));
        }else{
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    rejId.push(getAllId[i].get("v.text"));
                }
            } 
        }  
        helper.rejectSelectedHelper(component, event, rejId);
        component.set("v.Spinner", false); 
    },
    
    rtsInRejectedSelection: function(component, event, helper) {
        //alert('hello rts reject');
        if(component.get("v.selectedCount") != 0){
            var rejId = []; 
            var getAllId = component.find("boxPack"); 
            
            if (!Array.isArray(getAllId)){
                rejId.push(component.find("boxPack").get("v.text"));
            }else{
                for (var i = 0; i < getAllId.length; i++) {
                    if (getAllId[i].get("v.value") == true) {
                        rejId.push(getAllId[i].get("v.text"));
                    }
                } 
            }  
            helper.rejectRtsHelper(component, event, rejId);
        }else{
            helper.toggleClassInverse(component,'squawkModal','slds-fade-in-');
            helper.toggleClass(component,'noneSelectedModal','slds-fade-in-');
        }
    },
    
    updateCheckboxes : function(component, event) {
        var id = event.source.get("v.text");
        if (event.source.get("v.value")) {    	
            if (component.get("v.checkedSquawks").indexOf(id) < 0) {
                component.get("v.checkedSquawks").push(id);
                console.log(id);
            }
        } 
        else {
            var index = component.get("v.checkedSquawks").indexOf(id);
            if (index > -1) {
                component.get("v.checkedSquawks").splice(index, 1);
                console.log(id);
            }
        }
    },
    
    showApprovalmodal: function(component, event, helper) {
        
        if(component.get("v.selectedCount") != 0){
            helper.toggleClassInverse(component,'squawkModal','slds-fade-in-');
            helper.toggleClass(component,'approveModal','slds-fade-in-');
        }else{
            helper.toggleClassInverse(component,'squawkModal','slds-fade-in-');
            helper.toggleClass(component,'noneSelectedModal','slds-fade-in-');
        }
    },
    
    showRejectmodal: function(component, event, helper) {
        if(component.get("v.selectedCount") != 0){
            helper.toggleClassInverse(component,'squawkModal','slds-fade-in-');
            helper.toggleClass(component,'RtsSelectedModal','slds-fade-in-');
        }else{
            helper.toggleClassInverse(component,'squawkModal','slds-fade-in-');
            helper.toggleClass(component,'noneSelectedModal','slds-fade-in-');
        }
    },
    
    showDefermodal: function(component, event, helper) {
        if(component.get("v.selectedCount") != 0){
            helper.toggleClassInverse(component,'squawkModal','slds-fade-in-');
            helper.toggleClass(component,'deferModal','slds-fade-in-');
        }else{
            helper.toggleClassInverse(component,'squawkModal','slds-fade-in-');
            helper.toggleClass(component,'noneSelectedModal','slds-fade-in-');
        }
    },
    
    showRejectRtsModal: function(component, event, helper) {
        helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
        helper.toggleClassInverse(component,'RtsSelectedModal','slds-fade-in-');
        helper.toggleClass(component,'backdrop','slds-backdrop--');
        helper.toggleClass(component,'rejectModal','slds-fade-in-');
    },
    
    showProjectmodal: function(component, event, helper) {     
        helper.toggleClass(component,'backdrop','slds-backdrop--');
        helper.toggleClass(component,'projectModal','slds-fade-in-');
        
        var src = event.getSource();
        var projId = src.get("v.value");
        console.log(projId);
    },
    
    hideApproveModal : function(component, event, helper) {
        helper.toggleClass(component,'squawkModal','slds-fade-in-');
        helper.toggleClassInverse(component,'approveModal','slds-fade-in-');
    },
    
    hideRejectModal : function(component, event, helper) {
        helper.toggleClass(component,'squawkModal','slds-fade-in-');
        helper.toggleClassInverse(component,'rejectModal','slds-fade-in-');
    },
    
    hideDeferModal : function(component, event, helper) {
        helper.toggleClass(component,'squawkModal','slds-fade-in-');
        helper.toggleClassInverse(component,'deferModal','slds-fade-in-');
    },
    
    hideRtsSelectedModal : function(component, event, helper) {
        helper.toggleClass(component,'squawkModal','slds-fade-in-');
        helper.toggleClassInverse(component,'RtsSelectedModal','slds-fade-in-');
    },
    
    hideProjectModal : function(component, event, helper) {
        helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
        helper.toggleClassInverse(component,'projectModal','slds-fade-in-');
    },
    
    hideNoneSelectedModal : function(component, event, helper) {
        helper.toggleClass(component,'squawkModal','slds-fade-in-');
        helper.toggleClassInverse(component,'noneSelectedModal','slds-fade-in-');
    },
    
    deferSelected : function(component, event, helper) {
        
        component.set("v.Spinner", true); 
        var deferId = []; 
        var getAllId = component.find("boxPack");       
        if (!Array.isArray(getAllId)){
            deferId.push(component.find("boxPack").get("v.text"));
        }else{
            for (var i = 0; i < getAllId.length; i++) {
                if (getAllId[i].get("v.value") == true) {
                    deferId.push(getAllId[i].get("v.text"));
                }
            } 
        }  
        helper.deferSelectedHelper(component, event, deferId);
        component.set("v.Spinner", false);        
    },
    
    squawkNav : function(component, event, helper) {
        var squawkId = event.getSource().get("v.name");
        console.log('Squawk Id: ' + squawkId);
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": squawkId
        });
        navEvt.fire();
    }
 
})