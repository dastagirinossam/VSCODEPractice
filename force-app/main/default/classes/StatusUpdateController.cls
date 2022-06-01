public class StatusUpdateController {
    
    public List<String> fileIds {get; set;}
    
    @AuraEnabled
    public static List<ContentVersion> getAttachments(String conId){
        
        List<ContentDocumentLink> CDLs = [Select ContentDocumentId 
                                          from ContentDocumentLink 
                                          where LinkedEntityId = : conId];
        
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
    public static Map<Id, sObject> getRecordValues(String recordId){
        
        Id rId = Id.valueof(recordId);
        String sObjectType = rId.getSObjectType().getDescribe().getName();
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(sObjectType).getDescribe().fields.getMap();
        
        String joinedString = String.join((Iterable<String>)fieldMap.keyset(), ',');                     
        String  oquery = 'Select ' + joinedString + ' from ' + sObjectType + ' where ID =: rId';
        Map<Id, sObject> sObjectMap = new Map<Id, sObject>((List<sObject>)Database.query(oquery));
        
        return sObjectMap;               
    }
    
    @AuraEnabled
    public static void sendOpportunityEmail(String toEmail, String emailSubject, String emailBody, String fileMap, String oppId){
        //Get Id of Files
        List<String> fileIds = new List<String>();
        if(fileMap != null){ 
            system.debug('File Map: ' + fileMap);
            List<Object> selectedFileList = (List<Object>)JSON.deserializeUntyped(fileMap);                   
            for(Object sfl : selectedFileList){
                Map<String, Object> mpSFL = (Map<string, Object>)sfl;
                
                fileIds.add(string.valueof(mpSFL.get('Id')));
                system.debug('File Id: ' + mpSFL.get('Id'));
            }
        }
        
        
        List<Messaging.EmailFileAttachment> attachList = new  List<Messaging.EmailFileAttachment>();
        
       //query contentversion where Id IN:fileIds
        List<ContentVersion> CVList = [SELECT Id, ContentDocumentId,versionData, Title, FileType 
                                       FROM ContentVersion 
                                       WHERE Id = :fileIds];
       
      
       //loop content version
        for(contentVersion CV : CVList){
             system.debug('cv.FileType>>'+cv.FileType);
            // Blob b = Blob.valueOf(CV.versionData);
             Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            
       		 attach.setFileName(CV.title); //opportunity.pdf
            if(cv.FileType == 'PDF'){
        	attach.setContentType('application/pdf');
            }else if(cv.FileType == 'EXCEL_X'){
             attach.setContentType('application/x-msexcel');   //application/vnd.ms-excel //XLSX
            }else if(cv.FileType == 'WORD_X'){
              attach.setContentType('application/msword');  
            }
            attach.setBody(CV.versionData);
             attachList.add(attach); 
        }
        
     
        //Split Email addresses
        String emailAddressesString = '{';
        List<String> emailAddresses = toEmail.split(';');
        for(String e : emailAddresses){
            emailAddressesString += '\'' + e + '\',';
        }
        
        emailAddressesString = emailAddressesString.removeEnd(',');
        emailAddressesString += '}';
        
        system.debug('Email Addresses: ' + emailAddressesString);
        
        //Send Emails
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        
        message.toAddresses = emailAddresses;
        message.optOutPolicy = 'FILTER';
        message.subject = emailSubject;
        message.HTMLBody = emailBody;
        message.setReplyTo(userinfo.getUserEmail());
       // message.setFileAttachments(attachList);
        if(fileIds.Size() > 0)
          message.setEntityAttachments(fileIds);
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
            LogACall(oppId, emailBody);
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }     
    }
      
    //Logs a Call if Email sent successfully
    public static void LogACall(String oppId, String emailBody){
        Opportunity o = [Select Id, AccountId from Opportunity where Id =: oppId];
		Account a = [Select Id, Last_Activity_Date__c from Account where Id =: o.AccountId];
        Task t = new Task();
        t.Subject = 'Log A Call - Opportunity Email File';
        t.Status = 'Completed';
        t.ActivityDate = system.today();
        t.Priority = 'Normal';
        t.Risk_Level__c = 'Green = No Risk';
        t.WhatId = o.Id;
        t.Description = emailBody.stripHtmlTags();
        
        insert t;
        
        //Out Of The box field updated via Process
        //Not accessible thru Apex
        a.Last_Activity_Date__c = system.today();
        
        update a;
        
    }    
    
    
    @AuraEnabled
    public static void sendEmailApex(String suId, String fileMap) {
        List<String> fileIds = new List<String>();
        
        system.debug('Stauts Update Id: ' + suId);
                                                 
        Status_Update__c su = [Select Id,
                               Name, 
                               Update__c,
                               Designated_Approver__c,
                               Designated_Approver__r.Name,
                               Designated_Approver__r.Email,
                               Secondary_Approver__c,
                               Secondary_Approver__r.Name,
                               Secondary_Approver__r.Email,
                               Additional_Approver_3__c,
                               Additional_Approver_3__r.Name,
                               Additional_Approver_3__r.Email,
                               Additional_Approver_4__c,
                               Additional_Approver_4__r.Name,
                               Additional_Approver_4__r.Email,
                               Additional_Approver_5__c,
                               Additional_Approver_5__r.Name,
                               Additional_Approver_5__r.Email,
                               Additional_Approver_6__c,
                               Additional_Approver_6__r.Name,
                               Additional_Approver_6__r.Email
                               from Status_Update__c where Id =: suId];
                  
        //Populates Map with Names and Email Addresses
        Set<Id> daIds = new Set<Id>();
        Map<Id, User> taMap = new Map<Id, User>();           
        if(su.Designated_Approver__c != null)
            daIds.add(su.Designated_Approver__c);
        
        if(su.Secondary_Approver__c != null)
            daIds.add(su.Secondary_Approver__c);
        
        if(su.Additional_Approver_3__c != null)
            daIds.add(su.Additional_Approver_3__c);
        
        if(su.Additional_Approver_4__c != null)
            daIds.add(su.Additional_Approver_4__c);
        
        if(su.Additional_Approver_5__c != null)
            daIds.add(su.Additional_Approver_5__c);
        
        if(su.Additional_Approver_6__c != null)
            daIds.add(su.Additional_Approver_6__c);
        
        for(User u : [Select Id, Email, FirstName from User where Id In: daIds]){
            taMap.put(u.Id, u);
        }
        
        if(fileMap != null)
            updateStatusUpdateField(su, fileMap, fileIds);
                          
        EmailTemplate et = [Select Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name =: 'mySA Status Update Email'];
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
               
        String senderEmail = Userinfo.getUserEmail();

        for(String ta : taMap.keySet()){
        	Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(et.id, userInfo.getUserId(), su.Id);
            
            String emailSubject = email.getSubject();
            String emailHtml = email.getHTMLBody();
            system.debug('Email Address: ' + taMap.get(ta).Email);
            email.setToAddresses(new String[]{taMap.get(ta).Email});
            email.setTargetObjectId(ta);
            email.setSubject(emailSubject);
            email.setReplyTo(senderEmail);
            email.setHtmlBody(emailHtml);
            
            if(fileIds.Size() > 0)
            	email.setEntityAttachments(fileIds);
            
            email.saveAsActivity = false;
            System.debug(' new HTMLBody ' + email.getHtmlBody());
            String emailHtml1 = email.getHtmlBody();
            
            emailHtml1 = emailHtml1.replace('((CustomerName))', taMap.get(ta).FirstName);
            
            System.debug(emailHTML1);
            email.setHTMLBody(emailHtml1);
            emailList.add(email);
        }
       
        try{
            Messaging.sendEmail(emailList); 
        }
        catch (exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public static void updateStatusUpdateField(Status_Update__c su, String fileMap, List<String> fileIds){
        
        Network network = [SELECT Name, UrlPathPrefix FROM Network WHERE Name = 'Customer Community'];
		Domain base = [SELECT Domain, DomainType, HttpsOption FROM Domain where HttpsOption =: 'SitesRuntime']; 
    	String baseURL = 'https://' + base.Domain + '/' + network.UrlPathPrefix + '/s/contentdocument/';
        
        system.debug('File Map: ' + fileMap);
        
        List<Object> selectedFileList = (List<Object>)JSON.deserializeUntyped(fileMap); 
        
        su.Update__c += '<br/><br/><br/>Status Update Files: <ul>';
        
        for(Object sfl : selectedFileList){
            Map<String, Object> mpSFL = (Map<string, Object>)sfl;
            
            su.Update__c += '<li><a href="' + baseUrl + string.valueof(mpSFL.get('ContentDocumentId')) + '">' + string.valueof(mpSFL.get('Title')) + '</a></li>';
                      
            fileIds.add(string.valueof(mpSFL.get('Id')));
            system.debug('File Id: ' + mpSFL.get('Id'));
        }
        
        su.Update__c += '</ul>';
        
        update su;       
    } 
        
}