({
    doInit: function(component, event, helper) {
        
        var device = $A.get("$Browser.formFactor");
        
        if(device == 'DESKTOP'){           
            helper.projectHome(component, event, helper);; 
        }
        
        component.set('v.projDoc', 
                      'https://standardaero--c.na79.content.force.com/servlet/servlet.ImageServer?id=0151O000004FQq2&oid=00D00000000hfim'
                     );
    },
    
    handleCancel: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" : '/'
        });
        urlEvent.fire();
    }
})