({
    doInit : function (component, event, helper) {
		helper.method1(component);
        helper.method2(component);
    },
    
	redirect: function (){
    	var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;
    },
    
	viewDoc : function(component, event) {        
                
        var src = event.getSource().get("v.value");       
        console.log(src);
        
        var action = component.get("c.getPreview");
        
        	action.setParams({"file": src});

			action.setCallback(this, function(s) {
            
        	var contentDoc = s.getReturnValue();           
            var doc = JSON.parse(JSON.stringify(contentDoc));
           
            if(contentDoc != null){
            	var docId =  doc[0].ContentDocumentId;
                       
            	$A.get('e.lightning:openFiles').fire({
        			recordIds: [docId]
    			});
            }
        });
        
        $A.enqueueAction(action);
	}
})