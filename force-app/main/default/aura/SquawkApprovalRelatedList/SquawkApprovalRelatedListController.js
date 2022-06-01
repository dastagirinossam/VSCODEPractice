({
    
	doInit : function (component, event, helper) {
                
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');

        for (var i = 0; i < sURLVariables.length; i++) {
            var sParameterName = sURLVariables[i].split('='); 
        }
          
        var recordId = sParameterName[1];        
        var action = component.get("c.getAppHistory");
        	action.setParams({"lstRecordId" : recordId});

        	action.setCallback(this, function(s) {          
				component.set("v.recordId", recordId);
            	component.set("v.approvalHistory", s.getReturnValue());
                component.set("v.approvalHistorySize", s.getReturnValue().length);
            });
        
        $A.enqueueAction(action);
        
    },
    
    sortByDate: function(component, event, helper) {
        console.log("Hello");
        helper.sortBy(component, "instanceStep.CreatedDate");
    },
   
	redirect: function (){
    	var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;
    }
    
})