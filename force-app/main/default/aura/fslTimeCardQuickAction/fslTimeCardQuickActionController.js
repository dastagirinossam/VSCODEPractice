({
    doInit : function(component, event, helper){
        var recordId = component.get("v.recordId");
        console.log('Record Id: ' + recordId);
        
        var action = component.get('c.getSA');
        
        action.setParams({"saID" : recordId}); 
        action.setCallback(this, function(s) {
            var state = s.getState();
            if (state === "SUCCESS") {
                var sa = s.getReturnValue();
                var serviceAppointment = JSON.parse(JSON.stringify(sa));
                
                console.log('Good: ' + serviceAppointment.Active_Time_Card__c);
                
                if(serviceAppointment.Active_Time_Card__c != null)
                    component.set("v.TimeCard", serviceAppointment.Active_Time_Card__c); 
            }else{
                console.log('Errors: ' + JSON.stringify(s.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})