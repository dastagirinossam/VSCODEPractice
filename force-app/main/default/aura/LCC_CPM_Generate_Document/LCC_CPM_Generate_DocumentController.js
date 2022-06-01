({
    doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
       
        var action= component.get("c.updateQuote");
        action.setParams({
            QuoteId : component.get("v.recordId"),
             TempName : 'Squawks Template'
        }); 
        action.setCallback(this,function(response){
            var state= response.getState();
            $A.log(response);
            if(state == "SUCCESS"){
              
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/apex/SBQQ__GenerateDocument?scontrolCaching=1&id='+component.get("v.recordId")
                    
                });
                urlEvent.fire();
            } 
            
        });
        $A.enqueueAction(action);
    }
})