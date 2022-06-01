trigger WorkOrderDetailsTrigger on WO_Detail__c (before insert, before update) {  
     
    if(Trigger.isBefore){
        WorkOrderDetailsHandler handler = new WorkOrderDetailsHandler();
		handler.beforeInsertTrigger(Trigger.new); 
    }
                      
}