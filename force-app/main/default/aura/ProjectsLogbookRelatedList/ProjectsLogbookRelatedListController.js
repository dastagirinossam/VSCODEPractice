({
    doInit : function (component, event) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');

        for (var i = 0; i < sURLVariables.length; i++) {
            var sParameterName = sURLVariables[i].split('='); 
        }
          
        var recordId = sParameterName[1];
        console.log(recordId);
        var action = component.get("c.getLbEntries");
        	action.setParams({"lstRecordId" : recordId});

        	action.setCallback(this, function(s) {
        		var logbook = s.getReturnValue();  
	            var lb = JSON.parse(JSON.stringify(logbook));
           
            	component.set("v.project", lb[0].Project__c);
				component.set("v.projectName", lb[0].Project__r.Name);
                
            	component.set("v.logbook", s.getReturnValue());
                component.set("v.logbookSize", s.getReturnValue().length);
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