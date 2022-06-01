({
	method1 : function (component) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');

        for (var i = 0; i < sURLVariables.length; i++) {
            var sParameterName = sURLVariables[i].split('='); 
        }

        var recordId = sParameterName[1];
        
        var action = component.get("c.getProjFiles");
        	action.setParams({"lstRecordId" : recordId});

        	action.setCallback(this, function(s) { 

                var files = [];
                var files2 = [];
                var f = s.getReturnValue();
                
				for (var i=0; i<s.getReturnValue().length; i++) { 
                    if(i%2 == 0){
      					files.push(f[i]);
                	}else{
                 		files2.push(f[i]);
                    }
    			}
                
            	component.set("v.files", files);
                component.set("v.files2", files2);
                component.set("v.filesSize", s.getReturnValue().length);
            	component.set("v.project", recordId);
            });
        
        $A.enqueueAction(action);        
    },
    
	method2 : function (component) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');

        for (var i = 0; i < sURLVariables.length; i++) {
            var sParameterName = sURLVariables[i].split('='); 
        }

        var recordId = sParameterName[1];
        var action = component.get("c.getProjectDetails");
        	action.setParams({"lstRecordId" : recordId});

        	action.setCallback(this, function(s) {
                var projName = s.getReturnValue();  
	            var name = JSON.parse(JSON.stringify(projName));
				component.set("v.projectName", name[0].Name);
            });
        
        $A.enqueueAction(action);        
    }
    
})