({
	 doInit : function(component, event, helper) {
     
    var recordId = component.get("v.recordId");  
        
     var strings;   
         var vfUrl = '/apex/CreateAgentVfPage?id=' + recordId;
            // var vfUrl = 'https://myinstance.visual.force.com/apex/MyVFPage?Id='+myId;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": vfUrl
        });
        
        urlEvent.fire(); 
        // alert('>>>'+recordId);
       var vali;  
      var action = component.get('c.getData');
    action.setParams({ conId: recordId });
    action.setCallback(this, function(response) {
        // Not included, but remember to check isValid/result status
       if( response.getReturnValue() == 'userdontExist'){
           var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Message',
            message:'Agent User Created Successfully',
            duration:'1000',
            key: 'info_alt',
            type: 'Success',
            mode: 'dismissible'
        });
        toastEvent.fire();  
        }
    });
    $A.enqueueAction(action);
         
 }
})