({
    doInit: function(component, event, helper) {              
        helper.getSquawks(component);
        helper.getAmounts(component);
    },
    
    toggle : function(component, event, helper) {
        
        var slideStatus = component.get('v.slideStatus');
        var cmpSlide = component.find('slide').getElement();
        
        console.log('Slide Status: ' + slideStatus);
        
        if(slideStatus == 'Open'){
            $A.util.removeClass(cmpSlide, 'showSlide');
            $A.util.addClass(cmpSlide, 'hideSlide');
            component.set('v.slideStatus', 'Closed');
        }else{
            $A.util.removeClass(cmpSlide, 'hideSlide');
            $A.util.addClass(cmpSlide, 'showSlide');
            component.set('v.slideStatus', 'Open');
        }
    },
    
    handleChange: function(component, event, helper){
        var status = component.get('v.value');
        if(status != ''){
            helper.getStatusSquawks(component);
            helper.getStatusAmounts(component);
        }else{
            helper.getSquawks(component);
            helper.getAmounts(component);
        }       
    },
    
    search: function(component, event, helper){
        helper.getSquawkSearch(component);
		helper.getSquawkSearchAmount(component);
    },
    
    reset: function(component, event, helper){
        	component.set('v.squawkNo', '');
        	component.set('v.description', '');
        	component.set('v.value', '');
            helper.getSquawks(component);
            helper.getAmounts(component);
    },
    
    downloadDocument : function(component, event, helper){

        var sendDataProc = component.get("v.sendData");
        var dataToSend = {
            "label" : "This is test"
        }; //this is data you want to send for PDF generation
        
        //invoke vf page js method
        sendDataProc(dataToSend, function(){
            //handle callback
        });
    }
})