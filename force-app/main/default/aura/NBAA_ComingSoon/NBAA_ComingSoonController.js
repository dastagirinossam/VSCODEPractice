({
    
    doInit: function (component, event, helper){       
        component.set('v.NBAA', 
                      'https://standardaero--c.na79.content.force.com/servlet/servlet.ImageServer?id=0151O000004FQHH&oid=00D00000000hfim'
                     );
        var action = component.get("c.getUserProfiles"); 
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var returnRes = response.getReturnValue();
                console.log('Return Values: ' + returnRes);
                component.set("v.files" ,returnRes );
                component.set("v.firstPart", 'https://standardaero--c.na79.content.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=06839000004QEhd');
                //component.set("v.lastPart", '&contentId=');
            }
        });
        $A.enqueueAction(action);
    },
    
    viewDoc : function(component, event) {                        
        var src = event.getSource().get("v.id");       
        console.log(src);
        
        var action = component.get("c.getPreview");
        
        action.setParams({"file": src});
        
        action.setCallback(this, function(s) {                        
                $A.get('e.lightning:openFiles').fire({
                    recordIds: [src]
                });           
        });
        
        $A.enqueueAction(action);
    },
    
    handleCancel: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" : '/'
        });
        urlEvent.fire();
    }
})