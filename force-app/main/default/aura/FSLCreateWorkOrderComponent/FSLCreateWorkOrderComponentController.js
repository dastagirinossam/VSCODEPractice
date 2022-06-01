({
    doInit : function(component, event, helper) {
        console.log('URL: ' + window.location.href);
        helper.initAircraft(component);
        helper.initEquipment(component);
    },

    createWorkOrder : function(component, event, helper) {
        console.log('in createWorkOrder in js controller');
        helper.showSpinner(component);
        helper.createWO(component);
    },

    maxCrewSize : function(component, event, helper) {
        var val = component.find("crewSize").get('v.value');
        if(val > 5) {
            alert('Crew Size cannot be more than 5'); 
        }
    },
    
    onButtonPressed: function(component, event, helper) {
        // Figure out which action was called
        var actionClicked = event.getSource().getLocalId();
        // Fire that action
        var navigate = component.get('v.navigateFlow');
        navigate(actionClicked);
    }
})