({
	opportunityFields : function(component, event) {
        var recordId = component.get("v.recordId");
        console.log('Record Id: ' + recordId);
        var action = component.get("c.getDetailsFromOpp");
        action.setParams({
            recordId: recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.OppRec", response.getReturnValue());             
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Opportunity Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    opportunityAircraft : function(component, event) {
        var recordId = component.get("v.recordId");
        console.log('Record Id: ' + recordId);
        var action = component.get("c.getOppAircraft");
        action.setParams({
            "oppId": recordId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var acMap = response.getReturnValue(); 
                component.set("v.acRec", acMap);
              
                var forclose = component.find("lookup-pill");
                $A.util.addClass(forclose, 'slds-show');
                $A.util.removeClass(forclose, 'slds-hide');
                
                var lookUpTarget = component.find("lookupField");
                $A.util.addClass(lookUpTarget, 'slds-hide');
                $A.util.removeClass(lookUpTarget, 'slds-show');
                
                console.log('Success Aircraft: ' + JSON.stringify(response.getReturnValue()));
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Aircraft Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    opportunityEquipment : function(component, event) {
        var recordId = component.get("v.recordId");
        console.log('Record Id: ' + recordId);
        var action = component.get("c.getOppEquipment");
        action.setParams({
            "oppId": recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var engMap = response.getReturnValue(); 
                component.set("v.engRec", engMap); 
                
                var forclose = component.find("eng-lookup-pill");
                $A.util.addClass(forclose, 'slds-show');
                $A.util.removeClass(forclose, 'slds-hide');
                
                var lookUpTarget = component.find("eng-lookupField");
                $A.util.addClass(lookUpTarget, 'slds-hide');
                $A.util.removeClass(lookUpTarget, 'slds-show');
                
                console.log('Success Engine: ' + JSON.stringify(engMap));
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Engine Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        });
        
        $A.enqueueAction(action);
    },
    
    opportunitySubType2 : function(component, event) {
        var recordId = component.get("v.recordId");
        console.log('Record Id: ' + recordId);
        var action = component.get("c.getOppSubType2");
        action.setParams({
            "oppId": recordId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var st2 = response.getReturnValue();    
                component.set('v.st2Rec', st2);
                
                var forclose = component.find("st2-lookup-pill");
                $A.util.addClass(forclose, 'slds-show');
                $A.util.removeClass(forclose, 'slds-hide');
                
                var lookUpTarget = component.find("st2-lookupField");
                $A.util.addClass(lookUpTarget, 'slds-hide');
                $A.util.removeClass(lookUpTarget, 'slds-show');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            component.set("v.LoadingText", false);
        });
        
        $A.enqueueAction(action);
    },
    
    opportunityFacility : function(component, event){
        var action = component.get("c.getFacility");     
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.fac", response.getReturnValue());
                var results = response.getReturnValue();
                console.log('Facilities: ' + JSON.stringify(results)); 
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            component.set("v.LoadingText", false);
        });
        
        $A.enqueueAction(action);  
    },
    
    opportunityRecordTypes : function(component, event) {     
        var recordId = component.get("v.recordId");
        console.log('Record Id: ' + recordId);
        var action = component.get("c.getOppRecordTypes");
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log('Found Record Types');
                component.set("v.OppRecTypes", response.getReturnValue());             
            }      
        });
        
        $A.enqueueAction(action);
    },
    
    aircaftAccountList : function(component, event){  
        var recordId = component.get('v.recordId');
        var action = component.get("c.accountAircraft");       
        action.setParams({
            'oppId' : recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var aircraftList = response.getReturnValue();
                
                // set searchResult list with return value from server.
                component.set("v.listOfAircraftPerAccountRecords", aircraftList);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);       
    },
    
    aircraftEquipmentList : function(component, event){  
        var recordId = component.get('v.recordId');
        var action = component.get("c.aircraftEquipment");       
        action.setParams({
            'oppId' : recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var equipList = response.getReturnValue();
                console.log('Equipment List: ' + equipList);

                component.set("v.listOfEquipPerAircraft", equipList);
            }
            
        });
 
        $A.enqueueAction(action);       
    },
    
    aircraftEquipmentChange : function(component, event, helper, acId){  

        var action = component.get("c.aircraftEquipmentChange");       
        action.setParams({
            'acId' : acId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var equipList = response.getReturnValue();
                console.log('Equipment List: ' + equipList);

                for(var i = 0; i < equipList.length; i++) {
                    if(equipList[i].Name == 'NA'){
                        component.set("v.engRec", equipList[i]);
                        
                        var forclose = component.find("eng-lookup-pill");
                        $A.util.addClass(forclose, 'slds-show');
                        $A.util.removeClass(forclose, 'slds-hide');
                        
                        var engOpen = component.find("equipmentResults");
                        $A.util.addClass(engOpen, 'slds-hide');
                        $A.util.removeClass(engOpen, 'slds-show');
                        
                        var forclose = component.find("searchEngRes");
                        $A.util.addClass(forclose, 'slds-is-close');
                        $A.util.removeClass(forclose, 'slds-is-open');
                        
                        var lookUpTarget = component.find("eng-lookupField");
                        $A.util.addClass(lookUpTarget, 'slds-hide');
                        $A.util.removeClass(lookUpTarget, 'slds-show'); 
                        
                        var engSearchIcon = component.find("eng-SearchIcon");
                        $A.util.addClass(engSearchIcon, 'slds-show');
                        $A.util.removeClass(engSearchIcon, 'slds-hide');
                        
                        var engHideIcon = component.find("eng-CloseIcon");
                        $A.util.addClass(engHideIcon, 'slds-hide');
                        $A.util.removeClass(engHideIcon, 'slds-show');                
                    }
                }
                
                component.set("v.listOfEquipPerAircraft", equipList);
            }
            
        });
 
        $A.enqueueAction(action);       
    },
    
    subType2List : function(component, event){  
        var recordId = component.get('v.recordId');
        var action = component.get("c.SubType2List");       
        action.setParams({
            'oppId' : recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var st2List = response.getReturnValue();
                console.log('SubType2 List: ' + st2List);

                component.set("v.listOfSt2PerProductLine", st2List);
            }
            
        });
  
        $A.enqueueAction(action);       
    },
    
    searchHelper : function(component,event,getInputkeyWord) {
        var action = component.get("c.fetchAircraft");
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });
   
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", 'Search Result...');
                }
                
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
 
        $A.enqueueAction(action);        
    },
    
    searchEngHelper : function(component, event, getInputkeyWord) {

        var action = component.get("c.fetchEquipment");
        action.setParams({
            'searchKeyWord': getInputkeyWord
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.EngMessage", 'No Result Found...');
                } else {
                    component.set("v.EngMessage", 'Search Result...');
                }
                
                component.set("v.listOfEngineSearchRecords", storeResponse);
            }
            
        });

        $A.enqueueAction(action);
        
    },
    
    searchSt2Helper : function(component, event, getInputkeyWord) {

        var productLine = component.get('v.OppRec.Product_Line__c');
        var SubType = component.find("selectedSubType").get("v.value");
        var action = component.get("c.fetchSubType2");
        
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ProductLine' : productLine, 
            'SubType' : SubType
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.St2Message", 'No Result Found...');
                } else {
                    component.set("v.St2Message", 'Search Result...');
                }
                
                component.set("v.listOfSt2SearchRecords", storeResponse);
            }
            
        });

        $A.enqueueAction(action);
    },
    
    handleFormSubmit: function(component, opportunityFields) {
      
        var showValidationError = false;        
        var fields = JSON.parse(JSON.stringify(opportunityFields));
        console.log('SubType2: ' + fields.SubType__c);
        
        var vaildationFailReason = '';
        
        var acRec = component.get('v.acRec');
        var engRec = component.get('v.engRec');
        
        //Aircraft Required
        if(acRec == null){
            showValidationError = true;
            vaildationFailReason = 'Aircraft is a requiried field, please make a selection.';
        }
        
        //Engine Required
        if(engRec == null){
            showValidationError = true;
            vaildationFailReason = 'Equipment is a requiried field, please make a selection.';
        }
        
        //ProductLine Required
        if(fields.Product_Line__c == null){
            showValidationError = true;
            vaildationFailReason = 'Product Line is a requiried field, please make a selection.';
        }
        
        //SubType2 - Airframe Validation
        if(fields.SubType__c == "Airframe - Inspection" && acRec.Product_Line__r.Sub_Type_2_Required__c && fields.SubType2__c == null){
            showValidationError = true;
            vaildationFailReason = 'SubType2 is required. Confirm you have selected the proper SubType. SubType2 is only required for scripted inspection events.';
        }
        
        //SubType2 - CFE Validation
        if(fields.SubType__c == "CFE738 - MPI" || fields.SubType__c == "CFE738 - CZI R&R"){
            if(engRec.Product_Line__r.Sub_Type_2_Required__c && fields.SubType2__c == null){
                showValidationError = true;
                vaildationFailReason = 'SubType2 is required. Confirm you have selected the proper SubType. SubType2 is only required for scripted inspection events.';
            }
        }
        
        //SubType2 - TFE Validation
        if(fields.SubType__c == "TFE731 - MPI" || fields.SubType__c == "TFE731 - CZI"){
            if(engRec.Product_Line__r.Sub_Type_2_Required__c && fields.SubType2__c == null){
                showValidationError = true;
                vaildationFailReason = 'SubType2 is required. Confirm you have selected the proper SubType. SubType2 is only required for scripted inspection events.';
            }
        }
         
        //SubType2 - HTF Validation
        if(fields.SubType__c == "HTF - 2000 Hour Inspection" ||
           fields.SubType__c == "HTF - 2250 Hour Inspection" ||
           fields.SubType__c == "HTF - 2400 Hour Inspection" ||
           fields.SubType__c == "HTF - 4000 Hour Borescope Inspection" || 
           fields.SubType__c == "HTF - 4200 Hour Borescope Inspection" || 
           fields.SubType__c == "HTF - 4500 Hour Borescope Inspection" ||
           fields.SubType__c == "HTF - 4800 Hour Borescope Inspection" ||
           fields.SubType__c == "HTF - 8000 Hour Borescope Inspection" || 
           fields.SubType__c == "HTF - 9000 Hour Borescope Inspection" ||
           fields.SubType__c == "HTF - 9600 Hour Borescope Inspection"){
            if(engRec.Product_Line__r.Sub_Type_2_Required__c && fields.SubType2__c == null){
                showValidationError = true;
                vaildationFailReason = 'SubType2 is required. Confirm you have selected the proper SubType. SubType2 is only required for scripted inspection events.';
            }
        }
        
        if (!showValidationError) {
            component.set('v.loading', true);
            component.find('myform').submit(opportunityFields); 
        } else {
            component.find('OppMessage').setError(vaildationFailReason);
            component.set('v.loading', false); 
        }
    }

})