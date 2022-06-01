trigger ProjectsTrigger on MPM4_BASE__Milestone1_Project__c (before insert, before update, after insert, after update) {
    
    if(Trigger.isBefore){        
        ProjectsTriggerHelper.runOnceBefore = false;
        
        if(Trigger.isInsert){
            System.debug('before insert');
            ProjectsTriggerHelper.BeforeInsertProject(Trigger.new); 
        }
        
        if(Trigger.isUpdate && ProjectsTriggerHelper.runOnceBefore == true){
            ProjectsTriggerHelper.BeforeUpdateProject(Trigger.newMap, Trigger.oldMap);  
            System.debug('before update');           
        }
        
        if(Trigger.isUpdate && Test.isRunningTest())
        	ProjectsTriggerHelper.BeforeUpdateProject(Trigger.newMap, Trigger.oldMap);         
    }
       
    if(Trigger.isAfter){
        ProjectsTriggerHelper.runOnceAfter = false;
        
        if(Trigger.isInsert){
            System.debug('after insert');
            ProjectsTriggerHelper.AfterInsertProject(Trigger.newMap);
            ProjectsTriggerHelper.handleBrokerAccess(Trigger.new);
        }
        
        if(Trigger.isUpdate){
            System.debug('after update');
            ProjectsTriggerHelper.AfterUpdateProject(Trigger.newMap, Trigger.oldMap);  
            ProjectsTriggerHelper.revokeBrokerAccess(Trigger.oldMap,Trigger.new);
            ProjectsTriggerHelper.handleBrokerAccess(Trigger.new);
        }
    }     
}