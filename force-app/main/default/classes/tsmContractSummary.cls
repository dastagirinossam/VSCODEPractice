global class tsmContractSummary {
      
    @future(callout=true)
    public static void tsmContractSummary(String oppId){
                
        SBQQ__Quote__c quote = [Select Id, Name, SBQQ__Opportunity2__r.RecordType.Name
                                from SBQQ__Quote__c 
                                where SBQQ__Opportunity2__c =: oppId 
                                and SBQQ__Primary__c = true];       
                         
        String fileName;
        
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        
        Map<String, Id> cdlMap = new Map<String, Id>();   
        
        if(quote.SBQQ__Opportunity2__r.RecordType.Name == 'Master Opportunity'){
            fileName = quote.Name + ' - Contract Summary';
        }else{
            fileName = quote.Name + ' Master Contract Summary';
        }
     
        ContentVersion cv = new ContentVersion();
        cv.Title = fileName;
        cv.PathOnClient = fileName + '.csv';
               
        if(!Test.isRunningTest()){
            cv.VersionData = getRemoteCSV(quote.Name);
        }else{
            cv.VersionData = blob.valueOf('Unit.Test');  
        }
        
		insert cv;
    
        ContentVersion cv2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id];
            
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cv2.contentDocumentId;
        cdl.LinkedEntityId = oppId;
        cdl.ShareType = 'V';         
        
        insert cdl;     
    }
    
    @RemoteAction
    global static Blob getRemoteCSV(String quoteName) {
        Report r = [SELECT Id, Name FROM Report where Name =: 'Contract Summary'];
        
        ApexPages.PageReference report = new ApexPages.PageReference('/' + r.Id + '?pv1=' + quoteName + '&csv=1&exp=1&enc=UTF-8&isdtp=p1');
		return report.getContent();
    }
}