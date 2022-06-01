public with sharing class FSLCreateWorkOrderController {
    
    // Method to query the aircraft
    @AuraEnabled
    public static List<Aircraft__c> getAircraft(String aircraft) {
        return [ SELECT Id, Name FROM Aircraft__c WHERE Id = :aircraft ];         
    } 
    
    // Method to query the Equipment
    @AuraEnabled
    public static List<Equipment__c> getEquipments( List<String> lstEquipments ){ 
        return [ SELECT Id, Name, EnginePosition__c FROM Equipment__c WHERE Id IN: lstEquipments order by EnginePosition__c, Name asc];
    }
    
    // Method to insert the Work Order 
    @AuraEnabled 
    public static String insertWO(String newWOJSON, String newWOLIJSON) {  
        System.debug('In FSLCreateWorkOrderController - insertWO called.');
        System.debug('In FSLCreateWorkOrderController - newWOJSON :' + newWOJSON);
        System.debug('In FSLCreateWorkOrderController - newWOLIJSON :' + newWOLIJSON);
        
        List<Id> woIds = new List<Id>();
        
        string Part_91_135_121_str;
        String var_ServiceTerritoryId;
        
        List<WorkOrder> workOrders = new List<WorkOrder>();
        List<WorkOrderLineItem> woliList = new List<WorkOrderLineItem>();
        List<Object> newRawWOs = (List<Object>)JSON.deserializeUntyped(newWOJSON);
        system.debug('Wo: ' + newRawWOs);
        
        List<Object> newRawWOLIs = (List<Object>)JSON.deserializeUntyped(newWOLIJSON);
        
        map<id,ServiceTerritory>  ST_map = new map<id,ServiceTerritory>([select id, Name from ServiceTerritory]);
        for(Object nrWO : newRawWOs){ 
            Map<String, Object> woMap = (Map<String, Object>)nrWO;
            
            String cs = null;
            String sd = null;
            String ed = null;
            
            workOrder wo =  new WorkOrder();            
            
            cs = String.valueOf(woMap.get('Crew_Size_Per_Work_Order__c'));
            wo.Crew_Size_Per_Work_Order__c = (Decimal) Decimal.valueOf(cs);
            
            sd = String.valueOf(woMap.get('StartDate'));
            wo.StartDate = Datetime.valueOf(sd.replace('T',' '));
            
            ed = String.valueOf(woMap.get('EndDate'));
            wo.EndDate = Datetime.valueOf(ed.replace('T',' '));
            
            Datetime startDate = Datetime.valueOf(sd.replace('T',' '));// Start date
            Datetime endDate = Datetime.valueOf(ed.replace('T',' '));//End Date
            
            integer intDays =  (startDate.Date().daysBetween(endDate.Date())*9);
            
            if(intDays == 0)
                intDays = 9;
            
            wo.Duration = intDays;
            wo.WorkTypeId = (id) woMap.get('WorkTypeId');
            wo.CaseId = (id) woMap.get('CaseId');
            wo.ServiceTerritoryId = (id) woMap.get('ServiceTerritoryId');
            wo.Airport_Location__c = (id) woMap.get('Airport_Location__c');
            wo.AccountId = (id) woMap.get('AccountId');
            wo.ContactId = (id) woMap.get('ContactId');
            wo.Aircraft__c = (id) woMap.get('Aircraft__c'); 
            
            wo.Status = (String) woMap.get('Status');
            wo.Part_91_135_121__c = (String) woMap.get('Part_91_135_121__c');
            wo.RII_Required__c = (Boolean) woMap.get('RII_Required__c');
            
            var_ServiceTerritoryId = (String) woMap.get('ServiceTerritoryId');
            
            wo.Priority = (String) woMap.get('Priority');
            wo.Subject = (String) woMap.get('Subject');
            wo.Description = (String) woMap.get('Description');
            wo.Dispatch_Notes__c = (String) woMap.get('Dispatch_Notes__c');
            wo.Ship_To_City__c = (String) woMap.get('City');
            wo.Ship_to_Country__c = (String) woMap.get('Country');
            wo.Ship_to_Zip__c = (String) woMap.get('PostalCode');
            wo.Ship_To_State__c = (String) woMap.get('State');
            wo.Ship_To_Address__c = (String) woMap.get('Street');
            
            wo.City = (String) woMap.get('City');
            wo.Country = (String) woMap.get('Country');
            wo.PostalCode = (String) woMap.get('PostalCode');
            wo.State = (String) woMap.get('State');
            wo.Street = (String) woMap.get('Street');
            
            if(ST_map.containsKey((id) woMap.get('ServiceTerritoryId'))){
                system.debug((String) woMap.get('RPA_Work_Order__c')+'--22222---'+(ST_map.get((id) woMap.get('ServiceTerritoryId')).Name).startsWithIgnoreCase('us-'));
                if((ST_map.get((id) woMap.get('ServiceTerritoryId')).Name).startsWithIgnoreCase('us -')||(ST_map.get((id) woMap.get('ServiceTerritoryId')).Name).startsWithIgnoreCase('us-'))
                    wo.RPA_Work_Order__c = (String) woMap.get('RPA_Work_Order__c');
                else
                    wo.Navixa_Work_Order__c  = (String) woMap.get('RPA_Work_Order__c');  
            }
            
            workOrders.add(wo);
        }
        
        Try{     
            Database.SaveResult[] srList = Database.insert(workOrders);
            
            for (Database.SaveResult sr : srList){
                woIds.add(sr.getId());
            }
            
            
            
            if(woIds.Size() > 0)
                CreateServiceAppointments(woIds);
            
            Schema.DescribeSObjectResult WOLIRType = Schema.SObjectType.WorkOrderLineItem; 
            Map<String,Schema.RecordTypeInfo> rtMapByName = WOLIRType.getRecordTypeInfosByName();
            
            Integer i = 0;  
            if(woIds.size()>0){      
                for(Object nrWOLI : newRawWOLIs){ 
                    Map<String, Object> woliMap = (Map<String, Object>)newRawWOLIs[i];
                    
                    WorkOrderLineItem woli = new WorkOrderLineItem();
                    woli.WorkOrderId = woIds[0];
                    woli.Equipment__c = (id) woliMap.get('Equipment__c');
                    woli.PO__c = String.valueOf(woliMap.get('PO__c'));
                    if(rtMapByName.containskey('Equipment'))
                        woli.RecordTypeId =  rtMapByName.get('Equipment').recordtypeId ;
                    woliList.add(woli);            
                    i = i + 1;
                }
            }
            
            if( woliList.size() > 0 ){
                
                list<String>  Jobcard_list = new list<string>();
                string labelstring;
                if(ST_map.containsKey(var_ServiceTerritoryId)){
                    if((ST_map.get(var_ServiceTerritoryId).Name).startsWithIgnoreCase('us -')||(ST_map.get(var_ServiceTerritoryId).Name).startsWithIgnoreCase('us-')){
                        labelstring = System.Label.US_West_and_East;
                        
                        Jobcard_list = labelstring.split(',');
                    }else if((ST_map.get(var_ServiceTerritoryId).Name).containsIgnoreCase('EMEA')||(ST_map.get(var_ServiceTerritoryId).Name).containsIgnoreCase('Europe, the Middle East and Africa')){
                        labelstring = System.Label.EMEA;
                        Jobcard_list = labelstring.split(',');   
                    } 
                    
                    system.debug('--Jobcard_list--'+Jobcard_list);
                }         
                
                for(RPA_Job_Card__c RJC: [select id,Name from RPA_Job_Card__c where name In:Jobcard_list]){ //like '%RTS Administrative' Or name='Travel']) {
                    WorkOrderLineItem woli = new WorkOrderLineItem();
                    woli.WorkOrderId = woIds[0];
                    if(rtMapByName.containskey('Job Card'))
                        woli.RecordTypeId =  rtMapByName.get('Job Card').recordtypeId ;
                    woli.RPA_Job_Card__c = RJC.id;
                    woliList.add(woli);                 
                }
                
                insert woliList;  
                
                
            }
        }catch(exception e){
            
            System.debug('The following exception has occurred: ' + e.getMessage());
            string errorMessage ;
            errorMessage = '{\n' +
                ' "errorMsg" : "Please check the following in the WorkOrder: ",\n' +
                ' "errorMsgTitle" : "WorkOrder failed to create",\n' +
                ' "errorLine" : "' + e.getLineNumber() + '",\n' +
                ' "errorMessage" : "' + e.getMessage() + '"\n' +       
                '}';
            AuraHandledException ex = new AuraHandledException(errorMessage);
            ex.setMessage(errorMessage);
            if(!Test.isRunningTest())
                throw ex;
        }
        return woIds[0];
    }
    
    // Method to create Service Appointment based on the Screw Size in the WO. 
    @InvocableMethod   
    public static void CreateServiceAppointments(List<Id> woIDs){
        List<WorkOrder> wo = [SELECT Id,
                              AccountId,
                              Account.Name,
                              Country,
                              State,
                              City,
                              PostalCode,
                              Street,
                              Subject, 
                              StartDate, 
                              ContactId, 
                              EndDate, 
                              ServiceTerritoryId,
                              ServiceTerritory.Name,
                              Equipment__c, 
                              Aircraft__c,
                              RII_Required__c,
                              WorkTypeId,
                              WorkType.Name,
                              Description, Ship_to_Country__c, Ship_To_State__c, Ship_To_City__c, Ship_To_Address__c, Ship_to_Zip__c,
                              Crew_Size_Per_Work_Order__c FROM WorkOrder WHERE Id In: woIds];
        
        //Set Work Orders RII Autorizathion Names
        Set<String> woRII_Set = new Set<String>();
        for(WorkOrder woRII : WO){
            if(woRII.RII_Required__c){
                woRII_Set.add(woRII.Account.Name + ' - ' + woRII.WorkType.Name + ' - RII');
            }else{
                woRII_Set.add('NA');
            }
        }
        
        //Query RII Authorizations
        Set<String> existingRII = new Set<String>();
        for(RII_Authorization__c rii : [Select Name from RII_Authorization__c where Name In: woRII_Set]){
            existingRII.add(rii.Name);
        }
        
        //Find any missing RII Authorizations
        List<RII_Authorization__c> createRiiAuthorizationList = new List<RII_Authorization__c>();
        for(String w : woRII_Set){
            system.debug('w: '+ w);
            if(!existingRII.contains(w)){
                RII_Authorization__c newRII = new RII_Authorization__c();
                newRII.Name = w;
                
                createRiiAuthorizationList.add(newRII);
            }
            
        }
        
        //Create Missing Service Authorizations
        if(createRiiAuthorizationList.Size() > 0)
            insert(createRiiAuthorizationList);
        
        //Create Map for RII Authorizations
        Map<String, Id> riiMap = new Map<String, Id>();
        for(RII_Authorization__c rii : [Select Id, Name from RII_Authorization__c where Name In: woRII_Set]){
            riiMap.put(rii.Name, rii.Id);
        }
        
        //Create Service Appointments
        List<ServiceAppointment> sa = new List<ServiceAppointment>();
        for(WorkOrder w : wo){
            for(Integer i = 0; i < w.Crew_Size_Per_Work_Order__c; i++){
                String riiAuthorization;
                
                system.debug('RII Required: ' + w.RII_Required__c);
                
                if(w.RII_Required__c){
                    riiAuthorization = w.Account.Name + ' - ' + w.WorkType.Name + ' - RII';
                }else{
                    riiAuthorization = 'NA';
                }
                
                ServiceAppointment s = new ServiceAppointment();
                s.ServiceTerritoryId = w.ServiceTerritoryId;
                s.Aircraft__c = w.Aircraft__c;
                s.ParentRecordId = w.Id;
                s.Work_Order_ID__c = w.Id;
                s.Subject = w.Subject;
                
                //Assign RII Authorization
                s.RII_Authorization__c = riiMap.get(riiAuthorization);              
                s.SchedStartTime = w.StartDate;
                s.SchedEndTime = w.EndDate;
                s.Description = w.Description;
                s.EarliestStartTime = w.StartDate;
                s.DueDate = w.EndDate;
                s.ContactId = w.ContactId;
                s.FSL__GanttLabel__c = w.Subject;
                s.Country = w.Ship_to_Country__c;
                s.State = w.Ship_To_State__c;
                s.PostalCode = w.Ship_to_Zip__c;
                s.City = w.Ship_To_City__c;
                s.Street = w.Ship_To_Address__c;
                s.Work_Order__c = w.Id;
                sa.add(s);
                
            }
        }
        
        if(sa.Size()>0)
            insert sa;        
    }  
    
}