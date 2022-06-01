public class tcEndUserStatementController {
    
    @AuraEnabled
    public static String getAccount(Id recordId){
        
        String accntId;
        String obj = String.valueof(recordId.getsobjecttype());
       	system.debug('Object: ' + obj);
        
        if(obj == 'Opportunity'){
        	Opportunity o = [Select AccountId from Opportunity where Id =: recordId];
            accntId = o.AccountId; 
        }
        
        if(obj == 'Account'){
            accntId = recordId; 
        } 
        
        if(obj == 'Aircraft__c'){
        	Aircraft__c ac = [Select Account__c from Aircraft__c where Id =: recordId];
            accntId = ac.Account__c; 
        } 

        return accntId;       
    }
    
    @AuraEnabled
    public static List<ContentVersion> getAttachments(Id recordId){
        
        String accntId;
        String obj = String.valueof(recordId.getsobjecttype());
       	system.debug('Object: ' + obj);
        
        if(obj == 'Opportunity'){
        	Opportunity o = [Select AccountId from Opportunity where Id =: recordId];
            accntId = o.AccountId; 
        }
        
        if(obj == 'Account'){
            accntId = recordId; 
        } 
        
        if(obj == 'Aircraft__c'){
        	Aircraft__c ac = [Select Account__c from Aircraft__c where Id =: recordId];
            accntId = ac.Account__c; 
        } 
        
        List<ContentDocumentLink> CDLs = [Select ContentDocumentId from ContentDocumentLink where LinkedEntityId = : accntId];
        
        if(CDLs != NULL && CDLs.size() > 0){
            Set<Id> CDIdList = new Set<Id>();
            for (ContentDocumentLink nextCDL : CDLs) {
                CDIdList.add(nextCDL.ContentDocumentId); 
            }   
            
            List<ContentDocument> entries = [SELECT Id, Title, FileType FROM ContentDocument WHERE ContentDocument.Id IN :CDIdList];
            
            List<ContentVersion> CVmainList = new List<ContentVersion>();  
            List<ContentVersion> CVList = [SELECT Id, ContentDocumentId, isLatest, Title, FileType 
                                           FROM ContentVersion 
                                           WHERE ContentDocumentId = :CDIdList AND isLatest = true];
            
            return CVList;
        }
        else{
            List<ContentVersion> CV = new List<ContentVersion>();
            CV = NULL;
            return CV;
        }
    }
        
    @AuraEnabled
    public static void captureEUS(Id recordId, String fileId, Date ExpDate){
      
        String obj = String.valueof(recordId.getsobjecttype());
        ContentVersion c = [SELECT ContentDocumentId FROM ContentVersion where Id =: fileId];
        
        if(obj == 'Opportunity'){
            Opportunity o = [Select AccountId from Opportunity where Id =: recordId];
        	String accntId = o.AccountId;
            
            updateAccount(accntId, c.ContentDocumentId, ExpDate);        
        }
        
        if(obj == 'Account')
            updateAccount(recordId, c.ContentDocumentId, ExpDate);
        
        if(obj == 'Aircraft__c')
          	updateAircraft(recordId, c.ContentDocumentId, ExpDate);
    }
        
    public static void updateAccount(Id recordId, String fileId, Date ExpDate){
        
        Account a = [Select End_User_Statement_File_Id__c, End_User_Statement_Expiration_Date__c from Account where Id =: recordId];
        a.End_User_Statement_File_Id__c = fileId;
        a.End_User_Statement_Expiration_Date__c = ExpDate;
        
        update a;
    }  
    
    public static void updateAircraft(Id recordId, String fileId, Date ExpDate){
        Aircraft__c a = [Select End_User_Statement_File_Id__c, End_User_Statement_Expiration_Date__c from Aircraft__c where Id =: recordId];
        a.End_User_Statement_File_Id__c = fileId;
        a.End_User_Statement_Expiration_Date__c = ExpDate;
        
        update a;
    }           
}