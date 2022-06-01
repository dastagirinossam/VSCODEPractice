({
 	method1: function(component) {
		var action = component.get("c.getQuotes");
        action.setParams({
   			"lstRecordId": component.get("v.recordId")
  		});
   
        action.setCallback(this, function(p) {
                        	         
           	if(p.getReturnValue() == null){
                component.set("v.quoteSize", "0");
            }else{
                var quotes = []; 
            	var q = p.getReturnValue();
                if(p.getReturnValue().length > 6){
                	component.set("v.quoteSize", "6+");
                    for(var i = 0; i < 6; i++){
                        quotes.push(q[i]);
                    }               
                }else{
                    component.set("v.quoteSize", p.getReturnValue().length); 
                    for(var i = 0; i < p.getReturnValue().length; i++){
                        quotes.push(q[i]);                    
                    }                    
                }
                component.set("v.quote", quotes);
            }                
        });
        
        $A.enqueueAction(action);
	},
    
	method2: function(component) {
		var action = component.get("c.getProjectQuoteLines");
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
                    for(var i = 0 ; i < 6; i++){
                        
                        quoteLines.push(ql[i]);
                    }                                      
                }else{
                    component.set("v.quoteLineSize", p.getReturnValue().length);
                    for(var i=0; i< p.getReturnValue().length; i++){
                        quoteLines.push(ql[i]);                       
                    }					                    
                }
                component.set("v.quoteLine", quoteLines);
    		}                        
        });
        
        $A.enqueueAction(action);
	},
            
	method3: function(component) {
		var action = component.get("c.getQuoteDoc");
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
                    for( i = 0; i < p.getReturnValue().length; i++){
                        quoteDocs.push(qd[i]);
                    }                  
                }
               component.set("v.quoteDoc", quoteDocs);                  
            }               
        });
        
        $A.enqueueAction(action);
	},
    	
    method4: function(component) {
		var action = component.get("c.getProjFiles");
        action.setParams({
   			"lstRecordId": component.get("v.recordId")
  		});
               
        action.setCallback(this, function(p) {

            if(p.getReturnValue() == null){
                component.set("v.filesSize", "0");                
            }else{
            	var projectFiles = [];
            	var projectFiles2 = [];
            	var pf = p.getReturnValue();
                if(p.getReturnValue().length > 6){
                    component.set("v.filesSize", "6+");
                    for(var i = 0; i < 6; i++){
                        if(i%2 == 0){
                            projectFiles.push(pf[i]);                          
                        }else{
                        	projectFiles2.push(pf[i]);     
                        }                        
                    }                                     
                }else{
                    component.set("v.filesSize", p.getReturnValue().length);
                    for(var i = 0; i < p.getReturnValue().length; i++){
                        if(i%2 == 0){
                            projectFiles.push(pf[i]);                          
                        }else{
                        	projectFiles2.push(pf[i]);     
                        }                        
                    }                      
                }
                component.set("v.files", projectFiles);
				component.set("v.files2", projectFiles2);                
            }                                  
        });
        
        $A.enqueueAction(action);
	},
    
	method5: function(component) {
		var action = component.get("c.getLbEntries");
        action.setParams({
   			"lstRecordId": component.get("v.recordId")
  		});
               
        action.setCallback(this, function(p) {

            if(p.getReturnValue() == null){
                component.set("v.logbookEntrySize", "0");                
            }else{
            	var lbEntries = [];
            	var lb = p.getReturnValue();
                if(p.getReturnValue().length > 6){
                    component.set("v.logbookEntrySize", "6+");
                    for(var i = 0; i < 6; i++){
						lbEntries.push(lb[i]);                                                
                    }                                     
                }else{
                    component.set("v.logbookEntrySize", p.getReturnValue().length);
                    for(var i = 0; i < p.getReturnValue().length; i++){
                    	lbEntries.push(lb[i]);                                                 
                    }                      
                }
                component.set("v.logbookEntry", lbEntries);             
            }                                  
        });
        
        $A.enqueueAction(action);
	},
    
	method6: function(component) {
		var action = component.get("c.getCcos");
        action.setParams({
   			"lstRecordId": component.get("v.recordId")
  		});
               
        action.setCallback(this, function(p) {

            if(p.getReturnValue() == null){
                component.set("v.ccoSize", "0");                
            }else{
            	var ccos = [];
            	var co = p.getReturnValue();
                if(p.getReturnValue().length > 6){
                    component.set("v.ccoSize", "6+");
                    for(var i = 0; i < 6; i++){
						ccos.push(co[i]);                                                
                    }                                     
                }else{
                    component.set("v.ccoSize", p.getReturnValue().length);
                    for(var i = 0; i < p.getReturnValue().length; i++){
                    	ccos.push(co[i]);                                                 
                    }                      
                }
                component.set("v.cco", ccos);             
            }                                 
        });
        
        $A.enqueueAction(action);
	}
})