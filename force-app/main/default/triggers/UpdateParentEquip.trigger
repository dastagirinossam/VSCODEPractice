trigger UpdateParentEquip on Flight_Hours__c (before insert, before update) {


for (flight_hours__c fh: Trigger.new) {

 {
    (fh.Parent_equipment__c = fh.Equipment__c) ;
    }
}
}