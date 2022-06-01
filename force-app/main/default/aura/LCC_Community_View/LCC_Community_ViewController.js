({
    doInit : function(component, event, helper) {
        var action = component.get("c.getCommunityUrl");
        action.setCallback(this,function(response){
            var CommunityUrl = response.getReturnValue();
      	     window.open(CommunityUrl, '_blank');
             $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    }
})