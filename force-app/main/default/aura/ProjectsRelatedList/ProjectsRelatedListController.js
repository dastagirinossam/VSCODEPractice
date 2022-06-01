({
	doInit : function(component, event, helper) {
        //quote relatedlist
        helper.method1(component);
        
        //quoteline relatedlist
        helper.method2(component);
        
        //quoteDoc relatedlist
        helper.method3(component);
        
        //Project Files relatedlist
        helper.method4(component);
        
        //LogBookEntry relatedlist
        helper.method5(component);
        
        //CCO relatedlist
        helper.method6(component);
        
        var action1 = component.get("c.checkIsBroker");
        action1.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse[0] =='Customer - Broker' ){
                    component.set("v.isBroker", true);
                    
                }
            }
        });
        $A.enqueueAction(action1);
    },
        	
    showSpinner: function(component, event, helper) { 
        component.set("v.Spinner", true); 
    },
     
    hideSpinner : function(component,event,helper){    
       component.set("v.Spinner", false);
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