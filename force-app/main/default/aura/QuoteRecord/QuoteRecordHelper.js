({
    navigate : function(component, event) {
    	var address = "/sfdcpage/%2Fapex%2FSBQQ__GenerateDocument%3F%26id%3D" + component.get("v.recordId");
    	var urlEvent = $A.get("e.force:navigateToURL");
    	urlEvent.setParams({
      		"url": address,
      		"isredirect" :false
    	});
    	urlEvent.fire();
	}
})