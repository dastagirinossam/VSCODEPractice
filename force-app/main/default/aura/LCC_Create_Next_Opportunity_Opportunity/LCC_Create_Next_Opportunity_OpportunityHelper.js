({
    /*
     * This methid takes recordTypeId and entityTypeName parameters
     * and invoke standard force:createRecord event to create record
    * if recordTypeIs is blank, this will create record under master recordType
     * */
    showCreateRecordModal : function(component, recordTypeId, entityApiName) {
        var recordId = component.get("v.recordId");
        var action= component.get("c.OppRecord");
        action.setParams({
            OppId : recordId 
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
                                    'AccountId' : wrpRec.Opp.AccountId,
                                    'Name' : wrpRec.Opp.Name,
                                    'Equipment__c' : wrpRec.Opp.Equipment__c,
                                    'Type' : wrpRec.Opp.Type,
                                    'SubType__c':wrpRec.Opp.SubType__c,
                                    'LeadSource' : wrpRec.Opp.LeadSource,
                                    'WasCloned__c' : true,
                                    'CloseDate' : wrpRec.Opp.CloseDate,
                                    'InputDate__c' : wrpRec.Opp.InputDate__c,
                                    'OutputDate__c' : wrpRec.Opp.OutputDate__c,
                                    'StageName' : wrpRec.Opp.StageName,
                                    'RSM__c' : wrpRec.Opp.RSM__c,
                                    'Aircraft__c' : wrpRec.Opp.Aircraft__c,
                                    'Product__c' : wrpRec.Opp.Product__c,
                                    'Amount' : wrpRec.Opp.Amount,
                                    'Opportunity_Name_Override__c' : wrpRec.Opp.Opportunity_Name_Override__c,
                                    'Opportunity_Name_Details__c' : wrpRec.Opp.Opportunity_Name_Details__c,
                                    'Operator__c' : wrpRec.Opp.Operator__c,
                                    'Facility__c' : wrpRec.Opp.Facility__c,
                                    'CustomerName__c' : wrpRec.Opp.CustomerName__c,
                                    'NextStepCode__c' : 'U - Unassigned ',
                                    'Base_Quote_Number__c' : wrpRec.Opp.Base_Quote_Number__c,
                                    'Quote_Amendment__c' : wrpRec.Opp.Quote_Amendment__c,
                                    'QuoteNum__c' : wrpRec.Opp.QuoteNum__c,
                                    'Quote_Revision_Number__c' : wrpRec.Opp.Quote_Revision_Number__c,
                                    'Next_Step_Dialogue__c' : wrpRec.Opp.Next_Step_Dialogue__c, 
                                    'Sub_Type_3__c' :  wrpRec.Opp.Sub_Type_3__c,
                                    'SubType2__c' : wrpRec.Opp.CZI_Sub_Type_2__c,
                                    'Product_Line__c' : wrpRec.Opp.Product_Line__c
                                    
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