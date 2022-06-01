public class AddWorkQuoteTriggerHandler {

    private static Id awqRecType = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Add Work Quote').getRecordTypeId();
    public static Boolean afterRunOnce = true;

    public void BeforeAddWorkQuoteUpdates(List<SBQQ__Quote__c> awq){
    
        Set<Id> quoteProj = new Set<Id>();       
        for(SBQQ__Quote__c q : awq){ 
            if(q.RecordTypeId == awqRecType && q.Project__c != null){
                if(!quoteProj.contains(q.Project__c))
                    quoteProj.add(q.Project__c);
            }
        }
        
        if(!quoteProj.IsEmpty())
            PopulateQuote(awq, quoteProj);       
    }
     
    //Populate Quote From Project
    public static void PopulateQuote(List<SBQQ__Quote__c> awq, Set<Id> quoteProj){
        
        Map<Id, MPM4_BASE__Milestone1_Project__c> projMap= new Map<Id, MPM4_BASE__Milestone1_Project__c>([Select Id, 
                                                                                                          Designated_Approver__c, 
                                                                                                          DesignatedApproverProfileId__c, 
                                                                                                          Secondary_Approver__c, 
                                                                                                          X3_Approver__c, 
                                                                                                          X4_Approver__c,
                                                                                                          X5_Approver__c, 
                                                                                                          X6_Approver__c, 
                                                                                                          GroupId_of_Designated_Approver__c, 
                                                                                                          MPM4_BASE__Account__r.Name, 
                                                                                                          MPM4_BASE__Account__c, 
                                                                                                          Aircraft__c, 
                                                                                                          Aircraft__r.Aircraft_Model_2011__c, 
                                                                                                          Aircraft__r.ACReg__c, 
                                                                                                          Aircraft__r.Aircraft_SN__c, Engine__r.Name, Engine__r.Model__c, 
                                                                                                          CPM_Name__c, 
                                                                                                          CPM__c,
                                                                                                          Airframe_Crew_Chief__r.Name,
                                                                                                          Avionics_Crew_Chief__r.Name,
                                                                                                          Engine_Crew_Chief__r.Name,
                                                                                                          BackupCPM__c, 
                                                                                                          Work_Order__c 
                                                                                                          from MPM4_BASE__Milestone1_Project__c where Id In: quoteProj]);
       
        for(SBQQ__Quote__c q : awq){                            
            q.Account_Name__c = projMap.get(q.Project__c).MPM4_BASE__Account__r.Name;                   
            q.SBQQ__Account__c = projMap.get(q.Project__c).MPM4_BASE__Account__c;                   
            q.Add_Work_Aircraft_Model__c = projMap.get(q.Project__c).Aircraft__r.Aircraft_Model_2011__c;                   
            q.Add_Work_Aircraft_Reg_Number__c = projMap.get(q.Project__c).Aircraft__r.ACReg__c;                    
            q.Add_Work_Aircraft_Serial_Number__c = projMap.get(q.Project__c).Aircraft__r.Aircraft_SN__c;                    
            q.Aircraft__c = projMap.get(q.Project__c).Aircraft__c;                                    
            q.CPM_Name__c = projMap.get(q.Project__c).CPM_Name__c;                    
            q.CPM__c = projMap.get(q.Project__c).CPM__c; 
            
            //Crew Chief
            if(projMap.get(q.Project__c).Airframe_Crew_Chief__r.Name != null){
                q.Crew_Chief__c = projMap.get(q.Project__c).Airframe_Crew_Chief__r.Name;
            }else if(projMap.get(q.Project__c).Avionics_Crew_Chief__r.Name != null){
                q.Crew_Chief__c = projMap.get(q.Project__c).Avionics_Crew_Chief__r.Name;
            }else if(projMap.get(q.Project__c).Engine_Crew_Chief__r.Name != null){
                q.Crew_Chief__c = projMap.get(q.Project__c).Engine_Crew_Chief__r.Name;                
            }
                       
            if(projMap.get(q.Project__c).Engine__r.Name =='NA'){                        
                q.Add_Work_Engine_Model__c = 'NA';                   
            }else{                        
                q.Add_Work_Engine_Model__c = projMap.get(q.Project__c).Engine__r.Model__c;                    
            }
        }
    }
       
    //After Trigger
    public static void afterAddWorkQuoteUpdates(Map<Id, SBQQ__Quote__c> quoteMap){

        Map<Id, Id> quoteOppty = new mAP<Id, Id>();        
        Map<Id, Id> quoteProj = new Map<Id, Id>();
      
        for(SBQQ__Quote__c q : quoteMap.Values()){

            if(q.SBQQ__Opportunity2__c != null){
                if(q.SBQQ__Primary__c)
                    quoteOppty.put(q.Id, q.SBQQ__Opportunity2__c);
            }
            
            if(q.RecordTypeId == awqRecType && q.Project__c != null && q.SBQQ__Status__c == 'Presented')
                quoteProj.put(q.Project__c, q.id);
        }
                
        if(!quoteOppty.IsEmpty())
          UpdateOpportunity(quoteMap, quoteOppty);  
                     
        if(!quoteProj.IsEmpty())
            CreateShareRecord(quoteMap, quoteProj);
        
        if(quoteProj.IsEmpty())
            DeleteShareRecord(quoteMap);       
    }

    //Delete Share Record For Quote
    public static void DeleteShareRecord(Map<Id, SBQQ__Quote__c> quoteMap){
    
        Set<Id> quoteIds = new Set<Id>();        
        for(SBQQ__Quote__c q : quoteMap.Values()){
            if(q.SBQQ__Status__c == 'Draft')
                quoteIds.add(q.Id);  
        }
        
        List<SBQQ__Quote__Share> sharesToDelete = [Select Id from SBQQ__Quote__Share where ParentId In: quoteIds];
        if(!sharesToDelete.IsEmpty())       
            Delete sharesToDelete;
    }
    
    //Create Customer Share Record For Quote
    public static void CreateShareRecord(Map<Id, SBQQ__Quote__c> quoteMap, Map<Id, Id> quoteProj){
                                                                                  
        Map<Id, Id> projectShares = new Map<Id, Id>();
        for(MPM4_BASE__Milestone1_Project__Share ps : [Select Id, ParentId, UserOrGroupId from MPM4_BASE__Milestone1_Project__Share where ParentId In: quoteProj.KeySet() and RowCause = 'Project_Customer_Access__c']){
            projectShares.put(ps.UserOrGroupId, quoteProj.get(ps.ParentId));    
        }
     
        // inserting new records                                                
        List<SBQQ__Quote__Share> sharesToCreate = new List<SBQQ__Quote__Share>();
                                                         
        // create the new share for quotes
        for(Id p : projectShares.keyset()){                                                    
            SBQQ__Quote__Share qs = new SBQQ__Quote__Share();                           
            qs.AccessLevel = 'edit';                            
            qs.ParentId = projectShares.get(p);                            
            qs.RowCause = 'Quote_Customer_Access__c';                            
            qs.UserOrGroupId = p;                            
            sharesToCreate.add(qs);                         
        }
                                                             
        if(!sharesToCreate.isEmpty())                             
            insert sharesToCreate; 
    }
                
    //Update Opportunity From Quote          
    public static void UpdateOpportunity(Map<Id, SBQQ__Quote__c> quoteMap, Map<Id, Id> quoteOppty){
        Map<Id, Opportunity> newOppMap = new Map<Id, Opportunity>();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([Select Id, Name, Estimated_Labor_Sell__c, Quoted_Downtime__c, Base_Quote_Number__c, Estimated_Cost__c, Estimated_Sell_Amount__c, EstimatedHours__c from Opportunity where Id In: quoteOppty.Values()]);
        
        for(Id i : quoteOppty.keyset()){
            Opportunity o = oppMap.get(quoteMap.get(i).SBQQ__Opportunity2__c);
            o.EstimatedHours__c = quoteMap.get(i).Total_Labor_Hours__c;                        
            o.Estimated_Cost__c = quoteMap.get(i).Total_Labor_Cost_With_Warranty__c + quoteMap.get(i).Total_Material_Cost_With_Warranty__c;                        
            o.Estimated_Labor_Sell__c = quoteMap.get(i).Total_Labor_Sell_With_Warranty__c;                        
            o.Estimated_Sell_Amount__c = quoteMap.get(i).Total_Labor_Sell_With_Warranty__c + quoteMap.get(i).Total_Material_Sell_With_Warranty__c;                       
            o.Quoted_Downtime__c = quoteMap.get(i).Downtime_Days__c;
            o.Base_Quote_Number__c = quoteMap.get(i).Name;
                        
            newOppMap.put(o.Id, o);                                          
        }
                                            
        if(!newOppMap.IsEmpty())                                  
           update newOppMap.values();            
                                                                                  
    }
}