({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action= component.get("c.recallSquawk");
        action.setParams({
            squawkId : recordId
        });
        action.setCallback(this,function(response){
            var state= response.getState();            
            if(state === "SUCCESS"){
                var msg = response.getReturnValue();   
                if(msg == 'Record Recalled Successfully'){
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                }
                else{
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                }
            }             
        });
        $A.enqueueAction(action);
    }
})