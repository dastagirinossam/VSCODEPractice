({
    DoInit : function(component, event, helper) {
        
        var action = component.get("c.equipMethod1");
        
        action.setCallback(this,function(response){

            var state = response.getState();          
            if(state == "SUCCESS"){                
                component.set('v.EnginesAvilable',true);
                component.set('v.WarpList', response.getReturnValue()); 
            }
        });
        $A.enqueueAction(action);
        
    },
    
    //All
    handleClick1 : function(component, event, helper) {
        var action = component.get("c.equipMethod1");
        
        action.setCallback(this,function(response){

            var state = response.getState();
            if(state == "SUCCESS"){
                
                component.set('v.EnginesAvilable', true);
                component.set('v.EnginesAvilable1', false);
                component.set('v.EnginesAvilable2', false);
                component.set('v.EnginesAvilable3', false);
                component.set('v.WarpList', response.getReturnValue()); 
                console.log('Engines: ' + JSON.stringify(response.getReturnValue())); 
            }
        });
        
        $A.enqueueAction(action);
        //$A.get('e.force:refreshView').fire();   
    },
    
    //APU
    handleClick2 : function(component, event, helper) {
        var action = component.get("c.equipMethod2");
        
        action.setCallback(this,function(response){

            var state = response.getState();
            if(state == "SUCCESS"){
                
                component.set('v.EnginesAvilable', false);
                component.set('v.EnginesAvilable1', true);
                component.set('v.EnginesAvilable2', false);
                component.set('v.EnginesAvilable3', false);
                component.set('v.WarpList',response.getReturnValue()); 
                console.log('APUs: ' + JSON.stringify(response.getReturnValue())); 
            }
        });
        
        $A.enqueueAction(action);
        //$A.get('e.force:refreshView').fire();        
    },
        
    //HON
    handleClick3 : function(component, event, helper) {
        var action = component.get("c.equipMethod");
        
        action.setCallback(this,function(response){

            var state = response.getState();
            if(state == "SUCCESS"){
                
                component.set('v.EnginesAvilable', false);
                component.set('v.EnginesAvilable1', false);
                component.set('v.EnginesAvilable2', true);
                component.set('v.EnginesAvilable3', false);
                component.set('v.WarpList',response.getReturnValue()); 
                console.log('HON: ' + JSON.stringify(response.getReturnValue())); 
            }
        });
        
        $A.enqueueAction(action);       
    },
    
    //Pratt
    handleClick4 : function(component, event, helper) {
        var action = component.get("c.equipMethod3");
        
        action.setCallback(this,function(response){

            var state = response.getState();
            if(state == "SUCCESS"){
                
                component.set('v.EnginesAvilable', false);
                component.set('v.EnginesAvilable1', false);
                component.set('v.EnginesAvilable2', false);
                component.set('v.EnginesAvilable3', true);
                component.set('v.WarpList',response.getReturnValue()); 
                console.log('PWs: ' + JSON.stringify(response.getReturnValue())); 
            }
        });
        
        $A.enqueueAction(action);    
    },
    
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
    
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    }
})