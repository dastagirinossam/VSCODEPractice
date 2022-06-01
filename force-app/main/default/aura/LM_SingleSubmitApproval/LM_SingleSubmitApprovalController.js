({
    init : function (component,event) {       
        var flow = component.find("flowData");
        var inputVariables = [
            {
                name : "varQuoteLine",
                type : "String",
                value : component.get("v.recordId")
            }            
        ];
        flow.startFlow("Submit_All_QuoteLines",inputVariables);        
    },
    statusChange : function (cmp, event) {  
        if (event.getParam('status') === "FINISHED_SCREEN") {              
            $A.get("e.force:closeQuickAction").fire();
            // $A.get('e.force:refreshView').fire();
            //finishLocation="{!URLFOR($Page.Squawk, null, [Id=SBQQ__QuoteLine__c.Id])}"
            //SubmitSingleQuoteLineForApproval
            //
            
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/apex/Squawk?id=" + cmp.get("v.recordId") 
            });
            urlEvent.fire();
        }
        
        else if (event.getParam('status') === "FINISHED") {              
            
            $A.get("e.force:closeQuickAction").fire();
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/apex/Squawk?id=" + cmp.get("v.recordId") 
            });
            urlEvent.fire();
        }
    }   
})