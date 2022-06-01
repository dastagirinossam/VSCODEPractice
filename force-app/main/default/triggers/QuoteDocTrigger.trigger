trigger QuoteDocTrigger on SBQQ__QuoteDocument__c (before insert, after insert) {    
    
    if(Trigger.isBefore && Trigger.isInsert){
        QuoteDocTriggerHandler.beforeTrigger(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        set<Id> Qids = new set<Id>();
        set<Id> Qdids = new set<Id>();
        for(SBQQ__QuoteDocument__c q: Trigger.new){
            
          Qids.add(q.SBQQ__Quote__c);  
          Qdids.add(q.Id);  
        }
             QuoteDocTriggerHandler.afterTrigger(Qdids);
             }
	
}