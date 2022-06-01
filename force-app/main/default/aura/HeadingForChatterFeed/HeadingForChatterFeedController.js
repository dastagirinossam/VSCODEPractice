({
    // Handle component initialization 
    doInit : function(component, event, helper) {      
		var articleId = helper.getURLParameter('id');
        
		$A.createComponent(
			"forceChatter:feed", {
    			"type": "News",
    			"subjectId": articleId
			},
            
			function(recordFeed) {
    		//Add the new button to the body array
    			if (component.isValid()) {
        			var body = component.get("v.body");
        			body.push(recordFeed);
        			component.set("v.body", body);
    			}
			}
        );
	}
       
})