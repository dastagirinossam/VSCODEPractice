({
    init : function (component,event) {   
        var flow = component.find("flowData");
        var inputVariables = [
            {
                name : "varQuoteId",
                type : "String",
                value : component.get("v.recordId")
            }
        ];
        flow.startFlow("Submit_All_QuoteLines",inputVariables);        
    },
    statusChange : function (cmp, event) { 
        if (event.getParam('status') === "FINISHED") { 
            $A.get("e.force:closeQuickAction").fire();
            $A.get('e.force:refreshView').fire();
        }
    }
})