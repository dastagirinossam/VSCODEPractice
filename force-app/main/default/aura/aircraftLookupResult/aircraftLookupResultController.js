({
    selectAircraft : function(component, event, helper){      
        // get the selected Aircraft from list  
        var getSelectAircraft = component.get("v.oAircraft");
        // call the event   
        var compEvent = component.getEvent("oSelectedAircraftEvent");
        // set the Selected Aircraft to the event attribute.  
        compEvent.setParams({"aircraftByEvent" : getSelectAircraft });  
        // fire the event  
        compEvent.fire();
    },
})