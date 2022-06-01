({
	getMyProjects: function(component) {
        var action = component.get("c.getProjects"); // name on the apex class
        action.setCallback(this, function(p) {
            component.set("v.projects", p.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    projectSelectedHelper: function(component, event, projRecordsIds) {
  		//call apex class method
  		console.log(projRecordsIds);
  		var action = component.get('c.getProjectRecords');
  		// pass the all selected record's Id's to apex method 
  		action.setParams({
   			"lstRecordId": projRecordsIds
  		});
  		action.setCallback(this, function(s) {
            component.set("v.squawks", s.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    sortHelper: function(component, event, sortFieldName) {
    	var currentDir = component.get("v.arrowDirection");
 
      	if (currentDir == 'arrowdown') {
         	// set the arrowDirection attribute for conditionally rendred arrow sign  
         	component.set("v.arrowDirection", 'arrowup');
         	// set the isAsc flag to true for sort in Assending order.  
         	component.set("v.isAsc", true);
      	} else {
         	component.set("v.arrowDirection", 'arrowdown');
         	component.set("v.isAsc", false);
      	}
        this.reSortColumn(component, event, sortFieldName);
      
    },
     
   	reSortColumn: function(component, event, sortField) {
        
        var getAllId = component.find('projPack');
		var projId = null;
	
		for(i = 0; i < getAllId.length; i++){
			if(getAllId[i].get("v.value") == true){
				projId = getAllId[i].get("v.text");
                console.log(projId);
			}
		}	

      	var action = component.get('c.fetchSqk');
 
      	// pass the apex method parameters to action 
      	action.setParams({
            'lstRecordId': projId,
         	'sortField': sortField,
         	'isAsc': component.get("v.isAsc")
      	});
        
      	action.setCallback(this, function(s) {
         	var state = s.getState();
         	if (state === "SUCCESS") {
            	component.set('v.squawks', s.getReturnValue());
            }else{
                console.log('Failed');
            }
            console.log(state);
      	});
      	$A.enqueueAction(action);
   	},
     
    approveSelectedHelper: function(component, event, approveRecordsIds) {
  		//call apex class method
  		var action = component.get('c.approveRecords');
  		// pass the all selected record's Id's to apex method 
  		action.setParams({
   			"lstRecordId": approveRecordsIds
  		});
  		action.setCallback(this, function(response) {
   			//store state of response
   			var state = response.getState();
   			if (state === "SUCCESS") {
    			console.log(state);
    			if (response.getReturnValue() != '') {
     				// if getting any error while delete the records , then display a alert msg/
     				alert('The following error has occurred. while Updating record-->' + response.getReturnValue());
    			} else {
     				console.log('check it--> update successful');
    			}
   			}
  		});
  		$A.enqueueAction(action);
        
        this.onLoad(component, event);
        this.toggleClassInverse(component,'approveModal','slds-fade-in-'); 
        this.toggleClassInverse(component,'backdrop','slds-backdrop--'); 
     },
    
     rejectSelectedHelper: function(component, event, rejectRecordsIds) {
  		//call apex class method
  		var action = component.get('c.rejectRecords');
  		// pass the all selected record's Id's to apex method 
  		action.setParams({
   			"lstRecordId": rejectRecordsIds
  		});
  		action.setCallback(this, function(response) {
   			//store state of response
   			var state = response.getState();
   			if (state === "SUCCESS") {
    			console.log(state);
    			if (response.getReturnValue() != '') {
     				// if getting any error while delete the records , then display a alert msg/
     				alert('The following error has occurred. while Updating record-->' + response.getReturnValue());
    			} else {
     				console.log('check it--> update successful');
                } 			
   			}
  		});
  		$A.enqueueAction(action);
         
        this.onLoad(component, event);
     },
    
     rejectRtsHelper: function(component, event, rejectRecordsIds) {

  		var action = component.get('c.getRtsRecords');

  		action.setParams({
   			"lstRecordId": rejectRecordsIds
  		});
  		action.setCallback(this, function(response) {
   			//store state of response
   			var state = response.getState();
   			if (state === "SUCCESS") {
    			console.log(state);
    			if (response.getReturnValue().length > 0) {
					this.toggleClass(component,'backdrop','slds-backdrop--');
					this.toggleClass(component,'RtsSelectedModal','slds-fade-in-');
    			} else {
     				this.toggleClass(component,'backdrop','slds-backdrop--');
					this.toggleClass(component,'rejectModal','slds-fade-in-');
    			}
   			}
  		});
  		$A.enqueueAction(action);
     },
    
    onLoad: function(component, event) {
  		//call apex class method
  		var projId = [];
  		// get all checkboxes 
  		var getAllId = component.find("projPack");

        if (!Array.isArray(getAllId)){ 
        	projId = component.find("projPack").get("v.text");
        }else{        
  			for (var i = 0; i < getAllId.length; i++) {
  				if (getAllId[i].get("v.value") == true) {
    				projId.push(getAllId[i].get("v.text"));
   				}
  			}
        }
      
  		var action = component.get('c.getProjectRecords');      
  		action.setParams({"lstRecordId": projId});
  		action.setCallback(this, function(s) {
            var rv = s;
  			component.set("v.squawks", s.getReturnValue());
            
            console.log(rv);
            
    		component.set("v.selectedCount", 0);
    		component.find("box3").set("v.value", false);
  		});
  		$A.enqueueAction(action);
        
        this.toggleClassInverse(component,'rejectModal','slds-fade-in-'); 
        this.toggleClassInverse(component,'backdrop','slds-backdrop--');     
	},
    
    SearchHelper: function(component, event) {
        var action = component.get("c.findSquawks");
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is 0 ,display no record found message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.SquawkMessage", true);
                } else {
                    component.set("v.SquawkMessage", false);
                }
                // set numberOfRecord attribute value with length of return value from server
                //component.set("v.numberOfRecord", storeResponse.length);
                // set searchResult list with return value from server.
                //component.set("v.squawks", storeResponse);
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
		$A.util.addClass(modal,className+'hide');
		$A.util.removeClass(modal,className+'open');
	}
    
})