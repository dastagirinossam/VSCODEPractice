({     
    onInit : function( component, event, helper ) { 
        
        var showToast = $A.get( "e.force:showToast" );
        var action = component.get( "c.tsmContractSummaryInit" );
        action.setParams({  
            oppId: component.get( "v.recordId" )
        }); 
        
        action.setCallback(this, function(response) {  
            let state = response.getState();  
            if ( state === "SUCCESS" ) {  
                
                showToast.setParams({
                    title : 'Contract Summary Created',
                    message : 'Contract Summary File created and added to this Opportunity' ,
                    type : 'success',
                    duration: 5000,
                    mode : 'sticky'
                });
                
                showToast.fire();
                $A.get("e.force:closeQuickAction").fire();  
                $A.get('e.force:refreshView').fire();   
                
            }  else {
                 
                var errorMessage = 'Contract Summary Report Not Created.';
                
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message){
                        errorMessage = errors[0].message; 
                        console.log('Error: ' + errors[0].message);
                    }
                }
                
                showToast.setParams({
                    title : 'Contract Summary Error',
                    message : errorMessage ,
                    type : 'error',
                    duration: 5000,
                    mode : 'sticky'
                });
                
                showToast.fire();
                $A.get('e.force:closeQuickAction').fire();
                
            }
        });  
        $A.enqueueAction( action );         
        
    }
    
})