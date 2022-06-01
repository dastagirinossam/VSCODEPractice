({   
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
        
		var projId = component.get("v.projRecordsId");
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
  		
        action.setParams({
   			"lstRecordId": approveRecordsIds,
            "projMax": projMaxLimit
  		});
  		action.setCallback(this, function(response) {
   			//store state of response
   			var state = response.getState();
   			if (state === "SUCCESS") {
    			console.log(state);
    			if (response.getReturnValue() != '') {
     				// if getting any error while delete the records , then display a alert msg/
     				alert(response.getReturnValue());
    			} else {
     				console.log('check it--> update successful');
    			}
            }else{
                console.log('fail');
            }
  		});
  		$A.enqueueAction(action);
        
        this.onLoad(component, event);
        this.toggleClassInverse(component,'backdrop','slds-backdrop--');
		this.toggleClassInverse(component,'approveModal','slds-fade-in-');
        
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
     				alert( response.getReturnValue());
    			} else {
     				console.log('check it--> update successful');
                } 			
   			}
  		});
  		$A.enqueueAction(action);
         
        this.onLoad(component, event);
        this.toggleClassInverse(component,'backdrop','slds-backdrop--');
		this.toggleClassInverse(component,'rejectModal','slds-fade-in-');
         
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
  		var projId = component.get("v.projRecordsId");
  		var action = component.get('c.getProjectRecords');      
  		action.setParams({"lstRecordId": projId});
  		action.setCallback(this, function(s) {
            var rv = s;
            	if(s.getReturnValue().length == 0){
                	component.destroy();
                    $A.get('e.force:refreshView').fire();
                }
  				component.set("v.squawks", s.getReturnValue());            
    			component.set("v.selectedCount", 0);
    			component.find("box3").set("v.value", false);
        });
  		$A.enqueueAction(action);
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
                    component.set("v.Message", true);
                } else {
                    component.set("v.Message", false);
                }
                // set numberOfRecord attribute value with length of return value from server
                component.set("v.numberOfRecord", storeResponse.length);
                // set searchResult list with return value from server.
                component.set("v.squawks", storeResponse);
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