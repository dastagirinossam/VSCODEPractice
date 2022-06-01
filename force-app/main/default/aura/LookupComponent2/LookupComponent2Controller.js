({
    onfocus : function(component,event,helper){
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.find("name").get("v.value");
        //alert('getInputkeyWord'+getInputkeyWord);
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", {} );   
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        // get the selected Account record from the COMPONETN event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        // alert('selectedAccountGetFromEvent>>'+selectedAccountGetFromEvent)
        // ;
        component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        
    },
    
    CreateRecord:function(component, event, helper) {
        var recId = component.get("v.recordId");
        var outName = component.get("v.selectedRecord");
        //alert('recId>>'+recId+'outName>>'+JSON.stringify(outName));
        var action = component.get("c.createAgentRec");
        action.setParams({
            'RecordId': recId,
            'u' : outName 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert('state>>'+ state)
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // alert('storeResponse>>'+storeResponse);
                if(storeResponse === true){
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": recId
                    });
                    navEvt.fire();
                                       
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Message',
                        message:'Agent Record Created Successfully',
                        duration:' 10000',
                        key: 'info_alt',
                        type: 'Success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }else{
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": recId
                    });
                    navEvt.fire();
                                        
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Message',
                        message:'Agent Record Already Exist ',
                        duration:' 10000',
                        key: 'info_alt',
                        type: 'Error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);       
    },
    
    cancel:function(component, event, helper) {
        var close = $A.get('e.force:closeQuickAction');
		close.fire();
    }
    
})