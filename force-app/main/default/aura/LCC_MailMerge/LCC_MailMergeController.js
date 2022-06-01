({
    doInit : function(component, event, helper) {
        let recordId = component.get('v.recordId');
        var urlEvent = $A.get("e.force:navigateToURL");
        var action = component.get("c.sfdcURL");
        action.setParams({
            recId : component.get('v.recordId'),
            objectName :component.get('v.sobjecttype')
        });
        action.setCallback(this, function(response){
            var URLSFDC = response.getReturnValue();
            var urlInstance = URLSFDC[0]+'/mail/mmchoose.jsp?id='+ recordId+'&retURL=';
            var sobjectType =component.get('v.sobjecttype');
            if(response.getState() == "SUCCESS"){
                urlEvent.setParams({
                    "url" : urlInstance+'/lightning/r/'+sobjectType +'/'+recordId +'/view'
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})