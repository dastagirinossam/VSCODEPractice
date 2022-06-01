({
	doInit : function(component, event, helper) { 
        var myAction = component.get("c.quotaPerformanceYearly");
        var yr = component.get('v.selectedYear');
        //alert('yr>>'+yr)
        myAction.setParams({
            year :yr
        });
        
        myAction.setCallback(this, function(response) { 
            if(response.getState() === "SUCCESS")  
                var wrap = response.getReturnValue();
            
            //alert(JSON.stringify(wrap));
           component.set("v.searchResult",wrap);                      
        }); 
        
        $A.enqueueAction(myAction); 
    },
    selectYear : function(component, event, helper) { 
        
         var sel = component.find("mySelect");
        component.set("v.selectedYear", sel.get("v.value"));
        
         var myAction = component.get("c.quotaPerformanceYearly");
         var yr = component.get('v.selectedYear');
        myAction.setParams({
            year :yr
        });
        
        myAction.setCallback(this, function(response) { 
            if(response.getState() === "SUCCESS")  
                var wrap = response.getReturnValue();
            
           // alert(JSON.stringify(wrap));
           component.set("v.searchResult",wrap);                      
        }); 
        
        $A.enqueueAction(myAction); 
    }
    
})