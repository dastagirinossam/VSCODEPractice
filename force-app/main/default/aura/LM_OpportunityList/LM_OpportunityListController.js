({ 
    
    doInit: function(component, event, helper){
        helper.fetchListOfRecordTypes(component, event, helper);
        helper.openModal(component, event, helper);
        helper.getCreatable(component, event, helper);
    },
    
    createRecord: function(component, event,helper1) {
        component.set("v.isOpen", true);
        let helper = this;
        let pageRef = component.get( 'v.pageReference' );
        let urlParamMap = {
            'c__objectname' : '',      
            'c__recordid' : '' ,
            'c__name':''
        };
        
        for ( let key in pageRef.state ) {
            let lowerKey = key.toLowerCase();
            if ( urlParamMap.hasOwnProperty( lowerKey ) ) {
                urlParamMap[lowerKey] = pageRef.state[key];
            }
        } 
        Promise.resolve()
        .then( function() {
            if ( !$A.util.isEmpty( urlParamMap.c__recordid ) ) {
                helper1.navigateToSobject(urlParamMap.c__recordid );
                //helper.navigateToUrl( '/' + urlParamMap.c__recordid );
                //$A.get( 'e.force:navigateToURL' ).setParams({ 'url': '/' + urlParamMap.recordid}).fire();
                return new Promise( function( resolve, reject ) {
                    setTimeout( resolve, 1000 );
                });
            }
        })
        
        var action = component.get("c.getRecTypeId");        
        var recordTypeLabel = component.find("selectid").get("v.value");
        action.setParams({
            "recordTypeLabel": recordTypeLabel,
            "aircraftId": urlParamMap.c__recordid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var createRecordEvent = $A.get("e.force:createRecord");
                var RecTypeID  = response.getReturnValue();
                if(urlParamMap.c__objectname=='Account'){
                    createRecordEvent.setParams({
                        "entityApiName": 'Opportunity',
                        "recordTypeId": RecTypeID.TypeId,
                        "defaultFieldValues": {
                            'AccountId' : urlParamMap.c__recordid,
                            'Name' : urlParamMap.c__name
                        }
                        
                    });
                }else if(urlParamMap.c__objectname == 'Aircraft__c'){                 
                    createRecordEvent.setParams({
                        "entityApiName": 'Opportunity',
                        "recordTypeId": RecTypeID.TypeId,
                        "defaultFieldValues": {
                            'Aircraft__c' : urlParamMap.c__recordid,
                            'Name' : urlParamMap.c__name,
                            'Product_Line__c': RecTypeID.AirRec.Product_Line__c,
                            'AccountId':RecTypeID.AirRec.Account_ID__c //urlParamMap.c__accountid    //RecTypeID.AirRec.Account_ID__c                //
                        }
                    });
                }
                
                component.set("v.isOpen", false);
                if (component.get("v.booleanCreatable") === false)
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Oops!",
                        "type":"Info",
                        "message": "You don't have the necessary privileges to create this record. See your administrator for help."
                    });
                    toastEvent.fire();
                }
                else
                {
                    createRecordEvent.fire();
                }
                
            } else if (state == "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Oops!",
                    "message": "No Internet Connection"
                });
                toastEvent.fire();
                
            } else if (state == "ERROR") {             
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please contact your administrator"
                });
                toastEvent.fire();   
            }            
            $A.get("e.force:closeQuickAction").fire();
        });       
        $A.enqueueAction(action);   
    },
    
    closeModal: function(component, event, helper) {
        let pageRef = component.get( 'v.pageReference' );
        let urlParamMap = {
            'c__objectname' : '',      
            'c__recordid' : '' ,
            'c__name':''
        };
        for ( let key in pageRef.state ) {
            let lowerKey = key.toLowerCase();
            if ( urlParamMap.hasOwnProperty( lowerKey ) ) {
                urlParamMap[lowerKey] = pageRef.state[key];
            }
        } 
        $A.get( 'e.force:navigateToURL' ).setParams({ 'url': '/' + urlParamMap.c__recordid}).fire();
        component.set("v.isOpen", false);
    }     
})