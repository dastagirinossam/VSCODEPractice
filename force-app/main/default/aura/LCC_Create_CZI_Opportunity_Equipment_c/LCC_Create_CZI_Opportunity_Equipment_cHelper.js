({
    /*
     * This methid takes recordTypeId and entityTypeName parameters
     * and invoke standard force:createRecord event to create record
    * if recordTypeIs is blank, this will create record under master recordType
     * */
    showCreateRecordModal : function(component, recordTypeId, entityApiName) {
        var recordId = component.get("v.recordId");
         var action= component.get("c.eqpOpportunity");
        action.setParams({
            eqpID : recordId 
        });  
        action.setCallback(this,function(response){
            var state= response.getState();
            $A.log(response);
            if(state == "SUCCESS"){
                  var wrpRec = response.getReturnValue();

        var createRecordEvent = $A.get("e.force:createRecord");
                
            $A.get("e.force:closeQuickAction").fire();
        if(createRecordEvent){ 
                createRecordEvent.setParams({
                   "entityApiName": "Opportunity","recordTypeId": recordTypeId,
                        "defaultFieldValues": {
                            'AccountId' : wrpRec.euipRec.Account_ID__c,
                            'Name' : wrpRec.userRec.Alias,
                            'Equipment__c' : wrpRec.euipRec.X18_Character_Equipment_ID__c,
                            'Product_Line__c' : wrpRec.euipRec.Product_Line__c,
                            'Type' : wrpRec.euipRec.RecordType.Name,
                            'SubType__c':'TFE731 - CZI',
                            'LeadSource' : 'SFDC Next Maintenance Event Calculation',
                            'Tier_Level__c' : '3',
                            'CloseDate' : wrpRec.euipRec.CZI_Oppty_Close_Date__c,
                            'InputDate__c' : wrpRec.euipRec.Next_CZI_Date__c,
                            'OutputDate__c' : wrpRec.euipRec.CZI_Oppty_Output_Date__c,
                            'StageName' : 'New Opportunity',
                            'RSM__c' : wrpRec.euipRec.RSM__c,
                            'Aircraft__c' : wrpRec.euipRec.Aircraft__c,
                           //'SubType2__c' : wrpRec.euipRec.CZI_Sub_Type_2__c
                            
                            
                            
                            
                            
                        }     
                });
            } 
            createRecordEvent.fire();
        }
      });
      $A.enqueueAction(action);  
      
    },
    /*
     * closing quickAction modal window
     * */
    closeModal : function(){
        var closeEvent = $A.get("e.force:closeQuickAction");
        if(closeEvent){
        closeEvent.fire();
        } else{
            alert('force:closeQuickAction event is not supported in this Ligthning Context');
        }
    },
})