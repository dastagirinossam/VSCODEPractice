({
    doInit : function(component, event, helper) {
        var action = component.get("c.getQuoteLine");
         action.setParams({
            quoteId: component.get("v.recordId")       
        });      
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if(state === "SUCCESS") {
                var WorkStatus = response.getReturnValue();                
                if(WorkStatus.lineRec.Add_Work_Status__c == "Pending"){
                    alert("Quote Line Must Be Approved or Denied Before Resubmitting");
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                }else{
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": '/apex/ChangeAndResubmitQuoteLine?scontrolCaching=1&id='+component.get("v.recordId")
                        
                    });
                    urlEvent.fire();  
                }
            }
        });
        $A.enqueueAction(action);
        
    }                                                  
})