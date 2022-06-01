({
    doInit : function(component, event, helper) {
        var rId = component.get("v.recordId");
        console.log("In Init");
        
		var action = component.get("c.getAttachments");
        action.setParams({
            conId : rId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if(state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log("result of Attach display component");
                console.log(result);
                component.set("v.fileIds", result);
            }
        });
        
        $A.enqueueAction(action);
	},
    
    closeModal : function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    openModal : function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    
    onChan : function(component, event, helper) {
        var change = event.getSource().get("v.value");
        var val = event.getSource().get("v.checked");

        var selected = component.get("v.box");
        if(val === true){
        	selected.push(change); 
        }else{
            selected.pop(change);
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
              
    handleUpload : function(component, event, helper) {
        var init = component.get("c.doInit");
        $A.enqueueAction(init);
    }
})