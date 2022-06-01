({   	
    method1: function(component) {
		var action = component.get("c.getQuoteFiles");
        action.setParams({
   			"lstRecordId": component.get("v.recordId")
  		});
                
        action.setCallback(this, function(p) {
            if(p.getReturnValue() == null){
                component.set("v.filesSize", "0");               
            }else{
                var files = [];
                var files2 = [];
                var f = p.getReturnValue();
                if(p.getReturnValue().length > 6){
                    component.set("v.filesSize", "6+");
                    for(var i = 0; i < 6; i++){
                        if(i%2==0){
                        	files.push(f[i]);   
                        }else{
                        	files2.push(f[i]); 
                        }
                    }
                }else{
                    component.set("v.filesSize", p.getReturnValue().length);
                    for(var i = 0; i < p.getReturnValue().length; i++){
                    	if(i%2==0){
                        	files.push(f[i]);   
                        }else{
                        	files2.push(f[i]); 
                        }                        
                    }                   
                }
				component.set("v.files", files);
				component.set("v.files2", files2);                
            }                                   
        });
        
        $A.enqueueAction(action);
	},
       
	method2: function(component) {
		var action = component.get("c.getSquawks");
        action.setParams({
   			"lstRecordId": component.get("v.recordId")
  		});
   
        action.setCallback(this, function(p) {
            
            if(p.getReturnValue() == null){
                component.set("v.quoteLineSize", "0");                
            }else{
                var quoteLines = [];
                var ql = p.getReturnValue();
                if(p.getReturnValue().length > 6){
                 	component.set("v.quoteLineSize", "6+");
                    for(var i = 0; i < 6; i++){
                        quoteLines.push(ql[i]);
                    }
                }else{
                    component.set("v.quoteLineSize", p.getReturnValue().length);
                    for(var i = 0; i < p.getReturnValue().length; i++){
                        quoteLines.push(ql[i]);
                   	}                    
                }            
            	component.set("v.quoteLine", quoteLines);    
            }                        
        });
        
        $A.enqueueAction(action);
	},
    	    
	method3: function(component) {
		var action = component.get("c.getQuoteDoc2");
        action.setParams({
   			"lstRecordId": component.get("v.recordId")
  		});
   
        action.setCallback(this, function(p) {
            if(p.getReturnValue() == null){
                component.set("v.quoteDocSize", "0");
            }else{
                var quoteDocs = [];
                var qd = p.getReturnValue();
                if(p.getReturnValue().length > 6){
                    component.set("v.quoteDocSize", "6+");
                    for(var i = 0; i < 6; i++){
                        quoteDocs.push(qd[i]);
                    }
                }else{
                    component.set("v.quoteDocSize", p.getReturnValue().length);
                    for(var i = 0; i < p.getReturnValue().length; i++){
                        quoteDocs.push(qd[i]);
                    }                    
                }
            }            
            component.set("v.quoteDoc", quoteDocs);            
        });
        
        $A.enqueueAction(action);
	}
})