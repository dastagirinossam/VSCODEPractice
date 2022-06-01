public class CreateAgentUserVf{
    public Id contactId {set;get;}
    public Contact con  {set;get;}
    @auraEnabled public Boolean validate {set;get;}
        
    public CreateAgentUserVf(ApexPages.StandardController controller){
        con = (Contact) controller.getRecord();
        contactId = con.Id;
    }
	
	
	
	public PageReference redirect() {
	    
	PageReference pageRef = new PageReference('/'+contactId);  
	return pageRef;
	
	}
	
	
     public PageReference CreateUserFromContact() {
        
        Profile prfl = [SELECT Id, Name FROM Profile WHERE Name = 'Customer Community Plus Login - Opportunity Agent'];           
        Contact c = [Select Id, Email, FirstName, LastName, AccountId, Account.Name, Customer_Community_Role__c from Contact where Id =: contactId limit 1];
        system.debug('c---'+c);
        String roleId = UserInfo.getUserRoleId();
        
       System.debug('roleId'+roleId);
        
     //   UserRole role = [Select Name from UserRole where Id =: roleId];
        UserRole role;
        String pwd = null;
        String custUR = null;
        
        List<User> numberofusers = [Select Id, IsActive, ContactId from user where Username=: c.Email AND ContactId != Null];
        
        try{
            role = [Select Id, Name from UserRole where Name =: c.Customer_Community_Role__c];
            system.debug('role---'+role);
            custUR = role.Id;
        }catch (Exception e){
            system.debug(e.getMessage());
        }
        
        system.debug('custUR>>>>'+custUR);
        
        system.debug('numberofusers' + numberofusers.Size());
       PageReference pageRef;
        if(numberofusers.Size()  > 0   ){ 
          
            Contact con = [Select Name, Email, Title, AccountId, Number_of_Guests__c, Guest_Details__c, Additional_Guest__c, Invited_to_NBAA__c from Contact where Id =: numberofusers[0].ContactId];
			if(con.Id != c.Id){
				con.Invited_to_NBAA__c = 'Invited';
				con.NBAA_Inviter__c = Userinfo.getUserId();
				update con;
		
                }
         //   validate = false;
           
            pwd = 'Please use your existing password.';
            
            sendEmail(con, numberofusers[0].Id, pwd);
            pageRef =Null;
        }else {
            boolean flag=false;
            Database.DMLOptions dlo = new Database.DMLOptions();
            
            Integer len = 10;
            Blob blobKey = crypto.generateAesKey(128);
            String key = EncodingUtil.convertToHex(blobKey);
            system.debug('key>>>'+key);
            pwd = key.substring(0,len);
            
            system.debug('pwd>>>>'+pwd);
            
            //system.debug('role list: '+ role.Id);
            
            User uObj = new User();
            uObj.Username = c.Email;
            uObj.Email = c.Email;
            uObj.FirstName = c.FirstName;
            uObj.LastName = c.LastName;
            uObj.ContactId = c.Id;
            uObj.Alias = 'Reddy';            
            uObj.ProfileId = prfl.Id;
            uObj.Territory_or_Coverage_Details__c = pwd;
            uObj.IsActive = true; 
            uObj.TimeZoneSidKey = 'GMT';
            uObj.LanguageLocaleKey = 'en_US';
            uObj.EmailEncodingKey = 'UTF-8';
            uObj.LocaleSidKey = 'en_US';
           // uobj.CommunityNickname = 'CommunityUser';
            System.debug('custUR'+ custUR);
            if (custUR!=null)
                uObj.UserRoleId = role.Id;
            
            dlo.EmailHeader.triggerUserEmail =false;
            //String userId = Site.createPortalUser(uObj, c.accountId, pwd);
            
            Database.SaveResult sr = Database.insert(uObj, dlo);
            system.debug('uObj>>>>'+uObj);
           // User u=[select Id,name from User where Id =:uObj.Id];
           // system.debug('u>>>>>>>'+u);
            Database.SaveResult svr = sr;
         User origRecord = uObj;
           if (!sr.isSuccess()) {
        system.debug(svr.getId()); // I get null here
        system.debug(origRecord.Id); //This should be the Id you're looking for
     } 
             if(sr.getErrors().isempty() ){
                   System.setPassword(uObj.Id, pwd);
                  //  System.setPassword(Id.valueOf(u.Id), pwd);
               //  site.createPortalUser(u, c.accountId, pwd, false);
                    
             }else{
            for(Database.Error err : sr.getErrors()) {
                
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Account fields that affected this error: ' + err.getFields());
                }
            } 
            
           // System.setPassword(uObj.Id, pwd);
                       
            //Send Welcome Email
            sendEmail(c, uObj.Id, pwd);
          pageRef= new PageReference('/'+contactId);
        
        }
       
             return pageRef; 
       
    } 
    

    public static void sendEmail(Contact c, Id userId, String pwd){
        
        //BrandTemplate bt = [Select Id from BrandTemplate where Name =: 'NBAA -2019'];      
        //Select Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name =: 'NBAA - 2019' and BrandTemplateId =: bt];
        
        EmailTemplate et = [Select Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name =: 'myStandardAero Email'];
        
        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(et.id,userInfo.getUserId(), c.Id);
        
        String emailSubject = email.getSubject();
        String emailHtml = email.getHTMLBody();
        
        system.debug(emailHtml);
        
        email.setToAddresses(new String[]{c.Email});
        email.setTargetObjectId(userinfo.getUserId());
        email.setSubject(emailSubject);
        email.setHtmlBody(emailHtml);
        email.saveAsActivity = false;
        
        system.debug('HTMLBody' + email.getHtmlBody());
        Savepoint sp = Database.setSavepoint();
        Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        Database.rollback(sp);
        
        System.debug(' new HTMLBody ' + email.getHtmlBody());
        String emailHtml1 = email.getHtmlBody();
        
        emailHtml1 = emailHtml1.replace('((UserName))', c.Email);
        emailHtml1 = emailHtml1.replace('((Password))', pwd);
        
        System.debug(emailHTML1);
        email.setHTMLBody(emailHtml1);
        
        System.debug(' Final  ' + email.getHtmlBody());
        
        Messaging.SendEmailResult[] r1 = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
    }

  @auraEnabled
    public static string getData(Id conId)
    {
        string validate;
        contact c = [select Id,email from contact where Id =: conId LIMIT 1];
         List<User> numberofusers = [Select Id, IsActive, ContactId from user where Username=: c.Email];
        system.debug('>>>'+ numberofusers.Size());
        if(numberofusers.Size()  > 0){ 
           validate = 'userExist';
            }else{
             validate = 'userdontExist' ;  
            }
        system.debug('validate>>>'+validate);
        return validate;
    }
 
}