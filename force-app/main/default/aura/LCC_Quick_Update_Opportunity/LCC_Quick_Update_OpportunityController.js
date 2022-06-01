({
    
    doInit : function(component, event, helper) {
        event.stopPropagation(); 
        var recordId = component.get("v.recordId");
        var flow = component.find("flow");
        var inputVariables = [{
                name : 'OpportunityID',
                type : 'String',
                value : recordId
            }];
        flow.startFlow("Quick_Update_Opportunity", inputVariables);
    } ,
    
    statusChange : function (component, event) {
        var loc = event.getParam("token"); 
        $A.get('e.force:refreshView').fire(); 
        
        if (event.getParam('status') === "FINISHED") {         
            $A.get("e.force:closeQuickAction").fire();   
        }   
    }
   
})