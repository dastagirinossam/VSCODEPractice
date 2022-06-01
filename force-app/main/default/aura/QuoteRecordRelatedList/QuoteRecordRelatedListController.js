({
	doInit : function(component, event, helper) {
        //quote relatedlist
        helper.method1(component);

        //quoteline relatedlist
        helper.method2(component);
        
        //quoteDoc relatedlist
        helper.method3(component);
    },
        	
    showSpinner: function(component, event, helper) { 
        component.set("v.Spinner", true); 
    },
     
    hideSpinner : function(component,event,helper){    
       component.set("v.Spinner", false);
    }
})