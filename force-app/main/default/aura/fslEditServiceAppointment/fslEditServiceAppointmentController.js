({    invoke : function(component, event, helper) {

    var wo = component.get("v.WorkOrderId");
    var sa = component.get("v.ServiceAppointmentId");
    
    var redirect = $A.get("e.force:navigateToURL");
    redirect.setParams({
        "url": '/lightning/r/ServiceAppointment/' + sa + '/edit?navigationLocation=RELATED_LIST_ROW&backgroundContext=%2Flightning%2Fr%2FWorkOrder%2F' + wo + '%2Fview'
    });

    redirect.fire();
}})