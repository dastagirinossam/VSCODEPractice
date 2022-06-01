trigger AddWorkStatus on SBQQ__QuoteLine__c (before update, before insert, after update) {
    system.debug('entered trigger');
    
  AddWork_Trigger_Setting__c TS = AddWork_Trigger_Setting__c.getValues('AddWork');
    
 if(TS.IsActive__c){
        // Added by Krunal
        if(!Triggers.AddWorkStatusTrigger_Disabled){
            
            if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert)){      
                if(Trigger.isBefore && (Trigger.isInsert)){           
                    AddWorkStatusHelper.updateFieldsFromProject(Trigger.new);
                }
                
                AddWorkStatusHelper.populateSpecification(Trigger.new,Trigger.newMap,Trigger.isUpdate,Trigger.isInsert);       
            }
            
            if(Trigger.isAfter){
                if(Trigger.isUpdate){
                    
                    system.debug('entered quotelineitems handler');
                    recursiveClassforSpace.isFirstTime = false;
                    AddWorkStatusHelper.updateFieldsOnProject(Trigger.newMap);
                }
            }
        }
 }
}