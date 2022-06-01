({
    fetchListOfRecordTypes: function(component, event, helper) {
        var action = component.get("c.fetchRecordTypeValues");
        action.setCallback(this, function(response) {
            component.set("v.lstOfRecordType", response.getReturnValue());            
        });
        $A.enqueueAction(action);
    },
    openModal: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    navigateToUrl: function( url ) {
        console.log( 'navigating to url', url );
        
        if ( !$A.util.isEmpty( url ) ) {
            $A.get( 'e.force:navigateToURL' ).setParams({ 'url': url }).fire();
        }
    },
    navigateToSobject:function(recordId){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "Related"
        });
        navEvt.fire();
    },
    getCreatable:function(component, event,helper)
    {
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
        var action = component.get("c.isCreatable");
        action.setParams({
            sObjectName:"Opportunity"  
        });
        action.setCallback(this, function(response) {
            component.set("v.booleanCreatable", response.getReturnValue());
        });
        $A.enqueueAction(action); 
    } 
})