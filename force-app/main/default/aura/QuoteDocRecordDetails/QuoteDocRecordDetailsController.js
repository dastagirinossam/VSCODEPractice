({
   
    doInit : function(component, event) {

		var action = component.get("c.getQuoteDocument");
        action.setParams({
            "lstRecordId": component.get("v.recordId") 
        });

		action.setCallback(this, function(s) {
        	var document = s.getReturnValue();           
            var doc = JSON.parse(JSON.stringify(document));
           
            component.set("v.lAmount", doc[0].SBQQ__ListAmount__c);
     		component.set("v.netAmount", doc[0].SBQQ__NetAmount__c);
    		component.set("v.createdDate", doc[0].CreatedDate);
            component.set("v.name", doc[0].Name);
            component.set("v.version", doc[0].SBQQ__Version__c);
            
            if(doc[0].Project_On_Quote__c != null){
    			component.set("v.project", doc[0].Project_On_Quote__r.Name);
            	component.set("v.projectId", doc[0].Project_On_Quote__c);                        
            }
            
            if(doc[0].SBQQ__Quote__c != null){
    			component.set("v.quote", doc[0].SBQQ__Quote__r.Name);
            	component.set("v.quoteId", doc[0].SBQQ__Quote__c);                        
            }
                       
        });
        
        $A.enqueueAction(action);
	},
    
    viewDoc : function(component, event) {        
       
        var quote = component.get("v.quoteId");
        var quoteStr = quote.toString();
        var name = component.get("v.name");
        var nameStr = name.toString();        
        var action = component.get("c.getPreview");

        action.setParams({
            "quote": quoteStr,
            "docName": nameStr
            
        });

        console.log('Quote: ' + quote);
        console.log('Name: ' + nameStr);
        
		action.setCallback(this, function(s) {
            
        	var contentDoc = s.getReturnValue();           
            var doc = JSON.parse(JSON.stringify(contentDoc));
           
            console.log('Content Doc: ' + contentDoc);
            console.log('Doc: ' + doc);
            
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