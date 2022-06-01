({
	helperMethod : function(component, event, helper) {
	   
        var myAction = component.get("c.quotaPerformanceYearly");
         var yr = component.get('v.selectedYear');
      //  alert('yr>>'+yr)
        myAction.setParams({
            year :yr
        });
        
        myAction.setCallback(this, function(response) { 
            if(response.getState() === "SUCCESS")  
                var wrap = response.getReturnValue();
            
          // alert(wrap[0].PerformanceMarginTPEAll);
           component.set("v.searchResult2",wrap);                      
        }); 
        
        $A.enqueueAction(myAction); 	
	}
})