({
	doInit : function(component, event, helper) {
     
		var myAction = component.get("c.QPerformanceRecord");
        myAction.setParams({
            perId : component.get("v.perf2ID")
          
        }); 
        myAction.setCallback(this, function(response) { 
      if(response.getState() === "SUCCESS")  
          var wrap = response.getReturnValue();
        
        console.log(wrap);
        component.set("v.searchResult",wrap.perf2); 
     
        
      }); 
    
    $A.enqueueAction(myAction); 
        
	}
})