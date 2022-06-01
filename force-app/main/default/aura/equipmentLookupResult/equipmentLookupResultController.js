({
    selectEquipment : function(component, event, helper){      
        // get the selected Equipment from list  
        var getSelectEquipment = component.get("v.oEquipment");
        
        // call the event   
        var compEvent = component.getEvent("oSelectedEquipmentEvent");
        
        // set the Selected Equipment to the event attribute.  
        compEvent.setParams({"equipmentByEvent" : getSelectEquipment });
        
        // fire the event  
        compEvent.fire();
    }
})