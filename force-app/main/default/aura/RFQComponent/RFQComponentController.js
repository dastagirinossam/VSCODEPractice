({   
    handleLoad: function(component, event, helper) {
        component.set('v.showSpinner', false);
    },
    
    handleClick: function(component, event, helper) {
        var firstnam = component.find('firstNameField').get("v.value");
        var lastnam = component.find('lastNameField').get("v.value");
        var email = component.find('emailField').get("v.value");
        var descrip = component.find('questionField').get("v.value");
        
        if(firstname != null && lastnam != null && email != null && descrip != null){
			this.handleSubmit;            
        }
            
            /*var repv ;
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;        
        if(emailvl.match(regExpEmailformat)){                
            repv ='valid';  
        }else{
            component.set("v.isUnameError", true);   
            repv ='invalid'; 
        }
        alert('repv1>>'+repv); 
        alert(">>>159"+lastnam.length+">>>"+emailvl+">>>"+descrip+'>>>'+repv);
        if(repv === 'valid'){
            //component.set("v.Recsub",true);
            */         
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    handleSubmit : function(component,event,helper){
         var firstnam = component.find('firstNameField').get("v.value");
        var lastnam = component.find('lastNameField').get("v.value");
        var email = component.find('emailField').get("v.value");
        var descrip = component.find('questionField').get("v.value");
         var city = component.find('city').get("v.value");
         var state = component.find('state').get("v.value");
         var country = component.find('country').get("v.value");
         var phone = component.find('phone').get("v.value");
        var company = component.find('company').get("v.value");
        
        var action = component.get("c.createRFQRecord");
       action.setParams({ firstName : firstnam,
                         lastName:lastnam,
                         mail:email,
                         company:company,
                         phoneNum:phone,
                         city:city,
                         state:state,
                         country:country,
                         description:descrip,
                       
                        });
        action.setCallback(this, function(response) {
            var state = response.getState();
           // alert('state>>'+state);
            if (state === "SUCCESS") {
              component.set('v.saved', true);      
            }
           });
         $A.enqueueAction(action);
       
    	//component.find("RFQForm").submit();
	},
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    
    handleError: function(component, event, helper) {      
        component.set('v.showSpinner', false);
    },
    
    handleSuccess: function(component, event, helper) {              
        component.set('v.saved', true);     
    },
    
    closeModal:function(component,event,helper){
        window.location.href = 'https://www.mystandardaero.com/Customer/s/';       
    }
    
});