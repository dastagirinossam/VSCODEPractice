({
    //Aircraft
    helperMethod1 : function(component, event, helper, token) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.service");     
        action.setParams({
            'response' : token,
            'acId': recordId
        });        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var jn = response.getReturnValue();
                console.log('Aircraft Date: ' + jn.ac.purchasedate);
                
                var purchaseDate;
                if(jn.ac.purchasedate != null){
                    purchaseDate = jn.ac.purchasedate;
                    purchaseDate = purchaseDate.substring(6);
                    purchaseDate = purchaseDate.replace(')/', '');
                    component.set("v.purchaseDate", purchaseDate);
                }
                
                var regnbrexpires;
                if(jn.ac.regnbrexpires != null){
                    regnbrexpires = jn.ac.regnbrexpires;
                    regnbrexpires = regnbrexpires.substring(6);
                    regnbrexpires = regnbrexpires.replace(')/', '');
                    component.set("v.regnbrexpires", regnbrexpires);
                }
                
                var timesasofdate;
                if(jn.ac.timesasofdate != null){
                    timesasofdate = jn.ac.timesasofdate;
                    timesasofdate = timesasofdate.substring(6);
                    timesasofdate = timesasofdate.replace(')/', '');
                    component.set("v.timesasofdate", timesasofdate);
                }
                
                component.set("v.Aircraft", jn.ac);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    //Engine
    helperMethod2 : function(component, event, helper, token) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.serviceEngine");     
        action.setParams({
            'response' : token,
            'acId': recordId
        });        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var jn = response.getReturnValue();
                component.set("v.Engine", jn.ac);
            }
        });
        
        $A.enqueueAction(action);
	},
    
    //APU
    helperMethod3 : function(component, event, helper, token) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.serviceAPU");     
        action.setParams({
            'response' : token,
            'acId': recordId
        });        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var jn = response.getReturnValue();
                component.set("v.APU", JSON.parse(JSON.stringify(jn.ac)));
            }
        });
        
        $A.enqueueAction(action);
	},
    
    //Company
    helperMethod4 : function(component, event, helper, token) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.serviceCompany");     
        action.setParams({
            'response' : token,
            'acId': recordId
        });        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var jn = response.getReturnValue();
                console.log('Companies: ' + JSON.stringify(jn)); 
                component.set("v.Company", jn);
            }else{
                console.log('State: ' + state);
            }
        });
        
        $A.enqueueAction(action);
	},
    
    //Contacts
    helperMethod5 : function(component, event, helper, token) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.serviceContacts");     
        action.setParams({
            'response' : token,
            'acId': recordId
        });        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var jn = response.getReturnValue();
                component.set("v.Contacts", jn);
                console.log('Contacts: ' + JSON.stringify(jn));                
            }
        });
        
        $A.enqueueAction(action);
	},
    
    //Company Relatinships
    helperMethod6 : function(component, event, helper, token) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.serviceCompanyRelationships");     
        action.setParams({
            'response' : token,
            'acId': recordId
        });        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var jn = response.getReturnValue();
                //component.set("v.Contacts", jn);
                
                var relationships = JSON.stringify(jn);
                //String relationships = JSON.parse(JSON.stringify(jn.getAircraftCompanyrelationshipsResult));
                relationships = relationships.replace("companyrelationships\\", "companyrelationships");
                console.log('Company Relationships: ' + relationships);                
            }
        });
        
        $A.enqueueAction(action);
	}
    
})