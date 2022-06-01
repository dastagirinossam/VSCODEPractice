({
    doInit: function(component, event, helper) {  
        helper.opportunityFacility(component, event, helper);
        helper.opportunityFields(component, event, helper);
        helper.opportunityRecordTypes(component, event, helper);    
        helper.opportunityAircraft(component, event, helper); 
        helper.opportunityEquipment(component, event, helper); 
        helper.opportunitySubType2(component, event, helper);
        helper.aircaftAccountList(component, event, helper);
        helper.aircraftEquipmentList(component, event, helper);
        helper.subType2List(component, event, helper);
        component.set('v.loading', true);
    },
    
    handleLoad: function(component, event, helper) {
        component.set('v.loading', false);
    },
    
    onRecordSubmit: function(component, event, helper) {

        event.preventDefault(); // stop form submission
        
        var opportunityFields = event.getParam("fields");
        
        var oppStage = component.find("selectedStage").get("v.value");
        opportunityFields["StageName"] = oppStage;
        
        var rtMap = component.get("v.OppRecTypes");
        var recordType = null;
        
        //RFQ
        if(oppStage == 'RFQ Submitted')
            recordType = rtMap['RFQ'];
        
        //Qualified
        if(oppStage == 'Qualified Opportunity')
            recordType = rtMap['Qualified Opportunity'];
        
        //New Opportunity
        if(oppStage == 'New Opportunity')
            recordType = rtMap['New Opportunity'];
        
        var aircraft = component.get('v.acRec');
        if(aircraft != null)
            opportunityFields["Aircraft__c"] = aircraft.Id; 
        
        var engine = component.get('v.engRec');
        if(engine != null)
            opportunityFields["Equipment__c"] = engine.Id; 
        
        var subType2 = component.get('v.st2Rec');
        if(subType2 != null)
            opportunityFields["SubType2__c"] = subType2.Id; 
        
        var facility = component.get('v.OppRec.Facility__c');
        opportunityFields["Facility__c"] = facility;
        
        opportunityFields["RecordTypeId"] = recordType;
        opportunityFields["Hot_List__c"] = false;
        opportunityFields["WasCloned__c"] = true;
        
        console.log('Opportunity Fields:' + JSON.stringify(opportunityFields));
        helper.handleFormSubmit(component, opportunityFields);
    },
    
    handleSuccess : function(component, event, helper) {      
        var params = event.getParams();  
        var recordId = params.response.id; 
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": "related"
        });
        navEvt.fire(); 
        $A.get("e.force:closeQuickAction").fire();
    },
    
    handleError : function(component, event, helper) {         
        var params = event.getParams();  
        alert('Opportunity Clone Error: Something happened that prevented this cloned Opportunity from saving. Please contact your system admin for help regarding this.');
        console.log('Error: ' + JSON.stringify(params));
        component.set('v.loading', false);
    },
    
    cancel: function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    
    resetST2 : function(component, event, helper){
        var pillTarget = component.find("st2-lookup-pill");
        var lookUpTarget = component.find("st2-lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        var st2SearchIcon = component.find("st2-SearchIcon");
        $A.util.addClass(st2SearchIcon, 'slds-show');
        $A.util.removeClass(st2SearchIcon, 'slds-hide');
        
        var st2HideIcon = component.find("st2-CloseIcon");
        $A.util.addClass(st2HideIcon, 'slds-hide');
        $A.util.removeClass(st2HideIcon, 'slds-show'); 
        
        component.set("v.St2SearchKeyWord",null);
        component.set("v.listOfSt2SearchRecords", null );
        component.set("v.listOfSt2PerProductLine", null );
        component.set("v.st2Rec", null);
    },
    
    searchField : function(component, event, helper){
        var opportunitySubType = component.find("selectedSubType").get("v.value"); 
        console.log('Opportunity SubType: ' + opportunitySubType);
        
        if(opportunitySubType != '' && opportunitySubType != null){
            
            var OppRec = component.get("v.OppRec");      
            var OppAC = component.get("v.acRec");
            var OppEng = component.get("v.engRec");
                      
            var productLine = null;
            var opportunityType = component.find("selectedType").get("v.value");     
            
            console.log('Opportunity: ' + JSON.stringify(OppRec));
            console.log('Opportunity Type: ' + opportunityType);
            
            if(OppAC != null && opportunityType == 'Airframe')
                productLine = OppAC.Product_Line__c;
            
            if(OppAC != null && opportunityType == 'Aircraft Purchase')
                productLine = OppAC.Product_Line__c;
            
            if(OppAC != null && opportunityType == 'Avionics')
                productLine = OppAC.Product_Line__c;
            
            if(OppAC != null && opportunityType == 'Interior')
                productLine = OppAC.Product_Line__c;
            
            if(OppAC != null && opportunityType == 'Paint')
                productLine = OppAC.Product_Line__c;
            
            if(OppEng != null && opportunityType == 'APU')
                productLine = OppEng.Product_Line__c; 
            
            if(OppEng != null && opportunityType == 'ATF3')
                productLine = OppEng.Product_Line__c; 
            
            if(OppEng != null && opportunityType == 'CF34')
                productLine = OppEng.Product_Line__c; 
            
            if(OppEng != null && opportunityType == 'CFE738')
                productLine = OppEng.Product_Line__c; 
            
            if(OppEng != null && opportunityType == 'Engine-Other')
                productLine = OppEng.Product_Line__c; 
            
            if(OppEng != null && opportunityType == 'HTF')
                productLine = OppEng.Product_Line__c; 
            
            if(OppEng != null && opportunityType == 'PW300 Series')
                productLine = OppEng.Product_Line__c; 
            
            if(OppEng != null && opportunityType == 'TFE731')
                productLine = OppEng.Product_Line__c; 
            
            if(OppEng != null && opportunityType == 'TPE331')
                productLine = OppEng.Product_Line__c; 
            
            if(OppEng != null && opportunityType == 'AE3007')
                productLine = OppEng.Product_Line__c; 
            
            if(OppEng != null && opportunityType == 'PW600 Series')
                productLine = OppEng.Product_Line__c; 
            
            console.log('Opportunity Type: ' + opportunityType);        
            console.log('Product Line: ' + productLine);
            
            if(productLine != null){
                component.set('v.OppRec.Product_Line__c', productLine);
                
                var action = component.get("c.getSubType2");
                action.setParams({      
                    "productLine" : productLine,
                    "SubType": opportunitySubType
                });
                
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS") {
                        component.set("v.listOfSt2PerProductLine", response.getReturnValue());
                        var results = response.getReturnValue();
                        component.set("v.OppRec.SubType2__c", null);
                        console.log('Search Record: ' + JSON.stringify(results));
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
            }
        }
    },
    
    //Airframe Keyup Search
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        
        console.log('Keyword: ' + getInputkeyWord);
        
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component, event, getInputkeyWord);
            
            var acOpen = component.find("aircraftResults");
            $A.util.addClass(acOpen, 'slds-show');
            $A.util.removeClass(acOpen, 'slds-hide');
            
            var acSearchIcon = component.find("ac-SearchIcon");
            $A.util.addClass(acSearchIcon, 'slds-hide');
            $A.util.removeClass(acSearchIcon, 'slds-show');
            
            var acHideIcon = component.find("ac-CloseIcon");
            $A.util.addClass(acHideIcon, 'slds-show');
            $A.util.removeClass(acHideIcon, 'slds-hide'); 
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
        
    },
      
    //Engine Keyup Search
    keyPressEngController : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.EngineSearchKeyWord");    
        console.log('Keyword: ' + getInputkeyWord);
        
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchEngRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchEngHelper(component, event, getInputkeyWord);
            
            var engOpen = component.find("equipmentResults");
            $A.util.addClass(engOpen, 'slds-show');
            $A.util.removeClass(engOpen, 'slds-hide');
            
            var engSearchIcon = component.find("eng-SearchIcon");
            $A.util.addClass(engSearchIcon, 'slds-hide');
            $A.util.removeClass(engSearchIcon, 'slds-show');
            
            var engHideIcon = component.find("eng-CloseIcon");
            $A.util.addClass(engHideIcon, 'slds-show');
            $A.util.removeClass(engHideIcon, 'slds-hide');            
        }
        else{  
            component.set("v.listOfEngineSearchRecords", null ); 
            var forclose = component.find("searchEngRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
        
    },
    
    //SubType2 Keyup Search
    keyPressSt2Controller : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.St2SearchKeyWord");
        
        console.log('Keyword: ' + getInputkeyWord);
        
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchSt2Res");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchSt2Helper(component, event, getInputkeyWord);
            
            var st2Open = component.find("st2Results");
            $A.util.addClass(st2Open, 'slds-show');
            $A.util.removeClass(st2Open, 'slds-hide');
            
            var st2SearchIcon = component.find("st2-SearchIcon");
            $A.util.addClass(st2SearchIcon, 'slds-hide');
            $A.util.removeClass(st2SearchIcon, 'slds-show');
            
            var st2HideIcon = component.find("st2-CloseIcon");
            $A.util.addClass(st2HideIcon, 'slds-show');
            $A.util.removeClass(st2HideIcon, 'slds-hide');  
        }
        else{  
            component.set("v.listOfSt2SearchRecords", null ); 
            var forclose = component.find("searchSt2Res");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
        
    },
       
    //Closes aircraft Search Window
    aircraftCloseSearch : function(component, event, helper) {        
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-close');
        $A.util.removeClass(forOpen, 'slds-is-open');
        
        var acOpen = component.find("aircraftResults");
        $A.util.addClass(acOpen, 'slds-hide');
        $A.util.removeClass(acOpen, 'slds-show'); 
        
        var acSearchIcon = component.find("ac-SearchIcon");
        $A.util.addClass(acSearchIcon, 'slds-show');
        $A.util.removeClass(acSearchIcon, 'slds-hide');
        
        var acHideIcon = component.find("ac-CloseIcon");
        $A.util.addClass(acHideIcon, 'slds-hide');
        $A.util.removeClass(acHideIcon, 'slds-show');
        
        component.set("v.SearchKeyWord", null); 
        component.set("v.listOfSearchRecords", null); 
    },
    
    //Closes Engine Search Window
    engineCloseSearch : function(component, event, helper) {        
        var forOpen = component.find("searchEngRes");
        $A.util.addClass(forOpen, 'slds-is-close');
        $A.util.removeClass(forOpen, 'slds-is-open');
        
        var engOpen = component.find("equipmentResults");
        $A.util.addClass(engOpen, 'slds-hide');
        $A.util.removeClass(engOpen, 'slds-show'); 
        
        var engSearchIcon = component.find("eng-SearchIcon");
        $A.util.addClass(engSearchIcon, 'slds-show');
        $A.util.removeClass(engSearchIcon, 'slds-hide');
        
        var engHideIcon = component.find("eng-CloseIcon");
        $A.util.addClass(engHideIcon, 'slds-hide');
        $A.util.removeClass(engHideIcon, 'slds-show');
        
        component.set("v.EngineSearchKeyWord", null);
        component.set("v.listOfEngineSearchRecords", null);     
    },
    
    //Closes SubType2 Search Window
    st2CloseSearch : function(component, event, helper) {       
        var forOpen = component.find("searchSt2Res");
        $A.util.addClass(forOpen, 'slds-is-close');
        $A.util.removeClass(forOpen, 'slds-is-open');
        
        var st2Open = component.find("st2Results");
        $A.util.addClass(st2Open, 'slds-hide');
        $A.util.removeClass(st2Open, 'slds-show');
        
        var st2SearchIcon = component.find("st2-SearchIcon");
        $A.util.addClass(st2SearchIcon, 'slds-show');
        $A.util.removeClass(st2SearchIcon, 'slds-hide');
        
        var st2HideIcon = component.find("st2-CloseIcon");
        $A.util.addClass(st2HideIcon, 'slds-hide');
        $A.util.removeClass(st2HideIcon, 'slds-show');
        
        component.set("v.St2SearchKeyWord", null);
        component.set("v.listOfSt2SearchRecords", null);        
    },
    
    //Airframe Click Search
    searchAcController : function(component, event, helper) {
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        
        var acOpen = component.find("aircraftResults");
        $A.util.addClass(acOpen, 'slds-show');
        $A.util.removeClass(acOpen, 'slds-hide');
        
        var acSearchIcon = component.find("ac-SearchIcon");
        $A.util.addClass(acSearchIcon, 'slds-hide');
        $A.util.removeClass(acSearchIcon, 'slds-show');
        
        var acHideIcon = component.find("ac-CloseIcon");
        $A.util.addClass(acHideIcon, 'slds-show');
        $A.util.removeClass(acHideIcon, 'slds-hide');
    },
    
    //Engine Click Search
    searchEngController : function(component, event, helper) {        
        var forOpen = component.find("searchEngRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        
        var engOpen = component.find("equipmentResults");
        $A.util.addClass(engOpen, 'slds-show');
        $A.util.removeClass(engOpen, 'slds-hide'); 
        
        var engSearchIcon = component.find("eng-SearchIcon");
        $A.util.addClass(engSearchIcon, 'slds-hide');
        $A.util.removeClass(engSearchIcon, 'slds-show');
        
        var engHideIcon = component.find("eng-CloseIcon");
        $A.util.addClass(engHideIcon, 'slds-show');
        $A.util.removeClass(engHideIcon, 'slds-hide');
        
    },
    
    //SubType2 Click Search
    searchSt2Controller : function(component, event, helper) {
        
        var forOpen = component.find("searchSt2Res");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        
        var st2Open = component.find("st2Results");
        $A.util.addClass(st2Open, 'slds-show');
        $A.util.removeClass(st2Open, 'slds-hide');
        
        var st2SearchIcon = component.find("st2-SearchIcon");
        $A.util.addClass(st2SearchIcon, 'slds-hide');
        $A.util.removeClass(st2SearchIcon, 'slds-show');
        
        var st2HideIcon = component.find("st2-CloseIcon");
        $A.util.addClass(st2HideIcon, 'slds-show');
        $A.util.removeClass(st2HideIcon, 'slds-hide');     
    },
    
    //Clear Aircraft
    clear :function(component,event,helper){
        var eng = component.get('v.engRec');
        
        var pillTarget = component.find("lookup-pill");    
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');

        var lookUpTarget = component.find("lookupField");        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        var acSearch = component.find("ac-SearchIcon");
        $A.util.addClass(acSearch, 'slds-show');
        $A.util.removeClass(acSearch, 'slds-hide');        
        
        var acClose = component.find("ac-CloseIcon");
        $A.util.addClass(acClose, 'slds-hide');
        $A.util.removeClass(acClose, 'slds-show');
        
        component.set('v.OppRec.Product_Line__c', null); 
        component.set("v.OppRec.Type", null);
        component.set("v.OppRec.SubType__c", null);
        component.set("v.OppRec.SubType2__c", null);
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        
        //Clear Engine After Aircraft Change
        if(eng != null && eng.Name != 'NA'){
            var engPillTarget = component.find("eng-lookup-pill");
            var engLookUpTarget = component.find("eng-lookupField"); 
            
            $A.util.addClass(engPillTarget, 'slds-hide');
            $A.util.removeClass(engPillTarget, 'slds-show');
            
            $A.util.addClass(engLookUpTarget, 'slds-show');
            $A.util.removeClass(engLookUpTarget, 'slds-hide');
            
            component.set("v.engRec", null);
        }
        
        component.set("v.EngineSearchKeyWord", null);
        component.set("v.listOfEngineSearchRecords", null );    
        component.set("v.listOfEquipPerAircraft", null);
        
        //Clear SubType2
        var st2PillTarget = component.find("st2-lookup-pill");    
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        var st2LookUpTarget = component.find("st2-lookupField");       
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
       
        component.set("v.St2SearchKeyWord",null);
        component.set("v.St2SearchKeyWord",null);
        component.set("v.St2SearchKeyWord",null);
        component.set("v.listOfSt2SearchRecords", null );
        component.set("v.listOfSt2PerProductLine", null);
        component.set("v.st2Rec", null);     
    },
    
    //Clear Engine
    EngClear :function(component,event,helper){
        
        var pillTarget = component.find("eng-lookup-pill");
        var lookUpTarget = component.find("eng-lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.EngineSearchKeyWord",null);
        component.set("v.listOfEngineSearchRecords", null );

        var pillTarget = component.find("st2-lookup-pill");
        var lookUpTarget = component.find("st2-lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.St2SearchKeyWord",null);
        component.set("v.listOfSt2SearchRecords", null );
        component.set("v.listOfSt2PerProductLine", null);
        component.set("v.st2Rec", null);    
    },
    
    //Clear SubType2
    St2Clear : function(component,event,helper){
        
        var pillTarget = component.find("st2-lookup-pill"); 
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        var lookUpTarget = component.find("st2-lookupField");
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        var st2IconSearch = component.find("st2-SearchIcon");
        $A.util.addClass(st2IconSearch, 'slds-show');
        $A.util.removeClass(st2IconSearch, 'slds-hide');
        
        var st2IconClose = component.find("st2-CloseIcon");
        $A.util.addClass(st2IconClose, 'slds-hide');
        $A.util.removeClass(st2IconClose, 'slds-show');        
                
        component.set("v.St2SearchKeyWord",null);
        component.set("v.listOfSt2SearchRecords", null );
        component.set("v.st2Rec", null);
    },
    
    //Handles Aircraft Event   
    handleAC_ComponentEvent : function(component, event, helper) {
        
        var selectedAircraftGetFromEvent = event.getParam("aircraftByEvent");
        console.log('Selected Aircraft: ' + selectedAircraftGetFromEvent);
        component.set("v.acRec", selectedAircraftGetFromEvent); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var acOpen = component.find("aircraftResults");
        $A.util.addClass(acOpen, 'slds-hide');
        $A.util.removeClass(acOpen, 'slds-show');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
        
        component.set('v.OppRec.Product_Line__c', selectedAircraftGetFromEvent.Product_Line__c); 
        component.set("v.OppRec.Type", "Airframe");
        component.set("v.OppRec.SubType__c", null);
        component.set("v.OppRec.SubType2__c", null);
        
        //Clear Engine Field
        var eng = component.get('v.engRec');

        if(eng != null && eng.Name != 'NA'){
            var pillTarget = component.find("eng-lookup-pill");
            var lookUpTarget = component.find("eng-lookupField"); 
            
            $A.util.addClass(pillTarget, 'slds-hide');
            $A.util.removeClass(pillTarget, 'slds-show');
            
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide');
            
            component.set("v.engRec", null);
            component.set("v.EngineSearchKeyWord",null);
            component.set("v.listOfEngineSearchRecords", null );
        }
        
        var acId = selectedAircraftGetFromEvent.Id;
        
        console.log('Aircraft Id: ' + acId);
        helper.aircraftEquipmentChange( component, event, helper, acId);
        
    },
    
    //Handles Engine Event 
    handleEng_ComponentEvent : function(component, event, helper) {
        
        var selectedEquipGetFromEvent = event.getParam("equipmentByEvent");
        
        component.set("v.engRec", selectedEquipGetFromEvent); 
        
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
        
        if(selectedEquipGetFromEvent.Name != 'NA'){
            component.set('v.OppRec.Product_Line__c', selectedEquipGetFromEvent.Product_Line__c); 
            component.set("v.OppRec.Type", null);
            component.set("v.OppRec.SubType__c", null);
            component.set("v.OppRec.SubType2__c", null);
        }
        
        var engSearchIcon = component.find("eng-SearchIcon");
        $A.util.addClass(engSearchIcon, 'slds-show');
        $A.util.removeClass(engSearchIcon, 'slds-hide');
        
        var engHideIcon = component.find("eng-CloseIcon");
        $A.util.addClass(engHideIcon, 'slds-hide');
        $A.util.removeClass(engHideIcon, 'slds-show');
        
    },
    
    //Handles SubType2 Event 
    handleSt2_ComponentEvent : function(component, event, helper) {
        
        var selectedSt2GetFromEvent = event.getParam("st2ByEvent");
        
        component.set("v.st2Rec", selectedSt2GetFromEvent); 
        
        var forclose = component.find("st2-lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var st2Open = component.find("st2Results");
        $A.util.addClass(st2Open, 'slds-hide');
        $A.util.removeClass(st2Open, 'slds-show');
        
        var forclose = component.find("searchSt2Res");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("st2-lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
        
        var st2SearchIcon = component.find("eng-SearchIcon");
        $A.util.addClass(st2SearchIcon, 'slds-show');
        $A.util.removeClass(st2SearchIcon, 'slds-hide');
        
        var st2HideIcon = component.find("eng-CloseIcon");
        $A.util.addClass(st2HideIcon, 'slds-hide');
        $A.util.removeClass(st2HideIcon, 'slds-show');
        
    }
})