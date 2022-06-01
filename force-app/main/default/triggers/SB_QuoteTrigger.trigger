trigger SB_QuoteTrigger on SBQQ__Quote__c (before insert, after insert, before update, after update) {

    SB_QuoteTriggerHandler quoteTrigger = new SB_QuoteTriggerHandler();
    AddWorkQuoteTriggerHandler awqth = new AddWorkQuoteTriggerHandler();
    
    if(checkRecursive.runOnce()){ 
        if(Trigger.isBefore && Trigger.isInsert){
            quoteTrigger.updateFacilityAndAircraftForAmmendment(Trigger.new);
            awqth.BeforeAddWorkQuoteUpdates(Trigger.new); 
        } 

        if(Trigger.isBefore && Trigger.isUpdate){
            quoteTrigger.checkFacility(Trigger.new, 'Before Update');
            awqth.BeforeAddWorkQuoteUpdates(Trigger.new);
        }    
    }
     
    if(Trigger.isAfter){
        if(AddWorkQuoteTriggerHandler.afterRunOnce){
            AddWorkQuoteTriggerHandler.afterRunOnce = false;
            AddWorkQuoteTriggerHandler.afterAddWorkQuoteUpdates(Trigger.newMap); 
        }               
    }
}