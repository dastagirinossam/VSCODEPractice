({
    
    showSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    
    initAircraft: function(component){
        var WorkTypeId = component.get("v.WorkTypeId");
        component.set("v.WorkTypeId", WorkTypeId);
        
        var CaseId = component.get("v.CaseId");
        component.set("v.CaseId", CaseId);
        
        var ServiceTerritoryId = component.get("v.ServiceTerritoryId");
        component.set("v.ServiceTerritoryId", ServiceTerritoryId);      
        
        var AirportLocationId = component.get("v.AirportLocationId");
        component.set("v.AirportLocationId", AirportLocationId);
        
        var AccountId = component.get("v.AccountId");
        component.set("v.AccountId", AccountId);
        
        var ContactId = component.get("v.ContactId");
        component.set("v.ContactId", ContactId);
        
        var StartDate = component.get("v.StartDate");
        component.set("v.StartDate", StartDate);
        
        var EndDate = component.get("v.EndDate");
        component.set("v.EndDate", EndDate);
        
        var Status = component.get("v.Status");
        component.set("v.Status", Status);
        
        var Priority = component.get("v.Priority");
        component.set("v.Priority", Priority);
        
        var Part_91_135_121 = component.get("v.Part_91_135_121");
        component.set("v.Part_91_135_121", Part_91_135_121);
        
        var RII_Required = component.get("v.RII_Required");
        component.set("v.RII_Required", RII_Required);
        
        var Subject = component.get("v.Subject");
        component.set("v.Subject", Subject);
        
        var Description = component.get("v.Description");
        component.set("v.Description", Description);
        
        var Dispatch_Notes = component.get("v.Dispatch_Notes");
        component.set("v.Dispatch_Notes", Dispatch_Notes);
        
        var City = component.get("v.City");
        component.set("v.City", City);
        
        var State = component.get("v.State");
        component.set("v.State", State);
        
        var Country = component.get("v.Country");
        component.set("v.Country", Country);
        
        var PostalCode = component.get("v.PostalCode");
        component.set("v.PostalCode", PostalCode);
        
        var Street = component.get("v.Street");
        component.set("v.Street", Street);
        
        var System_po = component.get("v.System_po");
        component.set("v.System_po", System_po);
            
        var action = component.get("c.getAircraft");
        action.setParams({
            aircraft : component.get('v.Aircraft')  
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.woAircraft",a.getReturnValue()); 
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }
        });
        $A.enqueueAction(action);
    },
    
    
    initEquipment : function(component) {
        var array = [];
        
        var Equipment1 = component.get("v.Equipment1");
        if(Equipment1 != null)
            array.push(Equipment1);
        
        var Equipment2 = component.get("v.Equipment2");
        if(Equipment2 != null)
            array.push(Equipment2);
        
        var Equipment3 = component.get("v.Equipment3");
        if(Equipment3 != null)
            array.push(Equipment3);
        
        var APU = component.get("v.APU");
        if(APU != null)
            array.push(APU);
              
        var action = component.get('c.getEquipments');
        action.setParams({"lstEquipments": array}); 
        action.setCallback(this, function(s) {
            component.set("v.woEquipment", s.getReturnValue());
        });
        $A.enqueueAction(action);
        
    },
    
    createWO : function(component) {
        var spinner = component.find("mySpinner");
        
        var woWorkTypeId = component.get("v.WorkTypeId");
        var woCaseId = component.get("v.CaseId");
        var woServiceTerritoryId = component.get("v.ServiceTerritoryId");
        var woAirportLocationId  = component.get("v.AirportLocationId");
        var woAccountId = component.get("v.AccountId");
        var woContactId = component.get("v.ContactId");
        var woAircraft = component.get("v.Aircraft");    
        var woCaseId = component.get("v.CaseId");
        var woStartDate = component.get("v.StartDate");        
        var woEndDate = component.get("v.EndDate");       
        var woStatus = component.get("v.Status");    
        var woPriority = component.get("v.Priority");        
        var woSubject = component.get("v.Subject");      
        var woDescription = component.get("v.Description");       
        var woCity = component.get("v.City");      
        var woState = component.get("v.State");        
        var woCountry = component.get("v.Country");             
        var woPostalCode = component.get("v.PostalCode"); 
        var woStreet = component.get("v.Street");       
        var getEqId = component.find("aircraftId");
        var getCrewSize = component.find("crewSize");
        var getEqId = component.find("equipmentId");
        var getPoNo = component.find("PONumbers");
        var woLINumbers = component.get("v.woEquipment");
        var MSTDispatch = component.get("v.MSTDispatch");
        var woPart_91_135_121 = component.get("v.Part_91_135_121");
        var woRII_Required = component.get("v.RII_Required");
        var woSystem_po = component.get("v.System_po");
        var woDispatch_Notes = component.get("v.Dispatch_Notes");
        var newWorkOrder = [];
        var newWOLIs = [];
        var crewSize = getCrewSize.get("v.value");
        
        if( crewSize == null || crewSize === undefined){
            console.log('Yes');
            alert('Please enter Crew size. Maximum crew size that can be entered is 5.');
            this.hideSpinner(component);
            return;
        }
        
        newWorkOrder.push({ 
            Crew_Size_Per_Work_Order__c : getCrewSize.get("v.value"),
            WorkTypeId : woWorkTypeId,
            CaseId : woCaseId,
            ServiceTerritoryId : woServiceTerritoryId,
            Airport_Location__c : woAirportLocationId,
            AccountId : woAccountId,
            ContactId : woContactId,
            Aircraft__c : woAircraft,
            MST_Dispatch__c : MSTDispatch,
            StartDate : woStartDate,
            EndDate : woEndDate,
            Status : woStatus,
            Priority : woPriority,
            Part_91_135_121__c: woPart_91_135_121,
            RPA_Work_Order__c:woSystem_po,
            Subject : woSubject,
            Description : woDescription,
            City : woCity,
            Country : woCountry,
            PostalCode : woPostalCode,
            State : woState,
            Street : woStreet,  
            Dispatch_Notes__c : woDispatch_Notes,
            RII_Required__c : woRII_Required      
        })
        
        console.log('--newWorkOrder---'+newWorkOrder);
        console.log('v.System_po'+woSystem_po);
        console.log('in helper before looping over wolis')
        console.log('getEqId : ' + getEqId)
        console.log('getPoNo : ' + getPoNo)
        
        for (var i = 0; i < woLINumbers.length; i++) {
            var po = null;
            var equip = null;
            if(woLINumbers.length == 1){
                equip = getEqId.get("v.value");
                po = getPoNo.get("v.value");
            }
            else{
                equip = getEqId[i].get("v.value");
                po = getPoNo[i].get("v.value");
            }
            console.log('equip : ' + equip)
            console.log('po : ' + po)
            newWOLIs.push({ 
                Equipment__c : equip,               
                PO__c : po,                          
            })
        }
        
        console.log('calling action');
        console.log('JSON.stringify(newWorkOrder : ' + JSON.stringify(newWorkOrder));
        console.log('JSON.stringify(newWOLIs : ' + JSON.stringify(newWOLIs));
        
        var action = component.get('c.insertWO');
        var navigate = component.get('v.navigateFlow');
        action.setParams({"newWOJSON" : JSON.stringify(newWorkOrder), "newWOLIJSON" :JSON.stringify(newWOLIs)});
        action.setCallback(this, function(woId){
            var state = woId.getState();
            if (state === "SUCCESS") {
                console.log('Work Order Created: '+ woId.getReturnValue());              
                var url = window.location.href;
                if(url.includes('apex/fslCreateCase')){
                    console.log('True: ' + url);
                    window.open('/' + woId.getReturnValue());
                    $A.util.addClass(spinner, "slds-hide");
                    navigate('FINISH');
                }else{               
                    $A.util.addClass(spinner, "slds-hide");
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        'url' : '/' + woId.getReturnValue()
                    });
                    urlEvent.fire();
                }
            }else if (state === "ERROR"){
                 var resultsToast = $A.get("e.force:showToast");
                var errors = JSON.parse(JSON.stringify(woId.getError()));
                var mesge = JSON.parse(errors[0].message);
               // alert(JSON.stringify(mesge));
                
                var errorMessage = mesge.errorMsg;
                var newErrorMessage = errorMessage.replaceAll('/n','\n');

                resultsToast.setParams({
                    mode: 'sticky',
                    type : 'error',
                    title : mesge.errorMsgTitle,
                    message: mesge.errorMessage,
                    messageTemplate: newErrorMessage + '{1}',
                           
                });
                
                resultsToast.fire();
                  $A.get('e.force:refreshView').fire();
                //var dismissActionPanel = $A.get("e.force:closeQuickAction");
                //dismissActionPanel.fire();
                //dismissActionPanel
                //if( dismissActionPanel === '')
                 navigate('BACK');
                
                
            }
        });
        $A.enqueueAction(action);
    }
    
})