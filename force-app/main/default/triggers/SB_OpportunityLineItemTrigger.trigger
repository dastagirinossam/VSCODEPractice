trigger SB_OpportunityLineItemTrigger on OpportunityLineItem (before insert, before update) {
    
    
    if(Trigger.isBefore	&& Trigger.isInsert){
    	SB_OpportunityLineItemTriggerHandler.updateDiscount(Trigger.new) ;
    }
    
    if(Trigger.isBefore	&& Trigger.isUpdate){
    	SB_OpportunityLineItemTriggerHandler.updateDiscountUpdate(Trigger.new) ;
    }

}