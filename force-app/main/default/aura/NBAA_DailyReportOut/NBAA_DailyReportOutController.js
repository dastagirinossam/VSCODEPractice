({
    doInit: function(component, event, helper) {
        // Prepare a new record from template
        component.find("NBAA_DailyReportOut_RecordCreator").getNewRecord(
            "NBAA_Daily_Report_Outs__c", // sObject type (objectApiName)
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newNBAA_DailyReportOut");
                var error = component.get("v.newNBAA_DailyReportOutError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    component.set('v.showSpinner', false);
                    return;
                }
                console.log("Record template initialized: " + rec.apiName);
                component.set('v.showSpinner', false);
            })
        );     
    },
    
    handleSaveNBAA_DailyReportOut: function(component, event, helper) {
        
        component.set('v.showSpinner', true);     
        component.find("NBAA_DailyReportOut_RecordCreator").saveRecord(function(saveResult) {
            
            component.set('v.showSpinner', false);
            
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                
                // record is saved successfully                                                          
                component.set('v.saved', true); 
                
            } else if (saveResult.state === "INCOMPLETE") {
                // handle the incomplete state
                console.log("User is offline, device doesn't support drafts.");
                component.set('v.showSpinner', false);
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                console.log('Problem saving Entry, error: ' + JSON.stringify(saveResult.error));
                component.set('v.showSpinner', false);
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                component.set('v.showSpinner', false);
            }
        });
    },
    
    handleError: function(cmp, event, helper) {    
        cmp.set('v.showSpinner', false);
    },
    
    handleSuccess: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
        cmp.set('v.saved', true);
    },
    
    handleCancel: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" : '/'
        });
        urlEvent.fire();
    },
    
    handleClear : function(component, event, helper){
        var emptyFields = component.get('v.simpleNewNBAA_DailyReportOut');
        emptyFields.Customer_Name__c = '';
        emptyFields.Input_Date_Induction_Date__c = '';
        emptyFields.Amount__c = '';
        emptyFields.Product_Line_Type__c = '';
        emptyFields.Sales_Stage__c = ''; 
        emptyFields.Workscope__c = ''; 
        emptyFields.Comments__c = '';
        emptyFields.Market_Intelligence__c = '';
        emptyFields.Recruitment_Entry__c = '';
        component.set('v.simpleNewNBAA_DailyReportOut', emptyFields);
    },
    
    createNBAA_DailyReportOut : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" : '/nbaa-daily-report-out'
        });
        urlEvent.fire();
    },
    
    showEntries : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" : '/nbaa-daily-report-outs/NBAA_Daily_Report_Outs__c/00B5Y00000GYBrzUAH'
            });
        urlEvent.fire();
    }
})