trigger fslTmeCardTrigger on Time_Card__c (after insert, after update) {
           
    Map<String, Decimal> actualTimeMap = new Map<String, Decimal>();
    List<ServiceAppointment> saList = new List<ServiceAppointment>();
    Set<Id> saId = new Set<Id>();
    
    if (Trigger.isAfter ) {
        for (Time_Card__c tc : Trigger.new) {
            saId.add(tc.Service_Appointment__c);
        }
    }
    
    for (AggregateResult ar : [SELECT Service_Appointment__c, Sum(Actual_Duration__c) ad FROM Time_Card__c WHERE Service_Appointment__c IN: saId GROUP BY Service_Appointment__c]) {
        actualTimeMap.put((String)ar.get('Service_Appointment__c'), (Decimal)ar.get('ad'));
    }
    
    for(ServiceAppointment s : [Select Id, Total_Performed_Mx_Time__c from ServiceAppointment where Id In: saID]){
        s.Total_Performed_Mx_Time__c = actualTimeMap.get(s.id);
        saList.add(s);
    }
    
    update saList;
}