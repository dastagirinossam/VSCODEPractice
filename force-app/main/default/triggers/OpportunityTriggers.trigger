trigger OpportunityTriggers on Opportunity (after insert, after update, before update, before insert) {
    
    if(!Triggers.OpportunityTrigger_Disabled){
        if(checkRecursive.runOnce()){  
            if(Trigger.isBefore && Trigger.isInsert){
                SB_OpportunityTriggerHandler.OpportunityBeforeInsert(Trigger.new);
                OpportunityTriggerHandler.BeforeInsertMAO(Trigger.new);
            } 
            
            if(Trigger.isBefore && Trigger.isUpdate){
                
                OpportunityTriggerHandler.relationDisestablishment(trigger.newMap,trigger.oldMap);
                
                SB_OpportunityTriggerHandler.updateAmountsInQuote(Trigger.newMap);
                OpportunityTriggerHandler.BeforeUpdateMAO(Trigger.newMap, Trigger.oldMap);
                
                
            }     
        }
        
        if(Trigger.isAfter){
            
            // system.debug('trigger.new'+trigger.new);
            for(opportunity p: trigger.new){
                //   system.debug('p.MasterOpportunitylookup__c'+p.MasterOpportunitylookup__c+'p.Associated_Opportunity_02__c'+p.Associated_Opportunity_02__c); 
            }
            if(!OpportunityTriggerHandler.runAfter){
                OpportunityTriggerHandler.runAfter = true;
                OpportunityTriggerHandler.updateAfterMAO(Trigger.newMap);            
            }
            if(trigger.isUpdate)    {
                system.debug('trigger.new'+trigger.new);
                updateMasterAmounttoZero.addNegativeProduct(trigger.New);
            }
        }    
    }
}