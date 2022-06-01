trigger EquipmentTriggers on Equipment__c (after insert, after update, before insert, before update) {

    if(Trigger.isBefore)
        EquipmentTriggerHandler.EquipmentBefore(Trigger.new);
    
    if(Trigger.isAfter)
        EquipmentTriggerHandler.EquipmentAfter(trigger.newMap, Trigger.oldMap);

}