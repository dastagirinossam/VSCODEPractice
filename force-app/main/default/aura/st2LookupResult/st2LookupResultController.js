({
    selectSubType2 : function(component, event, helper){      
        // get the selected SubType2 from list  
        var getSelectSubType2 = component.get("v.oSubType2");
        // call the event   
        var compEvent = component.getEvent("oSelectedSubType2Event");
        // set the Selected SubType2 to the event attribute.  
        compEvent.setParams({"st2ByEvent" : getSelectSubType2 });  
        // fire the event  
        compEvent.fire();
    },
})