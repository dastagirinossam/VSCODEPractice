({ 
    doInit : function(component, event, helper) { 
        var myAction = component.get("c.QPerformance"); 
        
        myAction.setCallback(this, function(response) { 
            if(response.getState() === "SUCCESS")  
                var wrap = response.getReturnValue();
            
            console.log(wrap);
            component.set("v.searchResult",wrap.perf);                      
        }); 
        
        $A.enqueueAction(myAction);
        helper.helperMethod(component, event, helper); 
    },
    
    navigateToper : function(component, event, helper) {     
        var rectarget = event.currentTarget;
        var idstr = rectarget.getAttribute("data-conId"); 
        
        component.set("v.perfID",idstr);  
        component.set("v.recordlistview",false);
    },
     
    navigateToper2 : function(component, event, helper) {     
        var rectarget = event.currentTarget;
        var idstr = rectarget.getAttribute("data-conId"); 
        
        component.set("v.perfID",idstr);  
        component.set("v.recordlistview2",false);
    },
    
    
    navigateToemp : function(component, event, helper) {     
        var rectarget = event.currentTarget;
        var idstr = rectarget.getAttribute("data-conId"); 
        
        var newEvent = $A.get("e.force:navigateToComponent");
        newEvent.setParams({
            componentDef: "c:QuotaSalesEmployee",
            componentAttributes: {
                //Set you attributes here if required.
                employeID : idstr
            }
        });
        newEvent.fire();
    },
    
    selectYear :function(component, event, helper) {
        var sel = component.find("mySelect");
        component.set("v.selectedYear", sel.get("v.value"));
        
        var action = component.get("c.QPerformance1");
        
        var yr = component.get('v.selectedYear');
     
        action.setParams({
            year :yr
        });
        
        action.setCallback(this, function(response) {
            
            if(response.getState() === "SUCCESS")  
                var wrap = response.getReturnValue();
            
            console.log(wrap);
            component.set("v.searchResult", null);
            console.log(component.get("v.recordlistview"));
            component.set("v.recordlistview", true);
             component.set("v.recordlistview2", true);
            component.set("v.searchResult",wrap.perf); 
           // alert('perfoemance-->'+JSON.stringify(wrap.perf));
        }); 
        
        $A.enqueueAction(action);  
        helper.helperMethod(component, event, helper); 
    }
    
    /*getPerformance :function(component, event, helper) {
        
        var action = component.get("c.QPerformance1");
        alert(component.get('v.selectedYear'));
        var yr = component.get('v.selectedYear');
        action.setParams({
            year :yr
            });
        
        action.setCallback(this, function(response) {
            alert('response' +response);
            alert('response return'+response.getReturnValue());
      if(response.getState() === "SUCCESS")  
          var wrap = response.getReturnValue();
        alert('hell1'+wrap);
        console.log(wrap);
        component.set("v.searchResult",wrap.perf); 
     }); 
    
    $A.enqueueAction(action);
        
    }
    */
})