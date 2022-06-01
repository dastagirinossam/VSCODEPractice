({
    doInit : function (component, event) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');

        for (var i = 0; i < sURLVariables.length; i++) {
            var sParameterName = sURLVariables[i].split('='); 
        }
          
        var recordId = sParameterName[1];
        console.log(recordId);
        var action = component.get("c.getCcos");
        	action.setParams({"lstRecordId" : recordId});

        	action.setCallback(this, function(s) {
        		var changeOrder = s.getReturnValue();  
	            var cco = JSON.parse(JSON.stringify(changeOrder));
           
            	component.set("v.project", cco[0].Project__c);
				component.set("v.projectName", cco[0].Project__r.Name);
                
            	component.set("v.cco", s.getReturnValue());
                component.set("v.ccoSize", s.getReturnValue().length);
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