({
    doInit : function (component, event) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');

        for (var i = 0; i < sURLVariables.length; i++) {
            var sParameterName = sURLVariables[i].split('='); 
        }

        var recordId = sParameterName[1];
        
        var action = component.get("c.getFiles");
        	action.setParams({"lstRecordId" : recordId});

        	action.setCallback(this, function(s) { 

                var files = [];
                var files2 = [];
                var f = s.getReturnValue();
                
				for (var i=0; i < s.getReturnValue().length; i++) { 
                    if(i%2 == 0){
      					files.push(f[i]);
                	}else{
                 		files2.push(f[i]);
                    }
    			}
                
            	component.set("v.files", files);
                component.set("v.files2", files2);
                component.set("v.filesSize", s.getReturnValue().length);
            });
        
        $A.enqueueAction(action);        
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