({
    doInit : function (component, event) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');

        for (var i = 0; i < sURLVariables.length; i++) {
            var sParameterName = sURLVariables[i].split('='); 
        }
          
        var recordId = sParameterName[1];
        
        var action = component.get("c.getQuoteDoc");
        	action.setParams({"lstRecordId" : recordId});

        	action.setCallback(this, function(s) {
        		var quoteLine = s.getReturnValue();  
	            var ql = JSON.parse(JSON.stringify(quoteLine));
           
            	component.set("v.project", ql[0].Project_On_Quote__c);
				component.set("v.projectName", ql[0].Project_On_Quote__r.Name);
                
            	component.set("v.quoteDoc", s.getReturnValue());
                component.set("v.quoteDocSize", s.getReturnValue().length);
            });
        
        $A.enqueueAction(action);        
    },
    
	redirect: function (){
    	var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;
    }
})