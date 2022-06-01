trigger AircraftTriggers on Aircraft__c (before insert, before update, after update, after insert) {
    
    if(Trigger.isBefore && trigger.isInsert)
        AircraftTriggerHandler.AircraftBeforeInsert(Trigger.new); 
    
	if(Trigger.isBefore && trigger.isUpdate)
    	AircraftTriggerHandler.AircraftBeforeUpdate(Trigger.newMap);
    
    if(Trigger.isAfter && trigger.isInsert)
        AircraftTriggerHandler.AircraftAfterInsert(trigger.newMap);
    
    if(Trigger.isAfter && trigger.isUpdate)
        AircraftTriggerHandler.AircraftAfterUpdate(trigger.newMap, Trigger.oldMap);
        
}