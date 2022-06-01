({
	doInit : function(component, event, helper) {
		 var action=component.get('c.getoppRecs');
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
      //  alert('userId18>>'+userId);
        var ids = '00500000004C60sAAC';
        action.setParams({ usersId :userId
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue(); 
                //alert('rows>>>'+JSON.stringify(rows));
                component.set("v.opportunities", rows);  
            }
        });
        $A.enqueueAction(action);
	},
    someClickHandler4:function(component, event, helper) {
    var div = event.currentTarget;
    var recordId = div.getAttribute('data-record-id');
      // alert('recordId1>>>>>'+recordId);
        var address = '/aircraft-details/'+recordId;
    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": address,
      "isredirect" :false
    });
    urlEvent.fire();
  
},
    
     someClickHandler3:function(component, event, helper) {
    var div = event.currentTarget;
    var recordId = div.getAttribute('data-record-id');
       // alert('recordId1>>>>>'+recordId);
 var address = '/equipment-details/'+recordId;
    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": address,
      "isredirect" :false
    });
    urlEvent.fire();
  
},
     
     
    someClickHandler1:function(component, event, helper) {
    var div = event.currentTarget;
    var recordId = div.getAttribute('data-record-id');
     //   alert('recordId1>>>>>'+recordId);
 var address = '/opportunity-detail-page/'+recordId;
    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": address,
      "isredirect" :false
    });
    urlEvent.fire();
  
},
    someClickHandler2:function(component, event, helper) {
        var div = event.currentTarget;
    var recordId = div.getAttribute('data-record-id');
       //  alert('recordId1>>>>>'+recordId);
      var address = '/account-detail/'+recordId;
    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": address,
      "isredirect" :false
    });
    urlEvent.fire();
  }
    
     
})