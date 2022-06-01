public without sharing class CreateUserHandler {
    
    @AuraEnabled    
    public static Id CreateUserFromContact(String contactIds) {
        
        Profile prfl = [SELECT Id, Name FROM Profile WHERE Name = 'Customer Community Plus Login User - Custom'];           
        Contact c = [Select Id, Email, FirstName, LastName, AccountId, Account.Name, Customer_Community_Role__c from Contact where Id =: contactIds];
        system.debug('conid'+c.Email);
        List<UserRole> rId = [Select Id, name, PortalRole, PortalType, PortalAccountId From UserRole where PortalType = 'CustomerPortal' and PortalRole = 'Worker' and PortalAccountId =: c.AccountId];
        
        if(rId.size()==0){
            UserRole role = new UserRole();
            role.portalType = 'CustomerPortal';
            role.PortalAccountId = c.AccountId;
            role.CaseAccessForAccountOwner = 'Edit';
            role.OpportunityAccessForAccountOwner = 'Read';
            database.insert(role,false); 
            
            rId.add(role);      
        }
        Integer len = 8;
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        string  pwd = key.substring(0, len);
        
        Id userId = null;
        
        List<User> u = [Select Id, 
                        Username,
                        Email,
                        FirstName,
                        LastName,
                        UserRoleId,
                        ContactId,
                        Alias,           
                        ProfileId,
                        IsActive,
                        TimeZoneSidKey,
                        LanguageLocaleKey,
                        EmailEncodingKey,
                        LocaleSidKey from user where (Username=: c.Email or ContactId =: c.id)];
        
        if(u.Size()  > 0){ 
            userId = u[0].Id;
            
            u[0].Email = c.Email;
            u[0].Email = c.Email;
            u[0].FirstName = c.FirstName;
            u[0].LastName = c.LastName;
            U[0].UserRoleId = rId[0].Id;
            u[0].Alias = 'custcom';            
            u[0].ProfileId = prfl.Id;
            u[0].IsActive = true; 
            u[0].TimeZoneSidKey = 'GMT';
            u[0].LanguageLocaleKey = 'en_US';
            u[0].EmailEncodingKey = 'UTF-8';
            u[0].LocaleSidKey = 'en_US';
            u[0].UserPreferencesReceiveNoNotificationsAsApprover = true;
            
            update u;          
        }else {
            Database.DMLOptions dlo = new Database.DMLOptions();
            
            User uObj = new User();
            uObj.Username = c.Email;
            uObj.Email = c.Email;
            uObj.FirstName = c.FirstName;
            uObj.LastName = c.LastName;
            uObj.UserRoleId = rId[0].Id;
            uObj.ContactId = c.Id;
            uObj.Alias = 'custcom';            
            uObj.ProfileId = prfl.Id;
            uObj.IsActive = true; 
            uObj.TimeZoneSidKey = 'GMT';
            uObj.LanguageLocaleKey = 'en_US';
            uObj.EmailEncodingKey = 'UTF-8';
            uObj.LocaleSidKey = 'en_US';
            uObj.New_User_Password__c = pwd;
            uObj.UserPreferencesReceiveNoNotificationsAsApprover = true;
            
            dlo.EmailHeader.triggerUserEmail = false;
            
            Database.SaveResult sr = Database.insert(uObj, dlo);
            if(sr.getErrors().isempty() ){              
                userId = uObj.Id;             
            }else{
                for(Database.Error err : sr.getErrors()) {             
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
            
            setPassWord(userId);
        }
        system.debug('user id'+userid);   
        return userId;     
    }
    
    @future (callout=true)
    public static void setPassWord(Id uId){
        User u = [Select Id, ContactId, UserName, New_User_Password__c from User where Id =: uId];
        System.setPassword(u.Id, u.New_User_Password__c);
        EmailTemplate et = [Select Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name =: 'myStandardAero Email'];
        List<Messaging.SingleEmailMessage> emailList = new  List<Messaging.SingleEmailMessage>();
        
        Contact c = [Select Id, Email from Contact where Id =: u.ContactId];
        
        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(et.id, userInfo.getUserId(), c.Id);
        
        String emailSubject = email.getSubject();
        String emailHtml = email.getHTMLBody();
        
        system.debug(emailHtml);
        
        email.setToAddresses(new String[]{c.Email});
        email.setTargetObjectId(userinfo.getUserId());
        email.setSubject(emailSubject);
        email.setHtmlBody(emailHtml);
        email.saveAsActivity = false;
        System.debug(' new HTMLBody ' + email.getHtmlBody());
        String emailHtml1 = email.getHtmlBody();
        
        emailHtml1 = emailHtml1.replace('((UserName))', c.Email);
        emailHtml1 = emailHtml1.replace('((Password))', u.New_User_Password__c);
        
        System.debug(emailHTML1);
        email.setHTMLBody(emailHtml1);
        emailList.add(email);
        
        Messaging.sendEmail(emailList);        
    }
    
    @AuraEnabled
    public static Void setPassWordProj(List<string> uIds){
        string sent='false';
        resetPassWord(uIds);
        
    }
    
    @future (callout=true)
    public static void resetPassWord(List<string> uId){ 
        Map<Id,contact> useContactMap = new  Map<Id,contact>();
        EmailTemplate et = [Select Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name =: 'myStandardAero Email'];
        List<User> uList = [Select Id, ContactId,email, UserName, New_User_Password__c from User where Id IN: uId];
        List<Messaging.SingleEmailMessage> emailList = new  List<Messaging.SingleEmailMessage>();
        for(User u:uList){
            
            Integer len = 8;
            
            Blob blobKey = crypto.generateAesKey(128);
            String key = EncodingUtil.convertToHex(blobKey);
            string  pwd = key.substring(0, len);
            system.setPassword(U.Id, pwd); 
            
            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(et.id, userInfo.getUserId(), u.ContactId);
            
            String emailSubject = email.getSubject();
            String emailHtml = email.getHTMLBody();
            
            system.debug(emailHtml);
            
            email.setToAddresses(new String[]{u.Email});
            email.setTargetObjectId(userinfo.getUserId());
            email.setSubject(emailSubject);
            email.setHtmlBody(emailHtml);
            email.saveAsActivity = false;
            System.debug(' new HTMLBody ' + email.getHtmlBody());
            String emailHtml1 = email.getHtmlBody();
            
            emailHtml1 = emailHtml1.replace('((UserName))', u.Email);
            emailHtml1 = emailHtml1.replace('((Password))', pwd);
            
            System.debug(emailHTML1);
            email.setHTMLBody(emailHtml1);
            emailList.add(email);   
        }
        
        if(emailList.size()>0){
            Messaging.sendEmail(emailList); 
            
        }
        
    }
    
    @AuraEnabled    
    public static MPM4_BASE__Milestone1_Project__c getProjectRecord(Id pojId){
        Return [select Id, 
                Designated_Approver__c,
                Designated_Approver__r.Name,
                Secondary_Approver__c,
                Secondary_Approver__r.Name,
                X3_Approver__c, 
                X3_Approver__r.Name,
                X4_Approver__c,
                X4_Approver__r.Name,
                X5_Approver__c, 
                X5_Approver__r.Name,
                X6_Approver__c, 
                X6_Approver__r.Name,
                Name
                from MPM4_BASE__Milestone1_Project__c where Id =:pojId];  
    }
    
    @AuraEnabled 
    public static user fetchUser(){
       User u = [select id,Name from User where id =: userInfo.getUserId()];
        return u;
    }
    
    @AuraEnabled 
    public static void customerResetPassword(String uId, String pw){ 
        Map<Id,contact> useContactMap = new  Map<Id,contact>();
        EmailTemplate et = [Select Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name =: 'myStandardAero Email'];
        List<User> uList = [Select Id, ContactId, email, UserName from User where Id =: uId];
        List<Messaging.SingleEmailMessage> emailList = new  List<Messaging.SingleEmailMessage>();
        for(User u : uList){
            
            Integer len = 8;
            
            system.setPassword(u.Id, pw); 
            
            Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(et.id, userInfo.getUserId(), u.ContactId);
            
            String emailSubject = email.getSubject();
            String emailHtml = email.getHTMLBody();
            
            system.debug(emailHtml);
            
            email.setToAddresses(new String[]{u.Email});
            email.setTargetObjectId(userinfo.getUserId());
            email.setSubject(emailSubject);
            email.setHtmlBody(emailHtml);
            email.saveAsActivity = false;
            System.debug(' new HTMLBody ' + email.getHtmlBody());
            String emailHtml1 = email.getHtmlBody();
            
            emailHtml1 = emailHtml1.replace('((UserName))', u.Email);
            emailHtml1 = emailHtml1.replace('((Password))', pw);
            
            System.debug(emailHTML1);
            email.setHTMLBody(emailHtml1);
            emailList.add(email);   
        }
        
        if(emailList.size()>0){
            Messaging.sendEmail(emailList); 
        }
        
    }
}