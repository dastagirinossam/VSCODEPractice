({
    doInit : function(component, event) {

        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');

        for (var i = 0; i < sURLVariables.length; i++) {
            var sParameterName = sURLVariables[i].split('='); 
        }
          
        var recordId = sParameterName[1];
        console.log('Record Id: ' + recordId);
		var action = component.get("c.getQuote");
        action.setParams({
            "lstRecordId": recordId 
        });

        var source = "https://livepreview.cs60.force.com/sfsites/c/apex/SBQQ__GenerateDocument?=null&id=" + recordId + "&tour=&isdtp=p1&sfdcIFrameOrigin=https://livepreview.cs60.force.com&sfdcIFrameHost=web";
        var preview = "https://sbqq.cs60.visual.force.com/apex/GenerateDocument?scontrolCaching=1&id=" + recordId;
        console.log('Source: ' + source);
		action.setCallback(this, function(s) {
        	var squawk = s.getReturnValue();           
            var sqk = JSON.parse(JSON.stringify(squawk));        
            component.set("v.name", sqk[0].Name);
            component.set("v.source", source);
        });
       
        $A.enqueueAction(action);
	}
})