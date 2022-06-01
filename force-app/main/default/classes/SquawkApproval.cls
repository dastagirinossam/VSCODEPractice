public with sharing class SquawkApproval { 
    
    @AuraEnabled
    public static User getOwner() {
        return [select Id, name, ProfileId from user where id =: Userinfo.getUserId()];
    }  
    
    @AuraEnabled
    public static List<SBQQ__Quote__c> getQuote(List<id> lstRecordId) {
        List<Id> recIds = lstRecordId;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__Quote__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        
        string  oquery = 'Select ' + joinedString + ',Project__r.Name, Project__r.Project_Type__c from SBQQ__Quote__c where ID IN:lstRecordId' ;
        
        system.debug('String oquery is ' +oquery);
        
        List<SBQQ__Quote__c> sobjList = Database.query(oquery);
        system.debug('sobjList is' + sobjList );
        return sobjList;
    }
    
    @AuraEnabled
    public static List<SBQQ__QuoteDocument__c> getQuoteDocument(List<id> lstRecordId) {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__QuoteDocument__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String  oquery = 'Select ' + joinedString + ', Project_On_Quote__r.Name, SBQQ__Quote__r.Name from SBQQ__QuoteDocument__c where ID IN:lstRecordId' ;
        system.debug('String oquery is ' +oquery);
        List<SBQQ__QuoteDocument__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static List<Log_Book_Entry__c> getLbEntry(List<id> lstRecordId) {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('Log_Book_Entry__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String  oquery = 'Select ' + joinedString + ' from Log_Book_Entry__c where ID IN:lstRecordId' ;
        List<Log_Book_Entry__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static List<Contract_Change_Order__c> getCCO(List<id> lstRecordId) {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('Contract_Change_Order__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String  oquery = 'Select ' + joinedString + ' from Contract_Change_Order__c where  ID IN:lstRecordId' ;
        List<Contract_Change_Order__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static List<ContentDocumentLink> getLbPreview(Id file){
        
        return [SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedDate, ContentDocument.LastModifiedDate FROM ContentDocumentLink WHERE LinkedEntityId =: file];
    }
    
    //Preview Files On Quote Document
    @AuraEnabled
    public static List<ContentDocumentLink> getPreview(string file){
        return [SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedDate, ContentDocument.LastModifiedDate FROM ContentDocumentLink WHERE Id =: file];  
    }
    
    //Used in related list for Quotes        
    @AuraEnabled
    public static List <SBQQ__QuoteLine__c> getSquawks(List <Id> lstRecordId) {  
        string attr1 = 'lstRecordId';
        string attr2= 'Presented';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__QuoteLine__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String  oquery = 'Select ' + joinedString + ',Designated_Approver__r.Name, Project__r.Project_Type__c, Project__r.Name,SBQQ__Quote__r.Name,CreatedBy.Id  from SBQQ__QuoteLine__c where SBQQ__Quote__c IN: lstRecordId AND Add_Work_Status__c != null and SBQQ__ProductCode__c!= \''+attr1+'\' and SBQQ__Quote__r.SBQQ__Status__c = \''+attr2 +'\' Order BY Job_Card__c asc';
        List<SBQQ__QuoteLine__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static List <SBQQ__QuoteDocument__c> getQuoteDoc2(List <Id> lstRecordId) {  
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__QuoteDocument__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String  oquery = 'Select ' + joinedString + ',CreatedBy.Name,SBQQ__Quote__r.Name from SBQQ__QuoteDocument__c where  SBQQ__Quote__c IN:lstRecordId' ;
        List<SBQQ__QuoteDocument__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static List<ContentDocumentLink> getQuoteFiles(List<id> lstRecordId){
        Map<Id, SBQQ__QuoteLine__c> quoteLine = new Map<Id, SBQQ__QuoteLine__c>([Select Id from SBQQ__QuoteLine__c where SBQQ__Quote__c =: lstRecordId]);
        Map<Id, SBQQ__QuoteDocument__c> quoteDoc = new Map<Id, SBQQ__QuoteDocument__c>([Select Id from SBQQ__QuoteDocument__c where SBQQ__Quote__c =: lstRecordId]);
        
        Set<Id> cdl = new Set<Id>();
        
        if(!quoteLine.IsEmpty()){
            Set<Id> ql = quoteLine.keyset();
            for(ContentDocumentLink cd: [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: ql]){
                if(!cdl.contains(cd.Id))
                    cdl.add(cd.Id);
            }
        }
        
        if(!quoteDoc.IsEmpty()){
            Set<Id> qd = quoteDoc.keyset();
            for(ContentDocumentLink cd: [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: qd]){
                if(!cdl.contains(cd.Id))
                    cdl.add(cd.Id);
            }
        }
        
        for(ContentDocumentLink cd: [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: lstRecordId]){
            if(!cdl.contains(cd.Id))
                cdl.add(cd.Id);
        }
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('ContentDocumentLink');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String  oquery = 'Select ' + joinedString + ',ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedById, ContentDocument.LastModifiedDate from ContentDocumentLink where ID  IN: cdl' ;
        List<ContentDocumentLink> sobjList = Database.query(oquery);
        return sobjList;
    }   
    
    //Squawk Related List        
    @AuraEnabled
    public static List<ContentDocumentLink> getFiles(List<id> lstRecordId){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('ContentDocumentLink');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String  oquery = 'Select ' + joinedString + ',ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedById, ContentDocument.LastModifiedDate from ContentDocumentLink where LinkedEntityId  IN:lstRecordId' ;
        List<ContentDocumentLink> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static List<SBQQ__QuoteLine__c> getSqk() {
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__QuoteLine__c');
        String attr2 ='Pending';
        String attr3 ='UnscheduledBundle';
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String  oquery = 'Select ' + joinedString + ',Project__r.Name from SBQQ__QuoteLine__c where Add_Work_Status__c  =:attr2 And SBQQ__ProductCode__c!=:attr3 Order BY Job_Card__c asc';
        List<SBQQ__QuoteLine__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static list <SBQQ__QuoteLine__c> fetchSqk(String lstRecordId, String sortField, boolean isAsc) {
        String sSoql = 'Select id, Name, Labor_Code__c, Labor_Amount__c, Project__r.Name, Job_Card__c, Material_Amount__c, Job_Card_Description__c, Job_Card_Description_Section__c, IsFirmPriceMaterial__c, IsFirmPriceLabour__c, IsRTS__c, Job_Card_Description_Section_1__c ';     
        String status ='Pending';
        String proCode = 'UnscheduledBundle';
        sSoql += 'From SBQQ__QuoteLine__c where Add_Work_Status__c = \'' + String.escapeSingleQuotes(status) + '\' And SBQQ__ProductCode__c!= \'' + String.escapeSingleQuotes(proCode) + '\' And project__c = \'' + String.escapeSingleQuotes(lstRecordId) + '\'';
        system.debug('sortField-->' + sortField);
        system.debug('Query: ' + sSoql);
        
        if (sortField != '') {
            sSoql += ' order by ' + sortField;
            
            if (isAsc) {
                sSoql += ' asc';
            }else{
                sSoql += ' desc';
            }
        }
        
        list <SBQQ__QuoteLine__c> jobcardResult;
        try {
            jobcardResult = Database.query(sSoql);
            system.debug(jobcardResult);
            List <SBQQ__QuoteLine__c> returnSqkList = new List <SBQQ__QuoteLine__c> ();
            
            for (SBQQ__QuoteLine__c s: jobcardResult) {
                returnSqkList.add(s);
            }
            return returnSqkList;
        } 
        catch (Exception ex) {
            return null;
        }
    }
    
    @AuraEnabled
    public static list<MPM4_BASE__Milestone1_Project__c> getProjectDetails(String lstRecordId){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('MPM4_BASE__Milestone1_Project__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String oquery = 'Select ' + joinedString + ', MPM4_BASE__Account__r.Name, Opportunity__r.Name, Aircraft__r.Name, Engine__r.Name, ';
        oquery += 'CPM__r.Name, Designated_Approver__r.Name, Secondary_Approver__r.Name, X3_Approver__r.Name, X4_Approver__r.Name, X5_Approver__r.Name, ';
        oquery += 'X6_Approver__r.Name, LastModifiedBy.Name from MPM4_BASE__Milestone1_Project__c where ID =: lstRecordId' ;
        system.debug('oQuery: ' + oquery);
        List<MPM4_BASE__Milestone1_Project__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static list<MPM4_BASE__Milestone1_Project__c> checkProjectType(List <Id> lstRecordId){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('MPM4_BASE__Milestone1_Project__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String  oquery = 'Select ' + joinedString + ' from MPM4_BASE__Milestone1_Project__c where ID IN: lstRecordId' ;
        List<MPM4_BASE__Milestone1_Project__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static List<SBQQ__QuoteLine__c> getProjectRecords(List <Id> lstRecordId) {   
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__QuoteLine__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap(); 
        String attr4 ='UnscheduledBundle';
        string attr5 = 'Pending';
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String  oquery = 'Select ' + joinedString + ',Project__r.Id, Project__r.Name,Project__r.Approved_Total__c, Project__r.Max_Approval_Limit__c, ';
        oquery += 'Project__r.Estimated_Total__c,Project__r.Project_Type__c, Project__r.Buyer_Inspection__c,Project__r.Seller_Inspection__c, Project__r.Show_Estimated_Labor_Hours__c ';
        oquery += 'from SBQQ__QuoteLine__c where Add_Work_Status__c =:attr5 AND SBQQ__ProductCode__c !=:attr4 AND project__c IN: lstRecordId Order By fxItemNo__c asc' ;
        List<SBQQ__QuoteLine__c> sobjList = Database.query(oquery);
        return sobjList;      
    }
    
    @AuraEnabled
    public static List<ProcessInstanceStep> getAppHistory(List<Id> lstRecordId){
        return [SELECT ProcessInstance.Status, OriginalActor.Name, Comments, StepStatus, CreatedDate FROM ProcessInstanceStep where ProcessInstance.TargetObjectId =: lstRecordId order by CreatedDate desc];
    }
    
    //Squawk Detail Page
    @AuraEnabled
    public static List <SBQQ__QuoteLine__c> getQuoteLine(List<Id> lstRecordId) { 
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__QuoteLine__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap(); 
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String  oquery = 'Select ' + joinedString + ', SBQQ__Quote__r.Name, Project__r.CPM__c, Project__r.CPM__r.Name, Project__r.Name, ';
        oquery += 'Project__r.Buyer_Inspection__c, Project__r.Seller_Inspection__c, CreatedBy.Name, Designated_Approver__r.Name, ';
        oquery += 'CreatedBy.Id from SBQQ__QuoteLine__c where id In: lstRecordId';

        List<SBQQ__QuoteLine__c> sobjList = Database.query(oquery);
        return sobjList; 
    }
    
    //Project Related List
    @AuraEnabled
    public static List<SBQQ__Quote__c> getQuotes(List<id> lstRecordId) {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        String attr1 = 'Presented';
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__Quote__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        string  oquery = 'Select ' + joinedString + ',Project__r.Name from SBQQ__Quote__c where SBQQ__Status__c =: attr1 AND Project__c IN: lstRecordId' ;
        List<SBQQ__Quote__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static List<Log_Book_Entry__c> getLbEntries(List<id> lstRecordId) {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('Log_Book_Entry__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        string  oquery = 'Select ' + joinedString + ',Project__r.Name from Log_Book_Entry__c where  Project__c IN:lstRecordId' ;
        List<Log_Book_Entry__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static List<Contract_Change_Order__c> getCcos(List<id> lstRecordId) {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('Contract_Change_Order__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        string  oquery = 'Select ' + joinedString + ' from Contract_Change_Order__c where  Project__c IN:lstRecordId' ;
        List<Contract_Change_Order__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static List<ContentDocumentLink> getProjFiles(List<id> lstRecordId){
        Map<Id, SBQQ__Quote__c> quote = new Map<Id, SBQQ__Quote__c>([Select Id from SBQQ__Quote__c where Project__c =: lstRecordId]);
        Map<Id, SBQQ__QuoteLine__c> quoteLine = new Map<Id, SBQQ__QuoteLine__c>([Select Id from SBQQ__QuoteLine__c where Project__c =: lstRecordId]);
        Map<Id, SBQQ__QuoteDocument__c> quoteDoc = new Map<Id, SBQQ__QuoteDocument__c>([Select Id from SBQQ__QuoteDocument__c where Project_On_Quote__c =: lstRecordId]);
        
        Set<Id> cdl = new Set<Id>();
        
        if(!quote.IsEmpty()){
            Set<Id> q = quote.keyset();
            for(ContentDocumentLink cd: [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: q]){
                if(!cdl.contains(cd.Id))
                    cdl.add(cd.Id) ;
            }
        }
        
        if(!quoteLine.IsEmpty()){
            Set<Id> ql = quoteLine.keyset();
            for(ContentDocumentLink cd: [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: ql]){
                if(!cdl.contains(cd.Id))
                    cdl.add(cd.Id);
            }
        }
        
        if(!quoteDoc.IsEmpty()){
            Set<Id> qd = quoteDoc.keyset();
            for(ContentDocumentLink cd: [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: qd]){
                if(!cdl.contains(cd.Id))
                    cdl.add(cd.Id);
            }
        }
        
        for(ContentDocumentLink cd: [SELECT Id, ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId In: lstRecordId]){
            if(!cdl.contains(cd.Id))
                cdl.add(cd.Id);
        }
        
        return [SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.Title, ContentDocument.CreatedById, ContentDocument.LastModifiedDate FROM ContentDocumentLink WHERE Id In: cdl];  
    }
    
    @AuraEnabled
    public static List <SBQQ__QuoteLine__c> getProjectQuoteLines(List <Id> lstRecordId) {  
        System.debug('quote lines'+lstRecordId);
        String attr5 ='UnscheduledBundle';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__QuoteLine__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String attr= 'Presented' ;
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        string  oquery = 'Select ' + joinedString + ', Designated_Approver__r.Name, Project__r.Name,  Project__r.Show_Estimated_Labor_Hours__c, ';
        oquery += 'CreatedBy.Name, CreatedBy.Id, Project__r.Project_Type__c, Project__r.Buyer_Inspection__c, ';
        oquery += 'Project__r.Seller_Inspection__c  from SBQQ__QuoteLine__c where Project__c IN:lstRecordId AND Add_Work_Status__c != null ';
        oquery += 'and SBQQ__ProductCode__c!=:attr5 and SBQQ__Quote__r.SBQQ__Status__c =:attr Order BY fxItemNo__c asc' ;
        List<SBQQ__QuoteLine__c> sobjList = Database.query(oquery);
        return sobjList;
    }

    @AuraEnabled
    public static List <SBQQ__QuoteDocument__c> getQuoteDoc(List <Id> lstRecordId) { 
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__QuoteDocument__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        string  oquery = 'Select ' + joinedString + ',CreatedBy.Name, Project_On_Quote__r.Name,  SBQQ__Quote__r.Name  from SBQQ__QuoteDocument__c where  Project_On_Quote__c IN:lstRecordId Order by CreatedDate asc' ;
        List<SBQQ__QuoteDocument__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static List <SBQQ__QuoteLine__c> getRtsRecords(List <Id> lstRecordId) { 
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__QuoteLine__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');   
        string  oquery = 'Select ' + joinedString + ',Project__r.Name  from SBQQ__QuoteLine__c where  Id IN: lstRecordId AND IsRTS__c = '+'y' ;

        return [Select id, Name, Labor_Code__c, Labor_Amount__c, Project__r.Name, Job_Card__c, Material_Amount__c, Job_Card_Description__c, Job_Card_Description_Section__c, IsFirmPriceMaterial__c, IsFirmPriceLabour__c, IsRTS__c, Job_Card_Description_Section_1__c from SBQQ__QuoteLine__c where IsRTS__c = 'Y' and id in: lstRecordId];   
    }
    
    @AuraEnabled
    public static List <String> approveRecords(List <String> lstRecordId, Decimal maxAmount, Decimal appTotal) {
        
        List<String> response = new List<String>();
        Decimal max = 0;
        Decimal approvedAmount = 0;
        
        AggregateResult[] approvedTotal = [SELECT SUM(AddWork_Estimated_Total__c)appTotal FROM SBQQ__QuoteLine__c where Id In: lstRecordId];               
        for (AggregateResult ar : approvedTotal)  {
            approvedAmount = (Decimal)ar.get('appTotal');
        }
        
        If(maxAmount > 0){
            max = maxAmount - appTotal;
        }else{
            max = approvedAmount;
        }
        
        if(max >= approvedAmount){
            String dte = DateTime.now().format();
            String statusChange = 'Approved';
            String color = 'Blue';
            
            List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
            
            List<ProcessInstanceWorkitem> workItems = [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId IN: lstRecordId and ActorId =: UserInfo.getUserId()];
            
            if(workItems.size() > 0){
                try{
                    for(ProcessInstanceWorkitem workItem : workItems){
                        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                        req.setWorkitemId(workItem.Id);
                        req.setAction('Approve');
                        req.setComments('Approved by ' + UserInfo.getName() + ' On: ' + dte);
                        requests.add(req);
                    }
                    
                    Approval.ProcessResult[] processResults = Approval.process(requests);                                                        
                    QuoteLineEmail(lstRecordId, statusChange, color);
                    
                }catch ( Exception ex ){
                    response.add('error' + ex.getMessage());
                }
            }else{
                response.add('You are not able to Approve this Squawk. If you have questions regarding this, please contact your Customer Project Manager.');
            }
        }else{
            response.add('The Squawks you have Approved exceeds the Maximum Approval Amount of $' + maxAmount + '. If you have questions regarding this, please contact your Customer Project Manager.');    
        }
        return response;
    }
    
    @AuraEnabled
    public static List <String> rejectRecords(List <String> lstRecordId) {
        
        String dte = DateTime.now().format();
        String statusChange = 'Declined';
        String color = 'Red';
        
        List<String> response = new List<String>();          
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        List<ProcessInstanceWorkitem> workItems = [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId IN: lstRecordId and ActorId =: UserInfo.getUserId()];
        system.debug(UserInfo.getUserId());
        List<SBQQ__QuoteLine__c> updaterejectionType = new List<SBQQ__QuoteLine__c>();
        
        if(workItems.size() > 0){
            try{
                for(ProcessInstanceWorkitem workItem : workItems){
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                    req.setWorkitemId(workItem.Id);
                    req.setAction('Reject');
                    req.setComments('Rejected by ' + UserInfo.getName() + ' On: ' + dte);
                    requests.add(req);
                }
                
                Approval.ProcessResult[] processResults = Approval.process(requests);
                
                QuoteLineEmail(lstRecordId, statusChange, color);

            }catch ( Exception ex ){
                response.add('error' + ex.getMessage());
            }
        }else{
            response.add('You are not able to Reject this Squawk. If you have questions regarding this, please contact your Customer Project Manager.');
        }
        return response;
    }
    
    @AuraEnabled
    public static List < SBQQ__QuoteLine__c > findSquawks(String searchKeyWord) {
        String searchKey = '%' + searchKeyWord + '%';
        return [Select id, Name, Labor_Code__c, Project__r.Name, Job_Card__c, Labor_Amount__c, Job_Card_Description__c, Add_Work_Status__c, RTS__c,
                AddWork_Estimated_Total__c, Job_Card_Description_Section__c, Material_Amount__c, IsFirmPriceMaterial__c, Add_Work_Labor_Type__c, Material_Type__c,
                IsFirmPriceLabour__c, IsRTS__c, Job_Card_Description_Section_1__c, Designated_Approver__r.Name, Designated_Approver__c, Project__c, SBQQ__Quote__r.Name, SBQQ__Quote__c
                from SBQQ__QuoteLine__c 
                where SBQQ__ProductCode__c!= 'UnscheduledBundle' 
                and (Designated_Approver__c =: Userinfo.getUserId() or Secondary_Approver__c =: Userinfo.getUserId() or X3_Approver__c =: Userinfo.getUserId() or X4_Approver__c =: Userinfo.getUserId() or X5_Approver__c =: Userinfo.getUserId() or X6_Approver__c =: Userinfo.getUserId()) 
                and (Job_Card_Search_1__c LIKE: searchKey or Job_Card_Search_2__c LIKE: searchKey)];
    } 
    
    public static void QuoteLineEmail(List <String> lstRecordId, String statusChange, String color){
        
        string htmlBody = '';
        Organization instance = [SELECT InstanceName FROM Organization];
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__QuoteLine__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        string  oquery = 'Select ' + joinedString + ',Project__r.Name, SBQQ__Quote__r.Name, SBQQ__Quote__r.Add_Work_Work_Order__c, Project__r.Email_Distribution__c,CPM__r.Name  from SBQQ__QuoteLine__c where  Id IN:lstRecordId Order By Name asc' ;
        List<SBQQ__QuoteLine__c> quoteLines = Database.query(oquery);
        
        List<String> emailDistribution = quoteLines[0].Project__r.Email_Distribution__c.split(',');
        OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'customercommunity@standardaero.com']; 
        
        if(quoteLines != null || !quoteLines.isEmpty()){
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setToAddresses(emailDistribution); 
            message.setOrgWideEmailAddressId(owea.Id);
            message.optOutPolicy = 'FILTER';
            message.subject = Userinfo.getName() + ' ' + statusChange + ' ' + quoteLines.Size() + ' Squawks on Project: ' + quoteLines[0].Project__r.Name;
            message.HTMLBody = '<b>' + quoteLines[0].CPM__r.Name + ' :<b/>' + 
                '<br/><br/><b>' + Userinfo.getName() + ' has ' + statusChange + ' the following squawks on Project: </b>' +
                '<HTML><a href="https://' + instance.InstanceName + '.salesforce.com/' + quoteLines[0].Project__c + '">' + quoteLines[0].Project__r.Name + '</a></HTML>' +
                '<br/><br/>' +
                '<table border="1" style="border-collapse: collapse" cellpadding="10">'+
                '<thead><td colspan="9" style="background-color:' + color + '"><center><b>' + statusChange + '<b/></center></td></thead>'+
                '<tr><th>Squawk No</th><th>Labor Code</th><th width="35%">Job Card Description</th><th>Labor Amount</th><th>Labor Type</th><th>Material Amount</th><th>Material Type</th><th>Quote</th><th>Work Order</th></tr>';
            for(SBQQ__QuoteLine__c ql : quoteLines){    
                
                String sqkJobCard = ql.Job_Card_Description__c; if(ql.Job_Card_Description__c == null){sqkJobCard = '[Not Provided]';}
                Decimal sqkLaborAmount = ql.Labor_Amount__c; if(ql.Labor_Amount__c == null){sqkLaborAmount = null;}
                String sqkLaborType = ql.Add_Work_Labor_Type__c; if(ql.Add_Work_Labor_Type__c == null){sqkLaborType = '[Not Provided]';}
                Decimal sqkMaterialAmount = ql.Material_Amount__c; if(ql.Material_Amount__c == null){sqkMaterialAmount = null;}
                String sqkMaterialType = ql.Material_Type__c; if(ql.Material_Type__c == null){sqkMaterialType = '[Not Provided]';}
                
                message.htmlBody += '<tr>' +
                    '<td><HTML><a href="https://' + instance.InstanceName + '.salesforce.com/apex/Squawk?id=' + ql.Id + '">' + ql.fxSquawkNo__c + '</a></HTML></td>' + 
                    '<td>' + ql.Labor_Code__c + '</td>' +
                    '<td white-space="wrap">' + sqkJobCard + '</td>' +
                    '<td>' + sqkLaborAmount + '</td>'+
                    '<td>' + sqkLaborType + '</td>' +
                    '<td>' + sqkMaterialAmount + '</td>'+
                    '<td>' + sqkMaterialType +'</td>'+
                    '<td><HTML><a href="https://' + instance.InstanceName + '.salesforce.com/' + ql.SBQQ__Quote__c + '">' + ql.SBQQ__Quote__r.Name + '</a></HTML></td>' + 
                    '<td>' + ql.SBQQ__Quote__r.Add_Work_Work_Order__c + '</td>' + 
                    '</tr>';                    
            }                  
            message.htmlBody += '</table>';
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
    }
    
    //ProCom Controller Methods
    @AuraEnabled
    public static list<MPM4_BASE__Milestone1_Project__c> getActiveProjects(){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        String attr ='Active';
        Schema.SObjectType leadSchema = schemaMap.get('MPM4_BASE__Milestone1_Project__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        string  oquery = 'Select ' + joinedString + ',CPM__r.Name  from MPM4_BASE__Milestone1_Project__c where  MPM4_BASE__Status__c =: attr' ;
        List<MPM4_BASE__Milestone1_Project__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static list<MPM4_BASE__Milestone1_Project__c> getOldProjects(){
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        String attr='Completed';
        Schema.SObjectType leadSchema = schemaMap.get('MPM4_BASE__Milestone1_Project__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String  oquery = 'Select ' + joinedString + ',CPM__r.Name  from MPM4_BASE__Milestone1_Project__c where  MPM4_BASE__Status__c =:attr' ;
        List<MPM4_BASE__Milestone1_Project__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static List < MPM4_BASE__Milestone1_Project__c > findProjects(String searchKeyWord) {
        String searchKey = '%' + searchKeyWord + '%';
        List < MPM4_BASE__Milestone1_Project__c > returnList = new List < MPM4_BASE__Milestone1_Project__c > ();
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('MPM4_BASE__Milestone1_Project__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String  oquery = 'Select ' + joinedString + ',CPM__r.Name from MPM4_BASE__Milestone1_Project__c where  MPM4_BASE__Status__c ='+' Completed and Name LIKE:\''+ searchKey+'\'';
        List < MPM4_BASE__Milestone1_Project__c > lstOfProjects =  Database.query(oquery);
        for (MPM4_BASE__Milestone1_Project__c sqk: lstOfProjects) {
            returnList.add(sqk);
        }
        return returnList;
    } 
    
    @AuraEnabled
    public static List<MPM4_BASE__Milestone1_Project__c> getCount() {
        //return projList;
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('MPM4_BASE__Milestone1_Project__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();   
        String attr='Active';
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        string  oquery = 'Select ' + joinedString + ',CPM__r.Name  from MPM4_BASE__Milestone1_Project__c where  MPM4_BASE__Status__c =:attr' ;
        List<MPM4_BASE__Milestone1_Project__c> sobjList = Database.query(oquery);
        return sobjList;
        // return [SELECT id, name, MPM4_BASE__Deadline__c, CPM__r.Name, CPM__c, Pending_Squawks__c,Project_Type__c FROM MPM4_BASE__Milestone1_Project__c where MPM4_BASE__Status__c = 'Active'];
    } 
    
    @AuraEnabled
    public static List<SBQQ__QuoteLine__c> viewAllSquawks(List <Id> lstRecordId){
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('SBQQ__QuoteLine__c');
        String attr= 'UnscheduledBundle' ;
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();       
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');
        String  oquery = 'Select ' + joinedString + ',CPM__r.Name  from SBQQ__QuoteLine__c where  SBQQ__ProductCode__c !=:attr AND  project__c =: lstRecordId[0] And (Add_Work_Status__c ='+'Pending'+ ' Or Add_Work_Status__c ='+'Approved'+ ' Or Add_Work_Status__c ='+'Declined' ;
        List<SBQQ__QuoteLine__c> sobjList = Database.query(oquery);
        return sobjList;
    }
    
    @AuraEnabled
    public static List<String> checkIsBroker(){
        List<String> accountType = new List<String>();
        Contact c = [Select Id, Name, AccountId, Account.Name,Account.Type from contact where id in (select ContactId FROM User Where id =: userInfo.getUserId()) Limit 1];
        accountType.add(c.Account.Type);
        return accountType;
    }
    
    @AuraEnabled
    public static List <SBQQ__QuoteLine__c> getSellerProjectQuoteLines(List <Id> lstRecordId) {   
        return [Select id, Name, fxItemNo__c, IsRTS__c, Add_Work_Status__c, Job_Card_Description_Section__c, Designated_Approver__c,
                    Designated_Approver__r.Name, RTS__c, Job_Card_Description__c, Project__r.Name, 
                    Project__c, CreatedBy.Name, CreatedBy.Id 
                from SBQQ__QuoteLine__c 
                where Project__r.Buyer_Inspection__c =: lstRecordId and 
                    Add_Work_Status__c != null and 
                    SBQQ__ProductCode__c!= 'UnscheduledBundle' and 
                    SBQQ__Quote__r.SBQQ__Status__c = 'Presented' and  
                    //Add_Work_Status__c != 'Declined' and
                    Share_w_Buyer__c = True 
                Order BY fxItemNo__c asc
               ];   
    }
    
    @AuraEnabled
    public static List <SBQQ__QuoteLine__c> getBuyerProjectQuoteLines(List <Id> lstRecordId) {   
        return [Select id, Name, fxItemNo__c, IsRTS__c, Add_Work_Status__c, Job_Card_Description_Section__c, Designated_Approver__c,
                    Designated_Approver__r.Name, RTS__c, Job_Card_Description__c, Project__r.Name, 
                    Project__c, CreatedBy.Name, CreatedBy.Id 
                from SBQQ__QuoteLine__c 
                where Project__r.Seller_Inspection__c =: lstRecordId and 
                    Add_Work_Status__c != null and 
                    SBQQ__ProductCode__c!= 'UnscheduledBundle' and 
                    SBQQ__Quote__r.SBQQ__Status__c = 'Presented'  
                    //Add_Work_Status__c != 'Declined' 
                Order BY Job_Card__c asc
               ];   
    }
}