({
    doInit : function(component, event, helper) {
        helper.helperMethod1(component, event, helper);
        helper.helperMethod2(component, event, helper);
	},
    
    cancel : function(component, event, helper) {
        var closeActionPanel = $A.get("e.force:closeQuickAction");
        closeActionPanel.fire();        
    },
        
    onChan : function(component, event, helper) {
        var change = event.getSource().get("v.text").Id;
        var val = event.getSource().get("v.value");
        
        //Only Allow 1 Selection
        var cbf = component.find("boxPack");        
        for (var i = 0; i < cbf.length; i++) {   
            if (cbf[i].get("v.value") == true && cbf[i].get("v.text").Id != change) {
                cbf[i].set("v.value", false);
            }   
        } 
                    
        var selected = component.get("v.box");
        if(val === true){
        	selected = change; 
        }else{
            selected = null;
        }
       
        component.set("v.box", selected);  
    },
    
    onOk : function(component, event, helper) {
        var selected = component.get("v.box");
    
        console.log(JSON.stringify(selected));
        var evnt = component.getEvent("selectedAttachmentsNotifyEvent");
        
        evnt.setParams({
            selectedIds : selected
        });
        evnt.fire();
        
        component.set("v.isOpen", false);
        component.set("v.box", []);
    },
    
    selectEUS : function(component, event, helper) {
		var recordId = component.get('v.recordId');        
        var ExpDate = component.find("ExpDate").get("v.value");
        var selected = component.get("v.box");
        
        var action = component.get("c.captureEUS");
        action.setParams({
            recordId : recordId,
            fileId : selected, 
            ExpDate : ExpDate
        });
                      
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var closeActionPanel = $A.get("e.force:closeQuickAction");
                closeActionPanel.fire();   
            }
        });
        
        $A.enqueueAction(action);
    },
              
    handleUpload : function(component, event, helper) {
        var init = component.get("c.doInit");
        $A.enqueueAction(init);
    }
})