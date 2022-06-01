({
	doInit : function(component, event, helper) {
        
        var action = component.get('c.createMasterQuote');
        
        var resultsToast = $A.get("e.force:showToast");

        action.setParams({
            "oppId" : component.get('v.recordId')
        });
        
        action.setCallback(this, function(a){
            
            var state = a.getState(); // get the response state

            if(state == 'SUCCESS') {
                 var responseVal = a.getReturnValue();
                var quoteId = responseVal.Id;
               
                resultsToast.setParams({
                    mode: 'sticky',
                    type : 'success',
                    title: 'Proposal Successful',
                    message: 'This is a required message',
                    messageTemplate: 'Successfully created a proposal',
                   
                });

                resultsToast.fire();
                var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": 'https://standardaero.lightning.force.com/' + quoteId
    });
    urlEvent.fire();
                $A.get('e.force:closeQuickAction').fire();
                
            }else if (state === "ERROR"){
                alert(state);
              
                var errors = JSON.parse(JSON.stringify(a.getError()));
                var mesge = JSON.parse(errors[0].message);
           
                var errorMessage = mesge.errorMsg;
                var newErrorMessage = errorMessage.replaceAll('/n','\n');

                resultsToast.setParams({
                    mode: 'sticky',
                    type : 'error',
                    title : mesge.errorMsgTitle,
                    message: mesge.errorMessage,
                    messageTemplate: newErrorMessage + '{1}',
                           
                });
                
                resultsToast.fire();
                 
                $A.get('e.force:closeQuickAction').fire();
                
            }
        });
        $A.enqueueAction(action);
    }

})