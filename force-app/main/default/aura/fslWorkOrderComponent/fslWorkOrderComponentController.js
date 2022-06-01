({
    doInit : function(component, event, helper) {
        var woRecords = component.get("v.WorkOrderRecords");
        
        var WorkTypeId = component.get("v.WorkTypeId");
        component.set("v.WorkTypeId", WorkTypeId);
        
        var ServiceTerritoryId = component.get("v.ServiceTerritoryId");
        component.set("v.ServiceTerritoryId", ServiceTerritoryId);
        
        var AccountId = component.get("v.AccountId");
        component.set("v.AccountId", AccountId);
        
        var ContactId = component.get("v.ContactId");
        component.set("v.ContactId", ContactId);
        
        var Aircraft = component.get("v.Aircraft");
        component.set("v.Aircraft", Aircraft);
        
        var CaseId = component.get("v.CaseId");
        component.set("v.CaseId", CaseId);
        
        var StartDate = component.get("v.StartDate");
        component.set("v.StartDate", StartDate);
        
        var EndDate = component.get("v.EndDate");
        component.set("v.EndDate", EndDate);
        
        var Status = component.get("v.Status");
        component.set("v.Status", Status);
        
        var Priority = component.get("v.Priority");
        component.set("v.Priority", Priority);
        
        var Subject = component.get("v.Subject");
        component.set("v.Subject", Subject);
        
        var Description = component.get("v.Description");
        component.set("v.Description", Description);
        
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
        
        var array = [];       
        array = woRecords.split('; ');
        
        var action = component.get('c.getEquipment');
        
        action.setParams({"lstRecordId": array});
        action.setCallback(this, function(s) {
            component.set("v.woEquipment", s.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    onButtonPressed: function(cmp, event, helper) {
        // Figure out which action was called
        var actionClicked = event.getSource().getLocalId();
        // Fire that action
        var navigate = cmp.get('v.navigateFlow');
        navigate(actionClicked);
    },
    
    createWorkOrders: function(component, event, helper){
        var woNumbers = component.get("v.woEquipment");
        
        var woWorkTypeId = component.get("v.WorkTypeId");
        var woServiceTerritoryId = component.get("v.ServiceTerritoryId");
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
        var getEqId = component.find("eqId");
        var getPoNo = component.find("poNumbers");
        var getCrewSize = component.find("crewSize");
        
        var equip = null;
        var po = null;
        var cs = null;
        
        var newWorkOrders = [];        
        for (var i = 0; i < woNumbers.length; i++) {
            
            if(woNumbers.length == 1){
                equip = getEqId.get("v.value");
                po = getPoNo.get("v.value");
                cs = getCrewSize.get("v.value");
            }else{
                equip = getEqId[i].get("v.value");
                po = getPoNo[i].get("v.value");
                cs = getCrewSize[i].get("v.value");
            }
            
            newWorkOrders.push({ 
                Equipment__c : equip,               
                PO__c : po,
                Crew_Size_Per_Work_Order__c : cs,
                WorkTypeId : woWorkTypeId,
                ServiceTerritoryId : woServiceTerritoryId,
                AccountId : woAccountId,
                ContactId : woContactId,
                Aircraft__c : woAircraft,
                CaseId : woCaseId,
                StartDate : woStartDate,
                EndDate : woEndDate,
                Status : woStatus,
                Priority : woPriority,
                Subject : woSubject,
                Description : woDescription,
                City : woCity,
                Country : woCountry,
                PostalCode : woPostalCode,
                State : woState,
                Street : woStreet                           
            })
        }
        
        var action = component.get('c.insertWO');
        action.setParams({"newWOsJSON" : JSON.stringify(newWorkOrders)});
        action.setCallback(this, function(woId){
            var state = woId.getState();
            if (state === "SUCCESS") {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": woId.getReturnValue(),
                    "slideDevName": "related"
                });
                navEvt.fire();
            }
            /*else{
                var errors = woId.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error: ",
                    "message": errors
                });
                toastEvent.fire(); 
            }*/
        });
        
        $A.enqueueAction(action);         
    },
    
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true); 
    },
    
    hideSpinner : function(component,event,helper){   
        component.set("v.spinner", false);
    }
    
})