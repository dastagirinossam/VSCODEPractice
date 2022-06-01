public with sharing class fslCreateServiceAuthorizations {
    
    @InvocableMethod   
    public static void CreateServiceAppointments(List<Id> woIDs){
        List<WorkOrder> wo = [SELECT Id,
                              Account.Name,
                              Country,
                              Equipment__r.Name,
                              Subject, 
                              StartDate, 
                              ContactId, 
                              EndDate, 
                              ServiceTerritoryId,
                              Equipment__c, 
                              Aircraft__c, 
                              Description, 
                              Crew_Size_Per_Work_Order__c FROM WorkOrder WHERE Id In: woIds];
        List<ServiceAppointment> sa = new List<ServiceAppointment>();
        
        for(WorkOrder w : wo){
            for(Integer i = 0; i < w.Crew_Size_Per_Work_Order__c; i++){
                ServiceAppointment s = new ServiceAppointment();
                s.ServiceTerritoryId = w.ServiceTerritoryId;
                s.Aircraft__c = w.Aircraft__c;
                s.Equipment__c = w.Equipment__c;
                s.ParentRecordId = w.Id;
                s.Subject = w.Subject;
                s.Description = w.Description;
                s.EarliestStartTime = w.StartDate;
                s.DueDate = w.EndDate;
                s.ContactId = w.ContactId;
                s.SchedStartTime = w.StartDate;
                s.SchedEndTime = w.EndDate;
                s.FSL__GanttLabel__c = w.Subject;
                sa.add(s);
            }
        }
        
        if(sa.Size()>0)
            insert sa;        
    }  
    
    @AuraEnabled
    public static List<Equipment__c> getEquipment(List<String> lstRecordId) {                  
        return [Select Id, Name from Equipment__c where Name in: lstRecordId];       
    }
    
    @AuraEnabled 
    public static String insertWO(String newWOsJSON) {
        List<Id> woIds = new List<Id>();
        List<WorkOrder> workOrders = new List<WorkOrder>();
        List<Object> newRawWOs = (List<Object>)JSON.deserializeUntyped(newWOsJSON);
        
        Integer i = 0;        
        for(Object nrWO : newRawWOs){ 
            Map<String, Object> woMap = (Map<String, Object>)newRawWOs[i];
            
            String po = null;
            String cs = null;
            String sd = null;
            String ed = null;
            
            workOrder wo =  new WorkOrder();                              
            wo.Equipment__c = (id) woMap.get('Equipment__c');            
                      
            cs = String.valueOf(woMap.get('Crew_Size_Per_Work_Order__c'));
            wo.Crew_Size_Per_Work_Order__c = (Decimal) Decimal.valueOf(cs);
            
            sd = String.valueOf(woMap.get('StartDate'));
            wo.StartDate = Datetime.valueOf(sd.replace('T',' '));
            
            ed = String.valueOf(woMap.get('EndDate'));
            wo.EndDate = Datetime.valueOf(ed.replace('T',' '));
            
            Datetime startDate = Datetime.valueOf(sd.replace('T',' '));// Start date
            Datetime endDate = Datetime.valueOf(ed.replace('T',' '));//End Date
                
            //integer intDays =  (startDate.Date().daysBetween(endDate.Date())*24);
            
           // wo.Duration = intDays;
            wo.WorkTypeId = (id) woMap.get('WorkTypeId');
            wo.ServiceTerritoryId = (id) woMap.get('ServiceTerritoryId');
            wo.AccountId = (id) woMap.get('AccountId');
            wo.ContactId = (id) woMap.get('ContactId');
            wo.Aircraft__c = (id) woMap.get('Aircraft__c');
            wo.AssetId = (id) woMap.get('AssetId');
            wo.CaseId = (id) woMap.get('CaseId');         
            wo.PO__c = (String) woMap.get('PO__c');
            wo.Status = (String) woMap.get('Status');
            wo.Priority = (String) woMap.get('Priority');
            wo.Subject = (String) woMap.get('Subject');
            wo.Description = (String) woMap.get('Description');
            wo.City = (String) woMap.get('City');
            wo.Country = (String) woMap.get('Country');
            wo.PostalCode = (String) woMap.get('PostalCode');
            wo.State = (String) woMap.get('State');
            wo.Street = (String) woMap.get('Street');
            workOrders.add(wo);
            i = i +1;
        }
        
        Database.SaveResult[] srList = Database.insert(workOrders);
        
        for (Database.SaveResult sr : srList){
            woIds.add(sr.getId());
        }
        
        List<WorkOrder> updateWorkOrders = new List<WorkOrder>();
        for(WorkOrder w : [Select Id, ParentWorkOrderId from WorkOrder where Id In: woIds]){
            if(w.Id != woIds[0]){
                w.ParentWorkOrderId = woIds[0];
                updateWorkOrders.add(w);
            }
        }
        
        if(updateWorkOrders.Size() > 0)
            update updateWorkOrders;
        
        if(woIds.Size() > 0)
            CreateServiceAppointments(woIds);
                
        return woIds[0];
    }
}