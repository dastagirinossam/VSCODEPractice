Global class ProcessBuilderApexCalss implements Database.Batchable<sobject> {
    
    Global database.QueryLocator start(Database.BatchableContext bc){
        return database.getQueryLocator([Select Id, Name, CloseDate, InputDate__c, Reached_Date__c, ReachedDate__c, Contact__c, StageName, Oppty_Trigger_Update__c
                                         FROM Opportunity 
                                         where 
                                         (Reached_Date__c = 'Yes' and ReachedDate__c = false) or 
                                         (Reached_Date__c = 'No' and ReachedDate__c = true)
                                        ]);
    }
    
    Global void execute(Database.BatchableContext bc,list<opportunity> scope){
        Id newOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();
        Date fDate = Date.Today().addDays(365);
        
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        
        for(Opportunity opp: scope){
            if(opp.Reached_Date__c == 'Yes' && !opp.ReachedDate__c){
                opp.ReachedDate__c = true;         
            }else if(opp.Reached_Date__c == 'No' && opp.ReachedDate__c){
                opp.ReachedDate__c = false;
            }
            
            oppListToUpdate.add(opp);                          
        }
        
      if(!oppListToUpdate.isEmpty() && oppListToUpdate !=null){
            Database.SaveResult[] results = Database.Update(oppListToUpdate, false);
            
            for (Database.SaveResult sr : results) {
                if (sr.isSuccess()) {
                    System.debug('Successfully Success: ' + sr.getId());
                    
                }else {
                    System.debug('Successfully failed: ' + sr.getId());
                    
                }
            }
        }      
    }
    
    Global void finish(database.BatchableContext bc){        
    }  
    
}