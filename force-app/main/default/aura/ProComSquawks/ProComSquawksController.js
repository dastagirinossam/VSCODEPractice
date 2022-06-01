({
   
    doInit: function(component, event, projRecordsIds) {
  		//call apex class method
  		var proj = component.get("v.projRecordsId");
        
        console.log('Project Id: ' + proj);
        
  		var action = component.get('c.getProjectRecords');
  		// pass the all selected record's Id's to apex method 
  		action.setParams({"lstRecordId": proj});
  		action.setCallback(this, function(s) {
            component.set("v.squawks", s.getReturnValue());
            if(s.getReturnValue().length > 4){
                component.set("v.returnSize", "height: 450px;");                
            } else{
            	component.set("v.returnSize", "height: auto;");
            }
        });
        $A.enqueueAction(action);
    },
    
    sortJobCard: function(component, event, helper) {
        component.find("box3").set("v.value", false);
        component.set("v.selectedCount", 0);
       	helper.sortHelper(component, event, 'Job_Card__c');
    },

    sortName: function(component, event, helper) {
        component.find("box3").set("v.value", false);
        component.set("v.selectedCount", 0);
       	helper.sortHelper(component, event, 'Name');
    },
        
    sortDescription: function(component, event, helper) {
        component.find("box3").set("v.value", false);
        component.set("v.selectedCount", 0);
       	helper.sortHelper(component, event, 'Job_Card_Description__c');
    },
    
    sortLaborCost: function(component, event, helper) {
       	component.find("box3").set("v.value", false);
        component.set("v.selectedCount", 0);
       	helper.sortHelper(component, event, 'Labor_Amount__c');
    },
    
    sortFirmPriceLabor: function(component, event, helper) {
        component.find("box3").set("v.value", false);
        component.set("v.selectedCount", 0);
       	helper.sortHelper(component, event, 'IsFirmPriceLabour__c');
    },
    
    sortMaterialCost: function(component, event, helper) {
    	component.find("box3").set("v.value", false);
        component.set("v.selectedCount", 0);
       	helper.sortHelper(component, event, 'Material_Amount__c');
    },
    
    sortFirmPriceMaterial: function(component, event, helper) {
		component.find("box3").set("v.value", false);
       	component.set("v.selectedCount", 0); 
       	helper.sortHelper(component, event, 'IsFirmPriceMaterial__c');
    },
    
    sortRTS: function(component, event, helper) {
       	component.find("box3").set("v.value", false);
       	component.set("v.selectedCount", 0);
       	helper.sortHelper(component, event, 'IsRTS__c');
    },
    
	getSquawks : function(component, event, helper) {

  		var getAllId = component.find("projPack");
        var projValue = event.getSource().get("v.value");
    
        if(projValue == true){
        	var projId = event.getSource().get("v.text");     
        }
        
        component.find("box3").set("v.value", false);
        component.set("v.selectedCount", 0);
        component.set("v.ErrorMessage", false);
        component.set("v.Message", false);
        component.set("v.searchKeyword", null);
        
        for (var i = 0; i < getAllId.length; i++) {
            if (getAllId[i].get("v.value") == true){
                if (getAllId[i].get("v.text") != projId){
                	getAllId[i].set("v.value", false);
                }            
            }
  		}
                       
  		helper.projectSelectedHelper(component, event, projId);
        
	},
    
    sendNotification: function(component, event, helper) {
        event.preventDefault();
    },
    
    enterSearch: function(component, event, helper) {
    	console.log(event.getParams().keyCode);
      	if(event.getParams().keyCode == 13){
            console.log('Stop');
        	event.event.preventDefault();
      	}
   	},
    
    Search: function(component, event, helper) {
    	var searchKeyFld = component.find("searchId");     
        var srcValue = searchKeyFld.get("v.value");
        if (srcValue == '' || srcValue == null) {

			component.set("v.ErrorMessage", true);
         } else {              	            
         	component.set("v.ErrorMessage", false);
            component.find("box3").set("v.value", false);
            component.set("v.selectedCount", 0); 
             
            var proj = component.find("projPack");          	                                   
            for (var i = 0; i < proj.length; i++) {
            	if (proj[i].get("v.value") == true){
                	proj[i].set("v.value", false);
                }            
            }                         
         	helper.SearchHelper(component, event);
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
 	},
     
 	rejectSelected: function(component, event, helper) {
     
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
 	},
    
    rtsInRejectedSelection: function(component, event, helper) {
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
            helper.toggleClass(component,'backdrop','slds-backdrop--');
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
    
	showSpinner: function(component, event, helper) { 
        component.set("v.Spinner", true); 
    },
     
    hideSpinner : function(component,event,helper){    
       component.set("v.Spinner", false);
    },
    
	showApprovalmodal: function(component, event, helper) {
        
        if(component.get("v.selectedCount") != 0){
			helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'approveModal','slds-fade-in-');
        }else{
            helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'noneSelectedModal','slds-fade-in-');
        }
	},
    
    showRejectmodal: function(component, event, helper) {
         if(component.get("v.selectedCount") != 0){
			helper.toggleClass(component,'backdrop','slds-backdrop--');
			helper.toggleClass(component,'RtsSelectedModal','slds-fade-in-');
        }else{
            helper.toggleClass(component,'backdrop','slds-backdrop--');
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
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'approveModal','slds-fade-in-');
	},
    
    hideRejectModal : function(component, event, helper) {
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'rejectModal','slds-fade-in-');
	},
    
    hideRtsSelectedModal : function(component, event, helper) {
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'RtsSelectedModal','slds-fade-in-');
	},
    
    hideProjectModal : function(component, event, helper) {
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'projectModal','slds-fade-in-');
	},
    
    hideNoneSelectedModal : function(component, event, helper) {
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'noneSelectedModal','slds-fade-in-');
	}
    
})