({
    doInit : function (component) {
        var recordId = component.get("v.recordId");
        var inputVariables = [
            {
                name : "varOpportunityId",
                type : "String",
                value : recordId            
            }
        ];
        console.log('Record Id: ' + recordId);
        var flow = component.find("flowData");
        flow.startFlow("Create_Master_Opportunity", inputVariables);
    }
})