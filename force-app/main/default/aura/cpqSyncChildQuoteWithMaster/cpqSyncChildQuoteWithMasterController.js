({
	doInit : function(component, event, helper) {
        
        var action = component.get('c.getSyncToMasterQuoteAndOpportunity');
        
        var resultsToast = $A.get("e.force:showToast");

        action.setParams({
            "sbQuoteId" : component.get('v.recordId')
        });
        
        action.setCallback(this, function(a){
            
            var state = a.getState(); // get the response state

            if(state == 'SUCCESS') {
                 var responseVal = a.getReturnValue();

                resultsToast.setParams({
                    mode: 'sticky',
                    type : 'success',
                    title: 'Quote Synce Successful',
                    message: 'This is a required message',
                    messageTemplate: 'Successfully synced to master quote {1}',
                    messageTemplateData: ['Salesforce', {
                        url: 'https://standardaero.lightning.force.com/lightning/r/SBQQ__Quote__c/' + responseVal.Id + '/view',
                        label: responseVal.Name,
                    }]
                });

                resultsToast.fire();
                $A.get('e.force:closeQuickAction').fire();
                
            }else if (state === "ERROR"){
                
                var errors = JSON.parse(JSON.stringify(a.getError()));
                var mesge = JSON.parse(errors[0].message);
                
                var errorMessage = mesge.errorMsg;
                var newErrorMessage = errorMessage.replaceAll('/n','\n');

                resultsToast.setParams({
                    mode: 'sticky',
                    type : 'error',
                    title : mesge.errorMsgTitle,
                    message: 'This is a required message',
                    messageTemplate: newErrorMessage + '{1}',
                    messageTemplateData: ['Salesforce', {
                        url: 'https://standardaero.lightning.force.com/lightning/r/SBQQ__Quote__c/' + mesge.errorMsgId + '/view',
                        label: mesge.errorMsgIdName,
                    }]         
                });
                
                resultsToast.fire();
                $A.get('e.force:closeQuickAction').fire();
                
            }
        });
        $A.enqueueAction(action);
    }

})